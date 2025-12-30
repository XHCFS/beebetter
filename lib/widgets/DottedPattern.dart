import 'package:flutter/material.dart';

class DottedPatternPainter extends CustomPainter {
  final Color color;
  final double spacing; // space between dots
  final double radius;  // dot radius

  DottedPatternPainter({
    required this.color,
    this.spacing = 20.0,
    this.radius = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
