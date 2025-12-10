import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/pages/GuidedMode/RecordingLogic.dart';
import 'package:beebetter/widgets/RecordingCard.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeLogic.dart';

class PromptInput extends StatefulWidget {
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
  State<PromptInput> createState() => PromptInputState();
}

class PromptInputState extends State<PromptInput> with TickerProviderStateMixin {

  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    final logic = context.read<GuidedModeLogic>();
    int initialIndex = 1;

    // fallback if initial tab is locked
    if (initialIndex == 0 && logic.isTextLocked[logic.currentPrompt]) initialIndex = 1;
    if (initialIndex == 1 && logic.isVoiceLocked[logic.currentPrompt]) initialIndex = 0;

    tabController = TabController(length: 2, vsync: this, initialIndex: initialIndex);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) return;
      int i = tabController.index;
      bool textLocked  = logic.isTextLocked[logic.currentPrompt];
      bool voiceLocked = logic.isVoiceLocked[logic.currentPrompt];

      if ((i == 0 && textLocked) || (i == 1 && voiceLocked)) {
        tabController.index = tabController.previousIndex;
        return;
      }

      logic.lastActiveTab[logic.currentPrompt] = i;
    });
  }


  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final logic = context.watch<GuidedModeLogic>();

    bool textLocked = logic.isTextLocked[logic.currentPrompt];
    bool voiceLocked = logic.isVoiceLocked[logic.currentPrompt];

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
            widget.category,
            style: textTheme.titleSmall?.copyWith(color: colorScheme.inversePrimary),
          ),
        ),
        const SizedBox(height: 16),

        // ---------------------------------------------------
        // Prompt
        // ---------------------------------------------------
        Text(widget.prompt, style: textTheme.titleMedium?.copyWith(color: colorScheme.primary)),
        const SizedBox(height: 8),

        // ---------------------------------------------------
        // Tabs
        // ---------------------------------------------------

        // ---------------------------------------------------
        // TabBar
        // ---------------------------------------------------
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
              controller: tabController,
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

              tabs: [
              IgnorePointer(
                ignoring: textLocked,
                child:Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.text_fields, size: 20, color: textLocked ? colorScheme.secondary.withAlpha(128) : colorScheme.primary),
                        SizedBox(width: 6),
                        Text("Text", style: TextStyle( color: textLocked ? colorScheme.secondary.withAlpha(128) : colorScheme.primary)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mic, size: 20, color: voiceLocked ? colorScheme.secondary.withAlpha(128) : colorScheme.primary),
                      SizedBox(width: 6),
                      Text("Voice", style: TextStyle( color: voiceLocked ? colorScheme.secondary.withAlpha(128) : colorScheme.primary)),
                    ],
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
            controller: tabController,
            physics: (textLocked || voiceLocked)
                ? NeverScrollableScrollPhysics()
                : BouncingScrollPhysics(),
            children: [
              // ---------------------------------------------------
              // Text Input
              // ---------------------------------------------------
              AbsorbPointer(
                absorbing: textLocked,
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  color: colorScheme.surfaceBright,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: widget.controller,
                      readOnly: widget.isDone,
                      onChanged: widget.onTextChanged,
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
              ),

              // ---------------------------------------------------
              // Recording Tab
              // ---------------------------------------------------
              AbsorbPointer(
                absorbing: voiceLocked,
                child: ChangeNotifierProvider(
                  create: (_) => RecordingLogic(logic),
                  child: RecordingCard(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ---------------------------------------------------
        // Continue Button
        // ---------------------------------------------------
        OutlinedButton(
          onPressed: (widget.canContinue || !widget.isDone)
              ? ()  {
            widget.onFlip();
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
                colors: widget.canContinue
                    ? [colorScheme.inversePrimary, colorScheme.primaryContainer]
                    : [colorScheme.surfaceContainerHighest, colorScheme.surfaceContainerHighest],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                widget.isDone ? "Done" : "Continue",
                style: TextStyle(
                  color: widget.canContinue ? colorScheme.secondary : colorScheme.onSurface.withAlpha(160),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}