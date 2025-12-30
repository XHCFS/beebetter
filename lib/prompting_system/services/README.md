# `prompting_system\services` dir

This directory contains the prompting system of the guided mode. It has 2 main files, the `adaptation_system.dart` is responsible for learning the user's prefernces. The `prompt_selection_system.dart` which is a simple schotastic scoring algorithm to rank which prompts to show next.

## `prompt_selection_system.dart`

### Usage

```dart
import 'package:beebetter/prompting_system/services/prompt_selection_system.dart';

system = PromptSelectionSystem(db, random: Random(42));

final ranked = await system.rankPromptsForUser(userId: userId); // Rank of what to show next to user (best-worst)
```

### When to run?

### Scoring System

The class `PromptScorer` is our scoring engine, the table below shows how the scores are ranked for each prompt.
| Scoring Factor | Condition | Score Weight |
| :--- | :--- | :--- |
| **Novelty** | Prompt ID has not been used recently | +2.0 |
| **Category Variety** | Category does not match recent prompts | +1.5 |
| **Preference Match** | Category is in user's preferred list | +2.0 |
| **Difficulty Alignment** | $2.0 - |prompt - user|$ (Minimum 0) | +0.0 to +2.0 |
| **Mood Alignment** | Per matching mood in target states | +1.2 per match |
| **Time of Day** | Matches current time (or is universal) | +1.0 |

After each prompt is scored the `_weightRank` function adds some random weigh to each prompt score so the system is less determinstic. For more experimental approaches, modify the point base system or add more "predictors".

### test cases

The prompt selection system, was tested in `test\prompt_scorer.dart`, it was tested on:

1. Deterministic Logic: The point base system
2. Integration & Stress Tests: The distribution of schotastic weighted sampling

## `adaption_system.dart`

### Usage

```dart
import 'package:beebetter/prompting_system/services/adaptation_system.dart';

service = AdaptationService(db);

service.runAdaptation(userId); // Updates user data including: difficulty level, preferred categories, avoided prompts, last difficulty adjustment
```

### Adaption System

There are three different parameters adjusted for a user, their difficulty level, Preference Categories.

#### ` _adjustDifficultyLevel`

Completion rate is skipped Vs Solved
For incrementation

1. Minium 7 days since last adjusted
2. Completion rate > 80% in last 10 days
3. Average word count and time spent, >= 100 words or 300 sec
   For decrement
4. Completion rate < 50%
5. No entries in 7 days

#### `_updatePreferenceCategories`

The preference category uses a scoring table, just like the prompt selection.
| Logic Component | Condition | Weight |
| :--- | :--- | :--- |
| **Participation** | User completed any prompt in this category | +5.0 |
| **High Engagement** | Response word count > User's 30-day average | +3.0 |
| **Positive Sentiment** | Associated mood is classified as "Positive" | +5.0 |

Then after scoring there is filtering and save logic
| Action | Logic / Threshold |
| :--- | :--- |
| **Minimum Threshold** | Score must be **≥ 15** to be considered "Preferred" |
| **Execution Trigger** | Total entries must be **multiple of 6** (6, 12, 18...) |
| **Data Recency** | Only entries from the **last 30 days** are considered |
| **Storage Format** | List of names (e.g., `["Growth", "Health"]`) saved as **JSON** |

#### `_updateAvoidedPrompts`

| Action                  | Logic / Threshold                                |
| :---------------------- | :----------------------------------------------- |
| **Avoidance Threshold** | Prompt must be skipped **≥ 3 times**             |
| **Data Source**         | `promptInteractions` table                       |
| **Final Action**        | Prompt ID is added to `avoidedPrompts` JSON list |

TODO: Need to reset avoided prompts after sometime. (Idea)
