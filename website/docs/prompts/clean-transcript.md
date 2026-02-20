---
sidebar_position: 11
title: /tsh-clean-transcript
---

# /tsh-clean-transcript

**Agent:** Business Analyst  
**File:** `.github/prompts/tsh-clean-transcript.prompt.md`

Standalone command to clean a raw workshop or meeting transcript from small talk and structure it by topics.

## Usage

```text
/tsh-clean-transcript <transcript>
```

## What It Does

1. Identifies the transcript format (speaker-labelled, timestamped, plain text, or mixed). If the transcript is in PDF format, uses the PDF Reader tool to extract text content first.
2. Extracts meeting metadata (date, participants, topic) — asks the user if not present in the transcript.
3. Removes non-business content: greetings, small talk, filler words, technical difficulties, off-topic tangents.
4. Groups remaining content by discussion topics with descriptive headings.
5. Extracts key decisions, action items, and open questions into dedicated sections.
6. Preserves critical raw context (exact quotes where original wording matters).

## Skills Loaded

- `tsh-transcript-processing` — Structured cleaning process and output template.

## Output

A `cleaned-transcript.md` file placed in the `specifications/<workshop-name>/` directory.

:::tip
When in doubt about whether content is business-relevant, the agent keeps it — it's better to preserve potentially useful context than to accidentally remove important information.
:::
