import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:beebetter/widgets/Cards/RecordingCard/RecordingLogic.dart';
import 'package:beebetter/widgets/Cards/RecordingCard/RecordingIndicator.dart';

class VoiceEntryPlayer extends StatefulWidget {
  final RecordingLogic logic;
  const VoiceEntryPlayer({required this.logic, super.key});

  @override
  State<VoiceEntryPlayer> createState() => _VoiceEntryPlayerState();
}

class _VoiceEntryPlayerState extends State<VoiceEntryPlayer>
    with SingleTickerProviderStateMixin {
  late Ticker ticker;

  @override
  void initState() {
    super.initState();
    ticker = createTicker((_) {
      setState(() {}); //TODO: update waveform animation
    })..start();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final logic = widget.logic;

    return Row(
      children: [
        // ---------------------------------------------------
        // Play Button
        // ---------------------------------------------------
        IconButton(
          onPressed: widget.logic.togglePlayback,
          icon: Icon(
            logic.isPlayback ? Symbols.pause_rounded : Symbols.play_arrow_rounded,
          ),
          color: colorScheme.primary,
        ),

        // ---------------------------------------------------
        // Waveform
        // ---------------------------------------------------
        Expanded(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: RecordingIndicator(
              isRecording: true,
              amplitudes: List<double>.filled(40, 0.15), //TODO: replace placeholder with logic.amplitudes.toList()
              color: colorScheme.inversePrimary,
            ),
          ),
        ),
      ],
    );
  }
}
