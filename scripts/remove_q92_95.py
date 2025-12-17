#!/usr/bin/env python3
"""
Remove q92-q95 from reverse_scales files.

User clarification: "Q92-q95 should not be reversed. Other values should probably be NA"

These are 10-point scales that are already in the correct direction.
They should be cleaned (invalid values → NA) but NOT reversed.
"""

import re
from pathlib import Path


def remove_variable_reversal(content, var_name):
    """Remove a variable's reversal code block."""
    # Pattern to match the entire variable block:
    # - Comment line with variable name
    # - Keyword validation comment
    # - mutate() call with if_else and grepl
    # - Closing parentheses
    pattern = rf"  # {var_name}:.*?\n  # Keyword validation:.*?\n  mutate\({var_name}_reversed.*?\)\),\n\n"

    content = re.sub(pattern, "", content, flags=re.DOTALL)

    return content


def remove_10pt_function(content):
    """Remove the safe_reverse_10pt function since it's not needed."""
    pattern = r"\nsafe_reverse_10pt <- function\(x, missing_codes[^}]+\}\n"
    content = re.sub(pattern, "", content)
    return content


def main():
    scripts_dir = Path("scripts")
    filepath = scripts_dir / "reverse_scales_W5.R"

    print("=" * 60)
    print("Removing q92-q95 from reverse_scales_W5.R")
    print("=" * 60)
    print("\nReason: These are 10-point scales already in correct direction")
    print("They should be cleaned (invalid → NA) but NOT reversed")

    with open(filepath, "r") as f:
        content = f.read()

    # Remove each variable
    for var in ["q92", "q93", "q94", "q95"]:
        if f"{var}_reversed" in content:
            content = remove_variable_reversal(content, var)
            print(f"\n  ✓ Removed {var}_reversed")

    # Remove the 10pt function
    if "safe_reverse_10pt" in content:
        content = remove_10pt_function(content)
        print("\n  ✓ Removed safe_reverse_10pt() function (no longer needed)")

    # Write back
    with open(filepath, "w") as f:
        f.write(content)

    print(f"\n  ✓ Saved {filepath.name}")

    print("\n" + "=" * 60)
    print("Complete! q92-q95 will NOT be reversed.")
    print("Handle these separately in data cleaning:")
    print("  - Keep values 1-10 as valid responses")
    print("  - Recode all other values to NA")
    print("=" * 60)


if __name__ == "__main__":
    main()
