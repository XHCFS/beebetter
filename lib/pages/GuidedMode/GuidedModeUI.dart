import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/widgets/PromptCard.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeLogic.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class GuidedModeUI extends StatelessWidget {
  const GuidedModeUI({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<GuidedModeLogic>();
    final CardSwiperController cardSwiperController = CardSwiperController();

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
          children: [
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.all(8.0),
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
                      borderRadius: BorderRadius.circular(10),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // ---------------------------------------------------
                              // Back
                              // ---------------------------------------------------
                              ElevatedButton(
                                onPressed: () {
                                  logic.previousPrompt(cardSwiperController);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: logic.currentPrompt <= 0
                                      ? colorScheme.inversePrimary.withAlpha(100)
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
                              // Next
                              // ---------------------------------------------------
                              ElevatedButton(
                                onPressed: () {
                                  if (logic.currentPrompt + 1 < logic.totalPrompts) {
                                    cardSwiperController.swipe(CardSwiperDirection.right);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: logic.currentPrompt >= logic.totalPrompts -1
                                      ? colorScheme.inversePrimary.withAlpha(100)
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
                          onSwipe: (prevIndex, currentIndex, direction) {
                            logic.onSwipe(currentIndex);
                            return true;
                          },
                          cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                            // if (index >= logic.totalPrompts) return SizedBox.shrink();
                            final promptInfo = logic.prompts[index];

                            return PromptCard(
                              key: ValueKey(promptInfo.prompt),
                              index: index,
                              category: promptInfo.category,
                              prompt: promptInfo.prompt,
                              canContinue: promptInfo.canContinue,
                              isDone: promptInfo.isDone,
                              initialText: promptInfo.userInput,
                              cardSwiperController : cardSwiperController,
                              onTextChanged: (value) {
                                logic.updatePromptInput(index, value);
                                logic.updateCanContinue(value.trim().isNotEmpty);
                              },
                              onContinuePressed: (entry) {
                                logic.submit(index, cardSwiperController);
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
        ]
    );
  }
}