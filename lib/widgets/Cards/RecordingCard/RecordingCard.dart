import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:beebetter/widgets/Cards/RecordingCard/RecordingLogic.dart';
import 'package:beebetter/widgets/Cards/RecordingCard/RecordingIndicator.dart';
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

    Widget content;

    // ---------------------------------------------------
    // Start Screen
    // ---------------------------------------------------
    if (logic.state == RecordingState.beforeRecording) {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: logic.startRecording,
            child: Icon(
              Symbols.mic,
              size: 36,
              color: colorScheme.primary.withAlpha(200),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Click to start",
            style: textTheme.titleMedium?.copyWith(color: colorScheme.primary.withAlpha(160)),
          ),
        ],
      );
    }

    // ---------------------------------------------------
    // Recording
    // ---------------------------------------------------
    else if (logic.state == RecordingState.recording) {
      content = Column(
        children: [
          // waveform expanded
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: RecordingIndicator(
                isRecording: logic.isRecording,
                amplitudes: logic.amplitudes.toList(),
                color: colorScheme.inversePrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Recording... ${formatDuration(logic.elapsed)}",
            style: textTheme.titleMedium?.copyWith(color: colorScheme.primary.withAlpha(160)),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              // ---------------------------------------------------
              // Play / Pause (only works when paused)
              // ---------------------------------------------------
              SizedBox(
                height: 56,
                width: 56,
                child: IconButton(
                  onPressed: logic.isPaused ? () => logic.togglePlayback() : null,
                  icon: Icon(logic.isPlayback ? Symbols.pause_rounded : Symbols.play_arrow_rounded),
                  color: logic.isPaused ? colorScheme.primary : colorScheme.onSurface.withAlpha(128),
                  iconSize: 36,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.expand(),
                ),
              ),

              // ---------------------------------------------------
              // Record / Pause
              // ---------------------------------------------------
              SizedBox(
                height: 56,
                width: 56,
                child: IconButton(
                  onPressed: !logic.isPlayback ? () => logic.togglePause() : null,
                  icon: Icon(
                    logic.isPaused ? Icons.fiber_manual_record : Symbols.pause_circle_rounded,
                  ),
                  color: logic.isPaused
                      ? colorScheme.error
                      : logic.isPlayback
                      ? colorScheme.error.withAlpha(128)
                      : colorScheme.primary,
                  iconSize: 44,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.expand(),
                ),
              ),
              // ---------------------------------------------------
              // Stop
              // ---------------------------------------------------
              SizedBox(
                height: 56,
                width: 56,
                child: IconButton(
                  onPressed: logic.stopRecording,
                  icon: Icon(Symbols.stop_rounded),
                  color: colorScheme.primary,
                  iconSize: 36,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.expand(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      );
    }

    // ---------------------------------------------------
    // End Session
    // ---------------------------------------------------
    else {
      content = Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: RecordingIndicator(
                isRecording: false,
                amplitudes: logic.amplitudes.toList(),
                color: colorScheme.inversePrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              // ---------------------------------------------------
              // Play / Pause
              // ---------------------------------------------------
              SizedBox(
                height: 56,
                width: 56,
                child: IconButton(
                  onPressed: logic.togglePlayback,
                  icon: Icon(logic.isPlayback ? Symbols.pause_rounded : Symbols.play_arrow_rounded),
                  color: colorScheme.primary,
                  iconSize: 36,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.expand(),
                ),
              ),

              // ---------------------------------------------------
              // Delete
              // ---------------------------------------------------
              SizedBox(
                height: 56,
                width: 56,
                child: IconButton(
                  onPressed: logic.delete,
                  icon: Icon(Symbols.delete_rounded),
                  color: colorScheme.error,
                  iconSize: 36,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.expand(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      );
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.surfaceBright,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: SizedBox(
          height: 250,
          child: content,
        ),
      ),
    );
  }
}

