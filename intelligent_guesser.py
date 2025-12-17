"""
Intelligent Question Type Guesser

Analyzes value labels to automatically classify survey questions:
- Scale type (binary, 3-6 point Likert, 10-point, categorical)
- Directionality (normal vs reversed scales)
- Sentiment polarity of endpoints
"""

import json
import re
from typing import Dict, List, Optional
from dataclasses import dataclass


@dataclass
class ScaleAnalysis:
    """Results of scale analysis"""

    scale_type: str  # binary, likert_3, likert_4, likert_5, likert_6, scale_10, categorical, ordinal
    scale_points: int  # Number of substantive values (excluding NA)
    first_na_value: Optional[int]  # First NA/missing value
    max_substantive_value: int  # Highest non-NA value
    needs_reversal: bool  # True if scale should be reversed
    value_1_polarity: str  # positive, negative, neutral
    max_value_polarity: str  # positive, negative, neutral
    confidence: float  # 0.0 to 1.0
    reasoning: str  # Explanation of classification


class IntelligentGuesser:
    """Intelligent classification of survey question types"""

    # Common NA/missing indicators in labels
    NA_PATTERNS = [
        r"\bna\b",
        r"\bn/?a\b",
        r"missing",
        r"no answer",
        r"decline",
        r"refused",
        r"don\'t know",
        r"can\'t choose",
        r"not applicable",
        r"inapplicable",
        r"don\'t understand",
        r"do not understand",
        r"don not understand",
        r"do not unders",  # Matches both "understand" and "undersand" typo
        r"don\'t unders",
    ]

    # Positive sentiment indicators
    POSITIVE_WORDS = [
        "agree",
        "strongly agree",
        "satisfied",
        "very satisfied",
        "excellent",
        "very good",
        "good",
        "always",
        "often",
        "frequently",
        "support",
        "approve",
        "favorable",
        "positive",
        "confident",
        "trust",
        "easy",
        "very easy",
        "important",
        "very important",
        "yes",
        "definitely",
    ]

    # Negative sentiment indicators
    NEGATIVE_WORDS = [
        "disagree",
        "strongly disagree",
        "dissatisfied",
        "very dissatisfied",
        "poor",
        "very poor",
        "bad",
        "never",
        "rarely",
        "seldom",
        "oppose",
        "disapprove",
        "unfavorable",
        "negative",
        "distrust",
        "difficult",
        "very difficult",
        "unimportant",
        "not important",
        "no",
    ]

    def __init__(self):
        self.na_pattern = re.compile("|".join(self.NA_PATTERNS), re.IGNORECASE)

    def is_na_label(self, label: str) -> bool:
        """Check if a label indicates NA/missing value"""
        if not label:
            return False
        return bool(self.na_pattern.search(label.lower()))

    def get_label_polarity(self, label: str) -> str:
        """
        Determine sentiment polarity of a label
        Returns: 'positive', 'negative', or 'neutral'
        """
        if not label:
            return "neutral"

        label_lower = label.lower().strip()

        # Check for positive sentiment
        for pos_word in self.POSITIVE_WORDS:
            if pos_word in label_lower:
                return "positive"

        # Check for negative sentiment
        for neg_word in self.NEGATIVE_WORDS:
            if neg_word in label_lower:
                return "negative"

        return "neutral"

    def find_first_na_value(self, value_labels: List[Dict]) -> Optional[int]:
        """
        Find the first value that represents NA/missing
        Typically value 7, 8, 9, -1, 98, 99, etc.

        Asian Barometer conventions:
        - Negative values (e.g., -1) = Missing
        - Value 7+ = Don't know, Can't choose, Decline to answer
        """
        # First check for lowest value >= 7 that's NA
        na_values_high = []
        for vl in value_labels:
            if vl["value"] >= 7 and self.is_na_label(vl["label"]):
                na_values_high.append(vl["value"])

        if na_values_high:
            return min(na_values_high)

        # Check for any NA label
        for vl in sorted(value_labels, key=lambda x: x["value"]):
            if vl["value"] > 0 and self.is_na_label(vl["label"]):
                return vl["value"]

        return None

    def classify_scale(self, value_labels: List[Dict]) -> ScaleAnalysis:
        """
        Intelligently classify the scale type and directionality

        Asian Barometer conventions:
        - If max value > 99: substantive scale ends at value before 997
        - If max value = 99: substantive scale ends at value before 97
        - If max value > 9: likely ordinal/categorical, not Likert
        - Otherwise: value 7 may be first NA for Likert scales
        """
        if not value_labels:
            return ScaleAnalysis(
                scale_type="unknown",
                scale_points=0,
                first_na_value=None,
                max_substantive_value=0,
                needs_reversal=False,
                value_1_polarity="neutral",
                max_value_polarity="neutral",
                confidence=0.0,
                reasoning="No value labels provided",
            )

        # Get all values sorted
        all_values = sorted([vl["value"] for vl in value_labels])
        max_value_overall = max(all_values)

        # Determine the cutoff for substantive vs NA values
        # Using improved rules based on value magnitude:
        # - Values <= 9: NA starts at 7
        # - 2-digit values (10-99): NA starts with 9 (90, 97, 98, 99)
        # - 3-digit values (100-999): NA starts with 900 (900, 997, 998, 999)
        # - Values >= 1000: NA starts at 9997

        # First check for 997+ convention
        has_997_values = any(v >= 997 for v in all_values)

        if has_997_values:
            # Scale ends at value before 997
            max_substantive = max([v for v in all_values if v < 997], default=0)
            first_na = min([v for v in all_values if v >= 997], default=None)
        elif max_value_overall >= 100:
            # 3-digit values: NA starts with 900
            # Use gap detection - there's a gap between substantive (0-99) and NA (900+)
            positive_values = sorted([v for v in all_values if v > 0])

            # Find gap between substantive and NA values
            gap_found = False
            for i in range(len(positive_values) - 1):
                gap = positive_values[i + 1] - positive_values[i]
                if gap > 10:  # Large gap indicates start of NA values
                    max_substantive = positive_values[i]
                    first_na = positive_values[i + 1]
                    gap_found = True
                    break

            if not gap_found:
                # No gap found, use text-based NA detection
                first_na_from_labels = self.find_first_na_value(value_labels)
                if first_na_from_labels:
                    max_substantive = max(
                        [v for v in all_values if 0 < v < first_na_from_labels],
                        default=max_value_overall,
                    )
                    first_na = first_na_from_labels
                else:
                    # No NA detected, all values are substantive
                    max_substantive = max_value_overall
                    first_na = None
        elif max_value_overall >= 10:
            # 2-digit values: NA starts with 9 (90, 97, 98, 99)
            # Use gap detection
            positive_values = sorted([v for v in all_values if v > 0])

            gap_found = False
            for i in range(len(positive_values) - 1):
                gap = positive_values[i + 1] - positive_values[i]
                if gap > 10:  # Large gap indicates start of NA values
                    max_substantive = positive_values[i]
                    first_na = positive_values[i + 1]
                    gap_found = True
                    break

            if not gap_found:
                # No gap found, check if there are 90+ values
                has_90_values = any(v >= 90 for v in all_values)
                if has_90_values:
                    # Assume 90+ are NA
                    max_substantive = max([v for v in all_values if v < 90], default=max_value_overall)
                    first_na = min([v for v in all_values if v >= 90], default=None)
                else:
                    # No NA values, all are substantive
                    max_substantive = max_value_overall
                    first_na = None
        else:
            # Standard Likert range (1-9), value 7 may be first NA
            # Check for gaps in sequence (e.g., 1-5 then 7, missing 6 = gap of 2)
            positive_values = sorted([v for v in all_values if v > 0])

            gap_found = False
            for i in range(len(positive_values) - 1):
                gap = positive_values[i + 1] - positive_values[i]
                if gap > 1:  # Gap > 1 indicates missing value, likely start of NA
                    max_substantive = positive_values[i]
                    first_na = positive_values[i + 1]
                    gap_found = True
                    break

            if not gap_found:
                # No gap, check if value 7 is NA by label
                has_value_7 = 7 in all_values
                if has_value_7:
                    value_7_label = next(
                        (vl["label"] for vl in value_labels if vl["value"] == 7), ""
                    )
                    if self.is_na_label(value_7_label):
                        max_substantive = max(
                            [v for v in all_values if 0 < v < 7], default=6
                        )
                        first_na = 7
                    else:
                        first_na = self.find_first_na_value(value_labels)
                        max_substantive = max(
                            [v for v in all_values if 0 < v < (first_na or 999)], default=7
                        )
                else:
                    first_na = self.find_first_na_value(value_labels)
                    max_substantive = max(
                        [v for v in all_values if 0 < v < (first_na or 999)],
                        default=max_value_overall,
                    )

        # Separate substantive from NA values
        substantive_values = []
        na_values = []

        for vl in value_labels:
            if vl["value"] < 0:
                na_values.append(vl)
            elif vl["value"] > max_substantive:
                na_values.append(vl)
            elif self.is_na_label(vl["label"]):
                na_values.append(vl)
            else:
                substantive_values.append(vl)

        if not substantive_values:
            return ScaleAnalysis(
                scale_type="unknown",
                scale_points=0,
                first_na_value=first_na,
                max_substantive_value=0,
                needs_reversal=False,
                value_1_polarity="neutral",
                max_value_polarity="neutral",
                confidence=0.0,
                reasoning="No substantive values found",
            )

        # Get range of substantive values
        sub_values = sorted([vl["value"] for vl in substantive_values])
        min_value = min(sub_values)
        max_value = max(sub_values)
        num_points = len(sub_values)
        span = max_value - min_value + 1

        # Get polarity of endpoints
        value_1_label = next(
            (vl["label"] for vl in substantive_values if vl["value"] == min_value), ""
        )
        max_value_label = next(
            (vl["label"] for vl in substantive_values if vl["value"] == max_value), ""
        )

        value_1_polarity = self.get_label_polarity(value_1_label)
        max_value_polarity = self.get_label_polarity(max_value_label)

        # Determine if reversal is needed
        # If value 1 is positive, scale needs reversal
        # If value 1 is negative and max is positive, scale is normal
        needs_reversal = False
        if value_1_polarity == "positive" and max_value_polarity == "negative":
            needs_reversal = True
        elif value_1_polarity == "positive" and max_value_polarity == "neutral":
            # Might need reversal, medium confidence
            needs_reversal = True

        # Classification logic
        scale_type = "unknown"
        confidence = 0.8
        reasoning = ""

        # Binary scale: max value is 1 or 2
        if max_value <= 2:
            scale_type = "binary"
            reasoning = (
                f"Max substantive value is {max_value} (binary yes/no or 1-2 scale)"
            )

        # IMPORTANT: If 10+ substantive values, NOT Likert (user requirement)
        # Either 10-point scale or categorical
        elif num_points >= 10:
            # Check if it's a 10-point scale (values 0-10 or 1-10)
            if max_value in [10, 11] and span <= 11 and num_points <= 11:
                scale_type = "scale_10"
                reasoning = f"10-point scale (values {min_value}-{max_value})"
            else:
                # Categorical: many distinct values (not a Likert scale!)
                scale_type = "categorical"
                reasoning = f"Categorical with {num_points} distinct values"
                needs_reversal = False  # Categorical doesn't reverse

        # Likert scales: 3-6 points (ONLY if < 10 substantive values)
        elif max_value in [3, 4, 5, 6] and span <= 6:
            scale_type = f"likert_{max_value}"
            reasoning = f"{max_value}-point Likert scale (values 1-{max_value})"

        # 7-point scales (if first NA is 8 or higher)
        elif max_value == 7 and (first_na is None or first_na >= 8):
            scale_type = "likert_7"
            reasoning = "7-point Likert scale (values 1-7)"

        # Ordinal: sequential but not standard Likert
        elif span == num_points:
            scale_type = "ordinal"
            reasoning = f"Ordinal scale with {num_points} ordered categories"

        # Other cases
        else:
            scale_type = "ordinal"
            confidence = 0.5
            reasoning = f"Ordinal scale ({num_points} values, span {span})"

        # Adjust reasoning for reversal
        if needs_reversal and scale_type not in ["categorical", "unknown"]:
            reasoning += f" | NEEDS REVERSAL: value 1 is {value_1_polarity}, max is {max_value_polarity}"

        return ScaleAnalysis(
            scale_type=scale_type,
            scale_points=num_points,
            first_na_value=first_na,
            max_substantive_value=max_value,
            needs_reversal=needs_reversal,
            value_1_polarity=value_1_polarity,
            max_value_polarity=max_value_polarity,
            confidence=confidence,
            reasoning=reasoning,
        )

    def analyze_questionnaire(self, atomic_json_file: str, output_file: str):
        """
        Analyze all questions in atomic JSON and add scale analysis
        """
        print(f"Loading {atomic_json_file}...")
        with open(atomic_json_file, "r", encoding="utf-8") as f:
            variables = json.load(f)

        print(f"Analyzing {len(variables)} variables...\n")

        analyzed = []
        stats = {
            "binary": 0,
            "likert_3": 0,
            "likert_4": 0,
            "likert_5": 0,
            "likert_6": 0,
            "likert_7": 0,
            "scale_10": 0,
            "categorical": 0,
            "ordinal": 0,
            "unknown": 0,
            "needs_reversal": 0,
        }

        for var in variables:
            analysis = self.classify_scale(var["value_labels"])

            # Add analysis to variable
            var_with_analysis = var.copy()
            var_with_analysis["scale_analysis"] = {
                "scale_type": analysis.scale_type,
                "scale_points": analysis.scale_points,
                "first_na_value": analysis.first_na_value,
                "max_substantive_value": analysis.max_substantive_value,
                "needs_reversal": analysis.needs_reversal,
                "value_1_polarity": analysis.value_1_polarity,
                "max_value_polarity": analysis.max_value_polarity,
                "confidence": analysis.confidence,
                "reasoning": analysis.reasoning,
            }

            analyzed.append(var_with_analysis)

            # Update stats
            if analysis.scale_type in stats:
                stats[analysis.scale_type] += 1
            if analysis.needs_reversal:
                stats["needs_reversal"] += 1

        # Save analyzed results
        print(f"Saving to {output_file}...")
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(analyzed, f, indent=2, ensure_ascii=False)

        # Print statistics
        print(f"\n{'=' * 60}")
        print("SCALE TYPE DISTRIBUTION:")
        print(f"{'=' * 60}")
        for scale_type, count in sorted(stats.items()):
            if scale_type != "needs_reversal" and count > 0:
                pct = (count / len(variables)) * 100
                print(f"  {scale_type:15s}: {count:4d} ({pct:5.1f}%)")

        print(f"\n{'=' * 60}")
        print(
            f"SCALES NEEDING REVERSAL: {stats['needs_reversal']} ({(stats['needs_reversal'] / len(variables)) * 100:.1f}%)"
        )
        print(f"{'=' * 60}")

        # Show examples
        print(f"\n{'=' * 60}")
        print("SAMPLE ANALYSES:")
        print(f"{'=' * 60}")

        for scale_type in ["binary", "likert_5", "scale_10", "categorical"]:
            examples = [
                v for v in analyzed if v["scale_analysis"]["scale_type"] == scale_type
            ]
            if examples:
                ex = examples[0]
                print(f"\n{scale_type.upper()} Example:")
                print(f"  Variable: {ex['variable_id']}")
                print(f"  Question: {ex['question_text'][:60]}...")
                print(f"  Values: {ex['scale_analysis']['scale_points']} points")
                print(f"  Max value: {ex['scale_analysis']['max_substantive_value']}")
                print(f"  First NA: {ex['scale_analysis']['first_na_value']}")
                print(f"  Reversal: {ex['scale_analysis']['needs_reversal']}")
                print(f"  Reasoning: {ex['scale_analysis']['reasoning']}")

        print(f"\n✅ Analysis complete! Results saved to {output_file}")


def main():
    import sys

    if len(sys.argv) < 2:
        print("Usage: python intelligent_guesser.py <atomic_json_file> [output_file]")
        print("Example: python intelligent_guesser.py W5_atomic.json W5_analyzed.json")
        sys.exit(1)

    atomic_file = sys.argv[1]
    output_file = (
        sys.argv[2]
        if len(sys.argv) > 2
        else atomic_file.replace(".json", "_analyzed.json")
    )

    guesser = IntelligentGuesser()
    guesser.analyze_questionnaire(atomic_file, output_file)


if __name__ == "__main__":
    main()
