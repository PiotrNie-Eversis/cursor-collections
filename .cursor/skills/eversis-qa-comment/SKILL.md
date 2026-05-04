---
name: eversis-qa-comment
description: "Generate a professional English QA summary for Jira. Manual only after Fine status; no file or line references in Main Changes."
---

# QA Comment Generation

## Objective

Generate a professional summary for the QA department in English. This skill is used manually after the developer/agent reaches the **"Fine"** status.

## Guidelines

1. **Language**: The output MUST be in English.
2. **Audience**: Write specifically for Quality Assurance engineers.
3. **No Code References**: In the "Main Changes" section, do not refer to specific files or line numbers. Describe functionality.
4. **Manual Trigger**: This skill is executed upon user request or suggested after the **"Fine"** status is declared. Do **not** run it automatically.

## Structure

### 1. Main Changes

- Use the task context to explain what was modified.
- Focus on functional changes and business logic.
- Ensure it is clear for a person not looking at the code.

### 2. Verification List

- **Manual Testing**: Steps to verify the change.
- **Automation Insights**: If applicable, provide selectors (IDs, data-test attributes), API endpoints, or logic changes that are relevant for automated test scripts.

## Example

See **`qa-comment.example.md`** in this folder for a full few-shot template.
