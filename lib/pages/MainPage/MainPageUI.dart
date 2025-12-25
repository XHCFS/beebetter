import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/widgets/NavigationBar.dart';
import 'package:beebetter/pages/TodayPage/TodayPage.dart';
import 'package:beebetter/pages/MainPage/GuidedModeOverlay.dart';
import 'package:beebetter/pages/Dashboard/Dashboard.dart';
import 'package:beebetter/pages/ProfilePage/ProfilePage.dart';
import 'package:beebetter/pages/MainPage/MainPageLogic.dart';
import 'dart:ui';

class MainPageUI extends StatelessWidget {
  const MainPageUI({super.key});


  @override
  Widget build(BuildContext context) {
    final logic = context.watch<MainPageLogic>();
    final height = MediaQuery.of(context).size.height;
    final navBarHeight = 40.0;
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    final pages = [
      Dashboard(),
      TodayPage(openGuidedMode: logic.openGuidedMode),
      ProfilePage(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ---------------------------------------------------
          // Swipe Gesture Detector
          // ---------------------------------------------------
          GestureDetector(
          onVerticalDragUpdate: (details) {
            if(keyboardOpen) return;

            logic.guidedModeController.value -= details.delta.dy / height;
          },
            onVerticalDragEnd: (details) {
              if(keyboardOpen) return;

              if (logic.guidedModeController.value < 0.15) {
                logic.closeGuidedMode();   // snap closed
              } else {
                logic.openGuidedMode();    // snap open
              }
            },
          // ---------------------------------------------------
          // Page View
          // ---------------------------------------------------
            child: MediaQuery.removeViewInsets(
              context: context,
              removeBottom: true,
              child: ClipRect(
                child: PageView(
                  controller: logic.pageController,
                  children: pages,
                ),
              ),
            ),
          ),

          // ---------------------------------------------------
          // Navigation Bar
          // ---------------------------------------------------
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: NavigationBarWidget(navBarHeight: navBarHeight),
          ),

          // ---------------------------------------------------
          // Animation Builder for Swipe Animation
          // ---------------------------------------------------
          AnimatedBuilder(
            animation: logic.guidedModeController,
            builder: (_, __) {
              final topPosition = lerpDouble(height, 0, logic.guidedModeController.value)!;
              return Positioned(
                left: 0,
                right: 0,
                top: topPosition,
                height: height,
                child: GuidedModeOverlay(),
              );
            },
          ),
        ],
      ),
    );
  }
}
