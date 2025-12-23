import 'package:flutter/material.dart';
import 'package:beebetter/widgets/HexagonPattern.dart';

class ExpandingTextOverlay extends StatefulWidget {
  final Offset startOffset;
  final Size startSize;
  final String prompt;
  final String initialText;
  final void Function(String) onClose;

  const ExpandingTextOverlay({
    required this.startOffset,
    required this.startSize,
    required this.prompt,
    required this.initialText,
    required this.onClose,
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
      headerHeight = calculateHeaderHeight(context, widget.prompt);

      // header appears near the end of expansion
      await Future.delayed(const Duration(milliseconds: 240));
      if (mounted && !closing) {
        setState(() => showHeader = true);
      }
    });
  }

  void close() async {
    setState(() {
      closing = true;
      expanded = false;
      showHeader = false;
    });

    // wait for the reverse animation to finish
    await Future.delayed(const Duration(milliseconds: 300));

    widget.onClose(controller.text);
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
          child: AnimatedPhysicalModel(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            shape: BoxShape.rectangle,
            elevation: expanded && !closing ? 12 : 0,
            color: Colors.transparent,
            shadowColor: Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
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
                              offset: Offset(0, (1 - height / headerHeight) * 20),
                              child: child,
                            ),
                          ),
                        ),
                      );
                    },

                    child: Container(
                      height: headerHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceBright,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).primaryColor.withAlpha(150),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: close,
                          ),
                          Expanded(
                            child: Text(
                              widget.prompt,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      children: [
                        // -----------------------------------
                        // Hexagon pattern at the bottom
                        // -----------------------------------
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 200,
                          child: AnimatedOpacity(
                            opacity: expanded && !closing ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            child: CustomPaint(
                              painter: HexagonPatternPainter(
                                intensity: 1.0,
                                color: colorScheme.inversePrimary.withAlpha(50),
                                maxHexes: 30,
                              ),
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
                            padding: EdgeInsets.fromLTRB(0, 0, 0, keyboardInset,),
                            child: TextField(
                              controller: controller,
                              maxLines: null,
                              expands: true,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                isCollapsed: true,
                                hintText: "Share your thoughts...",
                                border: InputBorder.none,
                                hintStyle: textTheme.bodyMedium?.copyWith( color: colorScheme.primary.withAlpha(128), ),
                              ),
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
      maxLines: null,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: maxWidth);

    return textPainter.height + 24; // 24 = vertical padding
  }

}
