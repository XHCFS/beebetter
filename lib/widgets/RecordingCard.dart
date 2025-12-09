import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:beebetter/pages/GuidedMode/RecordingLogic.dart';
import 'package:beebetter/widgets/RecordingIndicator.dart';
import 'package:flutter/scheduler.dart';

class RecordingCard extends StatefulWidget {
  const RecordingCard({super.key});

  @override
  State<RecordingCard> createState() => RecordingCardState();
}

class RecordingCardState extends State<RecordingCard> with SingleTickerProviderStateMixin {
  late Ticker ticker;

  @override
  void initState() {
    super.initState();
    ticker = createTicker((_) {
      setState(() {});
    })..start();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  String formatDuration(Duration d) {
    return "${d.inMinutes.toString().padLeft(2,'0')}:${(d.inSeconds % 60).toString().padLeft(2,'0')}";
  }

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<RecordingLogic>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: colorScheme.surfaceBright,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: logic.toggleRecording,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      RecordingIndicator(
                        isRecording: logic.isRecording,
                        amplitudes: logic.amplitudes.toList(),
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),

                      // logic.isRecording ?
                      // SizedBox.shrink() :

                      Icon(
                        Symbols.mic,
                        size: 36,
                        color: colorScheme.primary.withAlpha(200),
                      ),
                    ],
                  ),

                ),
                const SizedBox(height: 8),
                Consumer<RecordingLogic>(
                builder: (_, logic, __) {
                return
                  Text(
                    logic.isRecording
                        ? "Recording... ${formatDuration(logic.elapsed)}"
                        : "Click to start",
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary.withAlpha(160),
                    ),
                  ); }
                ),
                const SizedBox(height: 8),
                if (logic.isRecording)
                  Wrap(
                    spacing: 16,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      IconButton(
                        onPressed: logic.stop,
                        icon: Icon(Symbols.stop),
                        color: colorScheme.error,
                        iconSize: 30,
                      ),
                      IconButton(
                        onPressed: logic.togglePause,
                        icon: Icon(logic.isPaused ? Symbols.play_arrow : Symbols.pause),
                        color: colorScheme.primary,
                        iconSize: 30,
                      ),
                      IconButton(
                        onPressed: logic.delete,
                        icon: Icon(Symbols.delete),
                        color: colorScheme.secondary,
                        iconSize: 30,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
  }
}
