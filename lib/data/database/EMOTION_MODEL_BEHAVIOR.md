# Emotion Model System - Behavior Guide

## Core Principle

**User selects ONE emotion model for the entire app. This affects:**
1. Which emotions can be selected manually
2. How AI model outputs are interpreted
3. Which emotions can be detected automatically vs manual-only

## Scenario: User Selects Plutchik's Model

### What Happens

#### 1. Manual Selection
- ✅ User can select **ALL 8 Plutchik emotions** manually:
  - joy, trust, fear, surprise, sadness, disgust, anger, anticipation
- All emotions are available because manual input has no limitations

#### 2. Automatic Detection (AI Models)

**Text Model (7 emotions):**
- `angry` → maps to Plutchik `anger` ✅
- `disgust` → maps to Plutchik `disgust` ✅
- `fear` → maps to Plutchik `fear` ✅
- `happy` → maps to Plutchik `joy` ✅
- `sad` → maps to Plutchik `sadness` ✅
- `surprise` → maps to Plutchik `surprise` ✅
- `neutral` → **doesn't map cleanly** (could be trust or content, ambiguous)

**Voice Model (4 emotions):**
- `ang` → maps to Plutchik `anger` ✅
- `hap` → maps to Plutchik `joy` ✅
- `sad` → maps to Plutchik `sadness` ✅
- `neu` → **doesn't map cleanly** (ambiguous)

**Result:**
- ✅ **6 Plutchik emotions can be detected automatically**: anger, disgust, fear, joy, sadness, surprise
- ❌ **2 Plutchik emotions are MANUAL-ONLY**: trust, anticipation

### Best Behavior Implementation

```dart
// 1. User selects Plutchik model
EmotionModel selectedModel = EmotionModel.plutchik;

// 2. Get all available moods for manual selection
Set<Mood> allAvailableMoods = EmotionModelMapper.getAvailableMoods(selectedModel);
// Returns all moods that correspond to all 8 Plutchik emotions

// 3. Get which emotions can be detected automatically
Map<String, bool> detectability = EmotionModelMapper.getEmotionDetectability(selectedModel);
// Returns: {anger: true, disgust: true, fear: true, joy: true, 
//           sadness: true, surprise: true, trust: false, anticipation: false}

// 4. When AI detects emotions, map to Plutchik
SevenEmotion textOutput = SevenEmotion.happy;
PlutchikEmotion? plutchikEmotion = EmotionModelMapper.mapTextModelToPlutchik(textOutput);
// Returns: PlutchikEmotion.joy

// 5. UI Behavior:
// - Show ALL 8 Plutchik emotions for manual selection
// - Mark "trust" and "anticipation" as "Manual Only" (grayed out or with icon)
// - When AI detects emotions, show which Plutchik emotion was detected
// - If AI detects something that doesn't map (like neutral), show "Unable to detect" or map to closest
```

## UI/UX Recommendations

### Manual Selection Screen
```
┌─────────────────────────────────┐
│ Select Emotion (Plutchik Model) │
├─────────────────────────────────┤
│ 😊 Joy              [Auto]      │
│ 🤝 Trust            [Manual]    │ ← Manual-only indicator
│ 😨 Fear             [Auto]      │
│ 😲 Surprise         [Auto]      │
│ 😢 Sadness          [Auto]      │
│ 🤢 Disgust          [Auto]      │
│ 😠 Anger            [Auto]      │
│ 🤔 Anticipation     [Manual]    │ ← Manual-only indicator
└─────────────────────────────────┘
```

### Automatic Detection Result
```
AI Detected: Joy (from text: "I'm so happy!")
Available in: Automatic & Manual ✅

AI Detected: Neutral (from text: "okay")
Mapped to: Trust (closest match)
Note: Trust is usually manual-only, but we mapped neutral → trust
```

## Edge Cases & Solutions

### Case 1: AI Output Doesn't Map to Selected Model
**Example**: User selects "Four" model, but text model detects "surprise"

**Solution**: 
- Option A: Map to closest match (surprise → neutral, since it's ambiguous)
- Option B: Show "Unable to map" and let user manually select
- Option C: Use confidence threshold - if confidence is low, suggest manual selection

**Recommended**: Option A with a note: "Detected 'surprise', mapped to 'neutral' (closest match)"

### Case 2: User Changes Emotion Model
**Example**: User switches from "Seven" to "Simple"

**Solution**:
- Existing moods in database remain unchanged (they're stored as base `Mood` enum)
- New automatic detections will use Simple model mapping
- Manual selections will only show Simple emotions going forward
- Historical data remains intact (no migration needed)

### Case 3: Multiple Emotions Detected
**Example**: Text model detects both "happy" (0.8) and "excited" (0.6) when user selected Plutchik

**Solution**:
- Map both to Plutchik: happy → joy, excited → joy (both map to same)
- Show: "Detected: Joy (confidence: 0.8)" - highest confidence wins
- Or show all: "Detected: Joy (0.8), Joy (0.6)" - aggregated

## Implementation Checklist

- [ ] Store user's selected `EmotionModel` in preferences/database
- [ ] Filter manual selection UI based on selected model
- [ ] Mark manual-only emotions in UI (for models like Plutchik)
- [ ] Map AI outputs to selected model before saving
- [ ] Handle unmappable AI outputs gracefully
- [ ] Show clear indicators for automatic vs manual-only emotions
- [ ] Provide user feedback when AI output is ambiguous

## Code Example: Complete Flow

```dart
// 1. Get user's selected model
final selectedModel = await getUserSelectedModel(); // e.g., EmotionModel.plutchik

// 2. Manual selection - show all available
final availableMoods = EmotionModelMapper.getAvailableMoods(selectedModel);
// User selects: PlutchikEmotion.trust (manual-only)

// 3. Automatic detection
final textPredictions = await textService.predictEmotions("I'm so happy!");
final detectedEmotion = EmotionMapper.mapTextEmotion(0); // Returns Mood.cheerful

// 4. Map to selected model
final sevenEmotion = SevenEmotion.happy; // From model output
final plutchikEmotion = EmotionModelMapper.mapTextModelToPlutchik(sevenEmotion);
// Returns: PlutchikEmotion.joy

// 5. Save to database
await db.moods.insertOne(MoodsCompanion.insert(
  recordId: record.id,
  mood: Value(plutchikEmotion.index), // Or map to Mood enum first
  source: Value(MoodSource.ai.index),
));
```

## Summary

**Key Takeaway**: When user selects a model (like Plutchik), they can:
- ✅ Manually select ANY emotion from that model
- ✅ Automatically detect emotions that AI models can map to that model
- ⚠️ Some emotions may be manual-only (like trust, anticipation in Plutchik)
- ✅ System gracefully handles unmappable AI outputs

The system ensures consistency: all emotions saved are valid for the selected model, whether manual or automatic.

