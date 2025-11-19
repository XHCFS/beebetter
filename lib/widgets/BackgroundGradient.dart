import 'package:flutter/material.dart';
import 'dart:math';

// NOTE:
// To add gradient and pattern to background in any page in the app:
// import import 'package:beebetter/widgets/BackgroundGradient.dart';
// add BackgroundGradient() to a Scaffold then add the rest of the page widget as the body

class BackgroundGradient extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;

  const BackgroundGradient({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
  });

  @override
  State<BackgroundGradient> createState() => _BackgroundGradientState();
}

class _BackgroundGradientState extends State<BackgroundGradient> {
  late final HoneycombPainter honeycombPainter;
  bool initialized = false;
  late final Size canvasSize;

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      canvasSize = MediaQuery.of(context).size;
      honeycombPainter = HoneycombPainter(
        size: canvasSize,
        color: Theme.of(context).colorScheme.inversePrimary.withAlpha(40),
        // to control pattern parameters
        hexagonRadius: 25,      // size of the hexagon
        fillProbability: 0.2,
        removeProbability: 0.7,
      );
      initialized = true;
    }

    Color surfaceContainerDark = Color.alphaBlend(
      Theme.of(context).colorScheme.inversePrimary.withAlpha(20),
      Theme.of(context).colorScheme.surface,
    );

    return Stack(
      children: [
        // Gradient background
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [surfaceContainerDark, Theme.of(context).colorScheme.surface],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // hexagon pattern
        SizedBox(
          width: canvasSize.width,
          height: canvasSize.height,
          child: CustomPaint(
            painter: honeycombPainter,
          ),
        ),

        widget.body,
      ],
    );
  }
}


// -------------------- CustomPainter for Hexagons --------------------
class HoneycombPainter extends CustomPainter {
  final Color color;
  final double hexagonRadius;
  final double fillProbability;   // chance a hexagon is filled
  final double removeProbability; // chance a hexagon is missing
  final Random random = Random();

  // Precomputed hexagons
  final List<_HexagonInfo> hexagons;

  HoneycombPainter({
    required Size size,
    required this.color,
    this.hexagonRadius = 30,
    this.fillProbability = 0.1,
    this.removeProbability = 0.1,
  }) : hexagons = [] {
    // Compute pattern only once
    final double radius = hexagonRadius;
    final double hexWidth = 2 * radius;
    final double hexHeight = sqrt(3) * radius;

    final double horizStep = hexWidth;
    final double vertStep = hexHeight;

    int rows = (size.height / vertStep).ceil() + 1;
    int cols = (size.width / horizStep).ceil() + 1;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        double dx = col * horizStep;
        if (row.isOdd) dx += horizStep / 2;
        double dy = row * vertStep;

        bool isRemoved = random.nextDouble() < removeProbability;
        bool isFilled = !isRemoved && (random.nextDouble() < fillProbability);

        hexagons.add(_HexagonInfo(center: Offset(dx, dy), filled: isFilled, removed: isRemoved));
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final fillPaint = Paint()
      ..color = color.withAlpha(40)
      ..style = PaintingStyle.fill;

    for (var hex in hexagons) {
      if (hex.removed) continue;
      final path = _hexagonPath(hex.center, hexagonRadius);
      if (hex.filled) canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, paint);
    }
  }

  Path _hexagonPath(Offset center, double radius) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      double angle = pi / 3 * i - pi / 6; // flat-top orientation
      double x = center.dx + radius * cos(angle);
      double y = center.dy + radius * sin(angle);
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HexagonInfo {
  final Offset center;
  final bool filled;
  final bool removed;
  _HexagonInfo({required this.center, this.filled = false, this.removed = false});
}
