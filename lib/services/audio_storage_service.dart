import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Service for managing audio file storage
/// Moves recordings from temporary storage to permanent app directory
class AudioStorageService {
  /// Move a recording from temporary location to permanent storage
  /// Returns the new file path, or null if operation fails
  static Future<String?> saveRecording(String tempFilePath) async {
    try {
      final tempFile = File(tempFilePath);
      if (!await tempFile.exists()) {
        return null;
      }

      // Get app documents directory for permanent storage
      final appDir = await getApplicationDocumentsDirectory();
      final recordingsDir = Directory(p.join(appDir.path, 'recordings'));
      
      // Create recordings directory if it doesn't exist
      if (!await recordingsDir.exists()) {
        await recordingsDir.create(recursive: true);
      }

      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'recording_$timestamp.m4a';
      final permanentPath = p.join(recordingsDir.path, fileName);

      // Copy file to permanent location
      await tempFile.copy(permanentPath);

      // Optionally delete temp file (or keep it for safety)
      // await tempFile.delete();

      return permanentPath;
    } catch (e) {
      print('Error saving recording: $e');
      return null;
    }
  }

  /// Delete an audio file
  static Future<bool> deleteRecording(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting recording: $e');
      return false;
    }
  }

  /// Check if a recording file exists
  static Future<bool> recordingExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}

