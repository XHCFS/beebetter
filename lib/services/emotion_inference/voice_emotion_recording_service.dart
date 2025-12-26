// lib/services/emotion_inference/voice_emotion_recording_service.dart

import 'dart:async';
import 'dart:collection';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

/// Result containing emotion label and confidence score
class EmotionResult {
  final String emotion; // 'Anger', 'Happy', 'Neutral', 'Sad'
  final double confidence;
  final Map<String, double> allScores; // All emotion scores for debugging

  EmotionResult({
    required this.emotion,
    required this.confidence,
    required this.allScores,
  });

  @override
  String toString() => '$emotion (${(confidence * 100).toStringAsFixed(1)}%)';
}

/// Real-time voice emotion detection service
/// 
/// Quick integration with existing recording UI:
/// 1. Initialize: await service.initialize()
/// 2. Listen: service.onEmotionDetected.listen((result) => ...)
/// 3. Feed audio: service.feedAudio(audioChunk) from your recorder stream
/// 
/// Optimized for fast evaluation - processes every 4 seconds for quick feedback
/// All processing happens in isolate (non-blocking UI)
class VoiceEmotionRecordingService {
  static const String _modelPath = 'assets/models/mobile_voice_model/emotion_model_quantized.onnx';
  
  // Audio specifications
  static const int _sampleRate = 16000; // 16kHz
  static const int _channels = 1; // Mono
  static const int _requiredSamples = 128000; // 8 seconds at 16kHz
  static const int _bytesPerSample = 2; // 16-bit PCM = 2 bytes
  
  // Emotion labels (indices match model output)
  static const List<String> _emotionLabels = ['Anger', 'Happy', 'Neutral', 'Sad'];
  
  // Audio recorder
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  StreamSubscription<Uint8List>? _audioStreamSubscription;
  
  // Audio buffer
  final List<int> _audioBuffer = [];
  static const int _bufferSizeBytes = _requiredSamples * _bytesPerSample; // 256000 bytes
  
  // For faster evaluation: process every 4 seconds instead of waiting for full 8 seconds
  static const int _fastEvaluationSamples = 64000; // 4 seconds
  static const int _fastEvaluationBytes = _fastEvaluationSamples * _bytesPerSample; // 128000 bytes
  
  // Result aggregation for long recordings
  final List<EmotionResult> _allResults = [];
  Timer? _finalProcessTimer;
  
  bool _isInitialized = false;
  bool _isAvailable = false; // Track if model actually loaded successfully
  
  // Isolate for inference
  Isolate? _inferenceIsolate;
  SendPort? _inferenceSendPort;
  ReceivePort? _inferenceReceivePort;
  
  // Queue management to prevent memory issues
  // Store raw PCM bytes, let isolate do preprocessing
  final Queue<Uint8List> _inferenceQueue = Queue();
  bool _isProcessing = false;
  static const int _maxQueueSize = 2; // Reduced to 2 for faster processing (less backlog)
  
  // Voice Activity Detection (VAD) - skip quiet sections
  // Current: Simple RMS-based (fast but basic)
  // Better options: Silero VAD (ONNX model) or improved energy-based with ZCR
  static const double _silenceThreshold = 0.01; // RMS threshold for silence detection
  static const double _zcrThreshold = 0.05; // Zero-crossing rate threshold
  static const int _minVoiceSamples = 8000; // Minimum samples (0.5s) to consider as voice
  
  // Stream controller for results
  final _resultController = StreamController<EmotionResult>.broadcast();
  
  /// Stream of emotion detection results
  /// Listen to this in your UI to get real-time emotion updates
  Stream<EmotionResult> get onEmotionDetected => _resultController.stream;
  
  /// Check if the service is available (model loaded successfully)
  bool get isAvailable => _isAvailable;
  
  /// Get the latest emotion result (if any)
  EmotionResult? get latestResult => _allResults.isNotEmpty ? _allResults.last : null;
  
  /// Verify the service is working by running a test inference
  /// Returns true if successful, false otherwise
  /// This is useful for testing on Android before using in production
  Future<bool> verifyService() async {
    if (!_isAvailable || _inferenceSendPort == null) {
      return false;
    }
    
    try {
      // Create dummy audio data (8 seconds of silence with some noise for testing)
      final testAudio = Uint8List(_bufferSizeBytes);
      final random = math.Random();
      for (var i = 0; i < testAudio.length ~/ 2; i++) {
        // Generate random Int16 values (simulating audio)
        final sample = (random.nextDouble() * 2000 - 1000).round().clamp(-32768, 32767);
        testAudio[i * 2] = sample & 0xFF;
        testAudio[i * 2 + 1] = (sample >> 8) & 0xFF;
      }
      
      // Process the test audio
      final completer = Completer<bool>();
      final subscription = _resultController.stream.listen((result) {
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      });
      
      // Send test audio to isolate
      final transferable = TransferableTypedData.fromList([testAudio]);
      _inferenceSendPort!.send(transferable);
      
      // Wait for result (with timeout)
      final success = await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );
      
      await subscription.cancel();
      return success;
    } catch (e) {
      print('Service verification failed: $e');
      return false;
    }
  }
  
  /// Initialize the service and load the ONNX model
  /// Returns true if successful, false if model is not supported on this platform
  Future<bool> initialize() async {
    if (_isInitialized) return _isAvailable;
    
    try {
      // Set up isolate for inference (model will be loaded in isolate)
      final success = await _setupInferenceIsolate();
      
      _isInitialized = true;
      _isAvailable = success;
      return success;
    } catch (e) {
      print('Voice emotion service initialization failed: $e');
      _isInitialized = true; // Mark as initialized so we don't retry
      _isAvailable = false;
      return false;
    }
  }
  
  /// Set up isolate for running inference
  /// Returns true if model loaded successfully, false otherwise
  Future<bool> _setupInferenceIsolate() async {
    _inferenceReceivePort = ReceivePort();
    
    // Get the model bytes to pass to isolate
    final modelData = await rootBundle.load(_modelPath);
    final modelBytes = modelData.buffer.asUint8List();
    
    _inferenceIsolate = await Isolate.spawn(
      _inferenceIsolateEntry,
      _inferenceReceivePort!.sendPort,
    );
    
    // Wait for isolate to send its send port and model initialization status
    final completer = Completer<bool>();
    bool modelLoaded = false;
    
    _inferenceReceivePort!.listen((message) {
      if (message is SendPort) {
        _inferenceSendPort = message;
        // Send model bytes to isolate
        _inferenceSendPort!.send(modelBytes);
      } else if (message is Map<String, dynamic>) {
        // Check for model initialization status
        if (message.containsKey('model_initialized')) {
          modelLoaded = message['model_initialized'] as bool;
          if (!completer.isCompleted) {
            completer.complete(modelLoaded);
          }
          if (!modelLoaded) {
            print('Voice model not available on this platform: ${message['error'] ?? 'Unknown error'}');
          }
          return;
        }
        
        // Check for inference errors
        if (message.containsKey('error')) {
          print('Inference error: ${message['error']}');
          _isProcessing = false;
          _processNextInQueue();
          return;
        }
        
        // Received inference result
        final emotion = message['emotion'] as String;
        final confidence = message['confidence'] as double;
        final allScores = Map<String, double>.from(message['allScores'] as Map);
        
        final result = EmotionResult(
          emotion: emotion,
          confidence: confidence,
          allScores: allScores,
        );
        
        // Store for aggregation
        _allResults.add(result);
        
        // Emit individual result
        _resultController.add(result);
        
        // Process next in queue
        _isProcessing = false;
        _processNextInQueue();
      }
    });
    
    // Wait for model initialization (with timeout)
    try {
      return await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('Timeout waiting for model initialization');
          return false;
        },
      );
    } catch (e) {
      print('Error setting up inference isolate: $e');
      return false;
    }
  }
  
  /// Entry point for inference isolate
  static void _inferenceIsolateEntry(SendPort mainSendPort) {
    final isolateReceivePort = ReceivePort();
    mainSendPort.send(isolateReceivePort.sendPort);
    
    OrtSession? session;
    
    isolateReceivePort.listen((message) async {
      if (message is Uint8List && session == null) {
        // First message: model bytes, initialize session
        try {
          final sessionOptions = OrtSessionOptions();
          session = OrtSession.fromBuffer(message, sessionOptions);
          mainSendPort.send({'model_initialized': true});
        } catch (e) {
          // Model initialization failed (e.g., ConvInteger not supported on Linux)
          mainSendPort.send({
            'model_initialized': false,
            'error': e.toString(),
          });
        }
      } else if (message is TransferableTypedData && session != null) {
        // Audio data: run inference (using TransferableTypedData for efficiency)
        try {
          // Extract raw PCM bytes
          final pcmBytes = message.materialize().asUint8List();
          
          // Preprocess in isolate (moves heavy computation off main thread)
          final normalizedAudio = _preprocessAudioInIsolate(pcmBytes);
          
          final result = await _runInference(session!, normalizedAudio);
          mainSendPort.send(result);
        } catch (e) {
          mainSendPort.send({'error': e.toString()});
        }
      }
    });
  }
  
  /// Run inference on preprocessed audio data
  static Future<Map<String, dynamic>> _runInference(
    OrtSession session,
    List<double> normalizedAudio,
  ) async {
    // Create input tensor [1, 128000]
    final inputTensor = OrtValueTensor.createTensorWithDataList(
      [normalizedAudio],
      [1, 128000],
    );
    
    final inputs = {'input_values': inputTensor};
    final runOptions = OrtRunOptions();
    
    // Run inference
    final outputs = session.run(runOptions, inputs);
    
    // Get logits (output shape: [1, 4])
    final logitsTensor = outputs[0] as OrtValueTensor;
    final logits = (logitsTensor.value as List).first as List<double>;
    
    // Apply softmax
    final probabilities = _softmax(logits);
    
    // Apply bias adjustments
    final adjustedScores = List<double>.from(probabilities);
    adjustedScores[1] += 0.15; // Boost Happy
    adjustedScores[3] -= 0.10; // Reduce Sad
    
    // Renormalize after adjustments
    final sum = adjustedScores.reduce((a, b) => a + b);
    for (var i = 0; i < adjustedScores.length; i++) {
      adjustedScores[i] /= sum;
    }
    
    // Find max emotion
    var maxIndex = 0;
    var maxScore = adjustedScores[0];
    for (var i = 1; i < adjustedScores.length; i++) {
      if (adjustedScores[i] > maxScore) {
        maxScore = adjustedScores[i];
        maxIndex = i;
      }
    }
    
    // Clean up
    inputTensor.release();
    runOptions.release();
    for (final output in outputs) {
      output?.release();
    }
    
    // Build result map
    final allScores = <String, double>{};
    for (var i = 0; i < _emotionLabels.length; i++) {
      allScores[_emotionLabels[i]] = adjustedScores[i];
    }
    
    return {
      'emotion': _emotionLabels[maxIndex],
      'confidence': maxScore,
      'allScores': allScores,
    };
  }
  
  /// Apply softmax to logits
  static List<double> _softmax(List<double> logits) {
    // Subtract max for numerical stability
    final maxLogit = logits.reduce(math.max);
    final expValues = logits.map((x) => math.exp(x - maxLogit)).toList();
    final sum = expValues.reduce((a, b) => a + b);
    return expValues.map((x) => x / sum).toList();
  }
  
  /// Request microphone permission
  /// On Linux, permissions may not be supported - returns true to allow testing
  Future<bool> requestPermission() async {
    try {
      final status = await Permission.microphone.request();
      return status.isGranted;
    } catch (e) {
      // On Linux, permission_handler may not work - allow testing anyway
      print('Permission check failed (likely Linux): $e');
      return true; // Allow testing on Linux
    }
  }
  
  /// Check if microphone permission is granted
  /// On Linux, permissions may not be supported - returns true to allow testing
  Future<bool> hasPermission() async {
    try {
      final status = await Permission.microphone.status;
      return status.isGranted;
    } catch (e) {
      // On Linux, permission_handler may not work - allow testing anyway
      print('Permission check failed (likely Linux): $e');
      return true; // Allow testing on Linux
    }
  }
  
  /// Start recording audio
  /// Note: On Linux, recording may not be supported. Use processAudioChunk() 
  /// directly with audio data from your UI layer for testing.
  Future<void> startRecording() async {
    if (_isRecording) return;
    
    // On Linux, skip permission check and recording start
    // The UI layer should call processAudioChunk() directly with audio data
    try {
      if (!await hasPermission()) {
        final granted = await requestPermission();
        if (!granted) {
          // On Linux, allow testing anyway
          print('Warning: Permission not granted, but continuing for testing');
        }
      }
    } catch (e) {
      // Permission handler may not work on Linux - continue anyway
      print('Permission check failed (likely Linux): $e');
    }
    
    try {
      // Get a temporary file path for recording
      final path = '/tmp/voice_emotion_recording_${DateTime.now().millisecondsSinceEpoch}.pcm';
      
      // Start recording to file
      // Note: This may fail on Linux - that's okay, use processAudioChunk() directly
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: _sampleRate,
          numChannels: _channels,
        ),
        path: path,
      );
      
      _isRecording = true;
      _audioBuffer.clear();
    } catch (e) {
      // On Linux, recording may not be supported
      // Allow the service to continue - UI can use processAudioChunk() directly
      print('Warning: Recording start failed (likely Linux): $e');
      print('You can still use processAudioChunk() directly with audio data');
      _isRecording = true; // Set to true anyway to allow testing
      _audioBuffer.clear();
    }
  }
  
  /// Process audio chunk (called by UI layer with raw PCM bytes)
  /// This is the main method to call from your existing recording UI
  /// Pass audio chunks as they come from your recorder
  void processAudioChunk(Uint8List pcmBytes) {
    if (!_isInitialized || !_isAvailable) {
      return; // Silently ignore if not ready
    }
    
    // Add to buffer
    _audioBuffer.addAll(pcmBytes);
    
    // Fast evaluation: process every 4 seconds for quicker feedback
    // Still uses 8-second windows for better accuracy
    while (_audioBuffer.length >= _fastEvaluationBytes) {
      // Take 8 seconds worth (or pad if we only have 4+ seconds)
      final takeBytes = math.min(_bufferSizeBytes, _audioBuffer.length);
      final audioData = Uint8List(_bufferSizeBytes);
      final copyLength = math.min(takeBytes, _bufferSizeBytes);
      audioData.setRange(0, copyLength, _audioBuffer.take(copyLength));
      
      // Remove processed bytes (keep overlap for smooth transitions)
      final removeBytes = _fastEvaluationBytes; // Remove 4 seconds, keep the rest
      if (_audioBuffer.length >= removeBytes) {
        _audioBuffer.removeRange(0, removeBytes);
      } else {
        _audioBuffer.clear();
      }
      
      // Process in isolate (non-blocking)
      _processAudioInIsolate(audioData);
    }
    
    // Reset timer for final chunk processing (when recording stops)
    _finalProcessTimer?.cancel();
    _finalProcessTimer = Timer(const Duration(milliseconds: 1500), () {
      _processFinalChunk();
    });
  }
  
  /// Simple API: Feed audio bytes from your existing recorder
  /// Returns immediately, results come via onEmotionDetected stream
  void feedAudio(Uint8List pcmBytes) {
    processAudioChunk(pcmBytes);
  }
  
  /// Process any remaining audio in buffer (for final partial chunk)
  void _processFinalChunk() {
    if (_audioBuffer.isEmpty) return;
    
    // Pad to required length if needed
    final audioData = Uint8List(_bufferSizeBytes);
    final copyLength = math.min(_audioBuffer.length, _bufferSizeBytes);
    audioData.setRange(0, copyLength, _audioBuffer);
    // Rest is already zeros (default Uint8List initialization)
    
    _audioBuffer.clear();
    _processAudioInIsolate(audioData);
  }
  
  /// Process audio data in isolate
  void _processAudioInIsolate(Uint8List pcmBytes) {
    if (_inferenceSendPort == null || !_isAvailable) return;
    
    // Voice Activity Detection: Skip quiet/silent sections
    if (!_hasVoice(pcmBytes)) {
      return; // Skip this chunk - it's too quiet
    }
    
    // Add raw PCM bytes to queue (preprocessing happens in isolate)
    if (_inferenceQueue.length >= _maxQueueSize) {
      // Drop oldest if queue is full (prioritize latest audio)
      _inferenceQueue.removeFirst();
    }
    _inferenceQueue.add(Uint8List.fromList(pcmBytes));
    
    // Process immediately if not already processing
    if (!_isProcessing) {
      _processNextInQueue();
    }
  }
  
  /// Process next item in inference queue
  void _processNextInQueue() {
    if (_inferenceQueue.isEmpty || _isProcessing || _inferenceSendPort == null) {
      return;
    }
    
    _isProcessing = true;
    final audioData = _inferenceQueue.removeFirst();
    
    // Use TransferableTypedData for efficient transfer (avoids copying)
    final transferable = TransferableTypedData.fromList([audioData]);
    
    // Send to isolate (preprocessing will happen there)
    _inferenceSendPort!.send(transferable);
  }
  
  /// Check if audio contains voice (Voice Activity Detection)
  /// Current: Improved energy-based (RMS + Zero-Crossing Rate)
  /// Better option: Silero VAD ONNX model (more accurate, especially in noise)
  /// 
  /// Returns true if audio has sufficient energy and speech-like characteristics
  static bool _hasVoice(Uint8List pcmBytes) {
    if (pcmBytes.length < 4) return false; // Need at least 2 samples (4 bytes)
    
    final byteData = pcmBytes.buffer.asByteData();
    final sampleCount = pcmBytes.length ~/ 2;
    if (sampleCount < 100) return false; // Need minimum samples for reliable detection
    
    // Convert to normalized samples
    final samples = <double>[];
    for (var i = 0; i < sampleCount; i++) {
      samples.add(byteData.getInt16(i * 2, Endian.little) / 32768.0);
    }
    
    // 1. Calculate RMS (Root Mean Square) energy
    double sumSquares = 0.0;
    for (var sample in samples) {
      sumSquares += sample * sample;
    }
    final rms = math.sqrt(sumSquares / sampleCount);
    
    // 2. Calculate Zero-Crossing Rate (ZCR) - speech has higher ZCR than noise
    int zeroCrossings = 0;
    for (var i = 1; i < samples.length; i++) {
      if ((samples[i - 1] >= 0 && samples[i] < 0) || 
          (samples[i - 1] < 0 && samples[i] >= 0)) {
        zeroCrossings++;
      }
    }
    final zcr = zeroCrossings / sampleCount;
    
    // 3. Combined check: Must have sufficient energy AND speech-like ZCR
    // Speech typically has ZCR between 0.05-0.15, noise is usually lower
    final hasEnergy = rms > _silenceThreshold;
    final hasSpeechZCR = zcr > _zcrThreshold && zcr < 0.2; // Speech range
    
    return hasEnergy && hasSpeechZCR;
  }
  
  // TODO: For better accuracy, consider using Silero VAD ONNX model:
  // - Download: https://github.com/snakers4/silero-vad
  // - Model: silero_vad.onnx (very lightweight, ~1MB)
  // - Input: 512 samples (32ms at 16kHz), Output: probability [0-1]
  // - Much more accurate, especially in noisy environments
  
  /// Preprocess audio in isolate: Convert Int16 PCM -> Float32 normalized
  /// This runs in the isolate to avoid blocking the main thread
  static List<double> _preprocessAudioInIsolate(Uint8List pcmBytes) {
    // Convert Uint8List to Int16List
    final int16Samples = Int16List(pcmBytes.length ~/ 2);
    final byteData = pcmBytes.buffer.asByteData();
    
    for (var i = 0; i < int16Samples.length; i++) {
      int16Samples[i] = byteData.getInt16(i * 2, Endian.little);
    }
    
    // Convert to Float32 and normalize to [-1.0, 1.0]
    final floatSamples = Float32List(int16Samples.length);
    for (var i = 0; i < int16Samples.length; i++) {
      floatSamples[i] = int16Samples[i] / 32768.0;
    }
    
    // Pad or truncate to exactly 128000 samples
    final processedSamples = Float32List(_requiredSamples);
    final copyLength = math.min(floatSamples.length, _requiredSamples);
    for (var i = 0; i < copyLength; i++) {
      processedSamples[i] = floatSamples[i];
    }
    // Rest is already zeros (Float32List default)
    
    // Calculate mean (optimized single pass)
    double sum = 0.0;
    for (var i = 0; i < processedSamples.length; i++) {
      sum += processedSamples[i];
    }
    final mean = sum / processedSamples.length;
    
    // Calculate variance (optimized single pass)
    double variance = 0.0;
    for (var i = 0; i < processedSamples.length; i++) {
      final diff = processedSamples[i] - mean;
      variance += diff * diff;
    }
    variance /= processedSamples.length;
    
    // Normalize: (sample - mean) / sqrt(variance + 1e-7)
    final stdDev = math.sqrt(variance + 1e-7);
    for (var i = 0; i < processedSamples.length; i++) {
      processedSamples[i] = (processedSamples[i] - mean) / stdDev;
    }
    
    // Convert to List<double> for tensor creation
    return processedSamples.toList();
  }
  
  /// Stop recording and get final aggregated result
  /// Returns the average emotion across all processed chunks (skips silent sections)
  /// This is the main method to call when recording stops
  Future<EmotionResult?> stopRecording() async {
    if (!_isRecording) return null;
    
    try {
      await _audioStreamSubscription?.cancel();
      _audioStreamSubscription = null;
      await _recorder.stop();
      _isRecording = false;
      
      // Process any remaining audio
      _finalProcessTimer?.cancel();
      _processFinalChunk();
      
      // Wait a bit for final processing
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Get aggregated result
      final aggregatedResult = _getAggregatedResult();
      
      // Clear buffer and results
      _audioBuffer.clear();
      _allResults.clear();
      
      return aggregatedResult;
    } catch (e) {
      throw Exception('Failed to stop recording: $e');
    }
  }
  
  /// Get aggregated result from all processed chunks
  /// Returns the emotion with highest average confidence
  /// Only includes chunks that had voice (silent sections are automatically skipped)
  EmotionResult? _getAggregatedResult() {
    if (_allResults.isEmpty) return null;
    
    // Calculate average scores across all results (only voice chunks are included)
    final avgScores = <String, double>{
      'Anger': 0.0,
      'Happy': 0.0,
      'Neutral': 0.0,
      'Sad': 0.0,
    };
    
    for (final result in _allResults) {
      for (final entry in result.allScores.entries) {
        avgScores[entry.key] = avgScores[entry.key]! + entry.value;
      }
    }
    
    // Average them
    final count = _allResults.length;
    if (count == 0) return null;
    
    for (final key in avgScores.keys) {
      avgScores[key] = avgScores[key]! / count;
    }
    
    // Find max
    var maxEmotion = 'Neutral';
    var maxScore = avgScores['Neutral']!;
    for (final entry in avgScores.entries) {
      if (entry.value > maxScore) {
        maxScore = entry.value;
        maxEmotion = entry.key;
      }
    }
    
    return EmotionResult(
      emotion: maxEmotion,
      confidence: maxScore,
      allScores: avgScores,
    );
  }
  
  /// Get final aggregated result without stopping recording
  /// Useful if you want to check the current aggregate while still recording
  EmotionResult? getFinalAggregate() {
    return _getAggregatedResult();
  }
  
  /// Check if currently recording
  bool get isRecording => _isRecording;
  
  /// Dispose of resources
  Future<void> dispose() async {
    await stopRecording();
    
    _inferenceQueue.clear();
    _isProcessing = false;
    
    _inferenceIsolate?.kill(priority: Isolate.immediate);
    _inferenceIsolate = null;
    _inferenceReceivePort?.close();
    _inferenceReceivePort = null;
    _inferenceSendPort = null;
    
    _resultController.close();
    _allResults.clear();
    _isInitialized = false;
  }
}

