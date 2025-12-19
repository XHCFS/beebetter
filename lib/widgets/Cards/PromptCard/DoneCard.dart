import 'package:flutter/material.dart';

class DoneCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Center(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image
            Image.asset(
              "assets/images/done.png",
              width: 200,
              height: 200,
            ),

            const SizedBox(height: 16),

            // Text
            Text(
              "All done for today!",
              style: TextStyle(
                fontSize: 20,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
