import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

// Enum for recording session states
enum RecordingState {
  beforeRecording,
  recording,
  stopped,
}

class RecordingLogic extends ChangeNotifier {
  // ---------------------------------------------------
  // Variables Initialization
  // ---------------------------------------------------

  final int minRecordingTime = 20; // seconds
  final recorder = AudioRecorder();
  RecordingState _state = RecordingState.beforeRecording;

  bool get isRecording => _state == RecordingState.recording;
  bool get isStopped => _state == RecordingState.stopped;
  bool get isBefore => _state == RecordingState.beforeRecording;

  bool isPaused = false; // pause recording indicator / timers
  bool isPlayback = false; // playback indicator

  Duration elapsed = Duration.zero;

  Timer? elapsedTimer;
  Timer? amplitudeTimer;

  final CircularBuffer amplitudes = CircularBuffer(80);
  final int amplitudePollIntervalMs = 80;

  // Callback when recording is complete
  final void Function(bool canContinue)? onRecordingComplete;

  RecordingLogic({this.onRecordingComplete});

  // ---------------------------------------------------
  // State getters
  // ---------------------------------------------------
  RecordingState get state => _state;
  bool get canContinue => elapsed.inSeconds >= minRecordingTime;

  // ---------------------------------------------------
  // Recording Functions
  // ---------------------------------------------------

  // Start a recording session
  Future<void> startRecording() async {
    final hasPermission = await recorder.hasPermission();
    if (!hasPermission) return;

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await recorder.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          sampleRate: 44100,
          numChannels: 1,
        ),
      path: path,
    );

    _state = RecordingState.recording;
    isPaused = false;
    isPlayback = false;
    elapsed = Duration.zero;
    amplitudes.count = 0; // reset recording indicator bars
    notifyListeners();

    // Track elapsed time
    elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isPaused) {
        elapsed += const Duration(seconds: 1);
        notifyListeners();
      }
    });

    // Poll amplitudes
    amplitudeTimer =
        Timer.periodic(Duration(milliseconds: amplitudePollIntervalMs), (_) async {
          if (!isPaused) {
            final amp = await recorder.getAmplitude();
            double normalized = ((amp.current + 60) / 60).clamp(0.0, 1.0);
            amplitudes.add(normalized);
            notifyListeners();
          }
        });
  }

  // Stop the recording session and transition to stopped state
  Future<void> stopRecording() async {
    if (!isRecording) return;

    _state = RecordingState.stopped;
    isPaused = false;
    isPlayback = false;

    elapsedTimer?.cancel();
    amplitudeTimer?.cancel();

    await recorder.stop();

    if (canContinue) {
      onRecordingComplete?.call(true);
    }

    notifyListeners();
  }

  // Toggle recording / pause
  void togglePause() {
    if (!isRecording) return;
    isPaused = !isPaused;
    notifyListeners();
  }

  // Delete the current recording and reset state
  void delete() {
    _state = RecordingState.beforeRecording;
    isPaused = false;
    isPlayback = false;
    elapsed = Duration.zero;
    amplitudes.count = 0;
    notifyListeners();
  }

  // ---------------------------------------------------
  // Playback (stub)
  // ---------------------------------------------------
  void togglePlayback() {
    if (state == RecordingState.stopped || state == RecordingState.recording) {
      isPlayback = !isPlayback;
      notifyListeners();
    }
    notifyListeners();
  }

  // ---------------------------------------------------
  // Dispose timers
  // ---------------------------------------------------
  @override
  void dispose() {
    amplitudeTimer?.cancel();
    elapsedTimer?.cancel();
    super.dispose();
  }
}

// ---------------------------------------------------
// Circular Buffer for waveform indicator
// ---------------------------------------------------
class CircularBuffer {
  final int size;
  final List<double> buffer;
  int index = 0;
  int count = 0;

  CircularBuffer(this.size) : buffer = List.filled(size, 0);

  void add(double value) {
    buffer[index] = value;
    index = (index + 1) % size;
    if (count < size) count++;
  }

  List<double> toList() {
    final list = List<double>.filled(count, 0);
    for (int i = 0; i < count; i++) {
      list[i] = buffer[(index + i) % size];
    }
    return list;
  }
}
