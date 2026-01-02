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

    test('Filters out avoided prompts from results', () async {
      await seedPrompts();
      final userId = await db
          .into(db.user)
          .insert(
            UserCompanion.insert(
              name: 'Test User',
              preferredCategories: Value(jsonEncode(['gratitude'])),
              currentDifficultyLevel: const Value(1),
            ),
          );

      // Avoid the gratitude prompt (id: 1)
      await db.into(db.userAvoidedPrompts).insert(
            UserAvoidedPromptsCompanion.insert(
              userId: userId,
              promptId: 1,
            ),
          );

      final ranked = await system.rankPromptsForUser(userId: userId);

      // Should only return the expressive_writing prompt, not the avoided gratitude one
      expect(ranked.length, 1);
      expect(ranked.first.prompt.category, 'expressive_writing');
      expect(ranked.first.prompt.id, 2);
    });

    test('Returns empty list when all prompts are avoided, then resets oldest', () async {
      await seedPrompts();
      final userId = await db
          .into(db.user)
          .insert(
            UserCompanion.insert(
              name: 'Test User',
              currentDifficultyLevel: const Value(1),
            ),
          );

      // Avoid both prompts
      await db.into(db.userAvoidedPrompts).insert(
            UserAvoidedPromptsCompanion.insert(
              userId: userId,
              promptId: 1,
              avoidedAt: Value(DateTime.now().subtract(const Duration(days: 5))),
            ),
          );
      await db.into(db.userAvoidedPrompts).insert(
            UserAvoidedPromptsCompanion.insert(
              userId: userId,
              promptId: 2,
              avoidedAt: Value(DateTime.now().subtract(const Duration(days: 2))),
            ),
          );

      // First call should reset oldest (prompt 1) and return prompts
      final ranked = await system.rankPromptsForUser(userId: userId);

      // Should have at least one prompt (the one that was reset)
      expect(ranked.isNotEmpty, isTrue);
      
      // Verify prompt 1 was reset (oldest)
      final remainingAvoided = await (db.select(db.userAvoidedPrompts)
            ..where((uap) => uap.userId.equals(userId)))
          .get();
      expect(remainingAvoided.length, 1); // Only prompt 2 should remain
      expect(remainingAvoided.first.promptId, 2);
    });

    test('Balances difficulty to prevent too many consecutive same-difficulty prompts', () async {
      // Create prompts with different difficulty levels
      final prompts = [
        {'id': 10, 'content': 'Easy 1', 'level': 1},
        {'id': 11, 'content': 'Easy 2', 'level': 1},
        {'id': 12, 'content': 'Easy 3', 'level': 1},
        {'id': 20, 'content': 'Medium 1', 'level': 3},
        {'id': 21, 'content': 'Medium 2', 'level': 3},
        {'id': 30, 'content': 'Hard 1', 'level': 5},
      ];

      for (var p in prompts) {
        await db.into(db.prompts).insert(
              PromptsCompanion.insert(
                id: Value(p['id'] as int),
                content: p['content'] as String,
                difficultyLevel: p['level'] as int,
                therapeuticFramework: 'CBT',
                isActive: const Value(true),
              ),
            );
      }

      final userId = await db
          .into(db.user)
          .insert(
            UserCompanion.insert(
              name: 'Balance User',
              currentDifficultyLevel: const Value(2),
            ),
          );

      final ranked = await system.rankPromptsForUser(userId: userId, limit: 6);

      // Check that we don't have more than 2 consecutive prompts of the same difficulty
      int consecutiveCount = 1;
      int? lastDifficulty;

      for (final scored in ranked) {
        final difficulty = scored.prompt.difficultyLevel;
        if (lastDifficulty == difficulty) {
          consecutiveCount++;
          expect(
            consecutiveCount,
            lessThanOrEqualTo(2),
            reason: 'Should not have more than 2 consecutive prompts of difficulty $difficulty',
          );
        } else {
          consecutiveCount = 1;
          lastDifficulty = difficulty;
        }
      }
    });
  });
}
