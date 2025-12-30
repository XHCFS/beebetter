import 'dart:convert';
import 'package:beebetter/data/database/app_database.dart';
import 'package:beebetter/data/database/tables.dart' as schema;
import 'package:drift/drift.dart';

class AdaptationService {
  final AppDatabase _db;

  AdaptationService(this._db);

  /// Main entry point to run adaptation logic for a user.
  Future<void> runAdaptation(int userId) async {
    await _adjustDifficultyLevel(userId);
    await _updatePreferenceCategories(userId);
    await _updateAvoidedPrompts(userId);
  }

  /* -------------------------------------------------------------------------- */
  /* DIFFICULTY LEVEL ADJUSTMENT                                                */
  /* -------------------------------------------------------------------------- */

  Future<void> _adjustDifficultyLevel(int userId) async {
    final user = await (_db.select(
      _db.user,
    )..where((u) => u.id.equals(userId))).getSingle();
    final now = DateTime.now();

    // Constraint: Once per day check
    if (user.lastDifficultyAdjustment != null &&
        _isSameDay(user.lastDifficultyAdjustment!, now)) {
      return;
    }

    // Get interactions and records for logic gates
    final tenDaysAgo = now.subtract(const Duration(days: 10));
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    final recentInteractions =
        await (_db.select(_db.promptInteractions)
              ..where((pi) => pi.userId.equals(userId))
              ..where(
                (pi) => pi.id.isBiggerThanValue(0),
              ) // Placeholder for logic
              ..orderBy([(pi) => OrderingTerm.desc(pi.id)])
              ..limit(10))
            .get();

    final recentRecords =
        await (_db.select(_db.records)
              ..where((r) => r.userId.equals(userId))
              ..where((r) => r.createdAt.isBiggerThanValue(tenDaysAgo)))
            .get();

    /* --- INCREMENT LOGIC --- */
    bool meetsMinDays =
        user.lastDifficultyAdjustment == null ||
        now.difference(user.lastDifficultyAdjustment!).inDays >= 7;

    if (meetsMinDays && recentInteractions.length >= 10) {
      final completionRate =
          recentInteractions.where((i) => i.completed).length / 10;

      // Calculate averages from records
      final avgWords = recentRecords.isEmpty
          ? 0
          : recentRecords
                    .map((r) => _countWords(r.content))
                    .reduce((a, b) => a + b) /
                recentRecords.length;

      // NOTE: 'durationSeconds' is missing in your tables.dart. Assuming 0 for now.
      final avgTime = 0;

      if (completionRate > 0.8 && (avgWords >= 100 || avgTime >= 300)) {
        await _updateUserDifficulty(
          userId,
          (user.currentDifficultyLevel ?? 1) + 1,
        );
        return; // Don't decrement if we just incremented
      }
    }

    /* --- DECREMENT LOGIC --- */
    final hasEntriesIn7Days = recentRecords.any(
      (r) => r.createdAt.isAfter(sevenDaysAgo),
    );

    // Completion rate check for decrement (using last 10 interactions)
    double completionRate = 1.0;
    if (recentInteractions.isNotEmpty) {
      completionRate =
          recentInteractions.where((i) => i.completed).length /
          recentInteractions.length;
    }

    if (completionRate < 0.5 || !hasEntriesIn7Days) {
      await _updateUserDifficulty(
        userId,
        (user.currentDifficultyLevel ?? 1) - 1,
      );
    }
  }

  /* -------------------------------------------------------------------------- */
  /* PREFERENCE CATEGORIES LEARNING                                             */
  /* -------------------------------------------------------------------------- */

  Future<void> _updatePreferenceCategories(int userId) async {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

    // Query last 30 days join
    final query =
        _db.select(_db.records).join([
            leftOuterJoin(
              _db.prompts,
              _db.prompts.id.equalsExp(_db.records.promptId),
            ),
            leftOuterJoin(
              _db.moods,
              _db.moods.recordId.equalsExp(_db.records.id),
            ),
          ])
          ..where(_db.records.userId.equals(userId))
          ..where(_db.records.createdAt.isBiggerThanValue(thirtyDaysAgo));

    final rows = await query.get();

    // Constraint: Run every 6 entries in the same 30 days
    if (rows.length < 6 || rows.length % 6 != 0) return;

    final Map<String, double> categoryScores = {};
    final avgWords =
        rows
            .map((r) => _countWords(r.readTable(_db.records).content))
            .reduce((a, b) => a + b) /
        rows.length;

    for (final row in rows) {
      final record = row.readTable(_db.records);
      final prompt = row.readTableOrNull(_db.prompts);
      final moodInt = row.readTableOrNull(_db.moods)?.mood;

      if (prompt?.category == null) continue;
      final cat = prompt!.category!;

      categoryScores[cat] = (categoryScores[cat] ?? 0) + 5; // Category Present

      if (_countWords(record.content) > avgWords) {
        categoryScores[cat] =
            (categoryScores[cat] ?? 0) + 3; // Word count bonus
      }

      if (moodInt != null && _isPositiveMood(schema.Mood.values[moodInt])) {
        categoryScores[cat] =
            (categoryScores[cat] ?? 0) + 5; // Positive mood bonus
      }
    }

    // Filter top categories (e.g. score > 15) and save
    final preferred = categoryScores.entries
        .where((e) => e.value >= 15)
        .map((e) => e.key)
        .toList();

    await (_db.update(_db.user)..where((u) => u.id.equals(userId))).write(
      UserCompanion(preferredCategories: Value(jsonEncode(preferred))),
    );
  }

  /* -------------------------------------------------------------------------- */
  /* AVOIDED PROMPTS UPDATE                                                     */
  /* -------------------------------------------------------------------------- */

  Future<void> _updateAvoidedPrompts(int userId) async {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

    final interactions =
        await (_db.select(_db.promptInteractions)
              ..where((pi) => pi.userId.equals(userId))
              ..where(
                (pi) => pi.id.isBiggerThanValue(0),
              ) // Just to trigger where
              )
            .get();

    final skipCounts = <int, int>{};
    for (final interaction in interactions) {
      if (interaction.skipped) {
        skipCounts[interaction.promptId] =
            (skipCounts[interaction.promptId] ?? 0) + 1;
      }
    }

    final avoidedIds = skipCounts.entries
        .where((e) => e.value >= 3)
        .map((e) => e.key)
        .toList();

    await (_db.update(_db.user)..where((u) => u.id.equals(userId))).write(
      UserCompanion(avoidedPrompts: Value(jsonEncode(avoidedIds))),
    );
  }

  /* -------------------------------------------------------------------------- */
  /* HELPERS                                                                    */
  /* -------------------------------------------------------------------------- */

  bool _isPositiveMood(schema.Mood mood) {
    // Mapping positive values from your enum
    const positiveSet = {
      schema.Mood.cheerful,
      schema.Mood.content,
      schema.Mood.proud,
      schema.Mood.optimistic,
      schema.Mood.excited,
      schema.Mood.enthusiastic,
      schema.Mood.playful,
      schema.Mood.satisfied,
      schema.Mood.grateful,
      schema.Mood.interested,
      schema.Mood.curious,
      schema.Mood.eager,
      schema.Mood.hopeful,
      schema.Mood.confident,
      schema.Mood.secure,
    };
    return positiveSet.contains(mood);
  }

  int _countWords(String? content) {
    if (content == null || content.isEmpty) return 0;
    return content.trim().split(RegExp(r'\s+')).length;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _updateUserDifficulty(int userId, int newLevel) async {
    final level = newLevel.clamp(1, 5);
    await (_db.update(_db.user)..where((u) => u.id.equals(userId))).write(
      UserCompanion(
        currentDifficultyLevel: Value(level),
        lastDifficultyAdjustment: Value(DateTime.now()),
      ),
    );
  }
}
