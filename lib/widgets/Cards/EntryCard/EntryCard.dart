import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/widgets/Cards/EntryCard/EntryInput.dart';
import 'package:beebetter/widgets/Cards/EmotionWheel/EmotionWheel.dart';
import 'package:beebetter/pages/TodayPage/NewEntryPageLogic.dart';

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
  bool showEmotions = false;

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

  Widget buildInput() {
    return EntryInput(
      key: const ValueKey('input'),
      canContinue: widget.canContinue,
      controller: controller,
      onTextChanged: widget.onTextChanged,
      onContinuePressed: widget.onContinuePressed,
      parentContext: context,
      onFlip: () => setState(() => showEmotions = true),
    );
  }


  Widget buildEmotionWheel(NewEntryPageLogic logic) {
    return EmotionWheel(
      key: const ValueKey('emotion'),
      emotionItems: logic.emotionItems,
      levels: logic.emotionLevels,
      selectedEmotions: logic.emotions,
      canSelectNext: logic.canSelectNext,
      onBack: () => setState(() => showEmotions = false),
      onEmotionSelected: (level, emotion) {
        logic.emotions[level] = emotion;
        logic.updateCanSelectNextForLevel(level);
      },
      onNext: (level) {
        if (level == logic.emotionLevels - 1) {
          logic.saveEntry();
          setState(() => showEmotions = false);
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
    final logic = context.watch<NewEntryPageLogic>();
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
