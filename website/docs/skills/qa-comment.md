---
sidebar_position: 33
title: QA Comment
---

# QA Comment Generation

**Folder:** `.cursor/skills/eversis-qa-comment/`

This skill bridges communication between developers and Quality Assurance. It generates a clear, English-language summary of changes.

## Usage

This skill is not automated. Once you reach the **"Fine"** status in your workflow, you can manually trigger it by asking:

> Generate a QA comment for this task.

Load **`eversis-qa-comment`** via the **`eversis-collections` MCP** (`eversis_skills_get`) or follow the skill folder instructions in Cursor.

## Why English?

To keep international tools such as Jira consistent and to ensure all stakeholders can follow verification steps.

## Rules for the Agent

- No direct code references (files, functions) in the summary.
- Focus on functional impact.
- Provide technical details for automation testers (selectors, API info).

## Example output

Below is an illustrative comment for a hypothetical MFA-in-settings task. An actual run should match this shape: **Main Changes** (functional, no file paths) plus a **Verification List** (manual steps and automation notes).

### 📝 QA Summary

**Task Context:** Implementation of multi-factor authentication (MFA) toggle in user settings.

**Main Changes:**
- Added a new section in User Settings to manage security preferences.
- Implemented a toggle switch to enable/disable MFA via Email.
- Updated the login flow to challenge the user for a code if MFA is active.
- Added descriptive error messages for invalid or expired MFA codes.

---

**✅ Verification List:**

**Manual Testing:**
- [ ] Navigate to Settings -> Security and verify the MFA toggle is visible.
- [ ] Enable MFA and logout. Verify that the system asks for an email code during the next login.
- [ ] Test the "Resend Code" functionality to ensure it triggers a new email.
- [ ] Verify that disabling MFA removes the extra step during login.

**Automation & Technical Notes:**
- **Selectors**: The MFA toggle can be targeted via `data-testid="mfa-toggle-switch"`.
- **API**: New endpoint `POST /api/v1/auth/mfa/verify` handles code validation.
- **Error Handling**: Invalid codes return a `422 Unprocessable Entity` with a `code_expired` or `code_invalid` reason.

The canonical few-shot template in the repository is [`qa-comment.example.md`](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/.cursor/skills/eversis-qa-comment/qa-comment.example.md) under `.cursor/skills/eversis-qa-comment/` (keeps this page aligned with the skill package).
