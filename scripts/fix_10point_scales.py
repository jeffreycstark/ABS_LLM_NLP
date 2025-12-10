#!/usr/bin/env python3
"""
Fix 10-point scale handling in W5 and W6.

For q92-q95 which are 10-point scales:
1. Add safe_reverse_10pt() function definition
2. Change function calls from safe_reverse_6pt to safe_reverse_10pt
3. Use missing codes that exclude 7, 8, 9 (valid responses on 10-point scale)
"""

import re
from pathlib import Path

TENPOINT_FUNCTION = """
safe_reverse_10pt <- function(x, missing_codes = c(-1, 97, 98, 99)) {
  dplyr::case_when(
    x %in% 1:10 ~ 11 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}
"""

def add_10pt_function(content):
    """Add safe_reverse_10pt function after other scale functions."""
    # Find the last safe_reverse function
    pattern = r'(safe_reverse_\d+pt <- function\(x, missing_codes[^}]+\})\n'
    matches = list(re.finditer(pattern, content))

    if matches:
        last_match = matches[-1]
        insert_pos = last_match.end()
        content = content[:insert_pos] + TENPOINT_FUNCTION + content[insert_pos:]

    return content

def fix_10pt_calls(content):
    """Change safe_reverse_6pt(q92-95) to safe_reverse_10pt()."""
    for var in ['q92', 'q93', 'q94', 'q95']:
        # Pattern: safe_reverse_6pt(q9X)
        pattern = rf'safe_reverse_6pt\({var}\)'
        replacement = f'safe_reverse_10pt({var})'
        content = re.sub(pattern, replacement, content)

    return content

def process_wave(filepath, wave_name):
    """Process a single wave file."""
    print(f"\nProcessing {wave_name}...")

    with open(filepath, 'r') as f:
        content = f.read()

    # Check if file needs 10-point handling
    if not any(f'q9{i}' in content for i in [2, 3, 4, 5]):
        print(f"  No q92-95 found, skipping")
        return

    # Add function if not already present
    if 'safe_reverse_10pt' not in content:
        content = add_10pt_function(content)
        print(f"  ✓ Added safe_reverse_10pt() function")
    else:
        print(f"  • safe_reverse_10pt() already exists")

    # Fix function calls
    original = content
    content = fix_10pt_calls(content)

    changes = sum(1 for var in ['q92', 'q93', 'q94', 'q95'] if f'safe_reverse_10pt({var})' in content)
    if changes > 0:
        print(f"  ✓ Changed {changes} variables to use safe_reverse_10pt()")

    # Write back
    with open(filepath, 'w') as f:
        f.write(content)

    print(f"  ✓ Saved {filepath.name}")

def main():
    scripts_dir = Path('scripts')

    print("="*60)
    print("10-Point Scale Fix for q92-q95")
    print("="*60)

    # Process W5 and W6
    process_wave(scripts_dir / 'reverse_scales_W5.R', 'W5')
    process_wave(scripts_dir / 'reverse_scales_W6_Cambodia.R', 'W6_Cambodia')

    print("\n" + "="*60)
    print("Complete! q92-q95 now use:")
    print("  • safe_reverse_10pt() function")
    print("  • missing_codes = c(-1, 97, 98, 99)")
    print("  • Values 7, 8, 9 are VALID responses")
    print("="*60)

if __name__ == '__main__':
    main()
