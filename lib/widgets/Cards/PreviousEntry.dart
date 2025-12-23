import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class PreviousEntry extends StatelessWidget {
  final String prompt;
  final String category;
  final bool isText;

  const PreviousEntry({
    required this.prompt,
    required this.category,
    required this.isText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.inversePrimary.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isText
                ? Symbols.mic_none_rounded
                : Symbols.text_fields_rounded,
            size: 32,
            color: colorScheme.primary.withAlpha(240),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prompt,
                  softWrap: true,
                  maxLines: null, // allow wrapping
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  category.toUpperCase(),
                  style: textTheme.labelSmall
                      ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
