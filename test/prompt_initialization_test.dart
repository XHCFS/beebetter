import 'package:beebetter/data/database/app_database.dart';
import 'package:beebetter/prompting_system/services/prompt_initalizer.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:drift/drift.dart' hide isNull;

void main() {
  late AppDatabase db;
  late PromptInitializationService service;

  setUp(() {
    // Initialize an in-memory database for clean state per test
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    service = PromptInitializationService(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('PromptInitializationService Tests', () {
    test('Successfully populates valid JSON data', () async {
      final validJson = json.encode([
        {
          "text": "Valid prompt",
          "category": "growth",
          "therapeutic_framework": "CBT",
          "difficulty_level": 1,
          "target_mood_states": ["satisfied", "proud"],
          "tags": ["test"],
          "best_time_of_day": ["morning"],
          "source_citation": "Source A",
        },
      ]);

      await service.initializePromptsFromJson(validJson);

      final prompts = await db.select(db.prompts).get();
      expect(prompts.length, 1);
      expect(prompts.first.content, "Valid prompt");
      // Verify Mood enum mapping: satisfied is index 7, proud is index 2
      expect(prompts.first.targetMoodStates, contains('7'));
      expect(prompts.first.targetMoodStates, contains('2'));
    });

    test('Handles missing optional fields with defaults', () async {
      final dirtyJson = json.encode([
        {
          "text": "Minimal prompt",
          "therapeutic_framework": "None",
          "difficulty_level": 3,
          // missing tags, category, mood states, etc.
        },
      ]);

      await service.initializePromptsFromJson(dirtyJson);

      final prompts = await db.select(db.prompts).get();
      expect(prompts.length, 1);
      expect(prompts.first.category, isNull);
      expect(prompts.first.isActive, true); // Default from schema
    });

    test('Does not duplicate data on second run', () async {
      final jsonInput = json.encode([
        {
          "text": "Unique prompt",
          "therapeutic_framework": "ACT",
          "difficulty_level": 2,
        },
      ]);

      // First run
      await service.initializePromptsFromJson(jsonInput);
      // Second run
      await service.initializePromptsFromJson(jsonInput);

      final prompts = await db.select(db.prompts).get();
      expect(prompts.length, 1); // Should remain 1 due to the .isNotEmpty check
    });

    test('Gracefully handles invalid mood names', () async {
      final invalidMoodJson = json.encode([
        {
          "text": "Prompt with bad mood",
          "therapeutic_framework": "Test",
          "difficulty_level": 1,
          "target_mood_states": ["not_a_real_mood", "proud"],
        },
      ]);

      await service.initializePromptsFromJson(invalidMoodJson);

      final prompt = await db.select(db.prompts).getSingle();
      final List decodedMoods = json.decode(prompt.targetMoodStates!);

      // Should only contain the index for "proud" (2), ignoring "not_a_real_mood"
      expect(decodedMoods.length, 1);
      expect(decodedMoods.first, 2);
    });
  });
}
