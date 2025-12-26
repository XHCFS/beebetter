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

  void showStopSheet(BuildContext context, RecordingLogic logic) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: colorScheme.surfaceContainerHighest.withAlpha(120),
      builder: (_) {
        return FractionallySizedBox(
          widthFactor: 0.95,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Text(
                  "Stop recording?",
                  style: Theme.of(context).textTheme.titleMedium ?.copyWith(color: colorScheme.primary),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    // CONTINUE
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          foregroundColor: colorScheme.secondary,
                          backgroundColor: colorScheme.inversePrimary,
                        ),
                        icon: Icon(Symbols.play_arrow_rounded, size: 32),
                        label: const Text(
                          "Continue recording",
                          overflow: TextOverflow.visible,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          logic.togglePause();
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    // DISCARD
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          foregroundColor: colorScheme.error,
                          side: BorderSide(color: colorScheme.error, width: 1)
                        ),
                        icon: Icon(Symbols.delete_rounded, size: 32),
                        label: const Text(
                          "Discard recording",
                          overflow: TextOverflow.visible,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          logic.delete();
                        },
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
        );
      },
    );
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
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               logic.isRecording ?
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
                 ):
                GestureDetector(
                     onTap: logic.toggleRecording,
                     child:
                      Icon(
                        Symbols.mic,
                        size: 36,
                        color: colorScheme.primary.withAlpha(200),
                      ),
                  ),
                SizedBox(height: 12),
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
                    );
                  }
                ),
                if (logic.isRecording)
                  Wrap(
                    spacing: 16,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      // -----------------------------
                      // Play (only works when paused)
                      // -----------------------------
                      IconButton(
                        onPressed: logic.isPaused ? () {
                          logic.togglePlayback();
                        } : null,
                        icon: Icon(logic.isPlayback ? Symbols.pause_rounded : Symbols.play_arrow_rounded),
                        color: logic.isPaused ? colorScheme.primary : colorScheme.onSurface.withAlpha(128),
                        iconSize: 36,
                      ),

                      // -----------------------------
                      // Record / Resume
                      // -----------------------------
                      IconButton(
                        onPressed: !logic.isPlayback ? () {
                          logic.togglePause();
                        }: null,
                        icon: Icon(logic.isPaused ? Symbols.play_circle_rounded : Symbols.pause_circle_rounded),
                        color: logic.isPaused
                            ? colorScheme.error
                            : logic.isPlayback
                              ? colorScheme.onSurface.withAlpha(128)
                              : colorScheme.primary,
                        iconSize: 44,
                      ),

                      // -----------------------------
                      // End (opens confirmation)
                      // -----------------------------
                      IconButton(
                        onPressed: () {
                          showStopSheet(context, logic);
                          logic.pause();
                        },
                        icon: Icon(Symbols.stop_rounded),
                        color: colorScheme.primary,
                        iconSize: 36,
                      ),
                    ],
                  ),
              ],
            ),
        );
  }
}
