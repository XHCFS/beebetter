import 'package:flutter/material.dart';
import 'dart:ui';

class GooeyNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const GooeyNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  State<GooeyNavigationBar> createState() => _GooeyNavigationBarState();
}

class _GooeyNavigationBarState extends State<GooeyNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void didUpdateWidget(GooeyNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != _previousIndex) {
      _controller.forward(from: 0);
      _previousIndex = widget.selectedIndex;
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

    final icons = const [
      Icons.today_outlined,
      Icons.menu_book_outlined,
      Icons.person_outline,
    ];
    final selectedIcons = const [
      Icons.today,
      Icons.menu_book_rounded,
      Icons.person,
    ];
    final labels = const ['Dashboard', 'Today', 'Profile'];

    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 🧃 Animated gooey capsule
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return CustomPaint(
                painter: _GooeyIndicatorPainter(
                  progress: _animation.value,
                  fromIndex: _previousIndex,
                  toIndex: widget.selectedIndex,
                  itemCount: icons.length,
                  color: colorScheme.inversePrimary.withOpacity(0.25),
                ),
                child: const SizedBox.expand(),
              );
            },
          ),

          // 🔹 Icons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(icons.length, (i) {
              final isSelected = widget.selectedIndex == i;
              return GestureDetector(
                onTap: () => widget.onDestinationSelected(i),
                child: AnimatedScale(
                  scale: isSelected ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected ? selectedIcons[i] : icons[i],
                        size: 28,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.primary.withOpacity(0.7),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[i],
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.primary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// 🧪 Custom painter for the gooey indicator
class _GooeyIndicatorPainter extends CustomPainter {
  final double progress;
  final int fromIndex;
  final int toIndex;
  final int itemCount;
  final Color color;

  _GooeyIndicatorPainter({
    required this.progress,
    required this.fromIndex,
    required this.toIndex,
    required this.itemCount,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..isAntiAlias = true;

    final spacing = size.width / itemCount;
    final radius = 26.0;

    final fromX = spacing * (fromIndex + 0.5);
    final toX = spacing * (toIndex + 0.5);

    // The “stretch” effect between the two positions
    final currentX = lerpDouble(fromX, toX, progress)!;
    final stretch = (progress * (1 - progress)) * 60; // gives the gooey bulge

    final path = Path();
    path.addRRect(RRect.fromRectXY(
      Rect.fromCenter(
        center: Offset(currentX, size.height / 2),
        width: 60 + stretch,
        height: 40,
      ),
      30,
      30,
    ));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GooeyIndicatorPainter oldDelegate) =>
      progress != oldDelegate.progress ||
          fromIndex != oldDelegate.fromIndex ||
          toIndex != oldDelegate.toIndex;
}
