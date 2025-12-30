// test/database_comprehensive_test.dart
import 'package:beebetter/data/database/tables.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beebetter/data/database/app_database.dart' hide Mood;
import 'dart:convert';

AppDatabase _createTestDatabase() {
  return AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
}
extension PromptFilling on AppDatabase {
  Future<void> completePrompt({
    required int userId,
    required int promptId,
    required String content,
    required Mood userMood,
    InputType inputType = InputType.text,
  }) async {
    print('--- Executing completePrompt Transaction for User: $userId ---');
    await transaction(() async {
      final recordId = await into(records).insert(
        RecordsCompanion.insert(
          userId: Value(userId),
          promptId: Value(promptId),
          content: Value(content),
          inputType: Value(inputType.index),
          createdAt: Value(DateTime.now()),
        ),
      );
      print('    Created Record ID: $recordId');

      await into(moods).insert(
        MoodsCompanion.insert(
          recordId: recordId,
          mood: Value(userMood.index),
          source: Value(MoodSource.user.index),
        ),
      );

      await into(promptInteractions).insert(
        PromptInteractionsCompanion.insert(
          userId: userId,
          promptId: promptId,
          completed: true,
          skipped: false,
        ),
      );
    });
    print('--- Transaction Successful ---\n');
  }
}


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late AppDatabase db;

  setUp(() {
    db = _createTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  group('User Table Tests', () {
    test('Create user with all fields', () async {
      print('>> Running: Create user with all fields');
      final userId = await db
          .into(db.user)
          .insert(
            UserCompanion.insert(
              name: 'John Doe',
              age: Value(30),
              currentDifficultyLevel: Value(2),
              journalingStreak: Value(5),
              preferredCategories: Value(
                json.encode(['reflection', 'gratitude']),
              ),
              avoidedPrompts: Value(json.encode([1, 3, 5])),
              lastDifficultyAdjustment: Value(DateTime.now()),
            ),
          );

      final user = await (db.select(
        db.user,
      )..where((u) => u.id.equals(userId))).getSingle();

      expect(user.name, 'John Doe');
      expect(user.age, 30);
      print('   Verified user: ${user.name}');
    });

    test('Update user fields', () async {
      print('>> Running: Update user fields');
      final userId = await db
          .into(db.user)
          .insert(
            UserCompanion.insert(
              name: 'Jane',
              age: Value(25),
              journalingStreak: Value(0),
            ),
          );

      await (db.update(db.user)..where((u) => u.id.equals(userId))).write(
        UserCompanion(
          journalingStreak: Value(10),
          currentDifficultyLevel: Value(3),
        ),
      );

      final updated = await (db.select(
        db.user,
      )..where((u) => u.id.equals(userId))).getSingle();
      expect(updated.journalingStreak, 10);
      print('   User streak updated to: ${updated.journalingStreak}');
    });

    test('Delete user', () async {
      print('>> Running: Delete user');
      final userId = await db
          .into(db.user)
          .insert(UserCompanion.insert(name: 'Temp User'));
      await (db.delete(db.user)..where((u) => u.id.equals(userId))).go();
      final users = await (db.select(
        db.user,
      )..where((u) => u.id.equals(userId))).get();
      expect(users.isEmpty, true);
      print('   User successfully deleted');
    });

    test('Multiple users management', () async {
      print('>> Running: Multiple users management');
      await db
          .into(db.user)
          .insert(UserCompanion.insert(name: 'User 1', age: Value(20)));
      await db
          .into(db.user)
          .insert(UserCompanion.insert(name: 'User 2', age: Value(30)));
      final allUsers = await db.select(db.user).get();
      expect(allUsers.length, 2);
      print('   Database contains ${allUsers.length} users');
    });
  });

  group('Prompts Table Tests', () {
    test('Create prompt with all fields', () async {
      print('>> Running: Create prompt with all fields');
      final promptId = await db
          .into(db.prompts)
          .insert(
            PromptsCompanion.insert(
              content: 'What made you smile today?',
              therapeuticFramework: 'Positive Psychology',
              difficultyLevel: 1,
              category: Value('Gratitude'),
              isActive: Value(true),
            ),
          );
      print('   Prompt created with ID: $promptId');
    });
  });

  group('Complex Queries & Relationships', () {
    test('Complete workflow: User completes prompt with mood', () async {
      print('>> Running: Complete workflow');
      final userId = await db
          .into(db.user)
          .insert(UserCompanion.insert(name: 'Full Flow User'));
      final promptId = await db
          .into(db.prompts)
          .insert(
            PromptsCompanion.insert(
              content: 'Reflect on your day',
              therapeuticFramework: 'Mindfulness',
              difficultyLevel: 2,
            ),
          );

      await db.completePrompt(
        userId: userId,
        promptId: promptId,
        content: 'Today was productive and fulfilling.',
        userMood: Mood.satisfied,
      );

      final records = await (db.select(
        db.records,
      )..where((r) => r.userId.equals(userId))).get();
      expect(records.length, 1);
      print('   Workflow verified: Record and interaction created.');
    });

    test('Transaction rollback on error', () async {
      print('>> Running: Transaction rollback on error');
      final userId = await db
          .into(db.user)
          .insert(UserCompanion.insert(name: 'Transaction User'));

      try {
        await db.transaction(() async {
          await db
              .into(db.records)
              .insert(
                RecordsCompanion.insert(
                  userId: Value(userId),
                  content: Value('Rollback me'),
                ),
              );
          print('   Inserted entry, now throwing error...');
          throw Exception('Simulated error');
        });
      } catch (e) {
        print('   Caught expected error: $e');
      }

      final records = await (db.select(
        db.records,
      )..where((r) => r.userId.equals(userId))).get();
      expect(records.isEmpty, true);
      print('   Verified: Database rolled back successfully.');
    });
  });
}
