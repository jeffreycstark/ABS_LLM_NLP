#!/usr/bin/env python3
"""
Final corrections to reverse_scales wave files.

Fixes three issues:
1. Replace 'tog' with proper wave assignment 'w1 <- w1 %>%'
2. Remove 0 from all missing codes (user: "absolutely no zero")
3. Distinguish 10-point scales from short Likert scales

Missing code strategy:
- Short Likert (2-6 point): c(-1, 7, 8, 9, 98, 99)
- 10-point scales: c(-1, 97, 98, 99)  # 7, 8, 9 are VALID responses
"""

import re
from pathlib import Path

# Standard missing codes for different scale types
LIKERT_MISSING = "c(-1, 7, 8, 9, 98, 99)"  # Short scales (2-6 point)
TENPOINT_MISSING = "c(-1, 97, 98, 99)"  # 10-point scales (7,8,9 are valid)

# Known 10-point scale variables
TENPOINT_VARS = {
    "W5": ["q92", "q93", "q94", "q95"],
    "W6_Cambodia": ["q92", "q93", "q94", "q95"],
}


def fix_missing_codes(content, wave_name):
    """Fix missing codes based on scale type."""

    # Pattern to match function definitions with variable names
    # Captures: function_name, variable_name, missing_codes
    pattern = (
        r"(mutate\((\w+)_reversed\s*=\s*if_else\([^)]+\s+(safe_reverse_\w+)\((\w+)\))"
    )

    def replacement(match):
        full_match = match.group(0)
        var_name = match.group(2)  # e.g., 'q92'

        # Check if this is a 10-point scale variable
        if wave_name in TENPOINT_VARS and var_name in TENPOINT_VARS[wave_name]:
            # 10-point scale: use different missing codes
            return full_match  # We'll handle this separately
        else:
            return full_match

    # First pass: identify mutations
    content = re.sub(pattern, replacement, content)

    # Now standardize ALL missing_codes parameters
    # Default to short Likert pattern
    content = re.sub(
        r"missing_codes\s*=\s*c\([^)]+\)", f"missing_codes = {LIKERT_MISSING}", content
    )

    # Special handling for 10-point scales
    # Find specific 10-point variable functions and update them
    if wave_name in TENPOINT_VARS:
        for var in TENPOINT_VARS[wave_name]:
            # Pattern to find this specific variable's reversal
            var_pattern = rf"(# {var}:.*?mutate\({var}_reversed.*?safe_reverse_\w+\s*=\s*function\(x,\s*)(missing_codes\s*=\s*c\([^)]+\))"

            def replace_10pt(m):
                return m.group(1) + f"missing_codes = {TENPOINT_MISSING}"

            content = re.sub(var_pattern, replace_10pt, content, flags=re.DOTALL)

    return content


def fix_w1_tog(content):
    """Replace 'tog' with proper wave assignment."""
    return content.replace("\ntog\n", "\nw1 <- w1 %>%\n")


def main():
    """Process all wave files."""
    scripts_dir = Path("scripts")

    wave_files = [
        ("reverse_scales_W1.R", "W1"),
        ("reverse_scales_W2.R", "W2"),
        ("reverse_scales_W3.R", "W3"),
        ("reverse_scales_W4.R", "W4"),
        ("reverse_scales_W5.R", "W5"),
        ("reverse_scales_W6_Cambodia.R", "W6_Cambodia"),
    ]

    for filename, wave_name in wave_files:
        filepath = scripts_dir / filename

        print(f"\n{'=' * 60}")
        print(f"Processing {filename}")
        print(f"{'=' * 60}")

        with open(filepath, "r") as f:
            content = f.read()

        # Apply fixes
        if wave_name == "W1":
            content = fix_w1_tog(content)
            print("✓ Fixed 'tog' → 'w1 <- w1 %>%'")

        content = fix_missing_codes(content, wave_name)

        if wave_name in TENPOINT_VARS:
            print(
                f"✓ Applied 10-point scale handling for: {', '.join(TENPOINT_VARS[wave_name])}"
            )

        # Count changes
        likert_count = content.count(LIKERT_MISSING)
        tenpoint_count = (
            content.count(TENPOINT_MISSING) if wave_name in TENPOINT_VARS else 0
        )

        print(f"  - Short Likert functions: {likert_count}")
        if tenpoint_count > 0:
            print(f"  - 10-point scale functions: {tenpoint_count}")

        # Write corrected file
        with open(filepath, "w") as f:
            f.write(content)

        print(f"✓ Saved corrected {filename}")

    print(f"\n{'=' * 60}")
    print("All corrections complete!")
    print(f"{'=' * 60}")


if __name__ == "__main__":
    main()
