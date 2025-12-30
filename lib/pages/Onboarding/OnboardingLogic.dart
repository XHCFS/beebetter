import 'package:flutter/material.dart';
import 'package:beebetter/services/onboarding_service.dart';
import 'package:beebetter/services/profile_manager.dart';
import 'package:beebetter/services/database_provider.dart';
import 'package:beebetter/pages/MainPage/MainPage.dart';

class OnboardingLogic extends ChangeNotifier {
  final PageController pageController = PageController();
  final TextEditingController nameController = TextEditingController();
  
  int currentStep = 0;
  bool isCreating = false;
  bool canCreateProfile = false;
  bool isCompleted = false;

  OnboardingLogic() {
    nameController.addListener(() {
      updateName(nameController.text);
    });
  }

  void updateName(String name) {
    canCreateProfile = name.trim().isNotEmpty;
    notifyListeners();
  }

  void nextStep() {
    if (currentStep < 2) {
      currentStep++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  Future<void> createProfile() async {
    if (!canCreateProfile || isCreating) return;

    isCreating = true;
    notifyListeners();

    try {
      final profileName = nameController.text.trim();
      
      // Create the profile
      final profile = await DatabaseProvider.instance.createProfile(
        name: profileName,
        age: null,
      );

      // Set as current profile
      await ProfileManager.instance.switchProfile(profile.id);
      await ProfileManager.instance.initialize();

      // Move to next step
      nextStep();
    } catch (e) {
      debugPrint('Error creating profile: $e');
    } finally {
      isCreating = false;
      notifyListeners();
    }
  }

  Future<void> completeOnboarding() async {
    await OnboardingService.completeOnboarding();
    isCompleted = true;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    nameController.dispose();
    super.dispose();
  }
}

