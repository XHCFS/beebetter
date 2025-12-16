import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/pages/TodayPage/TodayPageLogic.dart';
import 'package:beebetter/pages/GuidedMode/GuidedMode.dart';
import 'package:beebetter/pages/NewEntryPage/NewEntryPage.dart';

class TodayPageUI extends StatelessWidget {
  final VoidCallback openGuidedMode;
  const TodayPageUI({super.key, required this.openGuidedMode});

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<TodayPageLogic>();

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    Color surfaceContainerDark = Color.alphaBlend(
      Theme.of(context).colorScheme.inversePrimary.withAlpha(20),
      Theme.of(context).colorScheme.surfaceContainerLow,
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
          const SizedBox(height: 32),
          Text(logic.formattedDay, style: textTheme.titleMedium
              ?.copyWith(color: colorScheme.primary),),
          Text(logic.formattedDate, style: textTheme.titleMedium
              ?.copyWith(color: colorScheme.primary.withAlpha(160)),),
          const SizedBox(height: 16),

          Card(
            // elevation: 2,
            color: colorScheme.onPrimary,
            shadowColor: colorScheme.inversePrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              // side: BorderSide(color: colorScheme.inversePrimary, width: 1),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewEntryPage()),
                );
              },
              child: Container(
                width: double.infinity,
                height: 200,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 32,
                        color: colorScheme.primary.withAlpha(240),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "New Entry",
                      style: textTheme.titleMedium
                          ?.copyWith(color: colorScheme.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Journal your thoughts and mood",
                      style: textTheme.titleSmall
                          ?.copyWith(color: colorScheme.primary.withAlpha(100)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            color: surfaceContainerDark,
            shadowColor: colorScheme.inversePrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              // side: BorderSide(color: colorScheme.inversePrimary, width: 1),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: openGuidedMode,
              child: Container(
                width: double.infinity,
                height: 120,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Icon(
                        Icons.lightbulb_outline_rounded,
                        size: 32,
                        color: colorScheme.primary.withAlpha(200),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Daily prompts",
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
                    const SizedBox(width: 32),
                    Icon(
                      Icons.keyboard_arrow_up_rounded,
                      size: 32,
                      color: colorScheme.inversePrimary,
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
