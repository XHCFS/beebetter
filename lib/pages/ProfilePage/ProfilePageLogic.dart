import 'package:flutter/material.dart';
import 'package:beebetter/services/database_provider.dart';

class ProfilePageLogic extends ChangeNotifier {
  String username = "User";
  int? age;
  List<String> goals = [
    "Mindfulness",
    "Productivity",
    "Creative Writing",
  ];
  bool isLoading = false;
  bool isSaving = false;

  ProfilePageLogic() {
    _loadUserData();
  }

  /// Load user profile data
  Future<void> _loadUserData() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await DatabaseProvider.instance.getOrCreateUser();
      username = user.name;
      age = user.age;
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Update username
  Future<void> updateUsername(String newUsername) async {
    if (newUsername.trim().isEmpty) return;

    isSaving = true;
    notifyListeners();

    try {
      final user = await DatabaseProvider.instance.getOrCreateUser();
      await DatabaseProvider.instance.updateUser(
        userId: user.id,
        name: newUsername.trim(),
      );
      username = newUsername.trim();
    } catch (e) {
      debugPrint('Error updating username: $e');
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  /// Update age
  Future<void> updateAge(int? newAge) async {
    isSaving = true;
    notifyListeners();

    try {
      final user = await DatabaseProvider.instance.getOrCreateUser();
      await DatabaseProvider.instance.updateUser(
        userId: user.id,
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

  /// Refresh user data
  Future<void> refresh() async {
    await _loadUserData();
  }
}
