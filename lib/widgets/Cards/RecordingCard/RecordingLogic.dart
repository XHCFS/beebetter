import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  AudioRecorder? _recorder;
  AudioRecorder get recorder {
    _recorder ??= AudioRecorder();
    return _recorder!;
  }
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
  
  // Callback for showing error messages to user
  final void Function(String errorMessage)? onError;

  String? filePath;
  String? _errorMessage;
  
  String? get errorMessage => _errorMessage;

  RecordingLogic({this.onRecordingComplete, this.onError, this.filePath});

  RecordingLogic.fromFile(String path, {this.onRecordingComplete, this.onError}) {
    filePath = path;
    _state = RecordingState.stopped;
    isPaused = false;
    isPlayback = false;
    elapsed = Duration.zero;
    amplitudes.count = 0;
    _errorMessage = null;
  }
  
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  void _setError(String message) {
    _errorMessage = message;
    onError?.call(message);
    notifyListeners();
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
    _clearError();
    
    // Check if running on web (record package doesn't support web)
    if (kIsWeb) {
      _setError('Voice recording is not supported on web. Please use a mobile device.');
      return;
    }
    
    try {
      // Wait a brief moment to ensure Flutter engine and plugins are fully initialized
      // This helps prevent MissingPluginException in release builds
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Check and request microphone permission using permission_handler
      // (Don't use recorder.hasPermission() as it may throw MissingPluginException)
      PermissionStatus permissionStatus;
      try {
        // Try to access the permission handler - if it fails, the plugin isn't ready
        permissionStatus = await Permission.microphone.status;
      } on MissingPluginException catch (e) {
        // Plugin not registered - this should not happen if build is correct
        // But we provide helpful error message
        _setError('Microphone permission system not available.\n\nThis usually means:\n1. The app needs a full rebuild (not hot reload)\n2. Plugins may not be properly included in the build\n\nPlease rebuild the app completely.');
        debugPrint('MissingPluginException in permission check: $e');
        debugPrint('Full error details: ${e.toString()}');
        return;
      } catch (e) {
        _setError('Failed to check microphone permission: ${e.toString()}');
        debugPrint('Permission check error: $e');
        return;
      }
      
      if (!permissionStatus.isGranted) {
        PermissionStatus result;
        try {
          result = await Permission.microphone.request();
        } on MissingPluginException catch (e) {
          // Plugin not registered - this should not happen if build is correct
          _setError('Microphone permission system not available.\n\nThis usually means:\n1. The app needs a full rebuild (not hot reload)\n2. Plugins may not be properly included in the build\n\nPlease rebuild the app completely.');
          debugPrint('MissingPluginException in permission request: $e');
          debugPrint('Full error details: ${e.toString()}');
          return;
        } catch (e) {
          _setError('Failed to request microphone permission: ${e.toString()}');
          debugPrint('Permission request error: $e');
          return;
        }
        
        if (result.isPermanentlyDenied) {
          _setError('Microphone permission is permanently denied. Please enable it in app settings.');
          return;
        }
        
        if (!result.isGranted) {
          _setError('Microphone permission is required to record audio.');
          return;
        }
      }

      // Get temporary directory for recording
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a';
      filePath = path; // Store path for later use

      // Start recording with error handling
      // Ensure recorder is initialized (lazy initialization)
      try {
        // Small delay to ensure recorder plugin is ready
        await Future.delayed(const Duration(milliseconds: 50));
        
        await recorder.start(
          RecordConfig(
            encoder: AudioEncoder.aacLc,
            sampleRate: 44100,
            numChannels: 1,
          ),
          path: path,
        );
      } on MissingPluginException catch (e) {
        // Handle MissingPluginException specifically - plugin not registered
        _setError('Audio recording system not available.\n\nThis usually means:\n1. The app needs a full rebuild (not hot reload)\n2. Plugins may not be properly included in the build\n\nPlease rebuild the app completely.');
        debugPrint('MissingPluginException in recorder.start(): $e');
        debugPrint('Full error details: ${e.toString()}');
        return;
      } catch (e) {
        _setError('Failed to start recording: ${e.toString()}');
        debugPrint('Recording error: $e');
        return;
      }

      // Update state to recording
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
              try {
                final amp = await recorder.getAmplitude();
                double normalized = ((amp.current + 60) / 60).clamp(0.0, 1.0);
                amplitudes.add(normalized);
                notifyListeners();
              } catch (e) {
                // Silently handle amplitude errors during recording
                debugPrint('Error getting amplitude: $e');
              }
            }
          });
    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
    }
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
    filePath = null; // Clear file path
    _errorMessage = null; // Clear any error messages
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
    _recorder?.dispose();
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
