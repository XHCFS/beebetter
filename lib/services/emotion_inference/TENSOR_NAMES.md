# Tensor Name Mismatches - Explanation

## What are Tensor Names?

When you export a model to ONNX format, each input and output has a **name**. These names are like variable names - they identify which tensor is which.

For example:
- **Input tensors**: `input_ids`, `attention_mask`, `input_values`
- **Output tensors**: `logits`, `output`, `output_0`

## The Problem

The code I wrote assumes specific tensor names:

### Text Model (DistilBERT)
```dart
final inputs = {
  'input_ids': inputIds,           // ← Assumes this name
  'attention_mask': attentionMaskTensor,  // ← Assumes this name
};
final outputs = await _session!.run(OrtRunOptions(), inputs);
final logitsTensor = outputs[0];  // ← Assumes first output
```

### Voice Model (DistilHuBERT)
```dart
final inputs = {
  'input_values': inputTensor,  // ← Assumes this name
};
final outputs = await _session!.run(OrtRunOptions(), inputs);
final logitsTensor = outputs[0];  // ← Assumes first output
```

**If your ONNX models use different names, the code will fail with errors like:**
- `InvalidArgument: [ONNXRuntimeError] : 2 : INVALID_ARGUMENT : Invalid Feed Input Name: input_ids`
- `KeyError: 'input_values' not found`

## How to Check Your Model's Tensor Names

### Method 1: Using Python (Recommended)

```python
import onnx

# Load your model
model = onnx.load("assets/models/mobile_text_model/model_quantized.onnx")

# Check input names
print("Input names:")
for input_tensor in model.graph.input:
    print(f"  - {input_tensor.name}")

# Check output names
print("\nOutput names:")
for output_tensor in model.graph.output:
    print(f"  - {output_tensor.name}")
```

### Method 2: Using Netron (Visual Tool)

1. Install Netron: `pip install netron` or download from https://netron.app
2. Open your ONNX file: `netron assets/models/mobile_text_model/model_quantized.onnx`
3. Click on the input/output nodes to see their names

### Method 3: Using ONNX Runtime in Python

```python
import onnxruntime as ort

session = ort.InferenceSession("model_quantized.onnx")

print("Input names:", [input.name for input in session.get_inputs()])
print("Output names:", [output.name for output in session.get_outputs()])
```

## Common Tensor Name Variations

### Text Models (BERT/DistilBERT)
**Inputs:**
- `input_ids` (most common)
- `input` (sometimes)
- `token_ids` (rare)

- `attention_mask` (most common)
- `mask` (sometimes)
- `attention_mask_0` (rare)

**Outputs:**
- `logits` (most common)
- `output` (sometimes)
- `output_0` (sometimes)
- `output_1` (if multiple outputs)

### Voice Models (HuBERT/Wav2Vec2)
**Inputs:**
- `input_values` (most common for HuggingFace models)
- `input` (sometimes)
- `audio` (rare)

**Outputs:**
- `logits` (most common)
- `output` (sometimes)
- `output_0` (sometimes)

## How to Fix Mismatches

If your model uses different names, update the code:

### Example 1: Different Input Name
```dart
// If your model uses 'input' instead of 'input_ids'
final inputs = {
  'input': inputIds,  // ← Changed from 'input_ids'
  'attention_mask': attentionMaskTensor,
};
```

### Example 2: Different Output Name
```dart
// If your model outputs are named differently
final outputs = await _session!.run(OrtRunOptions(), inputs);

// Try accessing by name instead of index
final logitsTensor = outputs['logits'] as OrtValueTensor;
// OR
final logitsTensor = outputs['output'] as OrtValueTensor;
// OR
final logitsTensor = outputs['output_0'] as OrtValueTensor;
```

### Example 3: Multiple Outputs
```dart
// If your model has multiple outputs, you might need:
final outputs = await _session!.run(OrtRunOptions(), inputs);
final logitsTensor = outputs['logits'] as OrtValueTensor;  // First output
// OR if it's the second output:
final logitsTensor = outputs[1] as OrtValueTensor;
```

## Testing Your Model

After updating the tensor names, test with a simple input:

```dart
try {
  final predictions = await _textService.predictEmotions("test");
  print("Success! Predictions: $predictions");
} catch (e) {
  print("Error: $e");
  // Check the error message - it often tells you the expected tensor name
}
```

## Quick Fix Script

If you find the correct names, update these files:
1. `lib/services/emotion_inference/text_emotion_service.dart` (line ~180)
2. `lib/services/emotion_inference/voice_emotion_service.dart` (line ~189)

Then rebuild and test!

