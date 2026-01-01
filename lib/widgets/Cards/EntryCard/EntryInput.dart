import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:beebetter/widgets/Cards/RecordingCard/RecordingLogic.dart';
import 'package:beebetter/pages/TodayPage/NewEntryPageLogic.dart';
import 'package:beebetter/widgets/Cards/RecordingCard/RecordingCard.dart';
import 'package:beebetter/widgets/Cards/ExpandingTextOverlay.dart';

class EntryInput extends StatefulWidget {
  final bool canContinue;
  final TextEditingController controller;
  final void Function(String) onTextChanged;
  final BuildContext parentContext;
  final void Function(String) onContinuePressed;
  final VoidCallback onFlip;

  const EntryInput({
    super.key,
    required this.canContinue,
    required this.controller,
    required this.onTextChanged,
    required this.parentContext,
    required this.onContinuePressed,
    required this.onFlip,
  });

  @override
  State<EntryInput> createState() => EntryInputState();
}

class EntryInputState extends State<EntryInput> with TickerProviderStateMixin {

  final GlobalKey textCardKey = GlobalKey();
  OverlayEntry? overlayEntry;

  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    final logic = context.read<NewEntryPageLogic>();
    int initialIndex = logic.entryInfo.lastActiveTab;

    // fallback if initial tab is locked
    if (initialIndex == 0 && logic.entryInfo.isTextLocked) initialIndex = 1;
    if (initialIndex == 1 && logic.entryInfo.isVoiceLocked) initialIndex = 0;

    tabController = TabController(length: 2, vsync: this, initialIndex: initialIndex);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) return;
      int i = tabController.index;
      bool textLocked  = logic.entryInfo.isTextLocked;
      bool voiceLocked = logic.entryInfo.isVoiceLocked;

      if ((i == 0 && textLocked) || (i == 1 && voiceLocked)) {
        tabController.index = tabController.previousIndex;
        return;
      }

      logic.entryInfo.lastActiveTab = i;
    });
  }

  @override
  void didUpdateWidget(covariant EntryInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    final logic = context.read<NewEntryPageLogic>();
    final targetTab = logic.entryInfo.lastActiveTab;

    if (tabController.index != targetTab) {
      tabController.animateTo(
        targetTab,
        duration: Duration.zero,
      );
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void openExpandingTextInput(NewEntryPageLogic logic) {
    final renderBox =
    textCardKey.currentContext!.findRenderObject() as RenderBox;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return ExpandingTextOverlay(
          startOffset: offset,
          startSize: size,
          title: logic.entryInfo.title,
          initialText: widget.controller.text,
          onClose: (text) {
            widget.controller.text = text;
            widget.onTextChanged(text);
            overlayEntry?.remove();
            overlayEntry = null;
          },
          isGuided: false,
          isReadOnly: false,
        );
      },
    );

    Overlay.of(context).insert(overlayEntry!);
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final logic = context.watch<NewEntryPageLogic>();

    bool textLocked = logic.entryInfo.isTextLocked;
    bool voiceLocked = logic.entryInfo.isVoiceLocked;


    return Padding(
      padding: const EdgeInsets.all(16.0),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text("What’s on your mind?", style: textTheme.titleMedium?.copyWith(color: colorScheme.primary)),
          const SizedBox(height: 8),
          // ---------------------------------------------------
          // Title
          // ---------------------------------------------------
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              color: colorScheme.surfaceBright,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (text) => logic.updateTitle(text),
                  maxLines: 1,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(40),
                  ],
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: "Title",
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
                          FocusScope.of(context).unfocus();
                          openExpandingTextInput(logic);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:  widget.controller.text.isEmpty
                              ? Text(
                            "Share your thoughts...",
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary.withAlpha(128),
                            ),
                          )
                              : SingleChildScrollView(
                                  child: Container(
                                    width: double.infinity,
                                    child:MarkdownBody(
                                      data: widget.controller.text.trimLeft(),
                                      styleSheet: MarkdownStyleSheet.fromTheme(
                                        Theme.of(context),
                                      ).copyWith(
                                        p: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.primary,
                                        ),
                                        h1: textTheme.headlineSmall?.copyWith(
                                          color: colorScheme.primary,
                                        ),
                                        h2: textTheme.titleLarge?.copyWith(
                                          color: colorScheme.primary,
                                        ),
                                        h3: textTheme.titleMedium?.copyWith(
                                          color: colorScheme.primary,
                                        ),
                                        strong: TextStyle(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        em: TextStyle(
                                          color: colorScheme.primary,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        listBullet: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.primary,
                                        ),
                                        checkbox: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                  ),
                              ),
                          ),
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
                          logic.updateCanContinue(canContinue);
                          logic.entryInfo.isTextLocked = canContinue;
                        },
                        onError: (errorMessage) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: Theme.of(context).colorScheme.error,
                              duration: const Duration(seconds: 4),
                            ),
                          );
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
              onPressed: (widget.canContinue)
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
                    "Continue",
                    style: TextStyle(
                      color: widget.canContinue ? colorScheme.secondary : colorScheme.onSurface.withAlpha(160),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ]
      ),
    );
  }
}