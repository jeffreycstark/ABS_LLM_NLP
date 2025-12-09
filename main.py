import pandas as pd
import json
import os

# Assume your CSV has a column named 'question_text'
df = pd.read_csv('your_survey_data.csv')

# --- Define the System Prompt from the previous answer ---
SYSTEM_PROMPT = """
You are an expert social science data processor specializing in survey instrument distillation. Your task is to analyze a single survey question and provide a highly concise summary and a list of key concepts. Your entire response must be a single, valid JSON object. Do not include any introductory text, explanation, or markdown fences. The 'summary' value must be 4 to 5 words long. The 'keywords' array must contain exactly 3 to 4 distinct, domain-encapsulating phrases.
"""


def create_batch_request(row, system_prompt):
    """Generates a single line of the JSONL batch input file."""

    # 1. Define the specific user input payload (the question)
    user_content = {
        "id": f"Q_{row.name + 1}",  # Use the index + 1 as a unique ID
        "question_text": row['question_text']
    }

    # 2. Assemble the full API request structure (OpenAI style shown here)
    request = {
        "custom_id": f"batch-req-{row.name + 1}",
        "method": "POST",
        "url": "/v1/chat/completions",  # This endpoint is for Chat/Gemini models
        "body": {
            "model": "gpt-3.5-turbo",  # Or "gemini-2.5-flash"
            "messages": [
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": json.dumps(user_content)}
                # JSON stringify the user content
            ]
        }
    }
    return json.dumps(request) + '\n'


# --- Generate the JSONL File ---
jsonl_data = [create_batch_request(row, SYSTEM_PROMPT) for index, row in df.iterrows()]

# Write the data to a JSONL file
with open('batch_input.jsonl', 'w', encoding='utf-8') as f:
    f.writelines(jsonl_data)