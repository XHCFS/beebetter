import 'package:flutter/material.dart';
import 'package:beebetter/classes/EntryInfo.dart';
import 'package:beebetter/services/database_provider.dart';
import 'package:beebetter/services/profile_manager.dart';
import 'package:beebetter/data/database/tables.dart';

class DashboardLogic extends ChangeNotifier {
  String overallMood = "Happy";
  int overallMoodPercentage = 80;
  int totalEntries = 0;
  int daysTracked = 0;
  int streak = 0;

  List<int> moodValues = [0, 0, 0, 0, 0, 0, 0]; // Will be calculated from data

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  DateTime? get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;

  Map<DateTime, List<EntryInfo>> entriesByDay = {};
  bool isLoading = false;

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  List<EntryInfo> getEntriesForDay(DateTime day) =>
      entriesByDay[_normalize(day)] ?? [];

  List<EntryInfo> entries = []; // entries for the selected date
  List<EntryInfo> filteredEntries = []; // filtered entries (search bar)
  final int emotionLevels = 3;
  
  // Additional insights data
  Map<String, int> emotionFrequency = {}; // Emotion -> count
  int textEntriesCount = 0;
  int voiceEntriesCount = 0;
  
  // Advanced insights
  Map<String, int> weeklyEmotionFrequency = {}; // Emotions for this week
  double averageMoodScore = 2.0; // Average mood (0-4)
  int bestMoodDay = 0; // Day of week (0=Monday) with best mood
  int worstMoodDay = 0; // Day of week with worst mood
  String mostActiveDay = "Monday"; // Day with most entries
  int longestStreak = 0; // Longest consecutive days with entries
  
  // Helper to get day name from index
  String getDayName(int dayIndex) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[dayIndex.clamp(0, 6)];
  }

  DashboardLogic() {
    _loadData();
  }

  /// Load all dashboard data
  Future<void> _loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      await ProfileManager.instance.initialize();
      final profile = await ProfileManager.instance.getCurrentProfile();
      if (profile == null) return;
      final profileId = profile.id;

      // Load statistics
      totalEntries = await DatabaseProvider.instance.getTotalEntries(userId: profileId);
      daysTracked = await DatabaseProvider.instance.getDaysTracked(userId: profileId);
      streak = await DatabaseProvider.instance.getStreak(userId: profileId);

      // Load entries grouped by date
      entriesByDay = await DatabaseProvider.instance.getEntriesByDate(userId: profileId);

      // Load entries for selected day
      await _loadEntriesForSelectedDay();

      // Calculate mood values for the week (simplified - just use first 7 days)
      _calculateMoodValues();
      
      // Calculate additional insights
      _calculateInsights();
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Load entries for the currently selected day
  Future<void> _loadEntriesForSelectedDay() async {
    try {
      final profile = await ProfileManager.instance.getCurrentProfile();
      if (profile == null) return;
      entries = await DatabaseProvider.instance.getEntriesForDate(
        _selectedDay,
        userId: profile.id,
      );
      filteredEntries = entries; // Initially, filtered entries = all entries
    } catch (e) {
      debugPrint('Error loading entries for selected day: $e');
      entries = [];
      filteredEntries = [];
    }
  }

  /// Map Mood enum to a 0-4 scale (0 = very negative, 4 = very positive)
  int _mapMoodToValue(Mood mood) {
    // Very negative (0)
    if ([
      Mood.depressed,
      Mood.grief,
      Mood.hopeless,
      Mood.isolated,
      Mood.terrified,
      Mood.panicked,
      Mood.helpless,
    ].contains(mood)) {
      return 0;
    }
    
    // Negative (1)
    if ([
      Mood.anxious,
      Mood.insecure,
      Mood.scared,
      Mood.nervous,
      Mood.frustrated,
      Mood.irritated,
      Mood.enraged,
      Mood.furious,
      Mood.annoyed,
      Mood.disappointed,
      Mood.hurt,
      Mood.guilty,
      Mood.lonely,
      Mood.resentful,
      Mood.jealous,
      Mood.contemptuous,
      Mood.apprehensive,
    ].contains(mood)) {
      return 1;
    }
    
    // Neutral (2)
    if ([
      Mood.confused,
      Mood.shocked,
      Mood.perplexed,
      Mood.disoriented,
      Mood.startled,
      Mood.amazed,
      Mood.astonished,
    ].contains(mood)) {
      return 2;
    }
    
    // Positive (3)
    if ([
      Mood.content,
      Mood.satisfied,
      Mood.grateful,
      Mood.hopeful,
      Mood.confident,
      Mood.secure,
      Mood.faithful,
      Mood.assured,
      Mood.reliable,
      Mood.supported,
      Mood.accepted,
      Mood.interested,
      Mood.curious,
      Mood.alert,
      Mood.expectant,
      Mood.compassionate,
      Mood.affectionate,
      Mood.warm,
      Mood.sentimental,
      Mood.tender,
      Mood.caring,
    ].contains(mood)) {
      return 3;
    }
    
    // Very positive (4)
    if ([
      Mood.cheerful,
      Mood.excited,
      Mood.enthusiastic,
      Mood.playful,
      Mood.proud,
      Mood.optimistic,
      Mood.romantic,
      Mood.passionate,
      Mood.eager,
    ].contains(mood)) {
      return 4;
    }
    
    // Default to neutral if not found
    return 2;
  }

  /// Map emotion string to mood value
  int _mapEmotionStringToValue(String emotionStr) {
    final emotionLower = emotionStr.toLowerCase().trim();
    
    // Map common UI emotion strings to Mood enum
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
    
    Mood? mood;
    if (emotionMap.containsKey(emotionLower)) {
      mood = emotionMap[emotionLower];
    } else {
      // Try to find by enum name
      try {
        mood = Mood.values.firstWhere(
          (m) => m.toString().split('.').last.toLowerCase() == emotionLower,
        );
      } catch (e) {
        // If not found, return neutral
        return 2;
      }
    }
    
    return mood != null ? _mapMoodToValue(mood) : 2;
  }

  /// Calculate mood values for the week chart
  void _calculateMoodValues() {
    // Get entries for the last 7 days
    final now = DateTime.now();
    final weekDays = List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      return _normalize(date);
    });
    
    moodValues = weekDays.map((day) {
      final dayEntries = entriesByDay[day] ?? [];
      if (dayEntries.isEmpty) return 2; // Default to neutral if no entries
      
      // Calculate average mood for the day
      final moodScores = <int>[];
      for (final entry in dayEntries) {
        for (final emotion in entry.emotions) {
          if (emotion.isNotEmpty) {
            final score = _mapEmotionStringToValue(emotion);
            moodScores.add(score);
          }
        }
      }
      
      if (moodScores.isEmpty) return 2; // Default to neutral
      
      // Calculate average and round
      final average = moodScores.reduce((a, b) => a + b) / moodScores.length;
      return average.round().clamp(0, 4);
    }).toList();
    
    // Calculate overall mood from all entries
    if (entriesByDay.isNotEmpty) {
      final allMoodScores = <int>[];
      for (final entries in entriesByDay.values) {
        for (final entry in entries) {
          for (final emotion in entry.emotions) {
            if (emotion.isNotEmpty) {
              final score = _mapEmotionStringToValue(emotion);
              allMoodScores.add(score);
            }
          }
        }
      }
      
      if (allMoodScores.isNotEmpty) {
        final average = allMoodScores.reduce((a, b) => a + b) / allMoodScores.length;
        final overallScore = average.round().clamp(0, 4);
        
        // Map score to mood name
        final moodNames = ['Very Negative', 'Negative', 'Neutral', 'Positive', 'Very Positive'];
        overallMood = moodNames[overallScore];
        overallMoodPercentage = ((average / 4) * 100).round();
      }
    }
  }

  /// Calculate additional insights (emotion frequency, entry types, etc.)
  void _calculateInsights() {
    emotionFrequency = {};
    weeklyEmotionFrequency = {};
    textEntriesCount = 0;
    voiceEntriesCount = 0;
    
    // Get last 7 days for weekly insights
    final now = DateTime.now();
    final weekDays = List.generate(7, (i) {
      return _normalize(now.subtract(Duration(days: 6 - i)));
    });
    
    // Count entries by day of week
    final entriesByDayOfWeek = <int, int>{};
    final moodByDayOfWeek = <int, List<int>>{};
    
    // Process all entries with their dates
    for (final entryDate in entriesByDay.keys) {
      final entries = entriesByDay[entryDate] ?? [];
      
      for (final entry in entries) {
        // Count entry types
        if (entry.isText) {
          textEntriesCount++;
        } else {
          voiceEntriesCount++;
        }
        
        // Count emotion frequency (all time)
        for (final emotion in entry.emotions) {
          if (emotion.isNotEmpty) {
            emotionFrequency[emotion] = (emotionFrequency[emotion] ?? 0) + 1;
          }
        }
        
        // Weekly insights - check if this date is in the last 7 days
        if (weekDays.contains(entryDate)) {
          final dayOfWeek = entryDate.weekday - 1; // 0 = Monday
          entriesByDayOfWeek[dayOfWeek] = (entriesByDayOfWeek[dayOfWeek] ?? 0) + 1;
          
          // Count weekly emotions
          for (final emotion in entry.emotions) {
            if (emotion.isNotEmpty) {
              weeklyEmotionFrequency[emotion] = (weeklyEmotionFrequency[emotion] ?? 0) + 1;
              
              // Track mood by day of week
              final moodScore = _mapEmotionStringToValue(emotion);
              moodByDayOfWeek.putIfAbsent(dayOfWeek, () => []).add(moodScore);
            }
          }
        }
      }
    }
    
    // Calculate average mood
    final allMoodScores = <int>[];
    for (final entries in entriesByDay.values) {
      for (final entry in entries) {
        for (final emotion in entry.emotions) {
          if (emotion.isNotEmpty) {
            allMoodScores.add(_mapEmotionStringToValue(emotion));
          }
        }
      }
    }
    if (allMoodScores.isNotEmpty) {
      averageMoodScore = allMoodScores.reduce((a, b) => a + b) / allMoodScores.length;
    }
    
    // Find best/worst mood day
    if (moodByDayOfWeek.isNotEmpty) {
      double bestAvg = -1;
      double worstAvg = 5;
      for (final entry in moodByDayOfWeek.entries) {
        final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
        if (avg > bestAvg) {
          bestAvg = avg;
          bestMoodDay = entry.key;
        }
        if (avg < worstAvg) {
          worstAvg = avg;
          worstMoodDay = entry.key;
        }
      }
    }
    
    // Find most active day
    if (entriesByDayOfWeek.isNotEmpty) {
      final mostActive = entriesByDayOfWeek.entries.reduce((a, b) => a.value > b.value ? a : b);
      final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      mostActiveDay = dayNames[mostActive.key];
    }
    
    // Calculate longest streak
    longestStreak = _calculateLongestStreak();
  }
  
  /// Calculate longest consecutive days with entries
  int _calculateLongestStreak() {
    if (entriesByDay.isEmpty) return 0;
    
    final sortedDays = entriesByDay.keys.toList()..sort();
    if (sortedDays.isEmpty) return 0;
    
    int currentStreak = 1;
    int longestStreak = 1;
    
    for (int i = 1; i < sortedDays.length; i++) {
      final daysDiff = sortedDays[i].difference(sortedDays[i - 1]).inDays;
      if (daysDiff == 1) {
        currentStreak++;
        longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
      } else {
        currentStreak = 1;
      }
    }
    
    return longestStreak;
  }

  /// Get top emotions (most frequent)
  List<MapEntry<String, int>> getTopEmotions({int limit = 5}) {
    final sorted = emotionFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).toList();
  }

  /// Refresh all data
  Future<void> refresh() async {
    await _loadData();
  }

  void selectDay(DateTime selected, DateTime focused) {
    _selectedDay = selected;
    _focusedDay = focused;
    _loadEntriesForSelectedDay();
    notifyListeners();
  }

  /// Delete an entry
  Future<void> deleteEntry(String id) async {
    try {
      final recordId = int.tryParse(id);
      if (recordId == null) return;

      await DatabaseProvider.instance.deleteEntry(recordId);

      // Remove from local lists
      entries.removeWhere((e) => e.id == id);
      filteredEntries.removeWhere((e) => e.id == id);

      // Remove from entriesByDay
      final normalizedDay = _normalize(_selectedDay);
      if (entriesByDay.containsKey(normalizedDay)) {
        entriesByDay[normalizedDay]!.removeWhere((e) => e.id == id);
      }

      // Update statistics
      final profile = await ProfileManager.instance.getCurrentProfile();
      if (profile == null) return;
      totalEntries = await DatabaseProvider.instance.getTotalEntries(userId: profile.id);
      daysTracked = await DatabaseProvider.instance.getDaysTracked(userId: profile.id);
      streak = await DatabaseProvider.instance.getStreak(userId: profile.id);

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting entry: $e');
    }
  }

  /// Search entries
  Future<void> searchEntries(String query) async {
    if (query.trim().isEmpty) {
      filteredEntries = entries;
      notifyListeners();
      return;
    }

    try {
      final profile = await ProfileManager.instance.getCurrentProfile();
      if (profile == null) return;
      filteredEntries = await DatabaseProvider.instance.searchEntries(
        query,
        userId: profile.id,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error searching entries: $e');
      filteredEntries = [];
      notifyListeners();
    }
  }
}