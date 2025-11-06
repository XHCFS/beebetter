import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
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
  Widget build(BuildContext context) {
    Color surfaceContainerDark = Color.alphaBlend(
      Theme.of(context).colorScheme.inversePrimary.withAlpha(20),
      Theme.of(context).colorScheme.surface,
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            // Theme.of(context).colorScheme.inversePrimary.withAlpha(20),
            // Theme.of(context).colorScheme.inversePrimary.withAlpha(10),

            surfaceContainerDark,
            Theme.of(context).colorScheme.surface,

            // Theme.of(context).colorScheme.onPrimary,
            // Theme.of(context).colorScheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: body,
    );
  }
}