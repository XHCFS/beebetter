# The `assetes` dir

This directory should house all the application assetes.

## `assets/prompts.json`

The journaling prompts were curated from chatgpts, deep research findings. The prompts are **expert-created, clinically informed resources** commonly used in mental health and wellness contexts. These include:

- **Charlie Health Editorial Team (2023)**  
  Content written and reviewed by licensed clinicians (LMFTs, LCSWs, psychologists). Their prompts are grounded in CBT, ACT, and evidence-based mental health practices used in clinical and intensive outpatient settings.

- **Laura Copley, PhD, LMFT (2023)**  
  A licensed therapist and trauma expert. Her journaling prompts are widely cited in therapeutic journaling guides and focus on emotional processing, self-discovery, and values-based reflection.

- **Adonaca Barrett (2025)**  
  A wellness writer specializing in mindfulness and gratitude practices, frequently referenced by mental health platforms and wellness programs.

- **University of Rochester Medical Center – Health Encyclopedia (Pierce-Smith & Ballas, 2025)**  
  Academic medical source providing evidence-backed mindfulness and relaxation exercises used in clinical settings.

All prompts were adapted carefully to preserve **therapeutic intent** while fitting a consumer journaling app context. No prompts were taken from user-generated or unverified sources.

---

## JSON Field Explanation

Each journaling prompt is stored as a structured object to support filtering, personalization, and therapeutic alignment:

- **`text`**  
  The actual journaling prompt shown to the user. Written in clear, compassionate, action-oriented language.

- **`category`**  
  A high-level grouping (e.g., `gratitude`, `cognitive_restructuring`, `self-care`) used for prefernce learning algorithm.

- **`therapeutic_framework`**  
  The psychological or therapeutic model the prompt is based on (e.g., `CBT`, `ACT`, `expressive_writing`, `mindfulness`, `positive_psychology`).

- **`difficulty_level` (1–5)**  
  Indicates emotional or cognitive intensity:  
  - 1 = very light, accessible  
  - 3 = moderate reflection  
  - 5 = deep emotional or cognitive work

- **`tags`**  
  2–5 keywords describing themes or outcomes (not used now, can be used later).

- **`target_mood_states`**  
  One or more moods matched to our `Mood` enum. These represent the emotional states the prompt is best suited for supporting or transforming.

- **`best_time_of_day`**  
  Suggested journaling time (`morning`, `evening`, or `anytime`) based on cognitive load and emotional depth.

- **`source_citation`**  
  Human-readable citation for transparency, credibility, and future auditing.

---

## Design Notes

- Prompts were **evenly distributed across emotional valence** (positive, neutral, difficult).
- No medical advice or diagnosis is implied.
- Language is intentionally **non-triggering, open-ended, and autonomy-respecting**.
