import 'package:flutter/material.dart';

class EmotionsGrid extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;

  const EmotionsGrid({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      // physics: const NeverScrollableScrollPhysics(), // disables scrolling
        childAspectRatio: 2.5,
        children: List.generate(items.length, (index) {

          final item = items[index];
          final isSelected = selectedItem == item;

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.surfaceBright,
            shadowColor: colorScheme.inversePrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isSelected ? BorderSide(
                color: colorScheme.inversePrimary,
                width: 2.2,
              ) : BorderSide(
                color: Colors.transparent,
                width: 0,
              ),
            ),
          ),
          onPressed: () {
            onChanged(isSelected ? null : item);
          },
          child: Text(
            item,
            textAlign: TextAlign.center,
            style: TextStyle(color: colorScheme.primary),
          ),
        );
      }).toList(),
    );
  }
}
