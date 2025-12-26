# Emotion Model System

## Overview

This system allows users to select an emotion model for the entire app, with support for:
- **Simple**: BAD ↔ GOOD spectrum (2 emotions)
- **Seven**: 7 emotions from text model (angry, disgust, fear, happy, neutral, sad, surprise)
- **Four**: 4 emotions from IEMOCAP voice model (ang, hap, neu, sad)
- **Plutchik**: 8 basic emotions from Plutchik's wheel

## Key Principles

1. **Mapping DOWN only**: Models can map to less granular emotions, but not more granular
2. **Model selection**: User selects one model for the entire app
3. **Manual vs Automatic**:
   - **Manual input**: User can select any emotion from the selected model's available moods
   - **Automatic input**: Limited by what the AI models can detect

## Architecture

### Files

- `emotion_models.dart`: Defines emotion models, enums, and mapping functions
- `tables.dart`: Contains the base `Mood` enum (67 emotions)
- `emotion_mapper.dart`: Maps AI model outputs to `Mood` enum

### How It Works

1. **Base Mood Enum**: Contains all 67 possible emotions (the most granular level)

2. **Model-Specific Enums**:
   - `SimpleEmotion`: bad, good
   - `SevenEmotion`: angry, disgust, fear, happy, neutral, sad, surprise
   - `FourEmotion`: ang, hap, neu, sad
   - `PlutchikEmotion`: joy, trust, fear, surprise, sadness, disgust, anger, anticipation

3. **EmotionModelMapper**:
   - `getAvailableMoods(EmotionModel)`: Returns which `Mood` values are available for a model
   - `mapSimpleEmotion()`, `mapSevenEmotion()`, etc.: Map model enums → `Mood` enum
   - `isMoodAvailableForModel()`: Check if a mood can be used with a model

## Usage Examples

### 1. User Selects Emotion Model

```dart
// Store user's selected model (e.g., in SharedPreferences or database)
EmotionModel selectedModel = EmotionModel.seven;
```

### 2. Manual Emotion Selection UI

```dart
// Get available moods for the selected model
Set<Mood> availableMoods = EmotionModelMapper.getAvailableMoods(selectedModel);

// Show only these moods in the UI
List<Mood> moodList = availableMoods.toList()..sort();
```

### 3. Automatic Emotion Detection

```dart
// Text model outputs 7 emotions → map to Mood
final textPredictions = await textService.predictEmotions(text);
final moods = EmotionMapper.getMoodsFromTextPredictions(textPredictions);

// Voice model outputs 4 emotions → map to Mood
final voicePredictions = await voiceService.predictEmotions(audioBytes);
final mood = EmotionMapper.getPrimaryMoodFromVoice(voicePredictions);
```

### 4. Filtering Based on Selected Model

```dart
// When saving automatic predictions, filter to only moods available in selected model
EmotionModel selectedModel = getUserSelectedModel();
Set<Mood> availableMoods = EmotionModelMapper.getAvailableMoods(selectedModel);

final detectedMoods = await emotionService.predictEmotionsFromText(text);
final filteredMoods = detectedMoods
    .where((entry) => availableMoods.contains(entry.key))
    .toList();
```

## Model Hierarchy (Granularity)

From most granular to least granular:
1. **Plutchik** (8 emotions) - Most granular
2. **Seven** (7 emotions)
3. **Four** (4 emotions)
4. **Simple** (2 emotions) - Least granular

## Implementation Notes

- The base `Mood` enum remains unchanged (67 emotions)
- Model selection affects:
  - Which moods are shown in manual selection UI
  - Which moods can be saved from automatic detection
- AI models always output their specific emotions, which are then mapped to `Mood`
- The mapping ensures that model outputs always map to valid `Mood` values for the selected model

## Future Enhancements

- Add intensity levels for Plutchik's wheel
- Add spectrum value for Simple model (BAD ↔ GOOD on a scale)
- Support for custom emotion models
- Migration system if user changes emotion model

