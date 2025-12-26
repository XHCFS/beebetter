// lib/services/emotion_inference/text_emotion_service.dart

import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';
import 'package:transformers/transformers.dart';
import 'dart:math' as math;

/// Service for text-based emotion inference using DistilBERT model
/// Trained on GoEmotions dataset
class TextEmotionService {
  OrtSession? _session;
  bool _isInitialized = false;
  
  // Model configuration
  // Note: The notebook exports the quantized model as 'emotion_model.onnx'
  // If that file exists, use it; otherwise fall back to 'model_quantized.onnx'
  static const String _modelPath = 'assets/models/mobile_text_model/emotion_model.onnx';
  static const String _vocabPath = 'assets/models/mobile_text_model/vocab.txt';
  static const int _maxSequenceLength = 128; // Match training config
  static const int _vocabSize = 30522;
  static const int _numLabels = 7;
  
  // Use transformers package tokenizer
  BertTokenizer? _tokenizer;
  
  // Label names mapping (LABEL_0 to LABEL_6)
  // Update this if your model uses a different label order
  static const List<String> _labelNames = [
    'angry',      // LABEL_0
    'disgust',    // LABEL_1
    'fear',       // LABEL_2
    'happy',      // LABEL_3
    'neutral',    // LABEL_4
    'sad',        // LABEL_5
    'surprise',   // LABEL_6
  ];
  
  /// Get the label name for a given index
  static String getLabelName(int index) {
    if (index >= 0 && index < _labelNames.length) {
      return _labelNames[index];
    }
    return 'LABEL_$index';
  }
  
  /// Get all label names
  static List<String> getLabelNames() => List.unmodifiable(_labelNames);
  
  // Special tokens (DistilBERT uses BERT tokenizer)
  static const int _clsTokenId = 101;
  static const int _sepTokenId = 102;
  static const int _padTokenId = 0;
  static const int _unkTokenId = 100; // Unknown token
  
  /// Initialize the model session and load tokenizer
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize tokenizer from transformers package
      // DistilBERT uses the same tokenizer as BERT
      final options = PretrainedTokenizerOptions();
      final (tokenizerJSON, tokenizerConfig) = await loadTokenizer(
        'distilbert-base-uncased',
        options,
      );
      _tokenizer = BertTokenizer(tokenizerJSON, tokenizerConfig);
      print('Loaded BERT tokenizer for DistilBERT');
      
      // Load model
      final modelData = await rootBundle.load(_modelPath);
      final sessionOptions = OrtSessionOptions();
      
      _session = OrtSession.fromBuffer(
        modelData.buffer.asUint8List(),
        sessionOptions,
      );
      
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize text emotion model: $e');
    }
  }
  
  
  /// Dispose of the session
  void dispose() {
    _session?.release();
    _session = null;
    _isInitialized = false;
  }
  
  /// Tokenize text using the transformers package BertTokenizer
  /// This matches the HuggingFace DistilBERT tokenizer exactly
  /// Returns both input_ids and attention_mask
  Future<Map<String, List<int>>> _tokenize(String text) async {
    if (_tokenizer == null) {
      throw Exception('Tokenizer not loaded. Call initialize() first.');
    }
    
    // Use the transformers package to encode the text
    // The call method returns a BatchEncoding with input_ids, attention_mask, etc.
    final encoding = await _tokenizer!(
      text,
      padding: true,  // Pad to max_length
      truncation: true,
      max_length: _maxSequenceLength,
      return_tensor: false,
    );
    
    // Extract input_ids and attention_mask from the encoding
    // BatchEncoding has these as properties
    // Since return_tensor is false and we have a single input, they should be List<int>
    var inputIds = encoding.input_ids;
    var attentionMask = encoding.attention_mask;
    
    // Handle case where it might be nested (batched) - unwrap if needed
    if (inputIds is List && inputIds.isNotEmpty && inputIds[0] is List) {
      inputIds = (inputIds as List).first;
      attentionMask = (attentionMask as List).first;
    }
    
    final inputIdsList = (inputIds as List).cast<int>();
    final attentionMaskList = (attentionMask as List).cast<int>();
    
    // Ensure correct length (should already be 128, but double-check)
    final paddedInputIds = List<int>.from(inputIdsList);
    final paddedAttentionMask = List<int>.from(attentionMaskList);
    
    while (paddedInputIds.length < _maxSequenceLength) {
      paddedInputIds.add(_padTokenId);
      paddedAttentionMask.add(0);
    }
    if (paddedInputIds.length > _maxSequenceLength) {
      paddedInputIds.removeRange(_maxSequenceLength, paddedInputIds.length);
      paddedAttentionMask.removeRange(_maxSequenceLength, paddedAttentionMask.length);
    }
    
    // Debug: Print tokenization for first few tokens
    if (paddedInputIds.length > 3) {
      print('DEBUG Tokenization: Text="$text"');
      print('DEBUG First 10 token IDs: ${paddedInputIds.take(10).toList()}');
      // Try to decode first few tokens
      final firstTokens = paddedInputIds.take(10).map((tid) {
        try {
          final token = _tokenizer!.model.vocab[tid] ?? '?';
          return '$token($tid)';
        } catch (e) {
          return '?($tid)';
        }
      }).toList();
      print('DEBUG First 10 tokens: $firstTokens');
    }
    
    return {
      'input_ids': paddedInputIds,
      'attention_mask': paddedAttentionMask,
    };
  }
  
  /// Pad or truncate tokens to fixed length
  List<int> _padOrTruncate(List<int> tokens, int maxLength) {
    if (tokens.length > maxLength) {
      // Truncate: keep CLS, truncate middle, keep SEP if possible
      final truncated = <int>[tokens[0]]; // CLS
      final middleTokens = tokens.sublist(1, tokens.length - 1);
      final toKeep = maxLength - 2; // Reserve space for CLS and SEP
      
      if (middleTokens.length > toKeep) {
        truncated.addAll(middleTokens.sublist(0, toKeep));
      } else {
        truncated.addAll(middleTokens);
      }
      
      truncated.add(_sepTokenId); // SEP
      return truncated;
    } else {
      // Pad
      final padded = List<int>.from(tokens);
      while (padded.length < maxLength) {
        padded.add(_padTokenId);
      }
      return padded;
    }
  }
  
  /// Create attention mask
  List<int> _createAttentionMask(List<int> tokens) {
    return tokens.map((token) => token == _padTokenId ? 0 : 1).toList();
  }
  
  /// Split long text into token-based chunks for processing
  /// Each chunk will be at most 128 tokens (accounting for CLS and SEP)
  /// Returns list of text chunks that will fit within the token limit
  Future<List<String>> _chunkTextByTokens(String text) async {
    if (!_isInitialized || _tokenizer == null) {
      throw Exception('Model not initialized. Call initialize() first.');
    }
    
    // First, check if the entire text fits in one chunk
    final fullEncoding = await _tokenizer!(
      text,
      max_length: 10000, // Large enough to not truncate
      padding: false,
      truncation: false,
      return_tensor: false,
    );
    
    var fullInputIds = fullEncoding.input_ids;
    if (fullInputIds is List && fullInputIds.isNotEmpty && fullInputIds[0] is List) {
      fullInputIds = (fullInputIds as List).first;
    }
    final fullTokenIds = (fullInputIds as List).cast<int>();
    
    // If text fits in one chunk (accounting for CLS and SEP), return as-is
    if (fullTokenIds.length <= _maxSequenceLength) {
      return [text];
    }
    
    // Text is too long, need to chunk it
    // Strategy: Split text into chunks and verify each fits in token limit
    // Use approximate 4 chars per token as starting point
    final maxContentTokens = _maxSequenceLength - 2; // Reserve for CLS and SEP
    final approximateCharsPerToken = 4;
    final initialChunkSize = maxContentTokens * approximateCharsPerToken;
    
    final chunks = <String>[];
    var start = 0;
    
    while (start < text.length) {
      var end = (start + initialChunkSize).clamp(0, text.length);
      
      // Try to break at sentence boundary first, then word boundary
      if (end < text.length) {
        // Look for sentence endings
        final sentenceEnd = text.lastIndexOf(RegExp(r'[.!?]\s+'), end);
        if (sentenceEnd > start + initialChunkSize * 0.5) {
          end = sentenceEnd + 1;
        } else {
          // Fall back to word boundary
          final wordEnd = text.lastIndexOf(' ', end);
          if (wordEnd > start) {
            end = wordEnd;
          }
        }
      }
      
      var chunk = text.substring(start, end).trim();
      
      // Verify this chunk fits in token limit
      final chunkEncoding = await _tokenizer!(
        chunk,
        max_length: 10000,
        padding: false,
        truncation: false,
        return_tensor: false,
      );
      
      var chunkInputIds = chunkEncoding.input_ids;
      if (chunkInputIds is List && chunkInputIds.isNotEmpty && chunkInputIds[0] is List) {
        chunkInputIds = (chunkInputIds as List).first;
      }
      final chunkTokenIds = (chunkInputIds as List).cast<int>();
      
      // If chunk is still too long, split it by sentences
      if (chunkTokenIds.length > _maxSequenceLength) {
        final sentences = chunk.split(RegExp(r'[.!?]\s+'));
        var currentSubChunk = '';
        
        for (final sentence in sentences) {
          final testChunk = currentSubChunk.isEmpty 
              ? sentence.trim()
              : '$currentSubChunk. ${sentence.trim()}';
          
          if (testChunk.isEmpty) continue;
          
          final testEncoding = await _tokenizer!(
            testChunk,
            max_length: 10000,
            padding: false,
            truncation: false,
            return_tensor: false,
          );
          
          var testInputIds = testEncoding.input_ids;
          if (testInputIds is List && testInputIds.isNotEmpty && testInputIds[0] is List) {
            testInputIds = (testInputIds as List).first;
          }
          final testTokenIds = (testInputIds as List).cast<int>();
          
          if (testTokenIds.length <= _maxSequenceLength) {
            currentSubChunk = testChunk;
          } else {
            if (currentSubChunk.isNotEmpty) {
              chunks.add(currentSubChunk);
            }
            // If even a single sentence is too long, we'll truncate it
            // (This shouldn't happen often, but handle it gracefully)
            if (testTokenIds.length > _maxSequenceLength) {
              chunks.add(sentence.trim());
            } else {
              currentSubChunk = sentence.trim();
            }
          }
        }
        
        if (currentSubChunk.isNotEmpty) {
          chunks.add(currentSubChunk);
        }
      } else {
        chunks.add(chunk);
      }
      
      start = end;
    }
    
    return chunks.isEmpty ? [text] : chunks;
  }
  
  /// Run inference on a single text chunk
  Future<List<double>> _inferChunk(String text) async {
    if (!_isInitialized || _session == null) {
      throw Exception('Model not initialized. Call initialize() first.');
    }
    
    // Tokenize - returns both input_ids and attention_mask
    final tokenized = await _tokenize(text);
    final tokens = tokenized['input_ids']!;
    final attentionMask = tokenized['attention_mask']!;
    
    // Debug: Print actual input values
    print('DEBUG Input tokens (first 20): ${tokens.take(20).toList()}');
    print('DEBUG Attention mask (first 20): ${attentionMask.take(20).toList()}');
    
    // Convert to tensors
    final inputIds = OrtValueTensor.createTensorWithDataList(
      tokens,
      [1, _maxSequenceLength],
    );
    
    final attentionMaskTensor = OrtValueTensor.createTensorWithDataList(
      attentionMask,
      [1, _maxSequenceLength],
    );
    
    // Run inference
    // Verified tensor names: 'input_ids', 'attention_mask' (inputs), 'logits' (output)
    final inputs = {
      'input_ids': inputIds,
      'attention_mask': attentionMaskTensor,
    };
    
    // Debug: Verify tensor values before inference
    final inputIdsValue = inputIds.value as List;
    final attentionMaskValue = attentionMaskTensor.value as List;
    print('DEBUG Tensor input_ids (first 20): ${(inputIdsValue[0] as List).take(20).toList()}');
    print('DEBUG Tensor attention_mask (first 20): ${(attentionMaskValue[0] as List).take(20).toList()}');
    
    final outputs = _session!.run(OrtRunOptions(), inputs);
    
    // Get logits (output shape: [1, num_labels])
    // Outputs is a List<OrtValue?>, access by index
    final logitsTensor = outputs[0] as OrtValueTensor;
    final logits = logitsTensor.value as List<List<double>>;
    
    // Debug: Print output tensor info
    print('DEBUG Output tensor shape: ${logits.length}x${logits[0].length}');
    
    // Clean up
    inputIds.release();
    attentionMaskTensor.release();
    for (final output in outputs) {
      output?.release();
    }
    
    // Apply softmax for single-label classification (matches training)
    final logitsList = logits[0];
    final maxLogit = logitsList.reduce((a, b) => a > b ? a : b);
    final expLogits = logitsList.map((x) => math.exp(x - maxLogit)).toList();
    final sumExp = expLogits.reduce((a, b) => a + b);
    final probabilities = expLogits.map((x) => x / sumExp).toList();
    
    // Debug: Print raw logits and probabilities
    print('DEBUG Raw logits: $logitsList');
    print('DEBUG Probabilities: $probabilities');
    final maxIdx = probabilities.indexWhere((p) => p == probabilities.reduce((a, b) => a > b ? a : b));
    print('DEBUG Predicted label: ${TextEmotionService.getLabelName(maxIdx)} (index $maxIdx, confidence: ${probabilities[maxIdx].toStringAsFixed(4)})');
    
    return probabilities;
  }
  
  /// Predict emotions from text
  /// Returns a map of label indices to confidence scores
  /// Handles long text by chunking into 128-token segments and averaging predictions
  Future<Map<int, double>> predictEmotions(String text) async {
    if (text.trim().isEmpty) {
      throw ArgumentError('Text cannot be empty');
    }
    
    // Handle long text by chunking based on token count (128 tokens per chunk)
    final chunks = await _chunkTextByTokens(text);
    final allPredictions = <List<double>>[];
    
    print('DEBUG: Processing ${chunks.length} chunk(s) for text of length ${text.length}');
    
    // Run inference on each chunk
    for (var i = 0; i < chunks.length; i++) {
      final chunk = chunks[i];
      print('DEBUG: Processing chunk ${i + 1}/${chunks.length} (${chunk.length} chars)');
      final predictions = await _inferChunk(chunk);
      allPredictions.add(predictions);
    }
    
    // Aggregate predictions by averaging probability distributions across all chunks
    final aggregated = List<double>.filled(_numLabels, 0.0);
    for (final predictions in allPredictions) {
      for (var i = 0; i < _numLabels; i++) {
        aggregated[i] += predictions[i];
      }
    }
    
    // Average across all chunks
    for (var i = 0; i < _numLabels; i++) {
      aggregated[i] /= allPredictions.length;
    }
    
    print('DEBUG: Averaged ${allPredictions.length} prediction(s)');
    
    // Convert to map
    final result = <int, double>{};
    for (var i = 0; i < _numLabels; i++) {
      result[i] = aggregated[i];
    }
    
    return result;
  }
  
  /// Get top N emotions with highest confidence
  Future<List<MapEntry<int, double>>> getTopEmotions(
    String text, {
    int topN = 3,
    double threshold = 0.3,
  }) async {
    final predictions = await predictEmotions(text);
    
    final entries = predictions.entries
        .where((e) => e.value >= threshold)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return entries.take(topN).toList();
  }
}

