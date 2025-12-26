// lib/services/emotion_inference/voice_emotion_service.dart

import 'dart:math' as math;
import 'package:onnxruntime/onnxruntime.dart';
import 'package:flutter/services.dart';

/// Batch voice emotion inference service
/// Processes pre-recorded audio bytes (used by EmotionInferenceService)
/// For real-time recording, use VoiceEmotionRecordingService
class VoiceEmotionService {
  OrtSession? _session;
  bool _isInitialized = false;
  
  // Model configuration
  static const String _modelPath = 'assets/models/mobile_voice_model/emotion_model_quantized.onnx';
  
  // Audio processing constants
  static const int _sampleRate = 16000; // HuBERT expects 16kHz
  static const int _windowSizeSeconds = 3; // Process 3-second windows
  static const int _windowSizeSamples = _sampleRate * _windowSizeSeconds;
  static const int _overlapSeconds = 1; // 1 second overlap between windows
  static const int _overlapSamples = _sampleRate * _overlapSeconds;
  
  // Model output labels
  static const Map<int, String> _labelMap = {
    0: 'ang', // anger
    1: 'hap', // happiness
    2: 'neu', // neutral
    3: 'sad', // sadness
  };
  
  /// Initialize the model session
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final modelData = await rootBundle.load(_modelPath);
      final sessionOptions = OrtSessionOptions();
      
      _session = OrtSession.fromBuffer(
        modelData.buffer.asUint8List(),
        sessionOptions,
      );
      
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize voice emotion model: $e');
    }
  }
  
  /// Dispose of the session
  void dispose() {
    _session?.release();
    _session = null;
    _isInitialized = false;
  }
  
  /// Convert audio bytes to float32 array
  /// Assumes 16-bit PCM audio data
  List<double> _bytesToFloat32(Uint8List audioBytes) {
    final samples = <double>[];
    final bytesPerSample = 2; // 16-bit = 2 bytes
    
    for (var i = 0; i < audioBytes.length - 1; i += bytesPerSample) {
      // Read 16-bit signed integer (little-endian)
      final sample = (audioBytes[i] | (audioBytes[i + 1] << 8));
      final signedSample = sample > 32767 ? sample - 65536 : sample;
      
      // Normalize to [-1.0, 1.0]
      samples.add(signedSample / 32768.0);
    }
    
    return samples;
  }
  
  /// Resample audio if needed (simple linear interpolation)
  /// For production, use a proper resampling library
  List<double> _resampleIfNeeded(List<double> audio, int currentSampleRate) {
    if (currentSampleRate == _sampleRate) {
      return audio;
    }
    
    final ratio = _sampleRate / currentSampleRate;
    final newLength = (audio.length * ratio).round();
    final resampled = <double>[];
    
    for (var i = 0; i < newLength; i++) {
      final srcIndex = i / ratio;
      final srcIndexFloor = srcIndex.floor();
      final srcIndexCeil = math.min(srcIndexFloor + 1, audio.length - 1);
      final fraction = srcIndex - srcIndexFloor;
      
      if (srcIndexFloor < audio.length) {
        final interpolated = audio[srcIndexFloor] * (1 - fraction) +
            audio[srcIndexCeil] * fraction;
        resampled.add(interpolated);
      }
    }
    
    return resampled;
  }
  
  /// Normalize audio (zero mean, unit variance)
  List<double> _normalizeAudio(List<double> audio) {
    if (audio.isEmpty) return audio;
    
    // Calculate mean
    final mean = audio.reduce((a, b) => a + b) / audio.length;
    
    // Calculate standard deviation
    final variance = audio.map((x) => math.pow(x - mean, 2)).reduce((a, b) => a + b) / audio.length;
    final stdDev = math.sqrt(variance);
    
    if (stdDev == 0) return audio;
    
    // Normalize
    return audio.map((x) => (x - mean) / stdDev).toList();
  }
  
  /// Split long audio into overlapping windows
  List<List<double>> _createWindows(List<double> audio) {
    if (audio.length <= _windowSizeSamples) {
      return [audio];
    }
    
    final windows = <List<double>>[];
    var start = 0;
    
    while (start < audio.length) {
      final end = math.min(start + _windowSizeSamples, audio.length);
      final window = audio.sublist(start, end);
      
      // Pad if window is too short
      if (window.length < _windowSizeSamples) {
        final padded = List<double>.from(window);
        while (padded.length < _windowSizeSamples) {
          padded.add(0.0);
        }
        windows.add(padded);
      } else {
        windows.add(window);
      }
      
      // Move window with overlap
      start += _windowSizeSamples - _overlapSamples;
      
      // If we can't make a full window, break
      if (start + _windowSizeSamples > audio.length && end == audio.length) {
        break;
      }
    }
    
    return windows;
  }
  
  /// Run inference on a single audio window
  Future<List<double>> _inferWindow(List<double> audioWindow) async {
    if (!_isInitialized || _session == null) {
      throw Exception('Model not initialized. Call initialize() first.');
    }
    
    // Ensure correct length
    final processedAudio = List<double>.from(audioWindow);
    while (processedAudio.length < _windowSizeSamples) {
      processedAudio.add(0.0);
    }
    if (processedAudio.length > _windowSizeSamples) {
      processedAudio.removeRange(_windowSizeSamples, processedAudio.length);
    }
    
    // Create input tensor: [1, sequence_length]
    // HuBERT expects raw audio waveform
    final inputTensor = OrtValueTensor.createTensorWithDataList(
      processedAudio,
      [1, processedAudio.length],
    );
    
    // Run inference
    // Verified tensor names: 'input_values' (input), 'logits' (output)
    final inputs = {
      'input_values': inputTensor,
    };
    
    final outputs = _session!.run(OrtRunOptions(), inputs);
    
    // Get logits (output shape: [1, num_labels])
    // Verified: output tensor name is 'logits', accessed by index 0
    final logitsTensor = outputs[0] as OrtValueTensor;
    final logits = logitsTensor.value as List<List<double>>;
    
    // Clean up
    inputTensor.release();
    for (final output in outputs) {
      output?.release();
    }
    
    // Apply softmax for single-label classification
    final logitsList = logits[0];
    final maxLogit = logitsList.reduce(math.max);
    final expLogits = logitsList.map((x) => math.exp(x - maxLogit)).toList();
    final sumExp = expLogits.reduce((a, b) => a + b);
    
    return expLogits.map((x) => x / sumExp).toList();
  }
  
  /// Predict emotions from audio
  /// [audioBytes] should be 16-bit PCM audio data
  /// [sampleRate] is the sample rate of the audio (will be resampled to 16kHz if needed)
  /// Returns a map of label indices to confidence scores
  Future<Map<int, double>> predictEmotions(
    Uint8List audioBytes, {
    int sampleRate = 16000,
  }) async {
    if (audioBytes.isEmpty) {
      throw ArgumentError('Audio data cannot be empty');
    }
    
    // Convert bytes to float32
    var audio = _bytesToFloat32(audioBytes);
    
    // Resample if needed
    audio = _resampleIfNeeded(audio, sampleRate);
    
    // Normalize
    audio = _normalizeAudio(audio);
    
    // Handle long audio by windowing
    final windows = _createWindows(audio);
    final allPredictions = <List<double>>[];
    
    for (final window in windows) {
      final predictions = await _inferWindow(window);
      allPredictions.add(predictions);
    }
    
    // Aggregate predictions (average across windows)
    final aggregated = List<double>.filled(_labelMap.length, 0.0);
    for (final predictions in allPredictions) {
      for (var i = 0; i < _labelMap.length; i++) {
        aggregated[i] += predictions[i];
      }
    }
    
    for (var i = 0; i < _labelMap.length; i++) {
      aggregated[i] /= allPredictions.length;
    }
    
    // Convert to map
    final result = <int, double>{};
    for (var i = 0; i < _labelMap.length; i++) {
      result[i] = aggregated[i];
    }
    
    return result;
  }
  
  /// Get the predicted emotion label
  Future<String> getPredictedEmotion(
    Uint8List audioBytes, {
    int sampleRate = 16000,
  }) async {
    final predictions = await predictEmotions(audioBytes, sampleRate: sampleRate);
    
    var maxIndex = 0;
    var maxScore = 0.0;
    
    predictions.forEach((index, score) {
      if (score > maxScore) {
        maxScore = score;
        maxIndex = index;
      }
    });
    
    return _labelMap[maxIndex] ?? 'neu';
  }
  
  /// Get top N emotions with highest confidence
  Future<List<MapEntry<int, double>>> getTopEmotions(
    Uint8List audioBytes, {
    int topN = 2,
    int sampleRate = 16000,
  }) async {
    final predictions = await predictEmotions(audioBytes, sampleRate: sampleRate);
    
    final entries = predictions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return entries.take(topN).toList();
  }
  
  /// Get label name from index
  String getLabelName(int index) {
    return _labelMap[index] ?? 'unknown';
  }
}

