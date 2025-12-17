import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/widgets/EntryInput.dart';
import 'package:beebetter/widgets/EmotionWheel/EmotionWheel.dart';
import 'package:beebetter/pages/NewEntryPage/NewEntryPageLogic.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

class EntryCard extends StatefulWidget {
  final int index;
  final String category;
  final bool canContinue;
  final void Function(String) onContinuePressed;
  final void Function(String) onTextChanged;
  final String initialText;

  const EntryCard({
    super.key,
    required this.index,
    required this.category,
    required this.canContinue,
    required this.onContinuePressed,
    required this.onTextChanged,
    required this.initialText,
  });

  @override
  State<EntryCard> createState() => EntryCardState();
}

class EntryCardState extends State<EntryCard>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController controller;
  final cardController = FlipCardController();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialText);
  }

  @override
  void didUpdateWidget(covariant EntryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialText != widget.initialText) {
      controller.text = widget.initialText;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final logic = context.watch<NewEntryPageLogic>();
    final colorScheme = Theme.of(context).colorScheme;

    return FlipCard(
      controller: cardController,
      rotateSide: RotateSide.right,
      axis: FlipAxis.vertical,
      frontWidget: Card(
        margin: EdgeInsets.zero,
        color: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: EntryInput(
            canContinue: widget.canContinue,
            controller: controller,
            onTextChanged: widget.onTextChanged,
            onContinuePressed: widget.onContinuePressed,
            parentContext: context,
            onFlip: () => cardController.flipcard(), // flip to back
          ),
        ),
      ),
      backWidget: Card(
        margin: EdgeInsets.zero,
        color: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: EmotionWheel(
          emotionItems: logic.emotionItems,
          levels: logic.emotionLevels,
          selectedEmotions: logic.emotions,
          canSelectNext: logic.canSelectNext,
          onBack: () => cardController.flipcard(),
          onEmotionSelected: (level, emotion) {
            logic.emotions[level] = emotion;
            logic.updateCanSelectNextForLevel(level);
          },
          onNext: (level) {
            if (level == logic.emotionLevels - 1) {
              logic.saveEntry();
              cardController.flipcard();
            };
          },
          onLevelChanged: logic.updateCanSelectNextForLevel,
        ),
      ),
    );
  }
}
