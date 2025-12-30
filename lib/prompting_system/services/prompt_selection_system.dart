import 'dart:convert';
import 'dart:math';

import 'package:beebetter/data/database/app_database.dart';
import 'package:beebetter/data/database/tables.dart' as schema;
import 'package:drift/drift.dart';

/// Public service used by the app
class PromptSelectionSystem {
  final AppDatabase _db;
  final PromptScorer _scorer;
  final Random _random;

  PromptSelectionSystem(this._db, {PromptScorer? scorer, Random? random})
    : _scorer = scorer ?? PromptScorer(),
      _random = random ?? Random();

  /// Returns prompts in a *probabilistically ranked* order.
  /// Higher scores appear earlier more often, but ordering varies.
  Future<List<ScoredPrompt>> rankPromptsForUser({
    required int userId,
    int? limit,
  }) async {
    final user = await _getUser(userId);
    if (user == null) return [];

    final prompts = await _getActivePrompts();
    if (prompts.isEmpty) return [];

    final recentPromptIds = await _getRecentlyUsedPromptIds(userId);
    final recentCategories = await _getRecentCategories(userId);
    final recentMoods = await _getRecentMoods(userId);
    final preferredCategories = _decodeStringList(
      user.preferredCategories ?? '[]',
    );

    final timeOfDay = _currentTimeOfDay();

    final scored = prompts.map((prompt) {
      final score = _scorer.score(
        prompt: prompt,
        user: user,
        recentPromptIds: recentPromptIds,
        recentCategories: recentCategories,
        recentMoods: recentMoods,
        preferredCategories: preferredCategories,
        timeOfDay: timeOfDay,
      );
      return ScoredPrompt(prompt, score);
    }).toList();

    final ranked = _weightedRank(scored);

    if (limit != null && ranked.length > limit) {
      return ranked.take(limit).toList();
    }

    return ranked;
  }

  /* -------------------------------------------------------------------------- */
  /*                               STOCHASTIC RANK                               */
  /* -------------------------------------------------------------------------- */

  List<ScoredPrompt> _weightedRank(List<ScoredPrompt> input) {
    final remaining = List<ScoredPrompt>.from(input);
    final result = <ScoredPrompt>[];

    while (remaining.isNotEmpty) {
      final totalWeight = remaining.fold<double>(
        0,
        (sum, e) => sum + max(e.score, 0.01),
      );

      double r = _random.nextDouble() * totalWeight;

      for (final item in remaining) {
        r -= max(item.score, 0.01);
        if (r <= 0) {
          result.add(item);
          remaining.remove(item);
          break;
        }
      }
    }

    return result;
  }

  /* -------------------------------------------------------------------------- */
  /*                                   QUERIES                                   */
  /* -------------------------------------------------------------------------- */

  Future<UserData?> _getUser(int userId) {
    return (_db.select(
      _db.user,
    )..where((u) => u.id.equals(userId))).getSingleOrNull();
  }

  Future<List<Prompt>> _getActivePrompts() {
    return (_db.select(
      _db.prompts,
    )..where((p) => p.isActive.equals(true))).get();
  }

  Future<List<int>> _getRecentlyUsedPromptIds(
    int userId, {
    int limit = 10,
  }) async {
    final rows =
        await (_db.select(_db.promptInteractions)
              ..where((p) => p.userId.equals(userId) & p.completed.equals(true))
              ..orderBy([(p) => OrderingTerm.desc(p.id)])
              ..limit(limit))
            .get();

    return rows.map((e) => e.promptId).toList();
  }

  Future<List<String>> _getRecentCategories(int userId, {int days = 7}) async {
    final since = DateTime.now().subtract(Duration(days: days));

    final query =
        _db.select(_db.records).join([
            leftOuterJoin(
              _db.prompts,
              _db.prompts.id.equalsExp(_db.records.promptId),
            ),
          ])
          ..where(_db.records.userId.equals(userId))
          ..where(_db.records.createdAt.isBiggerThanValue(since));

    final rows = await query.get();

    return rows
            .map(
              (row) => row.readTableOrNull(_db.prompts)?.category,
            ) 
            .whereType<String>()
            .toList();
      }

  Future<List<schema.Mood>> _getRecentMoods(int userId, {int days = 7}) async {
    final since = DateTime.now().subtract(Duration(days: days));

    final query =
        _db.select(_db.moods).join([
            innerJoin(
              _db.records,
              _db.records.id.equalsExp(_db.moods.recordId),
            ),
          ])
          ..where(_db.records.userId.equals(userId))
          ..where(_db.records.createdAt.isBiggerThanValue(since));

    final rows = await query.get();

    return rows
        .map((row) => row.readTable(_db.moods).mood)
        .whereType<int>()
        .map((i) => schema.Mood.values[i])
        .toList();
  }

  /* -------------------------------------------------------------------------- */
  /*                                  UTILITIES                                  */
  /* -------------------------------------------------------------------------- */

  List<String> _decodeStringList(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return [];
  }

  String _currentTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    if (hour < 21) return 'evening';
    return 'night';
  }
}

/* -------------------------------------------------------------------------- */
/*                              SCORING ENGINE                                 */
/* -------------------------------------------------------------------------- */

class PromptScorer {
  double score({
    required Prompt prompt,
    required UserData user,
    required List<int> recentPromptIds,
    required List<String> recentCategories,
    required List<schema.Mood> recentMoods,
    required List<String> preferredCategories,
    required String timeOfDay,
  }) {
    double score = 0;

    if (!recentPromptIds.contains(prompt.id)) {
      score += 2.0;
    }

    if (prompt.category != null &&
        !recentCategories.contains(prompt.category)) {
      score += 1.5;
    }

    if (prompt.category != null &&
        preferredCategories.contains(prompt.category)) {
      score += 2.0;
    }

    if (user.currentDifficultyLevel != null) {
      final delta = (prompt.difficultyLevel - user.currentDifficultyLevel!)
          .abs();
      score += max(0, 2 - delta);
    }

    if (prompt.targetMoodStates != null && recentMoods.isNotEmpty) {
      final targets = (jsonDecode(prompt.targetMoodStates!) as List)
          .map((i) => schema.Mood.values[i])
          .toSet();

      final overlap = recentMoods.where(targets.contains).length;

      score += overlap * 1.2;
    }

    if (prompt.bestTimeOfDay == null || prompt.bestTimeOfDay == timeOfDay) {
      score += 1.0;
    }

    return score;
  }
}

/* -------------------------------------------------------------------------- */
/*                                   MODELS                                    */
/* -------------------------------------------------------------------------- */

class ScoredPrompt {
  final Prompt prompt;
  final double score;

  ScoredPrompt(this.prompt, this.score);
}
