"""
Generate R reversal functions with keyword validation

Creates wave-specific reversal functions that:
1. Validate questions using distinctive keywords
2. Handle scale-specific reversal (4pt, 5pt, 6pt, etc.)
3. Properly code missing values
4. Detect outliers
"""

import json
import re
from collections import defaultdict, Counter
from typing import List, Tuple


class RRecoderGenerator:
    """Generate validated R recoding functions"""

    def __init__(self):
        self.stop_words = {
            "the",
            "a",
            "an",
            "and",
            "or",
            "but",
            "in",
            "on",
            "at",
            "to",
            "for",
            "of",
            "with",
            "by",
            "from",
            "is",
            "are",
            "was",
            "were",
            "be",
            "been",
            "have",
            "has",
            "had",
            "do",
            "does",
            "did",
            "will",
            "would",
            "should",
            "could",
            "may",
            "might",
            "must",
            "can",
            "your",
            "you",
            "how",
            "what",
            "which",
            "when",
            "where",
            "who",
            "why",
            "that",
            "this",
            "these",
            "those",
            "question",
            "please",
            "following",
        }

    def build_word_frequency(
        self, all_questions: List[str], min_length: int = 5
    ) -> Counter:
        """Build word frequency across all questions in wave"""
        word_freq = Counter()

        for question in all_questions:
            text = question.lower()
            text = re.sub(r"[^\w\s]", " ", text)
            words = [
                w
                for w in text.split()
                if len(w) >= min_length and w not in self.stop_words
            ]
            word_freq.update(words)

        return word_freq

    def extract_distinctive_keyword(
        self, question_text: str, word_freq: Counter, min_length: int = 5
    ) -> str:
        """Extract most distinctive word from question using wave-wide frequency"""

        # Clean and split
        text = question_text.lower()
        text = re.sub(r"[^\w\s]", " ", text)
        words = [
            w for w in text.split() if len(w) >= min_length and w not in self.stop_words
        ]

        if not words:
            return question_text[:15]

        # Find word with lowest frequency (most distinctive)
        word_scores = {word: word_freq[word] for word in words}
        if word_scores:
            distinctive_word = min(word_scores.items(), key=lambda x: x[1])[0]
            return distinctive_word

        # Fallback
        return words[0] if words else question_text[:15]

    def generate_reversal_function(
        self,
        scale_type: str,
        scale_points: int,
        max_value: int,
        missing_codes: List[int],
    ) -> str:
        """
        Generate R reversal function for a specific scale type
        """
        func_name = f"safe_reverse_{scale_points}pt"

        # Calculate reversal formula: new = (max + 1) - old
        reverse_formula = f"{max_value + 1} - x"

        # Format missing codes
        missing_str = ", ".join(map(str, sorted(missing_codes)))

        r_code = f"""
{func_name} <- function(x, missing_codes = c({missing_str})) {{
  dplyr::case_when(
    x %in% 1:{max_value} ~ {reverse_formula},
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}}"""

        return r_code

    def generate_wave_recoding_script(
        self, wave_analyzed_file: str, wave_name: str
    ) -> str:
        """
        Generate complete R script for wave-specific recoding with keyword validation
        """
        print(f"Processing {wave_name}...")
        with open(wave_analyzed_file, "r", encoding="utf-8") as f:
            variables = json.load(f)

        # Extract all question texts and build word frequency
        all_questions = [v["question_text"] for v in variables]
        word_freq = self.build_word_frequency(all_questions)

        # Group variables by scale type that need reversal
        reversal_groups = defaultdict(list)
        for var in variables:
            sa = var["scale_analysis"]
            if sa["needs_reversal"]:
                scale_key = (
                    sa["scale_type"],
                    sa["scale_points"],
                    sa["max_substantive_value"],
                )
                reversal_groups[scale_key].append(var)

        if not reversal_groups:
            return f"# {wave_name}: No variables need reversal\n"

        # Start building R script
        r_script = [
            "# ============================================================",
            f"# {wave_name} Reversal Functions with Keyword Validation",
            "# Generated automatically from scale analysis",
            "# ============================================================\n",
            "library(dplyr)\n",
        ]

        # Generate reversal functions (one per scale type)
        generated_functions = set()
        for scale_key in sorted(reversal_groups.keys()):
            scale_type, scale_points, max_value = scale_key

            func_name = f"safe_reverse_{scale_points}pt"
            if func_name not in generated_functions:
                # Get typical missing codes for this scale
                sample_var = reversal_groups[scale_key][0]
                missing_codes = [
                    vl["value"]
                    for vl in sample_var["value_labels"]
                    if vl["value"] < 0
                    or vl["value"] >= 7
                    or any(
                        na_word in vl["label"].lower()
                        for na_word in [
                            "missing",
                            "don't know",
                            "can't choose",
                            "decline",
                            "not applicable",
                        ]
                    )
                ]
                missing_codes = sorted(set(missing_codes))

                r_code = self.generate_reversal_function(
                    scale_type, scale_points, max_value, missing_codes
                )
                r_script.append(r_code)
                generated_functions.add(func_name)

        r_script.append(
            "\n# ============================================================"
        )
        r_script.append(f"# {wave_name} Variable Recodings with Validation")
        r_script.append(
            "# ============================================================\n"
        )

        r_script.append(f"{wave_name.lower()} <- {wave_name.lower()} %>%")

        # Generate mutate statements with keyword validation
        recoding_lines = []
        for scale_key in sorted(reversal_groups.keys()):
            scale_type, scale_points, max_value = scale_key
            func_name = f"safe_reverse_{scale_points}pt"

            for var in reversal_groups[scale_key]:
                var_id = var["variable_id"]
                question = var["question_text"]

                # Find distinctive keyword using frequency analysis
                keyword = self.extract_distinctive_keyword(question, word_freq)

                # Truncate question for comment
                q_short = question[:60] + "..." if len(question) > 60 else question

                # Generate validation check
                validation = (
                    f'grepl("{keyword}", question_text["{var_id}"], ignore.case = TRUE)'
                )

                recoding_lines.append(f"  # {var_id}: {q_short}")
                recoding_lines.append(f"  # Keyword validation: '{keyword}'")
                recoding_lines.append(f"  mutate({var_id}_reversed = if_else(")
                recoding_lines.append(f"    {validation},")
                recoding_lines.append(f"    {func_name}({var_id}),")
                recoding_lines.append("    NA_real_  # Validation failed!")
                recoding_lines.append("  )),\n")

        # Remove trailing comma from last line
        if recoding_lines:
            recoding_lines[-1] = recoding_lines[-1].rstrip(",\n")

        r_script.extend(recoding_lines)

        r_script.append(
            "\n# ============================================================"
        )
        r_script.append(f"# {wave_name} Summary")
        r_script.append(
            f"# Variables needing reversal: {sum(len(vars) for vars in reversal_groups.values())}"
        )
        r_script.append(
            "# ============================================================"
        )

        return "\n".join(r_script)

    def generate_all_waves_script(
        self, wave_files: List[Tuple[str, str]], output_file: str
    ):
        """
        Generate master R script for all waves
        """
        print("Generating R recoding script for all waves...")

        all_scripts = [
            "# ============================================================",
            "# Asian Barometer Multi-Wave Reversal Script",
            "# Auto-generated with keyword validation",
            "# ============================================================\n",
            "# This script reverses scales where higher values indicate",
            "# LESS of the attribute (e.g., 1=Satisfied, 4=Dissatisfied)",
            "#",
            "# Each recoding includes:",
            "# 1. Scale-specific reversal function (4pt, 5pt, 6pt, etc.)",
            "# 2. Keyword validation to ensure correct question",
            "# 3. Missing value handling",
            "# 4. Outlier detection",
            "# ============================================================\n",
        ]

        for wave_file, wave_name in wave_files:
            wave_script = self.generate_wave_recoding_script(wave_file, wave_name)
            all_scripts.append(wave_script)
            all_scripts.append("\n")

        # Write to file
        with open(output_file, "w", encoding="utf-8") as f:
            f.write("\n".join(all_scripts))

        print(f"✅ R script saved to {output_file}")


def main():
    import sys

    generator = RRecoderGenerator()

    # Define waves to process
    waves = [
        ("W1_analyzed.json", "W1"),
        ("W2_analyzed.json", "W2"),
        ("W3_analyzed.json", "W3"),
        ("W4_analyzed.json", "W4"),
        ("W5_analyzed.json", "W5"),
        ("W6_Cambodia_analyzed.json", "W6_Cambodia"),
    ]

    output_file = "reverse_scales.R"
    if len(sys.argv) > 1:
        output_file = sys.argv[1]

    generator.generate_all_waves_script(waves, output_file)


if __name__ == "__main__":
    main()
