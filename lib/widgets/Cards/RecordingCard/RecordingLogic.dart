import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class RecordingLogic extends ChangeNotifier {
  // ---------------------------------------------------
  // Variables Initialization
  // ---------------------------------------------------

  final minRecordingTime = 20; // seconds
  final recorder = AudioRecorder();
  bool isRecording = false;
  bool isPaused = false;
  bool isPlayback = false;
  Duration elapsed = Duration.zero;

  bool get canContinue => elapsed.inSeconds >= minRecordingTime;

  Timer? elapsedTimer;
  Timer? amplitudeTimer;

  final CircularBuffer amplitudes = CircularBuffer(80);
  final int amplitudePollIntervalMs = 80;

  final void Function(bool canContinue)? onRecordingComplete;

  RecordingLogic({this.onRecordingComplete});

  // ---------------------------------------------------
  // Recording Functions
  // ---------------------------------------------------

  Future<void> toggleRecording() async {
    if (isRecording) {
      await stop();
      return;
    }

    final hasPermission = await recorder.hasPermission();
    if (!hasPermission) return;

    // Save Directory
    final dir = await getTemporaryDirectory();
    final path ='${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await recorder.start(
      RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 44100,
        numChannels: 1,
      ),
      path: path,
    );

    isRecording = true;
    elapsed = Duration.zero;
    amplitudes.count = 0; // reset recording indicator bars
    notifyListeners();

    // Track elapsed time
    elapsedTimer = Timer.periodic(Duration(seconds: 1), (_) {
      if (isRecording && !isPaused) {
        elapsed += Duration(seconds: 1);

        notifyListeners();
      }
    });

    // Poll amplitudes
    amplitudeTimer =
        Timer.periodic(Duration(milliseconds: amplitudePollIntervalMs), (_) async {
          if (isRecording && !isPaused) {
            final amp = await recorder.getAmplitude();
            double normalized = ((amp.current + 60) / 60).clamp(0.0, 1.0);
            amplitudes.add(normalized);
            notifyListeners();
          }
      },);
  }

  Future<void> stop() async {
    if (!isRecording) return;

    isRecording = false;
    isPaused = false;

    amplitudeTimer?.cancel();
    elapsedTimer?.cancel();

    await recorder.stop();

    // Notify parent if recording reached min time
    if (canContinue) {
      onRecordingComplete?.call(true);
    }

    elapsed = Duration.zero;

    notifyListeners();
  }

  void togglePause() {
    isPaused = !isPaused;
    notifyListeners();
  }
  void pause() {
    isPaused = true;
    notifyListeners();
  }

  void delete() {
    isRecording = false;
    isPaused = false;
    elapsed = Duration.zero;
    amplitudes.count = 0;
    notifyListeners();
  }
  // ---------------------------------------------------
  // Playback
  // ---------------------------------------------------
  // TODO: playback logic

  void togglePlayback()
  {
    isPlayback = !isPlayback;
  }


  @override
  void dispose() {
    amplitudeTimer?.cancel();
    elapsedTimer?.cancel();
    super.dispose();
  }
}


// ---------------------------------------------------
// Circular Buffer for indicator bars
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
