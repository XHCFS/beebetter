import 'package:flutter/material.dart';

class MainPageLogic extends ChangeNotifier {
  // ---------------------------------------------------
  // Navigation Bar Function
  // ---------------------------------------------------
  int selectedIndex = 1;
  final PageController pageController = PageController(initialPage: 1);

  void onItemTapped(int index) {
    selectedIndex = index;
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  // ---------------------------------------------------
  // Swipe Up Guided Mode
  // ---------------------------------------------------
  late final AnimationController guidedModeController;

  MainPageLogic(TickerProvider vsync) {
    guidedModeController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 250),
      value: 0,
    );
  }

  void disposeLogic() {
    guidedModeController.dispose();
  }

  void openGuidedMode() => guidedModeController.forward();
  void closeGuidedMode() => guidedModeController.reverse();

}

