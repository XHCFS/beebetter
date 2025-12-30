import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/widgets/Cards/PromptCard/PromptCard.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeLogic.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class GuidedModeUI extends StatefulWidget {
  const GuidedModeUI({super.key});

  @override
  State<GuidedModeUI> createState() => _GuidedModeUIState();
}

class _GuidedModeUIState extends State<GuidedModeUI> {
  late CardSwiperController cardSwiperController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    cardSwiperController = CardSwiperController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<GuidedModeLogic>();

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            // Move card to back and go to previous
            if (logic.currentPrompt > 0) {
              logic.moveCardToBack(logic.currentPrompt);
              cardSwiperController.swipe(CardSwiperDirection.left);
            }
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            // Move card to back and go to next
            if (logic.currentPrompt < logic.totalPrompts - 1) {
              logic.moveCardToBack(logic.currentPrompt);
              cardSwiperController.swipe(CardSwiperDirection.right);
            }
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(80),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text("Daily Prompts", style: textTheme.titleLarge
                    ?.copyWith(color: colorScheme.primary),),
                const SizedBox(height: 16),

                // ---------------------------------------------------
                // Progress bar
                // ---------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Progress", style: textTheme.bodyLarge
                        ?.copyWith(color: colorScheme.primary.withAlpha(160)),),
                    Text("${logic.completedPrompts} / ${logic.originalTotalPrompts}", style: textTheme.bodyLarge
                        ?.copyWith(color: colorScheme.primary.withAlpha(160)),),
                  ],
                ),
                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: logic.completedPrompts / logic.originalTotalPrompts,
                      backgroundColor: colorScheme.primary.withAlpha(30),
                      color: colorScheme.inversePrimary,
                      minHeight: 10,
                    ),
                  ),
                ),
                // ---------------------------------------------------
              ],
            ),
        ),

          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // ---------------------------------------------------
                // Navigation Buttons
                // ---------------------------------------------------
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 8,
                  child:Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ---------------------------------------------------
                            // Back (move card to back)
                            // ---------------------------------------------------
                            ElevatedButton(
                              onPressed: () {
                                if (logic.currentPrompt > 0) {
                                  logic.moveCardToBack(logic.currentPrompt);
                                  cardSwiperController.swipe(CardSwiperDirection.left);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: logic.currentPrompt <= 0
                                    ? colorScheme.inversePrimary.withAlpha(128)
                                    : colorScheme.inversePrimary,
                                foregroundColor: colorScheme.surface,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                              child: const Icon(Icons.arrow_back_ios_rounded),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${logic.currentPrompt + 1} / ${logic.totalPrompts}", style: textTheme.titleMedium
                                    ?.copyWith(color: colorScheme.primary.withAlpha(160)),),
                                const SizedBox(width: 4),
                                Material(
                                  color: Colors.transparent,
                                  shape: const CircleBorder(),
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: logic.shufflePrompts,
                                    splashColor: colorScheme.primary.withAlpha(50),
                                    highlightColor: Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.shuffle_rounded,
                                        color: colorScheme.primary.withAlpha(160),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // ---------------------------------------------------
                            // Next (move card to back)
                            // ---------------------------------------------------
                            ElevatedButton(
                              onPressed: () {
                                if (logic.currentPrompt < logic.totalPrompts - 1) {
                                  logic.moveCardToBack(logic.currentPrompt);
                                  cardSwiperController.swipe(CardSwiperDirection.right);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: logic.currentPrompt >= logic.totalPrompts -1
                                    ? colorScheme.inversePrimary.withAlpha(128)
                                    : colorScheme.inversePrimary,
                                foregroundColor: colorScheme.surface,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                              child: const Icon(Icons.arrow_forward_ios_rounded),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                // ---------------------------------------------------
                // Prompts Cards
                // ---------------------------------------------------
                Column(
                  children: [
                    Expanded(
                      child:CardSwiper(
                        key: ValueKey(logic.prompts.length),
                        cardsCount: logic.prompts.length,
                        numberOfCardsDisplayed: logic.prompts.length > 1 ? 2 : 1,
                        controller: cardSwiperController,

                        onSwipeDirectionChange: (previous, current) {
                          if (current == CardSwiperDirection.bottom) {
                            logic.isDraggingToDelete = true;
                            logic.deleteDragProgress = 0.3;
                          } else {
                            logic.resetDeleteDrag();
                          }
                        },

                        onSwipe:  (prevIndex, currentIndex, direction) {
                          if (direction == CardSwiperDirection.bottom) {
                            // Swipe down: skip prompt and get new one
                            logic.skipPrompt(prevIndex);
                            return false; // Don't remove, just replace
                          }

                          // Swipe left/right/up: move card to back of deck
                          if (direction == CardSwiperDirection.left || 
                              direction == CardSwiperDirection.right ||
                              direction == CardSwiperDirection.top) {
                            // Move card to back after a short delay to allow animation
                            Future.delayed(const Duration(milliseconds: 100), () {
                              logic.moveCardToBack(prevIndex);
                            });
                            // Update current index
                            if (currentIndex != null && currentIndex < logic.prompts.length) {
                              logic.onSwipe(currentIndex);
                            }
                            return true; // Allow CardSwiper to animate the card away
                          }

                          // Default: just update index
                          logic.onSwipe(currentIndex);
                          return true;
                        },
                        cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                          final promptInfo = logic.prompts[index];

                          return PromptCard(
                            key: ValueKey(promptInfo.title),
                            index: index,
                            category: promptInfo.category,
                            prompt: promptInfo.title,
                            canContinue: promptInfo.canContinue,
                            isDone: promptInfo.isDone,
                            initialText: promptInfo.userInput,
                            cardSwiperController : cardSwiperController,
                            onTextChanged: (value) {
                              logic.updatePromptInput(index, value);
                              logic.updateCanContinue(value.trim().isNotEmpty);
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 72), // area for navigation bar
                  ]
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}