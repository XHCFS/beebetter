// test/services/emotion_inference/text_emotion_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:beebetter/services/emotion_inference/text_emotion_service.dart';
import 'package:beebetter/services/emotion_inference/emotion_mapper.dart';
import 'package:beebetter/data/database/tables.dart';

void main() {
  // Initialize Flutter bindings for tests that need asset loading
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('TextEmotionService', () {
    late TextEmotionService service;

    setUp(() {
      service = TextEmotionService();
    });

    tearDown(() {
      service.dispose();
    });

    test('should initialize successfully', () async {
      await service.initialize();
      // If initialization fails, it will throw an exception
      expect(true, isTrue);
    });

    test('should get label names', () {
      final labelNames = TextEmotionService.getLabelNames();
      expect(labelNames.length, 7);
      expect(labelNames, contains('angry'));
      expect(labelNames, contains('disgust'));
      expect(labelNames, contains('fear'));
      expect(labelNames, contains('happy'));
      expect(labelNames, contains('neutral'));
      expect(labelNames, contains('sad'));
      expect(labelNames, contains('surprise'));
    });

    test('should get label name by index', () {
      expect(TextEmotionService.getLabelName(0), 'angry');
      expect(TextEmotionService.getLabelName(1), 'disgust');
      expect(TextEmotionService.getLabelName(2), 'fear');
      expect(TextEmotionService.getLabelName(3), 'happy');
      expect(TextEmotionService.getLabelName(4), 'neutral');
      expect(TextEmotionService.getLabelName(5), 'sad');
      expect(TextEmotionService.getLabelName(6), 'surprise');
    });

    test('should predict emotions from text', () async {
      await service.initialize();
      
      final predictions = await service.predictEmotions('I am so happy today!');
      
      expect(predictions.length, 7);
      expect(predictions.containsKey(0), true); // angry
      expect(predictions.containsKey(1), true); // disgust
      expect(predictions.containsKey(2), true); // fear
      expect(predictions.containsKey(3), true); // happy
      expect(predictions.containsKey(4), true); // neutral
      expect(predictions.containsKey(5), true); // sad
      expect(predictions.containsKey(6), true); // surprise
      
      // All predictions should be between 0 and 1 (sigmoid output)
      predictions.forEach((key, value) {
        expect(value, greaterThanOrEqualTo(0.0));
        expect(value, lessThanOrEqualTo(1.0));
      });
    });

    test('should handle empty text', () async {
      await service.initialize();
      
      expect(
        () => service.predictEmotions(''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should handle long text by chunking', () async {
      await service.initialize();
      
      final longText = 'I am feeling great today. ' * 100; // Very long text
      final predictions = await service.predictEmotions(longText);
      
      expect(predictions.length, 7);
      // Should not throw and should return valid predictions
      predictions.forEach((key, value) {
        expect(value, greaterThanOrEqualTo(0.0));
        expect(value, lessThanOrEqualTo(1.0));
      });
    });

    test('should get top emotions', () async {
      await service.initialize();
      
      final topEmotions = await service.getTopEmotions(
        'I am so happy and excited!',
        topN: 3,
        threshold: 0.1,
      );
      
      expect(topEmotions.length, lessThanOrEqualTo(3));
      // Should be sorted by confidence (descending)
      if (topEmotions.length > 1) {
        for (var i = 0; i < topEmotions.length - 1; i++) {
          expect(
            topEmotions[i].value,
            greaterThanOrEqualTo(topEmotions[i + 1].value),
          );
        }
      }
    });
  });

  group('EmotionMapper - Text Emotions', () {
    test('should map all 7 text emotions to Mood enum', () {
      expect(EmotionMapper.mapTextEmotion(0), Mood.enraged); // angry
      expect(EmotionMapper.mapTextEmotion(1), Mood.contemptuous); // disgust
      expect(EmotionMapper.mapTextEmotion(2), Mood.anxious); // fear
      expect(EmotionMapper.mapTextEmotion(3), Mood.cheerful); // happy
      expect(EmotionMapper.mapTextEmotion(4), Mood.content); // neutral
      expect(EmotionMapper.mapTextEmotion(5), Mood.depressed); // sad
      expect(EmotionMapper.mapTextEmotion(6), Mood.amazed); // surprise
    });

    test('should map text emotion by name', () {
      expect(EmotionMapper.mapTextEmotionByName('angry'), Mood.enraged);
      expect(EmotionMapper.mapTextEmotionByName('disgust'), Mood.contemptuous);
      expect(EmotionMapper.mapTextEmotionByName('fear'), Mood.anxious);
      expect(EmotionMapper.mapTextEmotionByName('happy'), Mood.cheerful);
      expect(EmotionMapper.mapTextEmotionByName('neutral'), Mood.content);
      expect(EmotionMapper.mapTextEmotionByName('sad'), Mood.depressed);
      expect(EmotionMapper.mapTextEmotionByName('surprise'), Mood.amazed);
    });

    test('should handle case-insensitive emotion names', () {
      expect(EmotionMapper.mapTextEmotionByName('HAPPY'), Mood.cheerful);
      expect(EmotionMapper.mapTextEmotionByName('Angry'), Mood.enraged);
      expect(EmotionMapper.mapTextEmotionByName('SAD'), Mood.depressed);
    });

    test('should return null for invalid emotion names', () {
      expect(EmotionMapper.mapTextEmotionByName('invalid'), null);
      expect(EmotionMapper.mapTextEmotionByName(''), null);
    });

    test('should filter predictions by threshold', () {
      final predictions = <int, double>{
        0: 0.1, // angry - below threshold
        1: 0.2, // disgust - below threshold
        2: 0.5, // fear - above threshold
        3: 0.8, // happy - above threshold
        4: 0.3, // neutral - at threshold (included)
        5: 0.15, // sad - below threshold
        6: 0.4, // surprise - above threshold
      };

      final moods = EmotionMapper.getMoodsFromTextPredictions(
        predictions,
        threshold: 0.3,
      );

      expect(moods.length, 4); // fear, happy, neutral, surprise (all >= 0.3)
      expect(moods[0].key, Mood.cheerful); // Highest confidence (0.8)
      expect(moods[0].value, 0.8);
    });

    test('should sort moods by confidence descending', () {
      final predictions = <int, double>{
        0: 0.5,
        1: 0.8,
        2: 0.3,
        3: 0.9,
      };

      final moods = EmotionMapper.getMoodsFromTextPredictions(
        predictions,
        threshold: 0.0, // Include all
      );

      expect(moods.length, 4);
      expect(moods[0].value, 0.9); // Highest
      expect(moods[1].value, 0.8);
      expect(moods[2].value, 0.5);
      expect(moods[3].value, 0.3); // Lowest
    });
  });
}

