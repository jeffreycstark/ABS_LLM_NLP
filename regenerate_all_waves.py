#!/usr/bin/env python3
"""
Regenerate all wave files with fixed parse_labels.py
"""

import subprocess
import sys

waves = [
    ("W1_labels.txt", "W1_atomic.json"),
    ("W2_labels.txt", "W2_atomic.json"),
    ("W3_labels.txt", "W3_atomic.json"),
    ("W4_labels.txt", "W4_atomic.json"),
    ("W5_labels.txt", "W5_atomic.json"),
    ("W6_Cambodia_labels.txt", "W6_Cambodia_atomic.json"),
]

def regenerate_atomic():
    """Step 1: Regenerate atomic JSON for all waves"""
    print("=" * 60)
    print("STEP 1: Regenerating atomic JSON files")
    print("=" * 60)

    for input_file, output_file in waves:
        print(f"\n📝 Processing {input_file}...")

        # Call parse_labels.py with this wave
        cmd = f'python3 -c "from parse_labels import main; main(\'{input_file}\', \'{output_file}\')"'
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)

        if result.returncode == 0:
            print(f"✅ Generated {output_file}")
        else:
            print(f"❌ Failed to generate {output_file}")
            print(result.stderr)
            return False

    return True

def regenerate_enriched():
    """Step 2: Regenerate enriched JSON with concepts"""
    print("\n" + "=" * 60)
    print("STEP 2: Regenerating enriched JSON files")
    print("=" * 60)

    wave_names = ["W1", "W2", "W3", "W4", "W5", "W6_Cambodia"]

    for wave in wave_names:
        print(f"\n📝 Processing {wave}...")

        cmd = f'python3 -c "from extract_concepts import main; main(\'{wave}_atomic.json\', \'{wave}_enriched.json\', \'{wave}_crosswalk.json\')"'
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)

        if result.returncode == 0:
            print(f"✅ Generated {wave}_enriched.json")
        else:
            print(f"❌ Failed to generate {wave}_enriched.json")
            print(result.stderr)
            return False

    return True

def regenerate_csv():
    """Step 3: Regenerate CSV files"""
    print("\n" + "=" * 60)
    print("STEP 3: Regenerating CSV files")
    print("=" * 60)

    wave_names = ["W1", "W2", "W3", "W4", "W5", "W6_Cambodia"]

    for wave in wave_names:
        print(f"\n📝 Processing {wave}...")

        cmd = f'python3 -c "from generate_csv import json_to_csv; json_to_csv(\'{wave}_enriched.json\', \'{wave}_concepts.csv\', \'{wave}_concepts_detailed.csv\')"'
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)

        if result.returncode == 0:
            print(f"✅ Generated {wave}_concepts.csv and {wave}_concepts_detailed.csv")
        else:
            print(f"❌ Failed to generate CSV files for {wave}")
            print(result.stderr)
            return False

    return True

if __name__ == "__main__":
    print("🚀 Starting regeneration of all wave files with fixed parser\n")

    if not regenerate_atomic():
        sys.exit(1)

    if not regenerate_enriched():
        sys.exit(1)

    if not regenerate_csv():
        sys.exit(1)

    print("\n" + "=" * 60)
    print("✅ ALL FILES REGENERATED SUCCESSFULLY!")
    print("=" * 60)
