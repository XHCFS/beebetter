import 'package:beebetter/data/database/app_database.dart';
import 'package:beebetter/data/database/tables.dart';
import 'package:beebetter/classes/EntryInfo.dart';
import 'package:drift/drift.dart';

/// Service layer for database operations
/// Provides high-level methods for CRUD operations on entries, users, and moods
class DatabaseService {
  final AppDatabase _db;

  DatabaseService(this._db);

  // ============================================================
  // USER OPERATIONS
  // ============================================================

  /// Get the current user (or create default if none exists)
  Future<UserData> getOrCreateUser() async {
    final users = await (_db.select(_db.user)..limit(1)).get();
    
    if (users.isEmpty) {
      // Create default user
      final userId = await _db.into(_db.user).insert(
        UserCompanion.insert(name: 'User', age: const Value.absent()),
      );
      return UserData(id: userId, name: 'User', age: null);
    }
    
    return users.first;
  }

  /// Update user profile
  Future<void> updateUser({
    required int userId,
    String? name,
    int? age,
  }) async {
    await (_db.update(_db.user)..where((u) => u.id.equals(userId))).write(
      UserCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        age: age != null ? Value(age) : const Value.absent(),
      ),
    );
  }

  /// Get user by ID
  Future<UserData?> getUser(int userId) async {
    return await (_db.select(_db.user)..where((u) => u.id.equals(userId))).getSingleOrNull();
  }

  // ============================================================
  // ENTRY OPERATIONS
  // ============================================================

  /// Save a new entry to the database
  /// Returns the created record ID
  Future<int> saveEntry({
    required int userId,
    String? content,
    String? title,
    int? promptId,
    InputType inputType = InputType.text,
    List<String>? emotions,
    String? audioFilePath,
  }) async {
    // Insert the record
    final recordId = await _db.into(_db.records).insert(
      RecordsCompanion.insert(
        userId: Value(userId),
        content: content != null ? Value(content) : const Value.absent(),
        title: title != null ? Value(title) : const Value.absent(),
        promptId: promptId != null ? Value(promptId) : const Value.absent(),
        inputType: Value(inputType.index),
        audioFilePath: audioFilePath != null ? Value(audioFilePath) : const Value.absent(),
      ),
    );

    // Save emotions if provided
    if (emotions != null && emotions.isNotEmpty) {
      await _saveEmotions(recordId, emotions);
    }

    return recordId;
  }

  /// Map UI emotion strings to Mood enum values
  /// This handles the mismatch between UI emotion names and database enum values
  Mood? _mapEmotionToMood(String emotionStr) {
    final emotionLower = emotionStr.toLowerCase().trim();
    
    // Direct mapping for common emotions
    final Map<String, Mood> emotionMap = {
      'happy': Mood.cheerful,
      'calm': Mood.content,
      'excited': Mood.excited,
      'overwhelmed': Mood.anxious,
      'empty': Mood.depressed,
      'hopeful': Mood.hopeful,
      'joy': Mood.cheerful,
      'trust': Mood.secure,
      'fear': Mood.scared,
      'surprise': Mood.amazed,
      'sadness': Mood.depressed,
      'disgust': Mood.contemptuous,
      'anger': Mood.frustrated,
      'anticipation': Mood.eager,
      'motivated': Mood.enthusiastic,
      'proud': Mood.proud,
      'tired': Mood.depressed,
      'low energy': Mood.depressed,
      'confused': Mood.confused,
      'playful': Mood.playful,
    };
    
    // Try direct mapping first
    if (emotionMap.containsKey(emotionLower)) {
      return emotionMap[emotionLower];
    }
    
    // Try to find by enum name
    try {
      return Mood.values.firstWhere(
        (m) => m.toString().split('.').last.toLowerCase() == emotionLower,
      );
    } catch (e) {
      // If no match found, return null (emotion won't be saved)
      return null;
    }
  }

  /// Save emotions for a record
  Future<void> _saveEmotions(int recordId, List<String> emotions) async {
    final moodCompanions = emotions
        .where((e) => e.isNotEmpty)
        .map((emotionStr) {
          final mood = _mapEmotionToMood(emotionStr);
          if (mood == null) return null;
          
          return MoodsCompanion.insert(
            recordId: recordId,
            mood: Value(mood.index),
            source: Value(MoodSource.user.index),
          );
        })
        .whereType<MoodsCompanion>()
        .toList();

    if (moodCompanions.isNotEmpty) {
      await _db.batch((batch) {
        batch.insertAll(_db.moods, moodCompanions);
      });
    }
  }

  /// Load entries for a specific date
  Future<List<EntryInfo>> getEntriesForDate(DateTime date, {int? userId}) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    var query = _db.select(_db.records)
      ..where((r) => r.createdAt.isBiggerOrEqualValue(startOfDay))
      ..where((r) => r.createdAt.isSmallerThanValue(endOfDay))
      ..orderBy((r) => OrderingTerm(expression: r.createdAt, mode: OrderingMode.desc));

    if (userId != null) {
      query = query..where((r) => r.userId.equals(userId));
    }

    final records = await query.get();
    return await _convertRecordsToEntryInfo(records);
  }

  /// Load all entries (optionally filtered by user)
  Future<List<EntryInfo>> getAllEntries({int? userId, int? limit}) async {
    var query = _db.select(_db.records)
      ..orderBy((r) => OrderingTerm(expression: r.createdAt, mode: OrderingMode.desc));

    if (userId != null) {
      query = query..where((r) => r.userId.equals(userId));
    }

    if (limit != null) {
      query = query..limit(limit);
    }

    final records = await query.get();
    return await _convertRecordsToEntryInfo(records);
  }

  /// Search entries by content or title
  Future<List<EntryInfo>> searchEntries(String query, {int? userId}) async {
    final searchTerm = '%$query%';
    
    var dbQuery = _db.select(_db.records)
      ..where((r) => 
        r.content.like(searchTerm) | r.title.like(searchTerm)
      )
      ..orderBy((r) => OrderingTerm(expression: r.createdAt, mode: OrderingMode.desc));

    if (userId != null) {
      dbQuery = dbQuery..where((r) => r.userId.equals(userId));
    }

    final records = await dbQuery.get();
    return await _convertRecordsToEntryInfo(records);
  }

  /// Get entry by ID
  Future<EntryInfo?> getEntryById(int recordId) async {
    final record = await (_db.select(_db.records)
          ..where((r) => r.id.equals(recordId)))
        .getSingleOrNull();
    
    if (record == null) return null;
    
    final entries = await _convertRecordsToEntryInfo([record]);
    return entries.isNotEmpty ? entries.first : null;
  }

  /// Delete an entry and its associated moods
  Future<void> deleteEntry(int recordId) async {
    // Delete associated moods first
    await (_db.delete(_db.moods)..where((m) => m.recordId.equals(recordId))).go();
    
    // Delete the record
    await (_db.delete(_db.records)..where((r) => r.id.equals(recordId))).go();
  }

  /// Update an entry
  Future<void> updateEntry({
    required int recordId,
    String? content,
    String? title,
    List<String>? emotions,
  }) async {
    // Update record
    final companion = RecordsCompanion(
      content: content != null ? Value(content) : const Value.absent(),
      title: title != null ? Value(title) : const Value.absent(),
    );
    
    await (_db.update(_db.records)..where((r) => r.id.equals(recordId))).write(companion);

    // Update emotions if provided
    if (emotions != null) {
      // Delete old moods
      await (_db.delete(_db.moods)..where((m) => m.recordId.equals(recordId))).go();
      // Insert new moods
      await _saveEmotions(recordId, emotions);
    }
  }

  /// Convert database records to EntryInfo objects
  Future<List<EntryInfo>> _convertRecordsToEntryInfo(List<Record> records) async {
    if (records.isEmpty) return [];

    final recordIds = records.map((r) => r.id).toList();
    
    // Load all moods for these records
    final moods = await (_db.select(_db.moods)
          ..where((m) => m.recordId.isIn(recordIds)))
        .get();

    // Group moods by recordId
    final moodsByRecord = <int, List<Mood>>{};
    for (final mood in moods) {
      if (mood.mood != null) {
        moodsByRecord.putIfAbsent(mood.recordId, () => []).add(Mood.values[mood.mood!]);
      }
    }

    // Convert records to EntryInfo
    return records.map((record) {
      final recordMoods = moodsByRecord[record.id] ?? [];
      // Convert Mood enum back to readable strings
      final emotionStrings = recordMoods
          .map((m) {
            // Convert enum to a more user-friendly name
            final enumName = m.toString().split('.').last;
            // Capitalize first letter
            return enumName[0].toUpperCase() + enumName.substring(1);
          })
          .toList();

      // Determine if it's text or voice based on inputType
      final isText = record.inputType == InputType.text.index || 
                     record.inputType == InputType.written.index;
      
      // For voice entries, use audioFilePath as userInput (for VoiceEntryPlayer)
      // For text entries, use content
      final userInput = isText 
          ? (record.content ?? '')
          : (record.audioFilePath ?? record.content ?? '');

      return EntryInfo(
        id: record.id.toString(),
        title: record.title ?? 
               'Entry ${record.createdAt.toString().substring(0, 16)}',
        category: 'default', // TODO: Load from prompt category if promptId exists
        emotionLevels: 3,
        isText: isText,
      )
        ..userInput = userInput
        ..emotions = List.generate(3, (i) => 
          i < emotionStrings.length ? emotionStrings[i] : ''
        );
    }).toList();
  }

  // ============================================================
  // STATISTICS OPERATIONS
  // ============================================================

  /// Get total number of entries for a user
  Future<int> getTotalEntries({int? userId}) async {
    var query = _db.selectOnly(_db.records, distinct: true)
      ..addColumns([_db.records.id.count()]);

    if (userId != null) {
      query = query..where((r) => r.userId.equals(userId));
    }

    final result = await query.getSingle();
    return result.read(_db.records.id.count()) ?? 0;
  }

  /// Get number of unique days with entries
  Future<int> getDaysTracked({int? userId}) async {
    var query = _db.selectOnly(_db.records)
      ..addColumns([_db.records.createdAt])
      ..groupBy([_db.records.createdAt]);

    if (userId != null) {
      query = query..where((r) => r.userId.equals(userId));
    }

    final results = await query.get();
    
    // Count unique days
    final uniqueDays = <String>{};
    for (final row in results) {
      final date = row.read(_db.records.createdAt);
      if (date != null) {
        final dayKey = '${date.year}-${date.month}-${date.day}';
        uniqueDays.add(dayKey);
      }
    }
    
    return uniqueDays.length;
  }

  /// Calculate current streak (consecutive days with entries)
  Future<int> getStreak({int? userId}) async {
    // Get all unique days with entries, ordered by date descending
    var query = _db.selectOnly(_db.records)
      ..addColumns([_db.records.createdAt])
      ..groupBy([_db.records.createdAt])
      ..orderBy([OrderingTerm(expression: _db.records.createdAt, mode: OrderingMode.desc)]);

    if (userId != null) {
      query = query..where((r) => r.userId.equals(userId));
    }

    final results = await query.get();
    
    if (results.isEmpty) return 0;

    // Extract unique days
    final days = <DateTime>{};
    for (final row in results) {
      final date = row.read(_db.records.createdAt);
      if (date != null) {
        final day = DateTime(date.year, date.month, date.day);
        days.add(day);
      }
    }

    final sortedDays = days.toList()..sort((a, b) => b.compareTo(a));
    
    // Calculate streak
    int streak = 0;
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    
    DateTime? expectedDate = todayNormalized;
    
    for (final day in sortedDays) {
      final normalized = DateTime(day.year, day.month, day.day);
      if (normalized == expectedDate) {
        streak++;
        expectedDate = expectedDate.subtract(const Duration(days: 1));
      } else if (normalized.isBefore(expectedDate!)) {
        // Gap found, streak broken
        break;
      }
    }
    
    return streak;
  }

  /// Get entries count for today
  Future<int> getTodayEntriesCount({int? userId}) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    var query = _db.selectOnly(_db.records)
      ..addColumns([_db.records.id.count()])
      ..where((r) => r.createdAt.isBiggerOrEqualValue(startOfDay))
      ..where((r) => r.createdAt.isSmallerThanValue(endOfDay));

    if (userId != null) {
      query = query..where((r) => r.userId.equals(userId));
    }

    final result = await query.getSingle();
    return result.read(_db.records.id.count()) ?? 0;
  }

  /// Get entries grouped by date
  Future<Map<DateTime, List<EntryInfo>>> getEntriesByDate({int? userId}) async {
    // Load records with dates to properly group
    var query = _db.select(_db.records)
      ..orderBy((r) => OrderingTerm(expression: r.createdAt, mode: OrderingMode.desc));

    if (userId != null) {
      query = query..where((r) => r.userId.equals(userId));
    }

    final records = await query.get();
    final entries = await _convertRecordsToEntryInfo(records);
    
    final Map<DateTime, List<EntryInfo>> entriesByDate = {};
    
    for (int i = 0; i < records.length; i++) {
      final record = records[i];
      final entry = entries[i];
      // Normalize date to just year/month/day (remove time component)
      final date = DateTime(
        record.createdAt.year,
        record.createdAt.month,
        record.createdAt.day,
      );
      
      entriesByDate.putIfAbsent(date, () => []).add(entry);
    }
    
    return entriesByDate;
  }

  /// Close database connection
  Future<void> close() async {
    await _db.close();
  }
}

