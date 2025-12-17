#!/usr/bin/env python3
"""
Split reverse_scales.R into wave-specific files with corrected missing codes.
Standardizes all Likert scales to use: c(-1, 7, 8, 9, 98, 99)
"""

import re
from pathlib import Path

# Standard missing codes for all Likert scales
STANDARD_MISSING = "c(-1, 7, 8, 9, 98, 99)"


def standardize_missing_codes(content):
    """Replace all missing_codes parameters with standard pattern."""

    # Pattern to match: missing_codes = c(...)
    pattern = r"missing_codes\s*=\s*c\([^)]+\)"
    replacement = f"missing_codes = {STANDARD_MISSING}"

    return re.sub(pattern, replacement, content)


def extract_wave_section(lines, start_idx, end_idx, wave_name):
    """Extract a wave section and return corrected content."""

    wave_lines = lines[start_idx:end_idx]
    content = "".join(wave_lines)

    # Standardize missing codes
    content = standardize_missing_codes(content)

    # Add header
    header = f"""# ============================================================
# Asian Barometer {wave_name} - Scale Reversal Script
# Corrected with standardized missing value codes
# ============================================================
#
# This script reverses scales where higher values indicate
# LESS of the attribute (e.g., 1=Satisfied, 4=Dissatisfied)
#
# Each recoding includes:
# 1. Scale-specific reversal function with STANDARDIZED missing codes
# 2. Keyword validation via grepl() to ensure correct question
# 3. Missing value handling: c(-1, 7, 8, 9, 98, 99)
# 4. Outlier detection
#
# STANDARDIZED MISSING CODES:
#   -1  = Explicit missing/refusal
#   7   = Likert NA (Don't know, Not applicable, Refused)
#   8   = Likert NA (Don't know, Not applicable, Refused)
#   9   = Likert NA (Don't know, Not applicable, Refused)
#   98  = Other missing code
#   99  = Other missing code
# ============================================================

library(dplyr)

"""

    return header + content


def main():
    """Main processing."""

    # Read original file
    with open("reverse_scales.R", "r") as f:
        lines = f.readlines()

    # Define wave boundaries (line numbers from grep output)
    waves = [
        ("W1", 16, 135),
        ("W2", 140, 618),
        ("W3", 623, 1133),
        ("W4", 1138, 1760),
        ("W5", 1765, 2315),
        ("W6_Cambodia", 2320, 3332),
    ]

    # Create scripts directory if doesn't exist
    scripts_dir = Path("scripts")
    scripts_dir.mkdir(exist_ok=True)

    # Process each wave
    for wave_name, start, end in waves:
        print(f"\nProcessing {wave_name}...")

        # Extract and correct
        corrected_content = extract_wave_section(lines, start, end, wave_name)

        # Write to new file
        output_file = scripts_dir / f"reverse_scales_{wave_name}.R"
        with open(output_file, "w") as f:
            f.write(corrected_content)

        print(f"✓ Created: {output_file}")

        # Count functions
        func_count = len(re.findall(r"safe_reverse_\w+pt", corrected_content))
        var_count = len(re.findall(r"mutate\([a-z0-9_]+_reversed", corrected_content))

        print(f"  - {func_count} reversal functions")
        print(f"  - {var_count} variables reversed")

    print("\n" + "=" * 60)
    print("✓ All wave-specific files created")
    print("  Location: scripts/reverse_scales_W*.R")
    print("  Missing codes standardized to: c(-1, 7, 8, 9, 98, 99)")
    print("=" * 60)


if __name__ == "__main__":
    main()
