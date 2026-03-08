---
sidebar_position: 11
title: Transcript Cleaning (sub-workflow)
---

# Transcript Cleaning

:::info Sub-workflow
Transcript cleaning is **not a standalone prompt** — it is a sub-workflow within [`/tsh-analyze-materials`](./analyze-materials). The Business Analyst agent automatically cleans transcripts as the first step when raw workshop materials are provided.
:::

**Agent:** Business Analyst (within `/tsh-analyze-materials`)  
**Skill:** `tsh-transcript-processing`

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
