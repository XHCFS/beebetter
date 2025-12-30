import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';

class HexagonPatternPainter extends CustomPainter {
  final double intensity;
  final Color color;
  final int maxHexes;

  HexagonPatternPainter({
    required this.intensity,
    required this.color,
    required this.maxHexes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rand = Random(42);
    final centerX = size.width / 2;

    // avoid overlaps
    final placedHexes = <Offset>[];

    int attempts = 0;
    int hexCount = 0;

    while (hexCount < maxHexes && attempts < maxHexes * 10) {
      attempts++;

      // Random Y position (smaller at top, larger at bottom)
      final y = rand.nextDouble() * size.height;
      final t = y / size.height;
      final radius = lerpDouble(5, 16, t)!;

      // Random X position with side bias
      double x;
      do {
        x = rand.nextDouble() * size.width;
      } while (((x - centerX).abs() / centerX) < rand.nextDouble());

      final candidate = Offset(x, y);

      // Check overlap with existing hexes
      bool overlaps = false;
      for (var hex in placedHexes) {
        if ((hex - candidate).distance < radius * 2.2) {
          overlaps = true;
          break;
        }
      }
      if (overlaps) continue;

      // Draw hexagon
      final opacity = t;
      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = color.withAlpha((0.12 * opacity * 255).toInt());

      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = color.withAlpha((0.4 * opacity * 255).toInt());

      _drawHexagon(canvas, candidate, radius, fillPaint);
      _drawHexagon(canvas, candidate, radius, strokePaint);

      placedHexes.add(candidate);
      hexCount++;
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double r, Paint paint, {double cornerRadius = 1.5}) {
    final path = Path();
    final angleStep = pi / 3;

    for (int i = 0; i < 6; i++) {
      final angle = angleStep * i;
      final nextAngle = angleStep * ((i + 1) % 6);

      final p1 = Offset(center.dx + r * cos(angle), center.dy + r * sin(angle));
      final p2 = Offset(center.dx + r * cos(nextAngle), center.dy + r * sin(nextAngle));

      final dx = p2.dx - p1.dx;
      final dy = p2.dy - p1.dy;
      final dist = sqrt(dx * dx + dy * dy);

      final radius = min(cornerRadius, dist / 2);

      final ux = dx / dist;
      final uy = dy / dist;

      final start = Offset(p1.dx + ux * radius, p1.dy + uy * radius);
      final end = Offset(p2.dx - ux * radius, p2.dy - uy * radius);

      if (i == 0) {
        path.moveTo(start.dx, start.dy);
      } else {
        path.lineTo(start.dx, start.dy);
      }

      path.quadraticBezierTo(p2.dx, p2.dy, end.dx, end.dy);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant HexagonPatternPainter oldDelegate) {
    return oldDelegate.intensity != intensity;
  }
}
