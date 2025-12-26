# Tokenization Issue - Model Always Predicts Neutral

## Problem

The model always predicts "neutral" regardless of input text. This is because our Dart tokenization implementation doesn't exactly match the HuggingFace `AutoTokenizer.from_pretrained("distilbert-base-uncased")` used during training.

## Root Cause

The HuggingFace tokenizer performs sophisticated preprocessing:
1. **Normalization**: Lowercasing, accent stripping, Unicode normalization
2. **Pre-tokenization**: Splits on whitespace AND punctuation (punctuation becomes separate tokens)
3. **Contraction handling**: Special handling for contractions like "I'm" → ["i", "'", "m"]
4. **WordPiece tokenization**: Greedy longest-match-first subword splitting

Our simplified implementation doesn't match this exactly, producing different token sequences than the model was trained on.

## Solutions

### Option 1: Use Platform Channel (Recommended for Production)

Call Python's HuggingFace tokenizer from Dart via a platform channel:

```dart
// In Dart
final tokenIds = await platform.invokeMethod('tokenize', {'text': text});
```

```python
# In Python (platform channel handler)
from transformers import AutoTokenizer
tokenizer = AutoTokenizer.from_pretrained("distilbert-base-uncased")

def tokenize_text(text):
    encoded = tokenizer(text, return_tensors="np", padding='max_length', 
                       max_length=128, truncation=True)
    return encoded["input_ids"][0].tolist()
```

**Pros**: Exact tokenization match, reliable
**Cons**: Requires Python runtime, more complex setup

### Option 2: Pre-tokenize in Python Script

Create a Python script that tokenizes text and saves token IDs, then load in Dart:

```python
# tokenize_batch.py
from transformers import AutoTokenizer
import json

tokenizer = AutoTokenizer.from_pretrained("distilbert-base-uncased")
texts = ["I am happy", "I am sad", ...]
tokenized = {text: tokenizer(text, ...)["input_ids"][0].tolist() 
             for text in texts}
json.dump(tokenized, open("tokenized.json", "w"))
```

**Pros**: Exact match, no runtime dependency
**Cons**: Only works for known texts, not dynamic

### Option 3: Use Dart BERT Tokenizer Package

If a Dart package exists that implements BERT tokenization:
- Search pub.dev for "bert tokenizer" or "wordpiece"
- Use that package instead of our custom implementation

### Option 4: Improve Our Implementation

Implement a more accurate tokenizer matching HuggingFace's behavior:
- Study HuggingFace's tokenizer source code
- Implement exact pre-tokenization regex
- Handle all edge cases (contractions, punctuation, Unicode)

**Pros**: Pure Dart, no dependencies
**Cons**: Very complex, time-consuming, error-prone

## Current Status

The current implementation is a simplified version that:
- ✅ Uses the correct vocabulary file
- ✅ Implements basic WordPiece tokenization
- ✅ Handles contractions
- ❌ Doesn't match HuggingFace's exact pre-tokenization
- ❌ May not handle all edge cases

## Testing

To verify tokenization matches, compare outputs:

```python
# Python (correct)
from transformers import AutoTokenizer
tokenizer = AutoTokenizer.from_pretrained("distilbert-base-uncased")
ids = tokenizer("I am happy", return_tensors="np", padding='max_length', 
                max_length=128, truncation=True)["input_ids"][0]
print(ids[:10])  # First 10 token IDs
```

Compare with our Dart output in debug logs.

## Recommendation

For a production app, use **Option 1 (Platform Channel)** to ensure exact tokenization match. For development/testing, continue improving our implementation to get closer to HuggingFace's behavior.

