import 'package:flutter/material.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeLogic.dart';
import 'package:provider/provider.dart';

class EmotionsGrid extends StatefulWidget {
  final List<String> items;
  final void Function(String) onPressed;
  final int emotionLevel;

  const EmotionsGrid({
    super.key,
    required this.items,
    required this.emotionLevel,
    required this.onPressed,
  });

  @override
  State<EmotionsGrid> createState() => EmotionsGridState();
}

class EmotionsGridState extends State<EmotionsGrid> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final logic = context.watch<GuidedModeLogic>();

    return GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      // physics: const NeverScrollableScrollPhysics(), // disables scrolling
        childAspectRatio: 2.5,
        children: List.generate( widget.items.length, (index) {

          selectedItem = logic.Emotions[logic.currentPrompt][widget.emotionLevel];

          final item = widget.items[index];
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
          // onPressed: () => onPressed(item),
          onPressed: () {
            setState(() {
              if (selectedItem == item) {
                selectedItem = null;
                logic.selectEmotion(widget.emotionLevel, "");
              } else {
                selectedItem = item;
                logic.selectEmotion(widget.emotionLevel, item);
              }
            });
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
