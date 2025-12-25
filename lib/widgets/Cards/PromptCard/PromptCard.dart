import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/widgets/Cards/PromptCard/PromptInput.dart';
import 'package:beebetter/widgets/Cards/EmotionWheel/EmotionWheel.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeLogic.dart';

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
  bool showEmotions = false;

  // Swipe down tracking for deleting prompt
  double dragOffset = 0.0;
  bool showDeleteHint = false;

  void resetDrag() {
    setState(() {
      dragOffset = 0.0;
      showDeleteHint = false;
    });
  }

  @override
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialText);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final logic = context.read<GuidedModeLogic>();
      logic.updateCanSelectNextForLevel(0);
    });
  }

  @override
  void didUpdateWidget(covariant PromptCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialText != widget.initialText) {
      controller.text = widget.initialText;
    }
  }

  Widget buildInput() {
    return PromptInput(
      key: const ValueKey('input'),
      category: widget.category,
      prompt: widget.prompt,
      canContinue: widget.canContinue,
      isDone: widget.isDone,
      controller: controller,
      onTextChanged: widget.onTextChanged,
      onContinuePressed: widget.onContinuePressed,
      parentContext: context,
      onFlip: () => setState(() => showEmotions = true),
    );
  }

  Widget buildEmotionWheel(GuidedModeLogic logic) {
    return EmotionWheel(
      key: const ValueKey('emotion'),
      emotionItems: logic.emotionItems,
      levels: logic.emotionLevels,
      selectedEmotions: logic.currentPromptInfo.emotions,
      canSelectNext: logic.canSelectNext,
      onBack: () => setState(() => showEmotions = false),
      onEmotionSelected: (level, emotion) {
        logic.currentPromptInfo.emotions[level] = emotion;
        logic.selectEmotion(level, emotion);
      },
      onNext: (level) async {
        if (level == logic.emotionLevels - 1) {
          setState(() => showEmotions = false);
          logic.submitEmotion(level);
          widget.cardSwiperController.swipe(CardSwiperDirection.left);
          await Future.delayed(const Duration(milliseconds: 300));
          logic.submit(widget.index, widget.cardSwiperController);
        } else {
          logic.updateCanSelectNextForLevel(level + 1);
        }
      },
      onLevelChanged: logic.updateCanSelectNextForLevel,
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final logic = context.watch<GuidedModeLogic>();

    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      color: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1.0,
                child: child,
              ),
            );
          },
          child: showEmotions
              ? buildEmotionWheel(logic)
              : buildInput(),
        ),
    );
  }
}
