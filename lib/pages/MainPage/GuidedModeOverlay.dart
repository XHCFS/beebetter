import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/pages/MainPage/MainPageLogic.dart';
import 'package:beebetter/pages/GuidedMode/GuidedMode.dart';

class GuidedModeOverlay extends StatelessWidget {
  const GuidedModeOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<MainPageLogic>();
    final height = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top; // safe area top
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.secondary.withAlpha(60),
            blurRadius: 12,
            spreadRadius: 1,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        child: Stack(
          children: [
            // ---------------------------------------------------
            // Guided Mode
            // ---------------------------------------------------
            GuidedMode(),

            // ---------------------------------------------------
            // Swipe Gesture Indication Bar
            // ---------------------------------------------------
            Positioned(
              top: topPadding,
              left: 0,
              right: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragUpdate: (details) {
                  logic.guidedModeController.value -= details.delta.dy / height;
                },
                onVerticalDragEnd: (details) {
                  if (logic.guidedModeController.value < 0.8) {
                    logic.closeGuidedMode(); // snap closed
                  } else {
                    logic.openGuidedMode(); // snap open
                  }
                },
                child: Container(
                  height: 150,
                  alignment: Alignment.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
