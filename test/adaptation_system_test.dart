import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beebetter/data/database/app_database.dart';
import 'package:beebetter/prompting_system/services/adaptation_system.dart';
import 'package:beebetter/data/database/tables.dart' as schema;
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/drift.dart';

AppDatabase _createTestDatabase() {
  return AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
}
void main() {
  late AppDatabase db;
  late AdaptationService service;

  setUp(() {
    db = _createTestDatabase();
    service = AdaptationService(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('AdaptationService - Difficulty Adjustment', () {
    test(
      'Increment level when completion rate > 80% and high engagement',
      () async {
        // 1. Setup User (last adjusted 8 days ago)
        final userId = await db
            .into(db.user)
            .insert(
              UserCompanion.insert(
                name: 'Test User',
                currentDifficultyLevel: const Value(2),
                lastDifficultyAdjustment: Value(
                  DateTime.now().subtract(const Duration(days: 8)),
                ),
              ),
            );

        // 2. Setup 10 completed interactions
        for (int i = 0; i < 10; i++) {
          await db
              .into(db.promptInteractions)
              .insert(
                PromptInteractionsCompanion.insert(
                  userId: userId,
                  promptId: 1,
                  completed: true,
                  skipped: false,
                ),
              );
        }

        // 3. Setup 10 high-effort records (120 words)
        for (int i = 0; i < 10; i++) {
          await db
              .into(db.records)
              .insert(
                RecordsCompanion.insert(
                  userId: Value(userId),
                  content: Value('word ' * 120),
                  createdAt: Value(DateTime.now()),
                ),
              );
        }

        await service.runAdaptation(userId);

        final updatedUser = await (db.select(
          db.user,
        )..where((u) => u.id.equals(userId))).getSingle();
        expect(updatedUser.currentDifficultyLevel, 3);
      },
    );

    test('Decrement level when no entries in 7 days', () async {
      final userId = await db
          .into(db.user)
          .insert(
            UserCompanion.insert(
              name: 'Inactive User',
              currentDifficultyLevel: const Value(3),
              lastDifficultyAdjustment: Value(
                DateTime.now().subtract(const Duration(days: 10)),
              ),
            ),
          );

      // No records inserted in the last 7 days

      await service.runAdaptation(userId);

      final updatedUser = await (db.select(
        db.user,
      )..where((u) => u.id.equals(userId))).getSingle();
      expect(updatedUser.currentDifficultyLevel, 2);
    });
  });

  group('AdaptationService - Preference Learning', () {
    test('Learns category after 6 entries with positive moods', () async {
      final userId = await db
          .into(db.user)
          .insert(UserCompanion.insert(name: 'Learning User'));

      final promptId = await db
          .into(db.prompts)
          .insert(
            PromptsCompanion.insert(
              content: 'Reflect on joy',
              therapeuticFramework: 'CBT',
              difficultyLevel: 1,
              category: const Value('Mindfulness'),
            ),
          );

      // Create 6 records with positive moods
      for (int i = 0; i < 6; i++) {
        final recordId = await db
            .into(db.records)
            .insert(
              RecordsCompanion.insert(
                userId: Value(userId),
                promptId: Value(promptId),
                content: Value('Significant content for the bonus... ' * 20),
              ),
            );

        await db
            .into(db.moods)
            .insert(
              MoodsCompanion.insert(
                recordId: recordId,
                mood: Value(schema.Mood.grateful.index), // Positive mood bonus
              ),
            );
      }

      await service.runAdaptation(userId);

      final updatedUser = await (db.select(
        db.user,
      )..where((u) => u.id.equals(userId))).getSingle();
      expect(updatedUser.preferredCategories, contains('Mindfulness'));
    });
  });

  group('AdaptationService - Avoided Prompts', () {
    test('Adds prompt to avoided list after 3 skips', () async {
      final userId = await db
          .into(db.user)
          .insert(UserCompanion.insert(name: 'Skipper'));
      const dislikedPromptId = 99;

      // Insert 3 skipped interactions
      for (int i = 0; i < 3; i++) {
        await db
            .into(db.promptInteractions)
            .insert(
              PromptInteractionsCompanion.insert(
                userId: userId,
                promptId: dislikedPromptId,
                completed: false,
                skipped: true,
              ),
            );
      }

      await service.runAdaptation(userId);

      final avoidedPrompts = await (db.select(db.userAvoidedPrompts)
            ..where((uap) => uap.userId.equals(userId)))
          .get();
      expect(avoidedPrompts.any((ap) => ap.promptId == dislikedPromptId), isTrue);
    });

    test('Expires avoided prompts older than 30 days', () async {
      final userId = await db
          .into(db.user)
          .insert(UserCompanion.insert(name: 'Expiration User'));
      const promptId1 = 10;
      const promptId2 = 20;

      // Create two avoided prompts: one old, one recent
      await db.into(db.userAvoidedPrompts).insert(
            UserAvoidedPromptsCompanion.insert(
              userId: userId,
              promptId: promptId1,
              avoidedAt: Value(DateTime.now().subtract(const Duration(days: 35))), // Old
            ),
          );
      await db.into(db.userAvoidedPrompts).insert(
            UserAvoidedPromptsCompanion.insert(
              userId: userId,
              promptId: promptId2,
              avoidedAt: Value(DateTime.now().subtract(const Duration(days: 10))), // Recent
            ),
          );

      await service.runAdaptation(userId);

      // Only the recent one should remain
      final remaining = await (db.select(db.userAvoidedPrompts)
            ..where((uap) => uap.userId.equals(userId)))
          .get();
      expect(remaining.length, 1);
      expect(remaining.first.promptId, promptId2);
    });
  });

  group('AdaptationService - Preference Learning Frequency', () {
    test('Learns category after 6 entries (not just multiples of 6)', () async {
      final userId = await db
          .into(db.user)
          .insert(UserCompanion.insert(name: 'Learning User'));

      final promptId = await db
          .into(db.prompts)
          .insert(
            PromptsCompanion.insert(
              content: 'Reflect on joy',
              therapeuticFramework: 'CBT',
              difficultyLevel: 1,
              category: const Value('Mindfulness'),
            ),
          );

      // Create 7 entries (not a multiple of 6)
      for (int i = 0; i < 7; i++) {
        final recordId = await db
            .into(db.records)
            .insert(
              RecordsCompanion.insert(
                userId: Value(userId),
                promptId: Value(promptId),
                content: Value('Significant content... ' * 20),
                createdAt: Value(DateTime.now().subtract(Duration(days: 29 - i))),
              ),
            );

        await db
            .into(db.moods)
            .insert(
              MoodsCompanion.insert(
                recordId: recordId,
                mood: Value(schema.Mood.grateful.index),
              ),
            );
      }

      await service.runAdaptation(userId);

      final updatedUser = await (db.select(
        db.user,
      )..where((u) => u.id.equals(userId))).getSingle();
      // Should learn preference even though 7 is not a multiple of 6
      expect(updatedUser.preferredCategories, contains('Mindfulness'));
    });
  });
}
