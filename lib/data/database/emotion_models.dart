// lib/data/database/emotion_models.dart

import 'tables.dart';

/// Emotion model types available in the app
enum EmotionModel {
  /// Simple BAD ↔ GOOD spectrum (1 dimension)
  simple,
  
  /// 7 emotions from text model: angry, disgust, fear, happy, neutral, sad, surprise
  seven,
  
  /// 4 emotions from IEMOCAP voice model: ang, hap, neu, sad
  four,
  
  /// Plutchik's wheel: 8 basic emotions with intensity
  plutchik,
}

/// Simple emotion model (BAD ↔ GOOD spectrum)
enum SimpleEmotion {
  bad,
  good,
}

/// Seven emotion model (from text model)
enum SevenEmotion {
  angry,
  disgust,
  fear,
  happy,
  neutral,
  sad,
  surprise,
}

/// Four emotion model (from IEMOCAP voice model)
enum FourEmotion {
  ang,  // anger
  hap,  // happiness
  neu,  // neutral
  sad,  // sadness
}

/// Plutchik's 8 basic emotions
enum PlutchikEmotion {
  joy,
  trust,
  fear,
  surprise,
  sadness,
  disgust,
  anger,
  anticipation,
}

/// Maps model-specific emotions to the base Mood enum
/// This allows mapping DOWN (more granular → less granular) but not UP
class EmotionModelMapper {
  /// Get all Moods available for a given emotion model
  /// This determines what emotions can be selected manually
  static Set<Mood> getAvailableMoods(EmotionModel model) {
    switch (model) {
      case EmotionModel.simple:
        // Simple model: map to positive/negative moods
        return {
          // Positive (good)
          Mood.cheerful,
          Mood.content,
          Mood.proud,
          Mood.optimistic,
          Mood.excited,
          Mood.enthusiastic,
          Mood.playful,
          Mood.satisfied,
          Mood.grateful,
          Mood.compassionate,
          Mood.affectionate,
          Mood.warm,
          Mood.sentimental,
          Mood.tender,
          Mood.caring,
          Mood.romantic,
          Mood.passionate,
          Mood.interested,
          Mood.curious,
          Mood.eager,
          Mood.hopeful,
          Mood.alert,
          Mood.expectant,
          Mood.confident,
          Mood.secure,
          Mood.faithful,
          Mood.assured,
          Mood.reliable,
          Mood.supported,
          Mood.accepted,
          // Negative (bad)
          Mood.lonely,
          Mood.disappointed,
          Mood.hurt,
          Mood.guilty,
          Mood.depressed,
          Mood.grief,
          Mood.isolated,
          Mood.hopeless,
          Mood.frustrated,
          Mood.irritated,
          Mood.enraged,
          Mood.resentful,
          Mood.jealous,
          Mood.contemptuous,
          Mood.furious,
          Mood.annoyed,
          Mood.anxious,
          Mood.insecure,
          Mood.scared,
          Mood.nervous,
          Mood.terrified,
          Mood.panicked,
          Mood.helpless,
          Mood.apprehensive,
          Mood.confused,
          Mood.perplexed,
          Mood.disoriented,
          Mood.startled,
        };
        
      case EmotionModel.seven:
        // Seven emotion model: map to moods that correspond to the 7 emotions
        return {
          // angry
          Mood.enraged,
          Mood.furious,
          Mood.irritated,
          Mood.annoyed,
          Mood.frustrated,
          Mood.resentful,
          // disgust
          Mood.contemptuous,
          Mood.jealous,
          // fear
          Mood.anxious,
          Mood.scared,
          Mood.nervous,
          Mood.terrified,
          Mood.panicked,
          Mood.helpless,
          Mood.apprehensive,
          Mood.insecure,
          // happy
          Mood.cheerful,
          Mood.excited,
          Mood.enthusiastic,
          Mood.playful,
          Mood.satisfied,
          Mood.grateful,
          Mood.optimistic,
          Mood.hopeful,
          Mood.confident,
          // neutral
          Mood.content,
          Mood.interested,
          Mood.curious,
          Mood.alert,
          Mood.expectant,
          // sad
          Mood.depressed,
          Mood.disappointed,
          Mood.lonely,
          Mood.hurt,
          Mood.grief,
          Mood.isolated,
          Mood.hopeless,
          Mood.guilty,
          // surprise
          Mood.amazed,
          Mood.astonished,
          Mood.shocked,
          Mood.startled,
          Mood.confused,
          Mood.perplexed,
          Mood.disoriented,
        };
        
      case EmotionModel.four:
        // Four emotion model: map to moods that correspond to the 4 emotions
        return {
          // ang (anger)
          Mood.enraged,
          Mood.furious,
          Mood.irritated,
          Mood.annoyed,
          Mood.frustrated,
          Mood.resentful,
          // hap (happiness)
          Mood.cheerful,
          Mood.excited,
          Mood.enthusiastic,
          Mood.playful,
          Mood.satisfied,
          Mood.grateful,
          Mood.optimistic,
          Mood.hopeful,
          Mood.confident,
          // neu (neutral)
          Mood.content,
          Mood.interested,
          Mood.curious,
          Mood.alert,
          Mood.expectant,
          // sad (sadness)
          Mood.depressed,
          Mood.disappointed,
          Mood.lonely,
          Mood.hurt,
          Mood.grief,
          Mood.isolated,
          Mood.hopeless,
          Mood.guilty,
        };
        
      case EmotionModel.plutchik:
        // Plutchik's wheel: map to moods that correspond to the 8 basic emotions
        return {
          // joy
          Mood.cheerful,
          Mood.excited,
          Mood.enthusiastic,
          Mood.playful,
          Mood.satisfied,
          Mood.grateful,
          Mood.optimistic,
          Mood.hopeful,
          // trust
          Mood.confident,
          Mood.secure,
          Mood.faithful,
          Mood.assured,
          Mood.reliable,
          Mood.supported,
          Mood.accepted,
          Mood.compassionate,
          Mood.caring,
          // fear
          Mood.anxious,
          Mood.scared,
          Mood.nervous,
          Mood.terrified,
          Mood.panicked,
          Mood.helpless,
          Mood.apprehensive,
          Mood.insecure,
          // surprise
          Mood.amazed,
          Mood.astonished,
          Mood.shocked,
          Mood.startled,
          Mood.confused,
          Mood.perplexed,
          Mood.disoriented,
          // sadness
          Mood.depressed,
          Mood.disappointed,
          Mood.lonely,
          Mood.hurt,
          Mood.grief,
          Mood.isolated,
          Mood.hopeless,
          Mood.guilty,
          // disgust
          Mood.contemptuous,
          Mood.jealous,
          Mood.resentful,
          // anger
          Mood.enraged,
          Mood.furious,
          Mood.irritated,
          Mood.annoyed,
          Mood.frustrated,
          // anticipation
          Mood.interested,
          Mood.curious,
          Mood.eager,
          Mood.alert,
          Mood.expectant,
        };
    }
  }
  
  /// Map SimpleEmotion to Mood enum
  static Mood? mapSimpleEmotion(SimpleEmotion emotion) {
    switch (emotion) {
      case SimpleEmotion.good:
        return Mood.cheerful; // Default positive mood
      case SimpleEmotion.bad:
        return Mood.depressed; // Default negative mood
    }
  }
  
  /// Map SevenEmotion to Mood enum
  static Mood? mapSevenEmotion(SevenEmotion emotion) {
    switch (emotion) {
      case SevenEmotion.angry:
        return Mood.enraged;
      case SevenEmotion.disgust:
        return Mood.contemptuous;
      case SevenEmotion.fear:
        return Mood.anxious;
      case SevenEmotion.happy:
        return Mood.cheerful;
      case SevenEmotion.neutral:
        return Mood.content;
      case SevenEmotion.sad:
        return Mood.depressed;
      case SevenEmotion.surprise:
        return Mood.amazed;
    }
  }
  
  /// Map FourEmotion to Mood enum
  static Mood? mapFourEmotion(FourEmotion emotion) {
    switch (emotion) {
      case FourEmotion.ang:
        return Mood.enraged;
      case FourEmotion.hap:
        return Mood.cheerful;
      case FourEmotion.neu:
        return Mood.content;
      case FourEmotion.sad:
        return Mood.depressed;
    }
  }
  
  /// Map PlutchikEmotion to Mood enum
  static Mood? mapPlutchikEmotion(PlutchikEmotion emotion) {
    switch (emotion) {
      case PlutchikEmotion.joy:
        return Mood.cheerful;
      case PlutchikEmotion.trust:
        return Mood.confident;
      case PlutchikEmotion.fear:
        return Mood.anxious;
      case PlutchikEmotion.surprise:
        return Mood.amazed;
      case PlutchikEmotion.sadness:
        return Mood.depressed;
      case PlutchikEmotion.disgust:
        return Mood.contemptuous;
      case PlutchikEmotion.anger:
        return Mood.enraged;
      case PlutchikEmotion.anticipation:
        return Mood.interested;
    }
  }
  
  /// Check if a Mood can be used with a given EmotionModel
  static bool isMoodAvailableForModel(Mood mood, EmotionModel model) {
    return getAvailableMoods(model).contains(mood);
  }
  
  /// Get the emotion model that a mood belongs to (for filtering)
  /// Returns the most granular model that includes this mood
  static EmotionModel? getModelForMood(Mood mood) {
    // Check from most granular to least granular
    if (getAvailableMoods(EmotionModel.plutchik).contains(mood)) {
      return EmotionModel.plutchik;
    }
    if (getAvailableMoods(EmotionModel.seven).contains(mood)) {
      return EmotionModel.seven;
    }
    if (getAvailableMoods(EmotionModel.four).contains(mood)) {
      return EmotionModel.four;
    }
    if (getAvailableMoods(EmotionModel.simple).contains(mood)) {
      return EmotionModel.simple;
    }
    return null; // Mood not in any model
  }
  
  // ============================================================================
  // AI MODEL OUTPUT → SELECTED EMOTION MODEL MAPPINGS
  // ============================================================================
  // These functions map AI model outputs directly to the user's selected emotion model
  // This ensures automatic detection respects the selected model
  
  /// Map text model output (7 emotions) to Plutchik emotions
  /// Some Plutchik emotions may not be detectable (manual-only)
  static PlutchikEmotion? mapTextModelToPlutchik(SevenEmotion textEmotion) {
    switch (textEmotion) {
      case SevenEmotion.angry:
        return PlutchikEmotion.anger;
      case SevenEmotion.disgust:
        return PlutchikEmotion.disgust;
      case SevenEmotion.fear:
        return PlutchikEmotion.fear;
      case SevenEmotion.happy:
        return PlutchikEmotion.joy;
      case SevenEmotion.neutral:
        return null; // Neutral doesn't map to Plutchik - use trust or content
      case SevenEmotion.sad:
        return PlutchikEmotion.sadness;
      case SevenEmotion.surprise:
        return PlutchikEmotion.surprise;
    }
  }
  
  /// Map voice model output (4 emotions) to Plutchik emotions
  static PlutchikEmotion? mapVoiceModelToPlutchik(FourEmotion voiceEmotion) {
    switch (voiceEmotion) {
      case FourEmotion.ang:
        return PlutchikEmotion.anger;
      case FourEmotion.hap:
        return PlutchikEmotion.joy;
      case FourEmotion.neu:
        return null; // Neutral doesn't map directly - could be trust or content
      case FourEmotion.sad:
        return PlutchikEmotion.sadness;
    }
  }
  
  /// Map text model output (7 emotions) to Simple emotions
  static SimpleEmotion? mapTextModelToSimple(SevenEmotion textEmotion) {
    switch (textEmotion) {
      case SevenEmotion.angry:
      case SevenEmotion.disgust:
      case SevenEmotion.fear:
      case SevenEmotion.sad:
        return SimpleEmotion.bad;
      case SevenEmotion.happy:
        return SimpleEmotion.good;
      case SevenEmotion.neutral:
      case SevenEmotion.surprise:
        return null; // Ambiguous - could be either
    }
  }
  
  /// Map voice model output (4 emotions) to Simple emotions
  static SimpleEmotion? mapVoiceModelToSimple(FourEmotion voiceEmotion) {
    switch (voiceEmotion) {
      case FourEmotion.ang:
      case FourEmotion.sad:
        return SimpleEmotion.bad;
      case FourEmotion.hap:
        return SimpleEmotion.good;
      case FourEmotion.neu:
        return null; // Neutral is ambiguous
    }
  }
  
  /// Map text model output (7 emotions) to Four emotions
  static FourEmotion? mapTextModelToFour(SevenEmotion textEmotion) {
    switch (textEmotion) {
      case SevenEmotion.angry:
        return FourEmotion.ang;
      case SevenEmotion.happy:
        return FourEmotion.hap;
      case SevenEmotion.neutral:
        return FourEmotion.neu;
      case SevenEmotion.sad:
        return FourEmotion.sad;
      case SevenEmotion.disgust:
      case SevenEmotion.fear:
      case SevenEmotion.surprise:
        return null; // These don't map cleanly to 4-emotion model
    }
  }
  
  /// Get which Plutchik emotions can be detected automatically
  /// Returns emotions that can be detected by AI models
  static Set<PlutchikEmotion> getDetectablePlutchikEmotions() {
    return {
      PlutchikEmotion.anger,    // From text/voice: angry/ang
      PlutchikEmotion.disgust,  // From text: disgust
      PlutchikEmotion.fear,     // From text: fear
      PlutchikEmotion.joy,      // From text/voice: happy/hap
      PlutchikEmotion.sadness,  // From text/voice: sad
      PlutchikEmotion.surprise, // From text: surprise
      // trust and anticipation are NOT automatically detectable
    };
  }
  
  /// Get which emotions in a model can be detected automatically vs manual-only
  static Map<String, bool> getEmotionDetectability(EmotionModel model) {
    switch (model) {
      case EmotionModel.simple:
        return {
          'good': true,  // Can detect from happy
          'bad': true,   // Can detect from angry/sad/fear/disgust
        };
      case EmotionModel.seven:
        return {
          'angry': true,
          'disgust': true,
          'fear': true,
          'happy': true,
          'neutral': true,
          'sad': true,
          'surprise': true,
        };
      case EmotionModel.four:
        return {
          'ang': true,
          'hap': true,
          'neu': true,
          'sad': true,
        };
      case EmotionModel.plutchik:
        return {
          'anger': true,      // Detectable from text/voice
          'disgust': true,    // Detectable from text
          'fear': true,       // Detectable from text
          'joy': true,        // Detectable from text/voice
          'sadness': true,    // Detectable from text/voice
          'surprise': true,   // Detectable from text
          'trust': false,     // Manual-only
          'anticipation': false, // Manual-only
        };
    }
  }
}

