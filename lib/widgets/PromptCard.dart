import 'package:flutter/material.dart';
import 'package:beebetter/widgets/PromptInput.dart';
import 'package:beebetter/widgets/EmotionWheel/EmotionWheel.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class PromptCard extends StatefulWidget {
  final int index;
  final String category;
  final String prompt;
  final bool canContinue;
  final bool isDone;
  final void Function(String) onContinuePressed;
  final void Function(String) onTextChanged;
  final String initialText;
  final CardSwiperController cardSwiperController;

  const PromptCard({
    super.key,
    required this.index,
    required this.category,
    required this.prompt,
    required this.canContinue,
    required this.isDone,
    required this.onContinuePressed,
    required this.onTextChanged,
    required this.initialText,
    required this.cardSwiperController,
  });

  @override
  State<PromptCard> createState() => PromptCardState();
}

class PromptCardState extends State<PromptCard>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController controller;
  final cardController = FlipCardController();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialText);
  }

  @override
  void didUpdateWidget(covariant PromptCard oldWidget) {
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
          child: PromptInput(
            category: widget.category,
            prompt: widget.prompt,
            canContinue: widget.canContinue,
            isDone: widget.isDone,
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
          onFlip: () => cardController.flipcard(),
          cardSwiperController : widget.cardSwiperController,
        ),
      ),
    );
  }
}
