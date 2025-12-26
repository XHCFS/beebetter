// lib/services/emotion_inference/emotion_mapper.dart

import '../../data/database/tables.dart';

/// Maps model predictions to Mood enum values
class EmotionMapper {
  /// Maps GoEmotions labels (LABEL_0 to LABEL_6) to Mood enum
  /// Simple 1-to-1 mapping: 0=angry, 1=disgust, 2=fear, 3=happy, 4=neutral, 5=sad, 6=surprise
  static Mood? mapTextEmotion(int labelIndex, {double? confidence}) {
    switch (labelIndex) {
      case 0: // angry
        return Mood.enraged;
      case 1: // disgust
        return Mood.contemptuous;
      case 2: // fear
        return Mood.anxious;
      case 3: // happy
        return Mood.cheerful;
      case 4: // neutral
        return Mood.content;
      case 5: // sad
        return Mood.depressed;
      case 6: // surprise
        return Mood.amazed;
      default:
        return null;
    }
  }
  
  /// Maps label name (string) to Mood enum
  static Mood? mapTextEmotionByName(String labelName, {double? confidence}) {
    switch (labelName.toLowerCase()) {
      case 'angry':
        return Mood.enraged;
      case 'disgust':
        return Mood.contemptuous;
      case 'fear':
        return Mood.anxious;
      case 'happy':
        return Mood.cheerful;
      case 'neutral':
        return Mood.content;
      case 'sad':
        return Mood.depressed;
      case 'surprise':
        return Mood.amazed;
      default:
        return null;
    }
  }
  
  /// Maps IEMOCAP voice labels to Mood enum
  /// Simple 1-to-1 mapping: ang=enraged, hap=cheerful, neu=content, sad=depressed
  static Mood? mapVoiceEmotion(String label, {double? confidence}) {
    switch (label.toLowerCase()) {
      case 'ang': // anger
        return Mood.enraged;
      case 'hap': // happiness
        return Mood.cheerful;
      case 'neu': // neutral
        return Mood.content;
      case 'sad': // sadness
        return Mood.depressed;
      default:
        return null;
    }
  }
  
  /// Maps voice emotion by index (0=ang, 1=hap, 2=neu, 3=sad)
  static Mood? mapVoiceEmotionByIndex(int index, {double? confidence}) {
    switch (index) {
      case 0: // ang
        return Mood.enraged;
      case 1: // hap
        return Mood.cheerful;
      case 2: // neu
        return Mood.content;
      case 3: // sad
        return Mood.depressed;
      default:
        return null;
    }
  }
  
  /// Get all possible moods from text predictions
  /// Returns a list of moods with confidence scores above threshold
  static List<MapEntry<Mood, double>> getMoodsFromTextPredictions(
    Map<int, double> predictions, {
    double threshold = 0.3,
  }) {
    final moods = <MapEntry<Mood, double>>[];
    
    predictions.forEach((labelIndex, confidence) {
      if (confidence >= threshold) {
        final mood = mapTextEmotion(labelIndex, confidence: confidence);
        if (mood != null) {
          moods.add(MapEntry(mood, confidence));
        }
      }
    });
    
    // Sort by confidence (descending)
    moods.sort((a, b) => b.value.compareTo(a.value));
    
    return moods;
  }
  
  /// Get primary mood from voice prediction
  static MapEntry<Mood, double>? getPrimaryMoodFromVoice(
    Map<int, double> predictions,
  ) {
    if (predictions.isEmpty) return null;
    
    var maxIndex = 0;
    var maxConfidence = 0.0;
    
    predictions.forEach((index, confidence) {
      if (confidence > maxConfidence) {
        maxConfidence = confidence;
        maxIndex = index;
      }
    });
    
    final mood = mapVoiceEmotionByIndex(maxIndex, confidence: maxConfidence);
    if (mood == null) return null;
    
    return MapEntry(mood, maxConfidence);
  }
  
  /// Get all moods from voice predictions above threshold
  static List<MapEntry<Mood, double>> getMoodsFromVoicePredictions(
    Map<int, double> predictions, {
    double threshold = 0.2,
  }) {
    final moods = <MapEntry<Mood, double>>[];
    
    predictions.forEach((index, confidence) {
      if (confidence >= threshold) {
        final mood = mapVoiceEmotionByIndex(index, confidence: confidence);
        if (mood != null) {
          moods.add(MapEntry(mood, confidence));
        }
      }
    });
    
    // Sort by confidence (descending)
    moods.sort((a, b) => b.value.compareTo(a.value));
    
    return moods;
  }
}

