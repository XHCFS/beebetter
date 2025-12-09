import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/pages/GuidedMode/RecordingLogic.dart';
import 'package:beebetter/widgets/RecordingCard.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeLogic.dart';

class PromptInput extends StatelessWidget {
  final String category;
  final String prompt;
  final bool canContinue;
  final bool isDone;
  final TextEditingController controller;
  final void Function(String) onTextChanged;
  final BuildContext parentContext;
  final void Function(String) onContinuePressed;
  final VoidCallback onFlip;

  const PromptInput({
    super.key,
    required this.category,
    required this.prompt,
    required this.canContinue,
    required this.isDone,
    required this.controller,
    required this.onTextChanged,
    required this.parentContext,
    required this.onContinuePressed,
    required this.onFlip,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final logic = context.watch<GuidedModeLogic>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------------------------------------------
        // Category
        // ---------------------------------------------------
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: colorScheme.surfaceBright,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: colorScheme.inversePrimary,
              width: 1,
            ),
          ),
          child: Text(
            category,
            style: textTheme.titleSmall?.copyWith(color: colorScheme.inversePrimary),
          ),
        ),
        const SizedBox(height: 16),

        // ---------------------------------------------------
        // Prompt
        // ---------------------------------------------------
        Text(prompt, style: textTheme.titleMedium?.copyWith(color: colorScheme.primary)),
        const SizedBox(height: 8),

        // ---------------------------------------------------
        // Tabs
        // ---------------------------------------------------
        DefaultTabController(
          length: 2,
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // TabBar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceBright,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: TabBar(
                      padding: EdgeInsets.zero,
                      labelPadding: EdgeInsets.zero,
                      indicatorPadding: EdgeInsets.zero,
                      indicator: BoxDecoration(
                        color: colorScheme.inversePrimary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: colorScheme.secondary,
                      unselectedLabelColor: colorScheme.primary,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(Icons.text_fields, size: 20), SizedBox(width: 6), Text("Text")],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(Icons.mic, size: 20), SizedBox(width: 6), Text("Voice")],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ---------------------------------------------------
                // TabBarView
                // ---------------------------------------------------
                Expanded(
                  child: TabBarView(
                    children: [
                      // Text Input
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        color: colorScheme.surfaceBright,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            controller: controller,
                            readOnly: isDone,
                            onChanged: onTextChanged,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Share your thoughts...",
                              hintStyle: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary.withAlpha(128),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
                          ),
                        ),
                      ),

                      // ---------------------------------------------------
                      // Recording Tab
                      // ---------------------------------------------------
                      ChangeNotifierProvider(
                        create: (_) => RecordingLogic(logic),
                        child: RecordingCard(),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ---------------------------------------------------
                // Continue Button
                // ---------------------------------------------------
                OutlinedButton(
                  onPressed: (canContinue || !isDone)
                      ? ()  {
                      onFlip();
                  }
                      : null,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide.none,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: canContinue
                            ? [colorScheme.inversePrimary, colorScheme.primaryContainer]
                            : [colorScheme.surfaceContainerHighest, colorScheme.surfaceContainerHighest],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Text(
                        isDone ? "Done" : "Continue",
                        style: TextStyle(
                          color: canContinue ? colorScheme.secondary : colorScheme.onSurface.withAlpha(160),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
