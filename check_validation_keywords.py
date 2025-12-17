#!/usr/bin/env python3
"""
Analyze question texts across all waves to identify suitable validation keywords
for the R double-checking function.
"""

import json
from collections import defaultdict
from typing import Dict, List, Set
import re


def extract_content_words(text: str, min_length: int = 5) -> Set[str]:
    """Extract meaningful content words from question text."""
    # Convert to lowercase and extract words
    words = re.findall(r"\b[a-z]+\b", text.lower())

    # Common words to exclude (expand as needed)
    stopwords = {
        "about",
        "after",
        "again",
        "against",
        "being",
        "before",
        "below",
        "between",
        "doing",
        "during",
        "further",
        "having",
        "should",
        "their",
        "there",
        "these",
        "those",
        "through",
        "under",
        "which",
        "while",
        "would",
        "could",
        "following",
        "statement",
        "question",
        "agree",
        "disagree",
        "strongly",
        "somewhat",
        "please",
        "think",
        "opinion",
    }

    # Filter for meaningful words
    content_words = {
        word for word in words if len(word) >= min_length and word not in stopwords
    }

    return content_words


def find_unique_keywords(questions: List[Dict], wave: str) -> Dict[str, Dict]:
    """Find unique validation keywords for each question in a wave."""

    # Build word frequency across all questions
    word_to_questions = defaultdict(set)
    question_to_words = {}

    for q in questions:
        var_id = q.get("variable_id", "")
        text = q.get("question_text", "")

        if not text or not var_id:
            continue

        words = extract_content_words(text)
        question_to_words[var_id] = words

        for word in words:
            word_to_questions[word].add(var_id)

    # For each question, find its unique or distinctive words
    results = {}

    for var_id, words in question_to_words.items():
        # Find words that appear in this question only
        unique_words = [w for w in words if len(word_to_questions[w]) == 1]

        # Find words that appear in few questions (distinctive but not necessarily unique)
        distinctive_words = [w for w in words if len(word_to_questions[w]) <= 3]

        # Get the question text
        q_text = next(
            q["question_text"] for q in questions if q.get("variable_id") == var_id
        )

        results[var_id] = {
            "question_text": q_text[:80] + ("..." if len(q_text) > 80 else ""),
            "unique_words": sorted(unique_words),
            "distinctive_words": sorted(distinctive_words),
            "total_words": len(words),
            "has_validation_keyword": len(unique_words) > 0
            or len(distinctive_words) > 0,
        }

    return results


def analyze_wave(wave_name: str) -> Dict:
    """Analyze a single wave's crosswalk file."""

    try:
        with open(f"{wave_name}_crosswalk.json", "r") as f:
            data = json.load(f)

        # Extract all questions from domains
        questions = []
        if "domains" in data and isinstance(data["domains"], list):
            for domain in data["domains"]:
                if "variables" in domain:
                    questions.extend(domain["variables"])

        results = find_unique_keywords(questions, wave_name)

        # Calculate statistics
        total_questions = len(results)
        with_keywords = sum(1 for r in results.values() if r["has_validation_keyword"])
        without_keywords = total_questions - with_keywords

        return {
            "wave": wave_name,
            "total_questions": total_questions,
            "with_keywords": with_keywords,
            "without_keywords": without_keywords,
            "percentage_covered": (with_keywords / total_questions * 100)
            if total_questions > 0
            else 0,
            "questions": results,
        }

    except Exception as e:
        return {"wave": wave_name, "error": str(e)}


def main():
    """Main analysis function."""

    waves = ["W1", "W2", "W3", "W4", "W5", "W6_Cambodia"]

    print("=" * 80)
    print("VALIDATION KEYWORD ANALYSIS FOR R DOUBLE-CHECKING")
    print("=" * 80)
    print()

    all_results = {}

    for wave in waves:
        print(f"\n{'=' * 80}")
        print(f"Analyzing {wave}...")
        print("=" * 80)

        result = analyze_wave(wave)
        all_results[wave] = result

        if "error" in result:
            print(f"❌ ERROR: {result['error']}")
            continue

        print("\n📊 Summary:")
        print(f"  Total questions: {result['total_questions']}")
        print(
            f"  With validation keywords: {result['with_keywords']} ({result['percentage_covered']:.1f}%)"
        )
        print(f"  Without keywords: {result['without_keywords']}")

        # Show examples of questions without good keywords
        if result["without_keywords"] > 0:
            print("\n⚠️  Questions needing attention:")
            count = 0
            for var_id, info in result["questions"].items():
                if not info["has_validation_keyword"]:
                    print(f"  • {var_id}: {info['question_text']}")
                    count += 1
                    if count >= 5:  # Limit to first 5 examples
                        if result["without_keywords"] > 5:
                            print(f"  ... and {result['without_keywords'] - 5} more")
                        break

        # Show some examples of good keywords
        print("\n✅ Sample validation keywords:")
        count = 0
        for var_id, info in sorted(result["questions"].items()):
            if info["unique_words"]:
                keyword = info["unique_words"][0]
                print(f"  • {var_id}: '{keyword}' in \"{info['question_text']}\"")
                count += 1
                if count >= 3:
                    break

    # Overall summary
    print(f"\n\n{'=' * 80}")
    print("OVERALL SUMMARY")
    print("=" * 80)

    total_q = sum(r.get("total_questions", 0) for r in all_results.values())
    total_with = sum(r.get("with_keywords", 0) for r in all_results.values())
    total_without = sum(r.get("without_keywords", 0) for r in all_results.values())

    print("\nAcross all waves:")
    print(f"  Total questions: {total_q}")
    print(
        f"  With validation keywords: {total_with} ({total_with / total_q * 100:.1f}%)"
    )
    print(f"  Without keywords: {total_without} ({total_without / total_q * 100:.1f}%)")

    print(f"\n{'=' * 80}")
    print("CONCLUSION")
    print("=" * 80)

    if total_without == 0:
        print("\n✅ All questions have suitable validation keywords!")
    else:
        print(f"\n⚠️  {total_without} questions may need manual keyword selection")
        print("   These questions use common words that appear in multiple questions.")
        print("   Consider using distinctive phrases or combinations of words.")


if __name__ == "__main__":
    main()
