import 'package:flutter/material.dart';
import 'package:beebetter/widgets/PromptCard.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeLogic.dart';
import 'package:provider/provider.dart';


class GuidedModeUI extends StatelessWidget {
  const GuidedModeUI({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<GuidedModeLogic>();

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
          children: [
            // ---------------------------------------------------
            // Swipe Gesture Indication Bar
            // ---------------------------------------------------
            Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(80),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

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
                      Text("${logic.completedPrompts} / ${logic.totalPrompts}", style: textTheme.bodyLarge
                          ?.copyWith(color: colorScheme.primary.withAlpha(160)),),
                    ],
                  ),
                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: logic.completedPrompts / logic.totalPrompts,
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

            // ---------------------------------------------------
            // Prompt Cards
            // ---------------------------------------------------
            const SizedBox(height: 32),
            PromptCard(
              category: logic.currentPromptCategory,
              prompt: logic.currentPromptText,
              canContinue: logic.canContinue,
              onTextChanged: (value) {
                logic.updateCanContinue(value.trim().isNotEmpty);
              },
              onContinuePressed: (entry) {logic.submit(entry);},
            ),
            const SizedBox(height: 32),

          // Navigation Buttons
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------------------------------------------
                  // Navigation Buttons
                  // ---------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back
                      ElevatedButton(
                        onPressed: logic.previousPrompt,
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
                      // Next
                      ElevatedButton(
                        onPressed: logic.nextPrompt,
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
                  // ---------------------------------------------------
                ],
              ),
            ),
        ]
    );
  }
}