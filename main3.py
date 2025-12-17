import os
from huggingface_hub import InferenceClient

# Use token from environment
token = os.getenv("HF_TOKEN")

client = InferenceClient(
    model="google/gemma-2-2b-it",  # Using a known-working model
    token=token,
)

messages = [
    {
        "role": "system",
        "content": "You parse survey questionnaires. When questions share a stem, you reconstruct the full question for each item.",
    },
    {
        "role": "user",
        "content": """Parse this Asian Barometer questionnaire into stateless JSON.

KEY RULES:
1. q38 contains a STEM question + specific item (about identity documents)
2. q39 contains ONLY a specific item (about school placement) - you must ADD the stem from q38
3. Each JSON object must be self-contained with the complete question
4. Value labels must be objects with "value" and "label" fields

INPUT:
Variable: q38
  Question: q38. Based on your experience, how easy or difficult is it to obtain the following services? Or have you never tried to get these services from government? An identity document (such as a birth certificate or passport)
  Value Labels:
     -1 = Missing
     1 = Very Difficult
     2 = Difficult
     3 = Easy
     4 = Very Easy
     5 = Never Tried
     8 = Can't choose
     9 = Decline to answer

Variable: q39
  Question: q39. A place in a public primary school for a child
  Value Labels:
     -1 = Missing
     1 = Very Difficult
     2 = Difficult
     3 = Easy
     4 = Very Easy
     5 = Never Tried
     8 = Can't choose
     9 = Decline to answer

STEP-BY-STEP:
1. Extract stem from q38: "Based on your experience, how easy or difficult is it to obtain the following services? Or have you never tried to get these services from government?"
2. Extract q38 item: "An identity document (such as a birth certificate or passport)"
3. Extract q39 item: "A place in a public primary school for a child"
4. Combine stem + q38 item for first JSON object
5. Combine stem + q39 item for second JSON object

EXPECTED OUTPUT:
[
  {
    "variable_id": "q38",
    "question_text": "Based on your experience, how easy or difficult is it to obtain the following services? Or have you never tried to get these services from government? An identity document (such as a birth certificate or passport)",
    "value_labels": [{"value": -1, "label": "Missing"}, {"value": 1, "label": "Very Difficult"}, {"value": 2, "label": "Difficult"}, {"value": 3, "label": "Easy"}, {"value": 4, "label": "Very Easy"}, {"value": 5, "label": "Never Tried"}, {"value": 8, "label": "Can't choose"}, {"value": 9, "label": "Decline to answer"}]
  },
  {
    "variable_id": "q39",
    "question_text": "Based on your experience, how easy or difficult is it to obtain the following services? Or have you never tried to get these services from government? A place in a public primary school for a child",
    "value_labels": [{"value": -1, "label": "Missing"}, {"value": 1, "label": "Very Difficult"}, {"value": 2, "label": "Difficult"}, {"value": 3, "label": "Easy"}, {"value": 4, "label": "Very Easy"}, {"value": 5, "label": "Never Tried"}, {"value": 8, "label": "Can't choose"}, {"value": 9, "label": "Decline to answer"}]
  }
]""",
    },
]

response = client.chat_completion(
    messages=messages,
    max_tokens=1024,  # Increased for two JSON objects
    temperature=0.2,
)

print(response.choices[0].message.content)
