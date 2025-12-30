import 'package:flutter/material.dart';
import 'package:beebetter/classes/EntryInfo.dart';
import 'package:beebetter/services/database_provider.dart';

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

  DashboardLogic() {
    _loadData();
  }

  /// Load all dashboard data
  Future<void> _loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await DatabaseProvider.instance.getOrCreateUser();
      final userId = user.id;

      // Load statistics
      totalEntries = await DatabaseProvider.instance.getTotalEntries(userId: userId);
      daysTracked = await DatabaseProvider.instance.getDaysTracked(userId: userId);
      streak = await DatabaseProvider.instance.getStreak(userId: userId);

      // Load entries grouped by date
      entriesByDay = await DatabaseProvider.instance.getEntriesByDate(userId: userId);

      // Load entries for selected day
      await _loadEntriesForSelectedDay();

      // Calculate mood values for the week (simplified - just use first 7 days)
      _calculateMoodValues();
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
      final user = await DatabaseProvider.instance.getOrCreateUser();
      entries = await DatabaseProvider.instance.getEntriesForDate(
        _selectedDay,
        userId: user.id,
      );
      filteredEntries = entries; // Initially, filtered entries = all entries
    } catch (e) {
      debugPrint('Error loading entries for selected day: $e');
      entries = [];
      filteredEntries = [];
    }
  }

  /// Calculate mood values for the week chart
  void _calculateMoodValues() {
    // Simplified: just set default values for now
    // TODO: Calculate actual mood values from entries
    moodValues = [0, 0, 0, 0, 0, 0, 0];
    
    // Calculate overall mood (simplified)
    if (entries.isNotEmpty) {
      overallMood = "Happy"; // TODO: Calculate from actual mood data
      overallMoodPercentage = 80; // TODO: Calculate from actual mood data
    }
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
      final user = await DatabaseProvider.instance.getOrCreateUser();
      totalEntries = await DatabaseProvider.instance.getTotalEntries(userId: user.id);
      daysTracked = await DatabaseProvider.instance.getDaysTracked(userId: user.id);
      streak = await DatabaseProvider.instance.getStreak(userId: user.id);

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
      final user = await DatabaseProvider.instance.getOrCreateUser();
      filteredEntries = await DatabaseProvider.instance.searchEntries(
        query,
        userId: user.id,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error searching entries: $e');
      filteredEntries = [];
      notifyListeners();
    }
  }
}