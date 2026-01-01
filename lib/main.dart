import 'package:flutter/material.dart';
import 'package:beebetter/pages/MainPage/MainPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorAccent = Colors.orangeAccent;
    final baseScheme = ColorScheme.fromSeed(seedColor: Colors.orangeAccent);
    final baseInversePrimary = baseScheme.inversePrimary;
    final lightInversePrimary = lighten(baseInversePrimary, 0.08);
    final colorScheme = ColorScheme.fromSeed(seedColor: colorAccent).copyWith(
      inversePrimary: lightInversePrimary,
      error: Colors.redAccent,
    );

    return MaterialApp(
      title: 'BEEbetter',
      theme: ThemeData(
        colorScheme: colorScheme,
      ),
      home: MainPage(),
    );
  }
}


Color lighten(Color color, [double amount = 0.1]) {
  // Convert to HSL to adjust lightness
  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  return hslLight.toColor();
}