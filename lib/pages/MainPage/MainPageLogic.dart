import 'package:flutter/material.dart';

class MainPageLogic extends ChangeNotifier {
  // ---------------------------------------------------
  // Initializations
  // ---------------------------------------------------
  int selectedIndex = 1;
  final PageController pageController = PageController(initialPage: 1);
  late final AnimationController guidedModeController;

  MainPageLogic(TickerProvider vsync) {
    guidedModeController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 250),
      value: 0,
    );
  }

  // ---------------------------------------------------
  // Navigation Bar Function
  // ---------------------------------------------------

  void onItemTapped(int index) {
    selectedIndex = index;

    if ((pageController.page ?? selectedIndex).round() == index) return;

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    notifyListeners();
  }

  void onPageChanged(int index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      notifyListeners();
    }
  }


  // ---------------------------------------------------
  // Swipe Up Guided Mode
  // ---------------------------------------------------

  void disposeLogic() {
    guidedModeController.dispose();
  }

  void openGuidedMode() {
    FocusManager.instance.primaryFocus?.unfocus();
    guidedModeController.forward();
  }

  void closeGuidedMode() {
    guidedModeController.reverse();
  }

}

