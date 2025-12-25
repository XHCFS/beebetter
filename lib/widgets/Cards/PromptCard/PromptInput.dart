import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/widgets/Cards/RecordingCard/RecordingLogic.dart';
import 'package:beebetter/widgets/Cards/RecordingCard/RecordingCard.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeLogic.dart';
import 'package:beebetter/widgets/Cards/PromptCard/DoneCard.dart';
import 'package:beebetter/widgets/Cards/ExpandingTextOverlay.dart';

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

  final GlobalKey textCardKey = GlobalKey();
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    final logic = context.read<GuidedModeLogic>();
    int initialIndex = 1;

    final prompt = logic.currentPromptInfo;

    // fallback if initial tab is locked
    if (initialIndex == 0 && prompt.isTextLocked) initialIndex = 1;
    if (initialIndex == 1 && prompt.isVoiceLocked) initialIndex = 0;

    tabController = TabController(length: 2, vsync: this, initialIndex: initialIndex);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) return;
      int i = tabController.index;
      bool textLocked  = prompt.isTextLocked;
      bool voiceLocked = prompt.isVoiceLocked;

      if ((i == 0 && textLocked) || (i == 1 && voiceLocked)) {
        tabController.index = tabController.previousIndex;
        return;
      }

      prompt.lastActiveTab = i;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void openExpandingTextInput() {
    final renderBox =
    textCardKey.currentContext!.findRenderObject() as RenderBox;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return ExpandingTextOverlay(
          startOffset: offset,
          startSize: size,
          title: widget.prompt,
          initialText: widget.controller.text,
          onClose: (text) {
            widget.controller.text = text;
            widget.onTextChanged(text);
            overlayEntry?.remove();
            overlayEntry = null;
          },
        );
      },
    );

    Overlay.of(context).insert(overlayEntry!);
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final logic = context.watch<GuidedModeLogic>();
    final prompt = logic.currentPromptInfo;

    bool textLocked = prompt.isTextLocked;
    bool voiceLocked = prompt.isVoiceLocked;

    bool isDoneCard = logic.currentPromptText == "Done!";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isDoneCard)...[
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
              style: textTheme.titleSmall?.copyWith(color: colorScheme.primary.withAlpha(200)),
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
                    key: textCardKey,
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    color: colorScheme.surfaceBright,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        openExpandingTextInput();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child:SingleChildScrollView(
                          child: Text(
                            widget.controller.text.isEmpty
                                ? "Share your thoughts..."
                                : widget.controller.text,
                            style: textTheme.bodyMedium?.copyWith(
                              color: widget.controller.text.isEmpty
                                  ? colorScheme.primary.withAlpha(128) : colorScheme.primary,
                            ),
                          ),
                        )

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
                    create: (_) => RecordingLogic(
                      onRecordingComplete: (canContinue) {
                        final logic = context.read<GuidedModeLogic>();
                        final prompt = logic.currentPromptInfo;
                        prompt.isTextLocked = canContinue;
                        logic.updateCanContinue(canContinue);
                      },
                    ),
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
            onPressed: widget.canContinue
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
        ]
      else... [
          DoneCard()
        ]
      ]
    ),
    );
  }
}