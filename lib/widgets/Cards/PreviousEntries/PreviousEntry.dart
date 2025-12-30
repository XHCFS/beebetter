import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:beebetter/widgets/Cards/ExpandingTextOverlay.dart';
import 'package:beebetter/widgets/Cards/PreviousEntries/VoiceEntryPlayer.dart';
import 'package:beebetter/widgets/Cards/RecordingCard/RecordingLogic.dart';

class PreviousEntry extends StatefulWidget {
  final String prompt;
  final String category;
  final bool isText;
  final String? userInput;
  final bool isExpanded;
  final VoidCallback onTap;
  final List<String>? emotions;
  final VoidCallback? onDelete;

  const PreviousEntry({
    required this.prompt,
    required this.category,
    required this.isText,
    this.userInput,
    required this.isExpanded,
    required this.onTap,
    this.emotions,
    this.onDelete,
    super.key,
  });

  @override
  State<PreviousEntry> createState() => _PreviousEntryState();
}

class _PreviousEntryState extends State<PreviousEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.isExpanded) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant PreviousEntry oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    OverlayEntry? overlayEntry;

    return Card(
      color: widget.isExpanded ? colorScheme.surface : colorScheme.onPrimary,
      shadowColor: colorScheme.inversePrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------
          // Header
          // ---------------------------------------------------
          InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ---------------------------------------------------
                  // Icon
                  // ---------------------------------------------------
                  Icon(
                    widget.isText ? Symbols.mic_none_rounded : Symbols.text_fields_rounded,
                    size: 32,
                    color: colorScheme.primary.withAlpha(240),
                  ),
                  const SizedBox(width: 12),
                  // ---------------------------------------------------
                  // Title
                  // ---------------------------------------------------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.prompt,
                          softWrap: true,
                          maxLines: null,
                          style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.category.toUpperCase(),
                          style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary.withAlpha(160)),
                        ),
                      ],
                    ),
                  ),

                  // ---------------------------------------------------
                  // Delete Icon
                  // ---------------------------------------------------
                  if (widget.onDelete != null)
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: colorScheme.error.withAlpha(200),
                      ),
                      splashRadius: 20,
                      tooltip: "Delete entry",
                      onPressed: widget.onDelete,
                    ),

                  // ---------------------------------------------------
                  // Arrow Icon
                  // ---------------------------------------------------
                  AnimatedRotation(
                    turns: widget.isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      color: colorScheme.primary.withAlpha(160),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------------------------------------------------
          // Content
          // ---------------------------------------------------
          SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: _animation,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 0,
                  bottom: 12,
                  right: 16,
                  left: 16,
                 ),
                decoration: BoxDecoration(
                  // color: colorScheme.surface,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------------------------------------------
                    // Emotions
                    // ---------------------------------------------------
                    if (widget.emotions != null && widget.emotions!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4,bottom: 12),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: widget.emotions!.map((e) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: colorScheme.inversePrimary.withAlpha(100),
                                borderRadius: BorderRadius.circular(12),
                                // border: Border.all(
                                //     color: colorScheme.inversePrimary, width: 1),
                              ),
                              child: Text(
                                e,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.primary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                    // ---------------------------------------------------
                    // Entry Text
                    // ---------------------------------------------------
                    if(!widget.isText)
                      if (widget.userInput != null && widget.userInput!.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            final renderBox = context.findRenderObject() as RenderBox;
                            final offset = renderBox.localToGlobal(Offset.zero);
                            final size = renderBox.size;

                            overlayEntry = OverlayEntry(
                              builder: (context) => ExpandingTextOverlay(
                                startOffset: offset,
                                startSize: size,
                                title: widget.prompt,
                                initialText: widget.userInput!,
                                isGuided: false,
                                isReadOnly: true,
                                onClose: (text) {
                                  // Remove overlay when closed
                                  overlayEntry?.remove();
                                  overlayEntry = null;
                                },
                              ),
                            );

                            Overlay.of(context)?.insert(overlayEntry!);
                          },
                          child: Text(
                            widget.userInput!,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
                          ),
                        ),

                    if(widget.isText)
                      if (widget.userInput != null && widget.userInput!.isNotEmpty)
                        VoiceEntryPlayer(
                          logic: RecordingLogic.fromFile(widget.userInput!),
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
