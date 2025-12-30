import 'package:flutter/material.dart';
import 'package:beebetter/services/database_provider.dart';
import 'package:beebetter/services/profile_manager.dart';
import 'package:beebetter/services/theme_manager.dart';
import 'package:beebetter/data/database/app_database.dart';

class ProfilePageLogic extends ChangeNotifier {
  String profileName = "Profile";
  int? age;
  int? currentProfileId;
  List<UserData> allProfiles = [];
  List<String> goals = [
    "Mindfulness",
    "Productivity",
    "Creative Writing",
  ];
  bool isLoading = false;
  bool isSaving = false;
  
  // Theme
  bool get isDarkMode => ThemeManager.instance.isDarkMode;

  ProfilePageLogic() {
    _loadProfileData();
    // Listen to theme changes
    ThemeManager.instance.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    ThemeManager.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  /// Load profile data
  Future<void> _loadProfileData() async {
    isLoading = true;
    notifyListeners();

    try {
      // Initialize profile manager
      await ProfileManager.instance.initialize();
      
      // Get current profile
      final profile = await ProfileManager.instance.getCurrentProfile();
      if (profile != null) {
        profileName = profile.name;
        age = profile.age;
        currentProfileId = profile.id;
      }

      // Load all profiles
      allProfiles = await DatabaseProvider.instance.getAllProfiles();
    } catch (e) {
      debugPrint('Error loading profile data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Update profile name
  Future<void> updateProfileName(String newName) async {
    if (newName.trim().isEmpty || currentProfileId == null) return;

    isSaving = true;
    notifyListeners();

    try {
      await DatabaseProvider.instance.updateProfile(
        profileId: currentProfileId!,
        name: newName.trim(),
      );
      profileName = newName.trim();
      await _loadProfileData(); // Reload to update all profiles list
    } catch (e) {
      debugPrint('Error updating profile name: $e');
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  /// Update age
  Future<void> updateAge(int? newAge) async {
    if (currentProfileId == null) return;

    isSaving = true;
    notifyListeners();

    try {
      await DatabaseProvider.instance.updateProfile(
        profileId: currentProfileId!,
        age: newAge,
      );
      age = newAge;
    } catch (e) {
      debugPrint('Error updating age: $e');
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  /// Create a new profile
  Future<UserData?> createProfile({required String name, int? age}) async {
    isSaving = true;
    notifyListeners();

    try {
      final newProfile = await DatabaseProvider.instance.createProfile(
        name: name,
        age: age,
      );
      await _loadProfileData(); // Reload profiles list
      return newProfile;
    } catch (e) {
      debugPrint('Error creating profile: $e');
      return null;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  /// Switch to a different profile
  Future<void> switchProfile(int profileId) async {
    try {
      await ProfileManager.instance.switchProfile(profileId);
      await _loadProfileData(); // Reload current profile data
      notifyListeners();
    } catch (e) {
      debugPrint('Error switching profile: $e');
    }
  }

  /// Delete a profile
  Future<bool> deleteProfile(int profileId) async {
    isSaving = true;
    notifyListeners();

    try {
      await DatabaseProvider.instance.deleteProfile(profileId);
      
      // If we deleted the current profile, switch to another one
      if (profileId == currentProfileId) {
        final remainingProfiles = await DatabaseProvider.instance.getAllProfiles();
        if (remainingProfiles.isNotEmpty) {
          await ProfileManager.instance.switchProfile(remainingProfiles.first.id);
        } else {
          // No profiles left, create a default one
          final defaultProfile = await DatabaseProvider.instance.getOrCreateProfile();
          await ProfileManager.instance.switchProfile(defaultProfile.id);
        }
      }
      
      await _loadProfileData(); // Reload profiles list
      return true;
    } catch (e) {
      debugPrint('Error deleting profile: $e');
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  /// Refresh profile data
  Future<void> refresh() async {
    await _loadProfileData();
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode() async {
    await ThemeManager.instance.toggleTheme();
    notifyListeners();
  }
}