import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:beebetter/widgets/DottedPattern.dart';
import 'package:beebetter/widgets/Cards/MarkdownToolbar.dart';
import 'package:beebetter/widgets/Cards/MarkdownFormatter.dart';

class ExpandingTextOverlay extends StatefulWidget {
  final Offset startOffset;
  final Size startSize;
  final String title;
  final String initialText;
  final void Function(String) onClose;
  final bool isGuided;
  final bool isReadOnly;

  const ExpandingTextOverlay({
    required this.startOffset,
    required this.startSize,
    required this.title,
    required this.initialText,
    required this.onClose,
    required this.isGuided,
    required this.isReadOnly,
  });

  @override
  State<ExpandingTextOverlay> createState() => ExpandingTextOverlayState();
}

class ExpandingTextOverlayState extends State<ExpandingTextOverlay> {
  late TextEditingController controller;
  late ScrollController scrollController;
  bool expanded = false;
  bool closing = false;
  bool showHeader = false;
  double headerHeight = 0;
  bool showToolbar = false;
  bool showPrompt = false;
  double dragOffset = 0;
  double dragDistance = 0;
  double scaleFactor = 1.0;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialText);
    scrollController = ScrollController();

    controller.addListener(() {
      if (!scrollController.hasClients) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!scrollController.hasClients) return;

        scrollController.jumpTo(
          scrollController.position.maxScrollExtent,
        );
      });
    });


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() => expanded = true);
      headerHeight = calculateHeaderHeight(context, widget.isGuided ? "Guided Mode" : widget.title);

      // header appears near the end of expansion
      await Future.delayed(const Duration(milliseconds: 240));
      if (mounted && !closing) {
        setState(() => showHeader = true);
      }

      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted && !closing) {
        setState(() => showToolbar = true);
        setState(() => showPrompt = true);
      }
    });
  }

  void close() async {
    setState(() {
      closing = true;
      expanded = false;
      showHeader = false;
      showToolbar = false;
      showPrompt = false;
    });

    // wait for the reverse animation to finish
    await Future.delayed(const Duration(milliseconds: 300));
    widget.onClose(controller.text);
  }

  void toggleToolbar() {
    if (closing) return;
    setState(() {
      showToolbar = !showToolbar;
    });
  }


  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    return Stack(
      children: [
        // light background
        AnimatedOpacity(
          opacity: expanded && !closing ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: GestureDetector(
            onTap: close,
            child: Container(
              color: Colors.black.withAlpha(20),
            ),
          ),
        ),

        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          top: expanded ? 48 : widget.startOffset.dy,
          left: expanded ? 24 : widget.startOffset.dx,
          width: expanded ? screen.width - 48 : widget.startSize.width,
          height: expanded ? screen.height - 72 : widget.startSize.height,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (closing) return;

              setState(() {
                dragDistance += details.delta.dy;

                // Calculate a subtle shrink effect (max 5% shrink)
                scaleFactor = (1 - (dragDistance / 600)).clamp(0.95, 1.0);
              });
            },
            onVerticalDragEnd: (details) {
              if (dragDistance > 100 || (details.primaryVelocity ?? 0) > 300) {
                close(); // plays your shrinking + fading animation
              } else {
                // Animate back to normal size
                setState(() {
                  dragDistance = 0;
                  scaleFactor = 1.0;
                });
              }
            },
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.diagonal3Values(1.0, scaleFactor, 1.0),
              child: AnimatedPhysicalModel(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                shape: BoxShape.rectangle,
                elevation: expanded && !closing ? 12 : 0,
                color: Theme.of(context).colorScheme.surface,
                shadowColor: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.none,
                child: Material(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.none,
                  child: Column(

                    children: [
                      // -----------------------------------
                      // Header
                      // -----------------------------------
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0,
                          end: showHeader ? headerHeight : 0,
                        ),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        builder: (context, height, child) {
                          return ClipRect(
                            child: SizedBox(
                              height: height,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Transform.translate(
                                  offset: Offset(0, -(1 - height / headerHeight) * 20),
                                  child: Container(
                                    height: headerHeight,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    ),
                                    child: Transform.translate(
                                      offset: Offset(0, -(1 - height / headerHeight) * 20), // slide down
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // -----------------------------------
                                          // Back Icon
                                          // -----------------------------------
                                          IconButton(
                                            icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
                                            padding: EdgeInsets.zero,
                                            onPressed: close,
                                          ),
                                          // -----------------------------------
                                          // Text
                                          // -----------------------------------
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                widget.isGuided ? "Guided Mode" : widget.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  color: Theme.of(context).colorScheme.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // -----------------------------------
                                          // Markdown Icon
                                          // -----------------------------------
                                          if(!widget.isReadOnly)
                                            IconButton(
                                              tooltip: 'Markdown',
                                              icon: Icon(
                                                showToolbar ? Symbols.code_off_rounded : Symbols.code_rounded,
                                                color: colorScheme.primary,
                                                weight: 600,
                                              ),
                                              padding: EdgeInsets.zero,
                                              onPressed: toggleToolbar,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                    Expanded(
                      child: Stack(
                          children: [
                            // -----------------------------------
                            // Pattern
                            // -----------------------------------
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: AnimatedOpacity(
                                  opacity: expanded && !closing ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                  child: CustomPaint(
                                    painter: DottedPatternPainter(
                                      color: colorScheme.inversePrimary.withAlpha(100),
                                      spacing: 20,
                                      radius: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // -----------------------------------
                            // Markdown and Text Field
                            // -----------------------------------
                            Column(
                              children: [
                                // -----------------------------------
                                // Markdown
                                // -----------------------------------
                                if(!widget.isReadOnly)
                                  TweenAnimationBuilder<double>(
                                    tween: Tween<double>(
                                      begin: 0,
                                      end: showToolbar ? 1 : 0,
                                    ),
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, value, child) {
                                      return ClipRect(
                                        child: Align(
                                          heightFactor: value,
                                          child: Transform.translate(
                                            offset: Offset(0, -12 * (1 - value)),
                                            child: Opacity(
                                              opacity: value,
                                              child: child,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: MarkdownToolbar(controller: controller),
                                  ),

                                // -----------------------------------
                                // Prompt
                                // -----------------------------------
                                if(widget.isGuided)
                                  TweenAnimationBuilder<double>(
                                    tween: Tween<double>(
                                      begin: 0,
                                      end: showPrompt ? 1 : 0,
                                    ),
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, value, child) {
                                      return ClipRect(
                                        child: Align(
                                          heightFactor: value,
                                          child: Transform.translate(
                                            offset: Offset(0, -12 * (1 - value)),
                                            child: Opacity(
                                              opacity: value,
                                              child: child,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Text(
                                          widget.title,
                                          style: textTheme.titleMedium?.copyWith(
                                            color: colorScheme.primary,)
                                      ),
                                    ),

                                  ),

                                // -----------------------------------
                                // Text Field
                                // -----------------------------------
                                Expanded(
                                  child: AnimatedPadding(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                    padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardInset,),
                                    child: widget.isReadOnly ?
                                    SingleChildScrollView(
                                        child: Container(
                                          width: double.infinity,
                                          child: MarkdownBody(
                                            data: controller.text.trimLeft(),
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
                                    ):

                                    TextField(
                                      controller: controller,
                                      maxLines: null,
                                      expands: true,
                                      inputFormatters: [MarkdownFormatter()],
                                      textAlignVertical: TextAlignVertical.top,
                                      decoration: InputDecoration(
                                        isCollapsed: true,
                                        hintText: "Share your thoughts...",
                                        border: InputBorder.none,
                                        hintStyle: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.primary.withAlpha(128),
                                        ),
                                      ),
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                 keyboardInset > 0 ?
                                 SizedBox(height: 4) : SizedBox(height: 52),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double calculateHeaderHeight(BuildContext context, String text) {
    final textStyle = Theme.of(context).textTheme.titleMedium!;
    final maxWidth = MediaQuery.of(context).size.width - 48 - 16 * 2 - 48;

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: maxWidth);

    return textPainter.height + 24; // 24 = vertical padding
  }

}
