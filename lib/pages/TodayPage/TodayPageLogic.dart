import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:beebetter/services/database_provider.dart';
import 'package:beebetter/services/profile_manager.dart';

class TodayPageLogic extends ChangeNotifier {
  String username = "User";
  int completedEntries = 0;
  int totalEntries = 3; // Default daily prompts count
  bool isLoading = false;

  DateTime today = DateTime.now();

  String get formattedDay => DateFormat('EEEE').format(today);
  String get formattedDate => DateFormat('MMMM d, yyyy').format(today);

  TodayPageLogic() {
    _loadData();
  }

  /// Load user data and today's entries count
  Future<void> _loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      // Load profile
      await ProfileManager.instance.initialize();
      final profile = await ProfileManager.instance.getCurrentProfile();
      if (profile == null) return;
      username = profile.name;

      // Load today's entries count
      completedEntries = await DatabaseProvider.instance.getTodayEntriesCount(userId: profile.id);
    } catch (e) {
      debugPrint('Error loading today page data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh data (call after saving an entry)
  Future<void> refresh() async {
    await _loadData();
  }

  void incrementCompleted() {
    if (completedEntries < totalEntries) {
      completedEntries++;
      notifyListeners();
    }
  }

  void setUserName(String name) {
    username = name;
    notifyListeners();
  }
}