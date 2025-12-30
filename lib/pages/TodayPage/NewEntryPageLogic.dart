import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:beebetter/classes/EntryInfo.dart';
import 'package:beebetter/services/database_provider.dart';
import 'package:beebetter/services/audio_storage_service.dart';
import 'package:beebetter/data/database/tables.dart';

class NewEntryPageLogic extends ChangeNotifier {
  // ---------------------------------------------------
  // Variables Initialization
  // ---------------------------------------------------

  DateTime today = DateTime.now();
  String get formattedDay => DateFormat('EEEE').format(today);
  String get formattedDate => DateFormat('MMMM d, yyyy').format(today);

  final int emotionLevels = 3;

  bool canSelectNext = false;
  late EntryInfo entryInfo;
  bool isSaving = false;
  String? _recordingFilePath; // Store path to current recording

  // ---------------------------------------------------
  // Later will be loaded from Database or prompt generator
  // ---------------------------------------------------

  final List<List<String>> emotionItems = const [
    [
      "Joy",
      "Trust",
      "Fear",
      "Surprise",
      "Sadness",
      "Disgust",
      "Anger",
      "Anticipation",
    ],
    ["Happy", "Calm", "Excited"],
    ["Overwhelmed", "Empty", "Hopeful"],
  ];

  // ---------------------------------------------------
  // Constructor
  // ---------------------------------------------------

  NewEntryPageLogic() {
    entryInfo = EntryInfo(
      id: "entry",
      title: DateFormat('MMMM d, yyyy hh:mm a').format(DateTime.now()),
      category: "default",
      emotionLevels: emotionLevels,
      isText: false,
    );
  }

  // ---------------------------------------------------
  // Functions
  // ---------------------------------------------------

  void updateCanContinue(bool value) {
    entryInfo.canContinue = value;
    notifyListeners();
  }

  void updateCanSelectNextForLevel(int level) {
    canSelectNext = entryInfo.emotions[level].isNotEmpty;
    notifyListeners();
  }

  void updateEntryInput(String value) {
    entryInfo.userInput = value;
    entryInfo.isVoiceLocked = value.isNotEmpty;
    notifyListeners();
  }

  /// Set the recording file path (called when recording is completed)
  void setRecordingFilePath(String? filePath) {
    _recordingFilePath = filePath;
    if (filePath != null) {
      entryInfo.isText = false; // Mark as voice entry
      entryInfo.isTextLocked = true; // Lock text input
    }
    notifyListeners();
  }

  void updateTitle(String value) {
    if (value.isEmpty) {
      entryInfo.title = DateFormat('MMMM d, yyyy hh:mm a').format(DateTime.now());
    } else {
      entryInfo.title = value;
    }
    notifyListeners();
  }

  /// Save entry to database
  /// Returns true if successful, false otherwise
  Future<bool> saveEntry({VoidCallback? onSuccess}) async {
    // Don't save if there's no content (text or voice)
    final hasText = entryInfo.userInput.trim().isNotEmpty;
    final hasVoice = _recordingFilePath != null;
    
    if (!hasText && !hasVoice) {
      return false;
    }

    isSaving = true;
    notifyListeners();

    try {
      // Get current user
      final user = await DatabaseProvider.instance.getOrCreateUser();

      // Filter out empty emotions
      final emotions = entryInfo.emotions.where((e) => e.isNotEmpty).toList();

      // Determine input type
      InputType inputType;
      String? content;
      String? audioFilePath;
      
      if (hasVoice && _recordingFilePath != null) {
        // Voice entry - save recording to permanent storage
        final savedPath = await AudioStorageService.saveRecording(_recordingFilePath!);
        if (savedPath == null) {
          debugPrint('Failed to save recording to permanent storage');
          return false;
        }
        audioFilePath = savedPath;
        inputType = InputType.voice;
        content = null; // Voice entries don't have text content
      } else {
        // Text entry
        inputType = entryInfo.isText ? InputType.text : InputType.written;
        content = entryInfo.userInput;
        audioFilePath = null;
      }

      // Save to database
      await DatabaseProvider.instance.saveEntry(
        userId: user.id,
        content: content,
        title: entryInfo.title,
        inputType: inputType,
        emotions: emotions,
        audioFilePath: audioFilePath,
      );

      // Reset fields after successful save
      final int lastTab = entryInfo.lastActiveTab;
      entryInfo = EntryInfo(
        id: "entry",
        title: DateFormat('MMMM d, yyyy hh:mm a').format(DateTime.now()),
        category: "default",
        emotionLevels: emotionLevels,
        isText: false,
        lastActiveTab: lastTab == 1 ? 1 : 0,
      );
      _recordingFilePath = null;
      canSelectNext = false;

      // Call success callback if provided
      onSuccess?.call();

      return true;
    } catch (e) {
      // Handle error - could show a snackbar or error message
      debugPrint('Error saving entry: $e');
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}