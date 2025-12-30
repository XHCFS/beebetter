import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

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

  String? filePath;
  
  // Audio player for playback
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  RecordingLogic({this.onRecordingComplete, this.filePath});

  RecordingLogic.fromFile(String path, {this.onRecordingComplete}) {
    filePath = path;
    _state = RecordingState.stopped;
    isPaused = false;
    isPlayback = false;
    elapsed = Duration.zero;
    amplitudes.count = 0;
    _initializePlayer();
  }
  
  void _initializePlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _playerState = state;
      isPlayback = state == PlayerState.playing;
      notifyListeners();
    });
    
    _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
      notifyListeners();
    });
    
    _audioPlayer.onPositionChanged.listen((position) {
      _position = position;
      notifyListeners();
    });
  }


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
    filePath = '${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await recorder.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          sampleRate: 44100,
          numChannels: 1,
        ),
      path: filePath!,
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

    elapsedTimer?.cancel();
    amplitudeTimer?.cancel();

    await recorder.stop();

    _state = RecordingState.stopped;
    isPaused = false;
    isPlayback = false;

    // Initialize player with the recorded file
    if (filePath != null && File(filePath!).existsSync()) {
      _initializePlayer();
      // Load the audio file
      try {
        await _audioPlayer.setSource(DeviceFileSource(filePath!));
        final duration = await _audioPlayer.getDuration();
        if (duration != null) {
          _duration = duration;
        }
      } catch (e) {
        debugPrint('Error loading audio file: $e');
      }
    }

    // Always notify completion when stopped
    onRecordingComplete?.call(canContinue);

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
    filePath = null; // Clear file path when deleting
    _audioPlayer.stop(); // Stop any playback
    notifyListeners();
  }

  // ---------------------------------------------------
  // Playback
  // ---------------------------------------------------
  Future<void> togglePlayback() async {
    if (filePath == null) {
      debugPrint('No file path available');
      return;
    }

    final file = File(filePath!);
    if (!await file.exists()) {
      debugPrint('Audio file does not exist: $filePath');
      return;
    }

    try {
      if (_playerState == PlayerState.playing) {
        await _audioPlayer.pause();
        isPlayback = false;
      } else {
        // Always set source before playing to ensure it's loaded
        await _audioPlayer.setSource(DeviceFileSource(filePath!));
        // Wait a moment for source to be set
        await Future.delayed(const Duration(milliseconds: 100));
        // Get duration after setting source
        final duration = await _audioPlayer.getDuration();
        if (duration != null) {
          _duration = duration;
        }
        await _audioPlayer.resume();
        isPlayback = true;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling playback: $e');
      // Try to reinitialize and play
      try {
        _initializePlayer();
        await _audioPlayer.setSource(DeviceFileSource(filePath!));
        final duration = await _audioPlayer.getDuration();
        if (duration != null) {
          _duration = duration;
        }
        await _audioPlayer.resume();
        isPlayback = true;
        notifyListeners();
      } catch (e2) {
        debugPrint('Error retrying playback: $e2');
      }
    }
  }
  
  Duration get duration => _duration;
  Duration get position => _position;
  
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // ---------------------------------------------------
  // Dispose timers and player
  // ---------------------------------------------------
  @override
  void dispose() {
    amplitudeTimer?.cancel();
    elapsedTimer?.cancel();
    _audioPlayer.dispose();
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
