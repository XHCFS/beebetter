# Implementation Notes

## Important: Before Using

### 1. Install Dependencies
Run the following command to install the ONNX Runtime package:
```bash
flutter pub get
```

### 2. Verify Model Paths
Ensure the model files exist at:
- `assets/models/mobile_text_model/model_quantized.onnx`
- `assets/models/mobile_voice_model/emotion_model_quantized.onnx`

### 3. Text Tokenization (CRITICAL)
The current text tokenization uses a simplified hash-based approach. **This is not production-ready.**

**You MUST:**
1. Load the actual BERT vocabulary file (`vocab.json` from the DistilBERT model)
2. Implement proper WordPiece tokenization
3. Handle subword tokens correctly

**Recommended approach:**
- Use a tokenizer package like `tokenizers` (if available for Dart)
- Or load the vocab file and implement WordPiece tokenization
- Or use a platform channel to call Python's transformers library

**Current limitation:** The `_simpleWordHash` function may not provide accurate tokenization, which will affect model accuracy.

### 4. Emotion Label Mapping
The `EmotionMapper.mapTextEmotion()` function uses placeholder mappings. You need to:

1. **Identify your GoEmotions labels**: Check what LABEL_0 through LABEL_6 actually represent in your trained model
2. **Update the mapping**: Modify `emotion_mapper.dart` to map each label to the appropriate `Mood` enum value

Example:
```dart
static Mood? mapTextEmotion(int labelIndex, {double? confidence}) {
  switch (labelIndex) {
    case 0: return Mood.cheerful;  // If LABEL_0 = "joy"
    case 1: return Mood.grateful;  // If LABEL_1 = "gratitude"
    // ... update based on your actual labels
  }
}
```

### 5. Tensor Names
The code assumes standard tensor names:
- **Text model**: `input_ids`, `attention_mask` for inputs
- **Voice model**: `input_values` for input
- Both models: First output tensor contains logits

**If inference fails**, check your ONNX model's input/output names using:
- ONNX Runtime tools
- Netron (ONNX model viewer)
- Python: `onnx.helper.printable_graph(model.graph)`

Then update the tensor names in the service files.

### 6. Audio Format
The voice service expects:
- **Format**: 16-bit PCM
- **Sample rate**: Will be resampled to 16kHz if different
- **Channels**: Mono (stereo will be processed but may need adjustment)

Ensure your audio recording matches these specifications.

## Testing

### Test Text Inference
```dart
final service = EmotionInferenceService();
await service.initialize();

try {
  final moods = await service.predictEmotionsFromText("I'm feeling great!");
  print('Detected moods: $moods');
} catch (e) {
  print('Error: $e');
  // Check tensor names, model path, etc.
} finally {
  service.dispose();
}
```

### Test Voice Inference
```dart
final service = EmotionInferenceService();
await service.initialize();

try {
  final audioBytes = await loadAudioFile(); // Your audio loading logic
  final moods = await service.predictEmotionsFromVoice(
    audioBytes,
    sampleRate: 16000,
  );
  print('Detected moods: $moods');
} catch (e) {
  print('Error: $e');
  // Check tensor names, model path, audio format, etc.
} finally {
  service.dispose();
}
```

## Performance Optimization

1. **Model Loading**: Models are loaded on first use. Consider pre-loading at app startup.
2. **Session Caching**: Keep sessions alive if making multiple predictions.
3. **Thread Configuration**: Currently set to 2 threads. Adjust based on device capabilities.
4. **Chunking**: Long inputs are automatically chunked. Adjust chunk sizes if needed.

## Troubleshooting

### "Model not initialized" error
- Ensure `initialize()` is called before inference
- Check that model files exist in assets

### "Failed to initialize" error
- Verify model file paths are correct
- Check that models are valid ONNX files
- Ensure `onnxruntime` package is properly installed

### Low accuracy / Wrong predictions
- **Text**: Verify tokenization is correct (see note above)
- **Voice**: Check audio preprocessing (sample rate, normalization)
- Verify emotion label mappings match your model's actual outputs

### Tensor name errors
- Inspect your ONNX model to get actual input/output names
- Update the service files with correct tensor names

### Memory issues
- Dispose of services when not in use
- Process inputs in smaller chunks
- Reduce thread count in session options

## Next Steps

1. ✅ Install dependencies: `flutter pub get`
2. ⚠️ Implement proper text tokenization
3. ⚠️ Update emotion label mappings
4. ⚠️ Verify tensor names match your models
5. ✅ Test with sample inputs
6. ✅ Integrate with your database

