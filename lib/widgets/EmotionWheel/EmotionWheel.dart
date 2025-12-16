import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:beebetter/widgets/EmotionWheel/EmotionsGrid.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeLogic.dart';
import 'package:provider/provider.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class EmotionWheel extends StatefulWidget {
  final VoidCallback onFlip;
  final CardSwiperController cardSwiperController;
  final int index;

  const EmotionWheel({
    super.key,
    required this.onFlip,
    required this.cardSwiperController,
    required this.index,
  });

  @override
  State<EmotionWheel> createState() => EmotionWheelState();
}

class EmotionWheelState extends State<EmotionWheel> {
  final PageController pageController = PageController();
  int currentLevel = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final logic = context.watch<GuidedModeLogic>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 32),
        Text(
          "How are you feeling?",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colorScheme.primary),
        ),
        const SizedBox(height: 16),

        // ---------------------------------------------------
        // Emotions Selection
        // ---------------------------------------------------
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child:
              PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                    EmotionsGrid(
                      items: logic.items,
                      emotionLevel: 0,
                      onPressed: (value) {
                        print("Selected: $value");
                      },
                    ),
                  EmotionsGrid(
                    items: logic.items,
                    emotionLevel: 1,
                    onPressed: (value) {
                      print("Selected: $value");
                    },
                  ),
                  EmotionsGrid(
                    items: logic.items,
                    emotionLevel: 2,
                    onPressed: (value) {
                      print("Selected: $value");
                    },
                  ),
                ],
             ),
          ),
        ),

        const SizedBox(height: 16),
        // ---------------------------------------------------
        // Back Button
        // ---------------------------------------------------
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Row(
            children: [
              // Back
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: colorScheme.secondary.withAlpha(90),
                      width: 1.2,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14), // match heights
                  ),
                  onPressed: () {
                    if(currentLevel == 0)
                      {
                        widget.onFlip();
                      }
                    else {
                      currentLevel--;
                      logic.updateCanSelectNextForLevel(currentLevel);
                      pageController.animateToPage(
                        currentLevel,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  child: Text(
                    "back",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.secondary.withAlpha(160),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),
              // Next
              Expanded(
                child:
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide.none,
                    ),
                    onPressed: logic.canSelectNext ? () async {
                      print("current level $currentLevel!?");
                      if(currentLevel == logic.emotionLevels - 1)
                      {
                        widget.onFlip();
                        logic.submitEmotion(currentLevel);
                        widget.cardSwiperController.swipe(CardSwiperDirection.left);
                        await Future.delayed(const Duration(milliseconds: 300));
                        logic.submit(widget.index, widget.cardSwiperController);
                      }
                      else {
                        currentLevel++;
                        logic.updateCanSelectNextForLevel(currentLevel);
                        pageController.animateToPage(
                          currentLevel,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOut,
                        );
                      }
                    } : null,
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:  logic.canSelectNext
                              ? [colorScheme.inversePrimary, colorScheme.primaryContainer]
                              : [colorScheme.surfaceContainerHighest, colorScheme.surfaceContainerHighest],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        alignment: Alignment.center,
                        child: Text(
                          "next",
                          style: TextStyle(
                            color: logic.canSelectNext ? colorScheme.secondary : colorScheme.onSurface.withAlpha(160),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ),
            ]
          ),
        ),
        const SizedBox(height: 16),
        // ---------------------------------------------------
        // Page Indicator
        // ---------------------------------------------------
        SmoothPageIndicator(
          controller: pageController,
          count: 3,
          effect: ExpandingDotsEffect(
            activeDotColor: colorScheme.inversePrimary,
            dotColor: colorScheme.primary.withAlpha(50),
            dotHeight: 8,
            dotWidth: 8,
            spacing: 8,
            expansionFactor: 3,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
