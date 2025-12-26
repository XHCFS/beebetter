# Emotion Inference Services

This directory contains services for emotion inference using ONNX models optimized for mobile devices.

## Models

1. **Text Emotion Model**: DistilBERT trained on GoEmotions dataset
   - Location: `assets/models/mobile_text_model/model_quantized.onnx`
   - Output: 7 emotion labels (multi-label classification)
   - Max sequence length: 512 tokens

2. **Voice Emotion Model**: DistilHuBERT trained on IEMOCAP dataset
   - Location: `assets/models/mobile_voice_model/emotion_model_quantized.onnx`
   - Output: 4 emotion labels (ang, hap, neu, sad)
   - Expected sample rate: 16kHz

## Usage

### Basic Usage

```dart
import 'package:beebetter/services/emotion_inference/emotion_inference_service.dart';
import 'dart:typed_data';

// Initialize the service
final emotionService = EmotionInferenceService();
await emotionService.initialize();

// Predict emotions from text
final textMoods = await emotionService.predictEmotionsFromText(
  "I'm feeling great today!",
  threshold: 0.3,
);

// Predict emotions from voice
final audioBytes = await getAudioBytes(); // Your audio recording
final voiceMoods = await emotionService.predictEmotionsFromVoice(
  audioBytes,
  sampleRate: 16000,
  threshold: 0.2,
);

// Get primary emotion
final primaryMood = await emotionService.getPrimaryEmotionFromText(
  "I'm so happy!"
);

// Clean up when done
emotionService.dispose();
```

### Using Individual Services

```dart
import 'package:beebetter/services/emotion_inference/text_emotion_service.dart';
import 'package:beebetter/services/emotion_inference/voice_emotion_service.dart';

// Text service
final textService = TextEmotionService();
await textService.initialize();

final predictions = await textService.predictEmotions("Your text here");
final topEmotions = await textService.getTopEmotions("Your text here", topN: 3);

textService.dispose();

// Voice service
final voiceService = VoiceEmotionService();
await voiceService.initialize();

final audioBytes = await getAudioBytes();
final predictions = await voiceService.predictEmotions(audioBytes, sampleRate: 16000);
final predictedLabel = await voiceService.getPredictedEmotion(audioBytes);

voiceService.dispose();
```

### Integration with Database

```dart
import 'package:beebetter/services/emotion_inference/emotion_inference_service.dart';
import 'package:beebetter/data/database/app_database.dart';
import 'package:beebetter/data/database/tables.dart';

final db = AppDatabase();
final emotionService = EmotionInferenceService();
await emotionService.initialize();

// Create a record
final record = await db.records.insertOne(RecordsCompanion.insert(
  content: "I'm feeling great!",
  inputType: Value(InputType.text.index),
));

// Predict emotions
final moods = await emotionService.predictEmotionsFromText(
  "I'm feeling great!",
);

// Save predicted moods to database
for (final moodEntry in moods) {
  await db.moods.insertOne(MoodsCompanion.insert(
    recordId: record.id,
    mood: Value(moodEntry.key.index),
    source: Value(MoodSource.ai.index),
  ));
}
```

## Important Notes

### Text Tokenization

The current implementation uses a simplified tokenization approach. For production use, you should:

1. Load the actual BERT vocabulary file (`vocab.json`)
2. Implement proper WordPiece tokenization
3. Handle subword tokens correctly

The current `_simpleWordHash` function is a placeholder and may not provide optimal results.

### Audio Processing

- Audio should be 16-bit PCM format
- Sample rate will be automatically resampled to 16kHz if different
- Long audio recordings are automatically split into 3-second windows with 1-second overlap
- Audio is normalized (zero mean, unit variance) before inference

### Model Outputs

**Text Model (GoEmotions)**:
- Returns 7 labels (LABEL_0 to LABEL_6)
- Multi-label classification (multiple emotions can be detected)
- You need to map these labels to your actual GoEmotions categories
- The `EmotionMapper` currently uses placeholder mappings that should be adjusted

**Voice Model (IEMOCAP)**:
- Returns 4 labels: ang (anger), hap (happiness), neu (neutral), sad (sadness)
- Single-label classification (softmax output)
- Mapped to Mood enum: enraged, cheerful, content, depressed

### Performance Considerations

- Models are quantized for mobile inference
- Long inputs are automatically chunked/windowed
- Inference runs on CPU with 2 threads per model
- Consider caching model sessions if making multiple predictions

### Error Handling

Always wrap inference calls in try-catch blocks:

```dart
try {
  final moods = await emotionService.predictEmotionsFromText(text);
} catch (e) {
  print('Error during inference: $e');
  // Handle error appropriately
}
```

## Customization

### Adjusting Emotion Mappings

Edit `emotion_mapper.dart` to customize how model outputs map to your `Mood` enum:

```dart
static Mood? mapTextEmotion(int labelIndex, {double? confidence}) {
  // Customize based on your actual GoEmotions labels
  switch (labelIndex) {
    case 0: return Mood.cheerful;
    // ... add your mappings
  }
}
```

### Adjusting Thresholds

Both services support confidence thresholds:

```dart
// Only return emotions with confidence >= 0.5
final moods = await emotionService.predictEmotionsFromText(
  text,
  threshold: 0.5,
);
```

### Adjusting Chunking/Windowing

For text, modify `_chunkText` in `text_emotion_service.dart`.
For voice, modify window size constants in `voice_emotion_service.dart`.

