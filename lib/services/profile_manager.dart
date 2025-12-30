import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beebetter/data/database/app_database.dart';
import 'package:beebetter/services/database_provider.dart';

/// Manages the current active profile
/// Stores the current profile ID and provides methods to switch profiles
class ProfileManager extends ChangeNotifier {
  static ProfileManager? _instance;
  int? _currentProfileId;
  bool _isLoading = false;
  bool _isInitialized = false;

  ProfileManager._();

  static ProfileManager get instance {
    _instance ??= ProfileManager._();
    return _instance!;
  }

  int? get currentProfileId => _currentProfileId;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  /// Initialize and load the current profile
  Future<void> initialize() async {
    if (_isInitialized) return;

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedProfileId = prefs.getInt('currentProfileId');

      if (savedProfileId != null) {
        // Try to load the saved profile
        final profile = await DatabaseProvider.instance.getProfile(savedProfileId);
        if (profile != null) {
          _currentProfileId = savedProfileId;
          _isInitialized = true;
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      // No saved profile or saved profile doesn't exist, get or create default
      final profile = await DatabaseProvider.instance.getOrCreateProfile();
      _currentProfileId = profile.id;
      await prefs.setInt('currentProfileId', profile.id);
    } catch (e) {
      debugPrint('Error initializing profile: $e');
    } finally {
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Switch to a different profile
  Future<void> switchProfile(int profileId) async {
    _currentProfileId = profileId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentProfileId', profileId);
    notifyListeners();
  }

  /// Get the current profile
  Future<UserData?> getCurrentProfile() async {
    if (!_isInitialized) {
      await initialize();
    }
    if (_currentProfileId == null) return null;
    return await DatabaseProvider.instance.getProfile(_currentProfileId!);
  }

  /// Refresh current profile (after updates)
  Future<void> refresh() async {
    if (_currentProfileId != null) {
      notifyListeners();
    }
  }
}

