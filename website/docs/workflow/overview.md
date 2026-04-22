---
sidebar_position: 1
title: Workflow Overview
---

# Workflow Overview

**Cursor Collections** is an AI product engineering framework that covers the **full product lifecycle** through a structured workflow:

> **Ideate → Implement → Review**

The Implement phase internally handles research and planning when you use the **`eversis-implement`** prompt (attach the Markdown file with `@`). Each phase is driven by **Cursor rules** and **attachable prompts**, and produces documented artifacts. This keeps outputs consistent from workshop materials to production-ready, reviewed code.

:::tip The Relay Race Metaphor
Think of this workflow as a **relay race**. Each phase produces a deliverable — the "baton" — that is reviewed by the human and then passed to the next phase. Workshop materials feed the backlog, the Engineering Manager pattern orchestrates research, planning, and implementation, and the implementation feeds the review. Nothing is lost between steps, and every handoff is a documented artifact.
:::

## The Phases

### 1. Ideate

- **Role:** Business Analyst (rules + prompt)
- **Prompt:** attach `website/docs/prompts/public/eversis-analyze-materials.md`
- Processes raw workshop materials (transcripts, Figma designs, documents) into structured epics and stories.
- Uses multi-step quality review with mandatory human review gates.
- **Produces:** Jira-ready epics and stories with acceptance criteria, dependencies, and priorities.

### 2. Implement

- **Role:** Engineering Manager orchestration (Context Engineer, Architect, implementers)
- **Prompt:** attach `website/docs/prompts/public/eversis-implement.md` with a Jira ID or description
- Typical flow:
  1. **Research** — Context gathering from Jira, Figma, and codebase. Confirm before planning when the prompt says so.
  2. **Plan** — Structured implementation plan. Confirm before large edits when the prompt says so.
  3. **Implement** — Software / Prompt / DevOps / E2E work per plan and internal prompts.
- **Produces:** Research document, implementation plan, and code changes.

### 3. Review

- **Role:** Code Reviewer
- **Prompt:** attach `website/docs/prompts/public/eversis-review.md`
- Structured review against acceptance criteria, security, reliability, and maintainability.
- **Produces:** Review with pass/blockers/suggestions.

## Workflow Diagram

import SdlcDiagram from '@site/src/components/SdlcDiagram';

<SdlcDiagram />

## Human Review at Every Step

:::warning Important
Each step requires your review and verification. Open the generated documents, go through them carefully, and iterate as many times as needed until the output looks correct. AI assistance does not replace human judgment — treat each output as a draft that needs your approval before proceeding.
:::

## Workflow Variants

- **[Workshop Analysis Flow](./workshop-flow)** — `eversis-analyze-materials` for Jira-ready epics and stories.
- **[Standard Flow](./standard-flow)** — `eversis-implement` → `eversis-review` (research and planning as in the public/internal prompts).
- **[Frontend Flow](./frontend-flow)** — UI tasks with Figma verification using `eversis-implement` (internal UI steps) and `eversis-review-ui`.
- **[E2E Testing Flow](./e2e-flow)** — E2E work via `eversis-implement` and E2E patterns in rules/skills.
