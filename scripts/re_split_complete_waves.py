#!/usr/bin/env python3
"""
Re-split reverse_scales.R with CORRECT wave boundaries.

Previous error: Stopped at Summary lines, missing variables after that.
Correct approach: Extract from wave start to next wave start (or EOF).
"""

import re
from pathlib import Path

# Standard missing codes for all Likert scales
STANDARD_MISSING = "c(-1, 7, 8, 9, 98, 99)"


def standardize_missing_codes(content):
    """Replace all missing_codes parameters with standard pattern."""
    pattern = r"missing_codes\s*=\s*c\([^)]+\)"
    replacement = f"missing_codes = {STANDARD_MISSING}"
    return re.sub(pattern, replacement, content)


def fix_w1_tog(content):
    """Replace 'tog' with proper wave assignment."""
    return content.replace("\ntog\n", "\nw1 <- w1 %>%\n")


def extract_wave_section(lines, start_idx, end_idx, wave_name, wave_var):
    """Extract a wave section and return corrected content."""
    wave_lines = lines[start_idx:end_idx]
    content = "".join(wave_lines)

    # Standardize missing codes
    content = standardize_missing_codes(content)

    # Fix W1 tog issue
    if wave_name == "W1":
        content = fix_w1_tog(content)

    # Add wave assignment if not present
    if f"{wave_var} <- {wave_var} %>%" not in content:
        # Find where variable recodings start (after function definitions)
        pattern = r"(# [A-Z0-9_]+ Variable Recodings with Validation\s*#+ =+\s*\n)"

        def add_assignment(match):
            return match.group(1) + f"\n{wave_var} <- {wave_var} %>%\n"

        content = re.sub(pattern, add_assignment, content)

    # Add header
    header = f"""# ============================================================
# Asian Barometer {wave_name} - Scale Reversal Script
# Corrected with standardized missing value codes
# ============================================================
#
# STANDARDIZED MISSING CODES:
#   -1  = Explicit missing/refusal
#   7   = Likert NA (Don't know, Not applicable, Refused)
#   8   = Likert NA (Don't know, Not applicable, Refused)
#   9   = Likert NA (Don't know, Not applicable, Refused)
#   98  = Other missing code
#   99  = Other missing code
#
# NOTE: 0 is NOT included - requires manual evaluation for binary variables
# ============================================================

library(dplyr)

"""
    return header + content


def main():
    """Main processing with CORRECT wave boundaries."""
    with open("reverse_scales.R", "r") as f:
        lines = f.readlines()

    # CORRECTED wave boundaries - from wave start to next wave start
    waves = [
        ("W1", "w1", 16, 140),  # Lines 17-140
        ("W2", "w2", 140, 623),  # Lines 141-623
        ("W3", "w3", 623, 1138),  # Lines 624-1138
        ("W4", "w4", 1138, 1765),  # Lines 1139-1765
        ("W5", "w5", 1765, 2320),  # Lines 1766-2320
        ("W6_Cambodia", "w6_cambodia", 2320, 3335),  # Lines 2321-end
    ]

    scripts_dir = Path("scripts")
    scripts_dir.mkdir(exist_ok=True)

    print("\n" + "=" * 60)
    print("RE-EXTRACTING with CORRECT wave boundaries")
    print("=" * 60)

    for wave_name, wave_var, start, end in waves:
        print(f"\nProcessing {wave_name}...")
        corrected_content = extract_wave_section(lines, start, end, wave_name, wave_var)

        output_file = scripts_dir / f"reverse_scales_{wave_name}.R"
        with open(output_file, "w") as f:
            f.write(corrected_content)

        # Count variables
        var_count = len(re.findall(r"mutate\(\w+_reversed\s*=", corrected_content))
        func_count = len(
            re.findall(r"safe_reverse_\w+pt\s*<-\s*function", corrected_content)
        )

        print(f"  ✓ Extracted lines {start + 1}-{end}")
        print(f"  • {func_count} reversal functions")
        print(f"  • {var_count} variables reversed")
        print(f"  ✓ Created: {output_file}")

    print("\n" + "=" * 60)
    print("Complete! All waves re-extracted with full variable counts")
    print("=" * 60)


if __name__ == "__main__":
    main()
