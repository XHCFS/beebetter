import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeLogic.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeUI.dart';
import 'package:beebetter/widgets/HexagonPattern.dart';

class GuidedModeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logic = context.watch<GuidedModeLogic>();
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // top & horizontal padding
              child: GuidedModeUI(),
            ),
          ),
          // -----------------------------------
          // Delete Visual Indicator
          // -----------------------------------
          Positioned(
            left: -16,
            right: -16,
            bottom: -16,
            child: IgnorePointer(
              ignoring: true,
              child: AnimatedOpacity(
                opacity: logic.deleteDragProgress > 0.1 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(0.0, -1.6),
                          radius: 1.5,
                          colors: [
                            colorScheme.error.withAlpha(0),
                            colorScheme.error.withAlpha(
                                ((0.2 + 0.5 * logic.deleteDragProgress) * 255).toInt()
                            ),
                          ],
                          stops: const [0.7, 1.0],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: AnimatedScale(
                        scale: 0.8 + logic.deleteDragProgress * 0.4,
                        duration: const Duration(milliseconds: 100),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 110),
                          child: Icon(
                            Icons.delete_forever_outlined,
                            size: 40,
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: CustomPaint(
                        painter: HexagonPatternPainter(
                          intensity: logic.deleteDragProgress,
                          color: colorScheme.error,
                          maxHexes: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
    );
  }
}