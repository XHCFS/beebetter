import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:beebetter/data/database/app_database.dart';
import 'package:beebetter/data/database/tables.dart' as schema;

class PromptInitializationService {
  final AppDatabase db;

  PromptInitializationService(this.db);

  /// Populates the Prompts table from a JSON string.
  Future<void> initializePromptsFromJson(String jsonString) async {
    try {
      // 1. Check if prompts already exist to avoid redundant work
      final existingPrompts = await db.select(db.prompts).get();
      if (existingPrompts.isNotEmpty) {
        print('Prompts already initialized. Skipping population.');
        return;
      }

      final List<dynamic> decodedData = json.decode(jsonString);

      await db.batch((batch) {
        for (var item in decodedData) {
          // Robust Mood Mapping
          final List<int>? moodIndexes = (item['target_mood_states'] as List?)
              ?.map((m) {
                final index = schema.Mood.values.indexWhere((e) => e.name == m);
                if (index == -1) print('Warning: Mood "$m" not found in enum');
                return index;
              })
              .where((index) => index != -1)
              .toList();

          batch.insert(
            db.prompts,
            PromptsCompanion.insert(
              content: item['text'] ?? 'No content provided',
              therapeuticFramework: item['therapeutic_framework'] ?? 'General',
              difficultyLevel: item['difficulty_level'] ?? 1,
              category: Value(item['category'] as String?),
              targetMoodStates: Value(
                moodIndexes != null ? json.encode(moodIndexes) : null,
              ),
              bestTimeOfDay: Value(
                (item['best_time_of_day'] as List?)?.join(', '),
              ),
              tags: Value(
                item['tags'] != null ? json.encode(item['tags']) : null,
              ),
              sourceCitation: Value(item['source_citation'] as String?),
              isActive: const Value(true),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });
      print('Successfully initialized ${decodedData.length} prompts.');
    } catch (e, stackTrace) {
      // Error Handling: Log the error and stack trace for debugging
      print('Error initializing prompts: $e');
      print(stackTrace);
      rethrow; // Optional: rethrow if you want the UI to handle the failure
    }
  }
}
