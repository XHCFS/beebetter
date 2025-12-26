#!/usr/bin/env python3
"""
Download DistilBERT vocabulary file from HuggingFace
Run this script to download vocab.json to assets/models/mobile_text_model/
"""

import json
import urllib.request
import os
from pathlib import Path

def download_vocab():
    """Download DistilBERT vocab.json from HuggingFace"""
    # Try multiple possible URLs
    vocab_urls = [
        "https://huggingface.co/distilbert-base-uncased/resolve/main/vocab.txt",
        "https://huggingface.co/distilbert-base-uncased/raw/main/vocab.txt",
        "https://huggingface.co/bert-base-uncased/resolve/main/vocab.txt",
    ]
    
    vocab_url = None
    for url in vocab_urls:
        try:
            print(f"Trying {url}...")
            urllib.request.urlretrieve(url, str(output_file))
            vocab_url = url
            break
        except:
            continue
    
    if vocab_url is None:
        raise Exception("Could not download vocab from any URL")
    output_dir = Path("assets/models/mobile_text_model")
    output_file = output_dir / "vocab.json"
    
    # Create directory if it doesn't exist
    output_dir.mkdir(parents=True, exist_ok=True)
    
    print(f"Downloading vocab.json from {vocab_url}...")
    try:
        urllib.request.urlretrieve(vocab_url, str(output_file))
        print(f"✓ Downloaded vocab.json to {output_file}")
        
        # Verify it's valid JSON
        with open(output_file, 'r') as f:
            vocab = json.load(f)
            print(f"✓ Vocab file is valid JSON with {len(vocab)} tokens")
            print(f"  Sample tokens: {list(vocab.items())[:10]}")
            
    except Exception as e:
        print(f"✗ Error downloading vocab: {e}")
        print("\nYou can also manually download it from:")
        print("https://huggingface.co/distilbert-base-uncased/raw/main/vocab.json")
        print(f"and save it to: {output_file}")

if __name__ == "__main__":
    download_vocab()

