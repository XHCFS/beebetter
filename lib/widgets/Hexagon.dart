import 'dart:math';
import 'package:flutter/material.dart';

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = w * sqrt(3) / 2; // regular hexagon height
    final path = Path();

    path.moveTo(0.25 * w, 0);
    path.lineTo(0.75 * w, 0);
    path.lineTo(w, h / 2);
    path.lineTo(0.75 * w, h);
    path.lineTo(0.25 * w, h);
    path.lineTo(0, h / 2);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
