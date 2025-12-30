import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:beebetter/widgets/Cards/RecordingCard/recording_logic.dart';
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

  void _showStopRecordingDialog(BuildContext context, RecordingLogic logic, ColorScheme colorScheme, TextTheme textTheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Stop Recording?",
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.primary,
          ),
        ),
        content: Text(
          "Your recording will be saved.",
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary.withAlpha(200),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              logic.delete(); // Cancel and delete
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: colorScheme.error),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              logic.stopRecording();
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showDeleteRecordingDialog(BuildContext context, RecordingLogic logic, ColorScheme colorScheme, TextTheme textTheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Delete Recording?",
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.error,
          ),
        ),
        content: Text(
          "This will permanently delete your recording. This action cannot be undone.",
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary.withAlpha(200),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: colorScheme.primary.withAlpha(160)),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              logic.delete();
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
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
          const SizedBox(height: 16),
          // Time display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Recording ${formatDuration(logic.elapsed)}",
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Control buttons - cleaner layout
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ---------------------------------------------------
              // Pause/Resume Recording
              // ---------------------------------------------------
              Container(
                decoration: BoxDecoration(
                  color: logic.isPaused 
                      ? colorScheme.errorContainer 
                      : colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => logic.togglePause(),
                  icon: Icon(
                    logic.isPaused ? Symbols.play_arrow_rounded : Symbols.pause_rounded,
                    size: 28,
                  ),
                  color: logic.isPaused 
                      ? colorScheme.onErrorContainer 
                      : colorScheme.onPrimaryContainer,
                  padding: const EdgeInsets.all(16),
                  tooltip: logic.isPaused ? "Resume" : "Pause",
                ),
              ),
              const SizedBox(width: 24),
              // ---------------------------------------------------
              // Stop Recording
              // ---------------------------------------------------
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => _showStopRecordingDialog(context, logic, colorScheme, textTheme),
                  icon: Icon(
                    Symbols.stop_rounded,
                    size: 28,
                  ),
                  color: colorScheme.primary,
                  padding: const EdgeInsets.all(16),
                  tooltip: "Stop",
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );
    }

    // ---------------------------------------------------
    // End Session (Stopped)
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
          const SizedBox(height: 16),
          // Duration display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              formatDuration(logic.duration != Duration.zero ? logic.duration : logic.elapsed),
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Control buttons - cleaner layout
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ---------------------------------------------------
              // Play / Pause
              // ---------------------------------------------------
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => logic.togglePlayback(),
                  icon: Icon(
                    logic.isPlayback ? Symbols.pause_rounded : Symbols.play_arrow_rounded,
                    size: 28,
                  ),
                  color: colorScheme.onPrimaryContainer,
                  padding: const EdgeInsets.all(16),
                  tooltip: logic.isPlayback ? "Pause" : "Play",
                ),
              ),
              const SizedBox(width: 24),
              // ---------------------------------------------------
              // Delete
              // ---------------------------------------------------
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => _showDeleteRecordingDialog(context, logic, colorScheme, textTheme),
                  icon: Icon(
                    Symbols.delete_rounded,
                    size: 28,
                  ),
                  color: colorScheme.onErrorContainer,
                  padding: const EdgeInsets.all(16),
                  tooltip: "Delete",
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.surfaceContainerHigh,
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

