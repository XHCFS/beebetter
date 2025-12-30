import 'package:flutter/material.dart';
import 'package:beebetter/data/database/app_database.dart';
import 'package:beebetter/services/database_provider.dart';

/// Manages the current active profile
/// Stores the current profile ID and provides methods to switch profiles
class ProfileManager extends ChangeNotifier {
  static ProfileManager? _instance;
  int? _currentProfileId;
  bool _isLoading = false;

  ProfileManager._();

  static ProfileManager get instance {
    _instance ??= ProfileManager._();
    return _instance!;
  }

  int? get currentProfileId => _currentProfileId;
  bool get isLoading => _isLoading;

  /// Initialize and load the current profile
  Future<void> initialize() async {
    if (_currentProfileId != null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Get or create default profile
      final profile = await DatabaseProvider.instance.getOrCreateProfile();
      _currentProfileId = profile.id;
    } catch (e) {
      debugPrint('Error initializing profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Switch to a different profile
  Future<void> switchProfile(int profileId) async {
    _currentProfileId = profileId;
    notifyListeners();
  }

  /// Get the current profile
  Future<UserData?> getCurrentProfile() async {
    if (_currentProfileId == null) {
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

