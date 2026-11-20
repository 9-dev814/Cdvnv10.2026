#!/usr/bin/env python3
import hashlib, os

base_dir = os.path.dirname(os.path.abspath(__file__))
manifest_path = os.path.join(base_dir, "SHA256SUMS.txt")

with open(manifest_path, "r", encoding="utf-8") as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        expected_hash, rel_name = line.split("  ", 1)
        rel_name = rel_name.strip()
        if os.path.isabs(rel_name) or ".." in rel_name.split("/"):
            raise ValueError(f"Unsafe path in manifest: {rel_name}")
        target = os.path.join(base_dir, rel_name)
        with open(target, "rb") as tf:
            actual = hashlib.sha256(tf.read()).hexdigest()
        print(f"{rel_name}: {'OK' if actual == expected_hash else 'MISMATCH'}")
