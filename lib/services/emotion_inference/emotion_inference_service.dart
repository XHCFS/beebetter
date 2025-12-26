// lib/services/emotion_inference/emotion_inference_service.dart

import 'dart:typed_data';
import '../../data/database/tables.dart';
import 'text_emotion_service.dart';
import 'voice_emotion_service.dart';
import 'emotion_mapper.dart';

/// Main service that coordinates both text and voice emotion inference
class EmotionInferenceService {
  final TextEmotionService _textService = TextEmotionService();
  final VoiceEmotionService _voiceService = VoiceEmotionService();
  
  bool _isInitialized = false;
  bool _voiceModelAvailable = false;
  
  /// Initialize both models
  /// Voice model initialization may fail on some platforms due to quantization support
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize text model (required)
      await _textService.initialize();
      
      // Try to initialize voice model (optional - may fail on some platforms)
      try {
        await _voiceService.initialize();
        _voiceModelAvailable = true;
      } catch (voiceError) {
        // Voice model may not be supported on this platform (e.g., quantized ops on Linux)
        // Text model will still work
        _voiceModelAvailable = false;
        print('Warning: Voice model initialization failed: $voiceError');
        print('Text emotion inference will still be available.');
      }
      
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize emotion inference services: $e');
    }
  }
  
  /// Dispose of both services
  void dispose() {
    _textService.dispose();
    _voiceService.dispose();
    _isInitialized = false;
  }
  
  /// Predict emotions from text
  /// Returns a list of moods with confidence scores
  Future<List<MapEntry<Mood, double>>> predictEmotionsFromText(
    String text, {
    double threshold = 0.3,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    final predictions = await _textService.predictEmotions(text);
    return EmotionMapper.getMoodsFromTextPredictions(
      predictions,
      threshold: threshold,
    );
  }
  
  /// Get raw model predictions (all 7 labels) without threshold filtering
  Future<Map<int, double>> getRawTextPredictions(String text) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    return await _textService.predictEmotions(text);
  }
  
  /// Get label names for text model
  List<String> getTextLabelNames() {
    return TextEmotionService.getLabelNames();
  }
  
  /// Get label name for a specific index
  String getTextLabelName(int index) {
    return TextEmotionService.getLabelName(index);
  }
  
  /// Predict emotions from voice/audio
  /// Returns a list of moods with confidence scores
  Future<List<MapEntry<Mood, double>>> predictEmotionsFromVoice(
    Uint8List audioBytes, {
    int sampleRate = 16000,
    double threshold = 0.2,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_voiceModelAvailable) {
      throw Exception('Voice model is not available on this platform. Quantized operations may not be supported.');
    }
    
    final predictions = await _voiceService.predictEmotions(
      audioBytes,
      sampleRate: sampleRate,
    );
    return EmotionMapper.getMoodsFromVoicePredictions(
      predictions,
      threshold: threshold,
    );
  }
  
  /// Get primary emotion from text (highest confidence)
  Future<MapEntry<Mood, double>?> getPrimaryEmotionFromText(String text) async {
    final moods = await predictEmotionsFromText(text, threshold: 0.0);
    return moods.isNotEmpty ? moods.first : null;
  }
  
  /// Get primary emotion from voice (highest confidence)
  Future<MapEntry<Mood, double>?> getPrimaryEmotionFromVoice(
    Uint8List audioBytes, {
    int sampleRate = 16000,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_voiceModelAvailable) {
      throw Exception('Voice model is not available on this platform. Quantized operations may not be supported.');
    }
    
    final predictions = await _voiceService.predictEmotions(
      audioBytes,
      sampleRate: sampleRate,
    );
    return EmotionMapper.getPrimaryMoodFromVoice(predictions);
  }
  
  /// Get top N emotions from text
  Future<List<MapEntry<Mood, double>>> getTopEmotionsFromText(
    String text, {
    int topN = 3,
    double threshold = 0.3,
  }) async {
    final moods = await predictEmotionsFromText(text, threshold: threshold);
    return moods.take(topN).toList();
  }
  
  /// Get top N emotions from voice
  Future<List<MapEntry<Mood, double>>> getTopEmotionsFromVoice(
    Uint8List audioBytes, {
    int topN = 2,
    int sampleRate = 16000,
    double threshold = 0.2,
  }) async {
    final moods = await predictEmotionsFromVoice(
      audioBytes,
      sampleRate: sampleRate,
      threshold: threshold,
    );
    return moods.take(topN).toList();
  }
  
  /// Check if services are initialized
  bool get isInitialized => _isInitialized;
  
  /// Check if voice model is available
  bool get isVoiceModelAvailable => _voiceModelAvailable;
}

