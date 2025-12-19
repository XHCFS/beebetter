import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/pages/NewEntryPage/NewEntryPageLogic.dart';
import 'package:beebetter/widgets/Cards/EntryCard/EntryCard.dart';

class NewEntryPageUI extends StatelessWidget {
  const NewEntryPageUI({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<NewEntryPageLogic>();

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    Color surfaceContainerDark = Color.alphaBlend(
      Theme.of(context).colorScheme.inversePrimary.withAlpha(20),
      Theme.of(context).colorScheme.surfaceContainerLow,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                // ---------------------------------------------------
                // Back button
                // ---------------------------------------------------
                IconButton(
                  icon: Icon(Icons.arrow_back, color: colorScheme.primary),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                // ---------------------------------------------------
                // Day and date
                // ---------------------------------------------------
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        logic.formattedDay,
                        style: textTheme.titleMedium?.copyWith(color: colorScheme.primary),
                      ),
                      Text(
                        logic.formattedDate,
                        style: textTheme.titleMedium
                            ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                      ),
                    ],
                  ),
                ),
                // balancing back button width
                SizedBox(width: 48),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: EntryCard(
                index: 0,
                category: "Free Entry",
                canContinue: logic.canContinue,
                onContinuePressed: (text) {},
                onTextChanged: (text) {
                  logic.updatePromptInput(text);
                  logic.updateCanContinue(text.trim().isNotEmpty);
                },
                initialText: "",
              ),
            )
          ]
      ),
    );
  }
}
