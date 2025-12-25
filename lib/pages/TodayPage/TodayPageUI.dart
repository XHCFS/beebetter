import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/pages/TodayPage/TodayPageLogic.dart';
import 'package:beebetter/widgets/Cards/EntryCard/EntryCard.dart';
import 'package:beebetter/pages/TodayPage/NewEntryPageLogic.dart';
import 'package:beebetter/widgets/HexagonPattern.dart';


class TodayPageUI extends StatelessWidget {
  final VoidCallback openGuidedMode;
  const TodayPageUI({super.key, required this.openGuidedMode});

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<TodayPageLogic>();
    final entryLogic = context.watch<NewEntryPageLogic>();

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    Color inversePrimaryBright = Color.alphaBlend(
      Theme.of(context).colorScheme.inversePrimary.withAlpha(20),
      Theme.of(context).colorScheme.surfaceContainerLowest,
    );
    Color inversePrimaryBrighter = Color.alphaBlend(
      Theme.of(context).colorScheme.inversePrimary.withAlpha(100),
      Theme.of(context).colorScheme.surfaceContainerLowest,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome back, ", style: textTheme.headlineMedium
                  ?.copyWith(color: colorScheme.primary),),
              const SizedBox(width: 4),
              Text(logic.username, style: textTheme.headlineMedium
                  ?.copyWith(color: colorScheme.primary),),
              const SizedBox(width: 4),
              Text("!", style: textTheme.headlineMedium
                  ?.copyWith(color: colorScheme.primary),),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(logic.formattedDay, style: textTheme.titleMedium
                  ?.copyWith(color: colorScheme.primary),),
              const SizedBox(width: 8),
              Text(logic.formattedDate, style: textTheme.titleMedium
                  ?.copyWith(color: colorScheme.primary.withAlpha(160)),),
            ],
          ),

          const SizedBox(height: 16),

          // ---------------------------------------------------
          // New Entry
          // ---------------------------------------------------
          SizedBox(
            height: 400,
            child: EntryCard(
              index: 0,
              category: "Free Entry",
              canContinue: entryLogic.canContinue,
              initialText: "",
              onTextChanged: (text) {
                entryLogic.updatePromptInput(text);
                entryLogic.updateCanContinue(text.trim().isNotEmpty);
              },
              onContinuePressed: (text) {},
            ),
          ),
          const SizedBox(height: 20),

          // ---------------------------------------------------
          // Daily Prompts
          // ---------------------------------------------------
          Card(
            elevation: 2,
            color: colorScheme.inversePrimary,
            shadowColor: colorScheme.inversePrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              // side: BorderSide(color: colorScheme.inversePrimary, width: 1),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: openGuidedMode,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      inversePrimaryBright,
                      inversePrimaryBrighter
                    ],
                    stops: const [0.1, 1,],
                  ),
                ),
                child: Stack(
                  children: [
                    // ---------------------------------------------------
                    // Hexagons Pattern
                    // ---------------------------------------------------
                    Positioned.fill(
                      child: IgnorePointer(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomPaint(
                            painter: HexagonPatternPainter(
                              intensity: 1,
                              color: colorScheme.inversePrimary,
                              maxHexes: 10,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ---------------------------------------------------
                    // Text and Icons
                    // ---------------------------------------------------
                    Container(
                      width: double.infinity,
                      height: 100,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Icon(
                              Icons.edit_note_rounded,
                              size: 32,
                              color: colorScheme.primary.withAlpha(200),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Daily Prompts",
                                style: textTheme.titleMedium
                                    ?.copyWith(color: colorScheme.primary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${logic.completedEntries} / ${logic.totalEntries} completed",
                                style: textTheme.titleSmall
                                    ?.copyWith(color: colorScheme.primary.withAlpha(120)),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.keyboard_arrow_up_rounded,
                            size: 32,
                            color: colorScheme.inversePrimary,
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
