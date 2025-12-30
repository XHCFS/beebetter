import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:beebetter/widgets/Cards/EmotionWheel/EmotionsGrid.dart';

class EmotionWheel extends StatefulWidget {
  final List<List<String>> emotionItems;
  final int levels;
  final List<String?> selectedEmotions;
  final void Function(int level, String emotion) onEmotionSelected;
  final bool canSelectNext;
  final void Function(int level) onNext;
  final VoidCallback onBack;
  final void Function(int level) onLevelChanged;

  const EmotionWheel({
    super.key,
    required this.emotionItems,
    required this.levels,
    required this.selectedEmotions,
    required this.onEmotionSelected,
    required this.canSelectNext,
    required this.onNext,
    required this.onBack,
    required this.onLevelChanged,
  });

  @override
  State<EmotionWheel> createState() => EmotionWheelState();
}

class EmotionWheelState extends State<EmotionWheel> {
  final PageController pageController = PageController();
  int currentLevel = 0;
  // late List<String?> selectedEmotions;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void goNext() {
    widget.onNext(currentLevel);

    if (currentLevel < widget.levels - 1) {
      setState(() => currentLevel++);
      widget.onLevelChanged(currentLevel);
      pageController.animateToPage(
        currentLevel,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void goBack() {
    if (currentLevel == 0) {
      widget.onBack();
    } else {
      setState(() => currentLevel--);
      widget.onLevelChanged(currentLevel);
      pageController.animateToPage(
        currentLevel,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 4),
          Text(
            "How are you feeling?",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colorScheme.primary),
          ),
          const SizedBox(height: 8),

          // ---------------------------------------------------
          // Emotions Selection
          // ---------------------------------------------------
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child:
              PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  widget.levels,
                      (level) => EmotionsGrid(
                    items: widget.emotionItems[level],
                    selectedItem: widget.selectedEmotions[level],
                    onChanged: (value) {
                      setState(() {
                        widget.selectedEmotions[level] = value;
                      });
                      widget.onEmotionSelected(level, value ?? "");
                    },
                  ),
                ),
              ),
            ),
          ),

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
                      onPressed: goBack,
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
                      onPressed: widget.canSelectNext ? goNext : null,
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:  widget.canSelectNext
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
                              color: widget.canSelectNext ? colorScheme.secondary : colorScheme.onSurface.withAlpha(160),
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
          const SizedBox(height: 8),
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
          // const SizedBox(height: 16),
        ],
      ),
    );
  }
}
