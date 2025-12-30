import 'dart:convert';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beebetter/data/database/app_database.dart';
import 'package:beebetter/data/database/tables.dart' as schema;
import 'package:beebetter/prompting_system/services/prompt_selection_system.dart';

void main() {
  late AppDatabase db;
  late PromptSelectionSystem system;

  setUp(() {
    db = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    // Using a fixed seed for the default system instance
    system = PromptSelectionSystem(db, random: Random(42));
  });

  tearDown(() async => await db.close());

  /// Helper to seed the database with consistent test data
  Future<void> seedPrompts() async {
    final prompts = [
      {
        'id': 1,
        'content': "Gratitude",
        'category': 'gratitude',
        'level': 1,
        'moods': [schema.Mood.content.index],
      },
      {
        'id': 2,
        'content': "Writing",
        'category': 'expressive_writing',
        'level': 1,
        'moods': [schema.Mood.anxious.index],
      },
    ];
    for (var p in prompts) {
      await db
          .into(db.prompts)
          .insert(
            PromptsCompanion.insert(
              id: Value(p['id'] as int),
              content: p['content'] as String,
              category: Value(p['category'] as String),
              difficultyLevel: p['level'] as int,
              targetMoodStates: Value(jsonEncode(p['moods'])),
              isActive: const Value(true),
              therapeuticFramework: 'CBT',
            ),
          );
    }
  }

  group('PromptScorer - Deterministic Logic', () {
    final scorer = PromptScorer();

    test('Should award exactly +8.5 for a perfect match scenario', () {
      final prompt = Prompt(
        id: 1,
        content: 'Test',
        category: 'stress',
        difficultyLevel: 1,
        therapeuticFramework: 'CBT',
        isActive: true,
      );

      final user = UserData(
        id: 1,
        name: 'User',
        preferredCategories: jsonEncode(['stress']),
        currentDifficultyLevel: 1,
      );

      final score = scorer.score(
        prompt: prompt,
        user: user,
        recentPromptIds: [], // +2.0 (Not recent)
        recentCategories: [], // +1.5 (New category)
        recentMoods: [],
        preferredCategories: ['stress'], // +2.0 (Preferred)
        timeOfDay: 'morning', // +1.0 (Matches default)
      );

      // Score: 2.0 (New) + 1.5 (New Cat) + 2.0 (Pref) + 2.0 (Diff Match) + 1.0 (Time) = 8.5
      expect(score, equals(8.5));
    });

    test('Mood Matching calculation matches expected overlap weight', () {
      final prompt = Prompt(
        id: 1,
        content: 'Expressive Writing',
        targetMoodStates: jsonEncode([
          schema.Mood.anxious.index,
          schema.Mood.depressed.index,
        ]),
        difficultyLevel: 1,
        therapeuticFramework: 'Framework',
        isActive: true,
      );

      final dummyUser = UserData(
        id: 1,
        name: 'User',
        currentDifficultyLevel: 1,
      );

      final score = scorer.score(
        prompt: prompt,
        user: dummyUser,
        recentPromptIds: [1], // Penalty: doesn't get the +2.0 New Prompt boost
        recentCategories: [
          'expressive_writing',
        ], // Penalty: doesn't get the +1.5 New Cat boost
        recentMoods: [schema.Mood.anxious], // One match! (+1.2)
        preferredCategories: [],
        timeOfDay: 'morning',
      );

      // Base for matching diff (2.0) + Time (1.0) + Mood (1.2) = 4.2
      expect(score, closeTo(4.2, 0.01));
    });
  });

  group('PromptSelectionSystem - Integration & Stress Tests', () {
    test('Scores are calculated correctly in the database context', () async {
      await seedPrompts();
      final userId = await db
          .into(db.user)
          .insert(
            UserCompanion.insert(
              name: 'Test User',
              preferredCategories: Value(jsonEncode(['expressive_writing'])),
              currentDifficultyLevel: const Value(1),
            ),
          );

      final ranked = await system.rankPromptsForUser(userId: userId);

      final writingResult = ranked.firstWhere(
        (r) => r.prompt.category == 'expressive_writing',
      );
      final gratitudeResult = ranked.firstWhere(
        (r) => r.prompt.category == 'gratitude',
      );

      print(
        'DEBUG: Writing Score: ${writingResult.score} | Gratitude Score: ${gratitudeResult.score}',
      );

      expect(writingResult.score, greaterThan(gratitudeResult.score));
      expect(
        writingResult.score - gratitudeResult.score,
        equals(2.0),
        reason: 'Difference should be exactly the preference boost',
      );
    });

    test(
      'Monte Carlo Stress Test: Higher scores win more often over 1000 runs',
      () async {
        await seedPrompts();
        final userId = await db
            .into(db.user)
            .insert(
              UserCompanion.insert(
                name: 'Stress User',
                preferredCategories: Value(jsonEncode(['expressive_writing'])),
                currentDifficultyLevel: const Value(1),
              ),
            );

        int writingWins = 0;
        int gratitudeWins = 0;
        const int iterations = 1000;

        for (int i = 0; i < iterations; i++) {
          // Use a new seed for every iteration to test randomness
          final sessionSystem = PromptSelectionSystem(db, random: Random(i));
          final result = await sessionSystem.rankPromptsForUser(userId: userId);

          if (result.first.prompt.category == 'expressive_writing')
            writingWins++;
          if (result.first.prompt.category == 'gratitude') gratitudeWins++;
        }

        final double writingRate = writingWins / iterations;
        final double gratitudeRate = gratitudeWins / iterations;

        print('\n--- STRESS TEST (1000 RUNS) ---');
        print(
          'Writing (Score 8.5) Win Rate: ${(writingRate * 100).toStringAsFixed(1)}%',
        );
        print(
          'Gratitude (Score 6.5) Win Rate: ${(gratitudeRate * 100).toStringAsFixed(1)}%',
        );

        // Theoretical probability: 8.5 / (8.5 + 6.5) = ~56.7%
        expect(writingWins, greaterThan(gratitudeWins));
        expect(writingRate, closeTo(0.56, 0.05));
      },
    );
  });
}
