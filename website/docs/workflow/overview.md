---
sidebar_position: 1
title: Workflow Overview
---

# Workflow Overview

**Cursor Collections** covers the **full product lifecycle**:

> **Ideate → Implement → Review**

Attach **`@eversis-implement`** (or `/eversis-implement`) for the Implement phase — research and planning run inside that flow. Each phase produces documented artifacts with **human gates** where the prompts require them.

:::tip The relay race
Each phase passes a reviewed deliverable to the next. Workshop materials feed the backlog; the Engineering Manager orchestrates research, planning, and implementation; implementation feeds review.
:::

## The phases

### 1. Ideate

- **Role:** Business Analyst
- **Prompt:** `@eversis-analyze-materials`
- Workshop materials → Jira-ready epics and stories with acceptance criteria.
- **Gates:** Gate 1, Gate 1.5, and Gate 2 before Jira sync — see [Workshop Analysis Flow](./workshop-flow).

### 2. Implement

- **Role:** Engineering Manager (delegates Context Engineer, Architect, Plan Reviewer, implementers)
- **Prompt:** `@eversis-implement` with a Jira ID or task description
- **Flow selection:** Step 0 — EM recommends **Quick** or **Full** in chat (you may override). See [Orchestrating Implementation](../skills/orchestrating-implementation).
- **Quick Flow:** implement → quality checks → `@eversis-review` → **Fine** + QA draft (skips full research/plan when criteria pass).
- **Full Flow:** research → plan → plan validation → code → **Fine** + mandatory QA comment draft.
- **Produces:** `*.research.md`, `*.plan.md`, `*.plan-review.md` (Full), code changes.

:::info Quick vs Full
**Hard exclusion:** Figma, UI verification tasks, cross-domain work, or likely >3 files → **Full Flow only**. Quick is for narrow, low-risk fixes after you confirm the EM recommendation.
:::

### 3. Review

- **Role:** Code Reviewer
- **Prompt:** `@eversis-review`
- Structured review — PASS / BLOCKER / SUGGESTION.

## Implement → Review

| Step | Attach | What happens |
| ---- | ------ | ------------ |
| Implement (Quick) | `@eversis-implement` | EM: implement → review → Fine + QA draft |
| Implement (Full) | `@eversis-implement` | EM: research → plan → plan validation → implementation → Fine + QA draft |
| Review | `@eversis-review` | Structured code review |

## Status: Fine — handoff

When Implement is complete, the Engineering Manager declares **Fine** and **must** output a **QA comment draft in the same response** (not a separate turn). Normative procedure: [`.cursor/skills/eversis-fine-handoff/SKILL.md`](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/.cursor/skills/eversis-fine-handoff/SKILL.md) or MCP `eversis_skills_get` for `eversis-fine-handoff`. Onboarding overview: [Fine Handoff](../skills/fine-handoff).

The draft is labeled **`Draft QA comment — review before posting to Jira`**. Post to Jira only after you approve (copy-paste or explicit Atlassian MCP instruction).

## Workflow diagram

import SdlcDiagram from '@site/src/components/SdlcDiagram';

<SdlcDiagram />

## Human review at every step

:::warning Important
Each step requires your review. Open generated documents, iterate until correct, then approve before proceeding. AI output is always a draft.
:::

## Workflow variants

| Variant | Entry | Use when |
| ------- | ----- | -------- |
| **Standard flow** | `@eversis-implement` → `@eversis-review` | Backend / fullstack — Quick or Full at Step 0 |
| **UI + Figma** | `@eversis-implement` + `@eversis-review-ui` loop | Design-driven UI |
| **[Workshop analysis](./workshop-flow)** | `@eversis-analyze-materials` | Workshop → Jira only |
| **[E2E testing](./e2e-flow)** | `@eversis-implement` (E2E tasks in plan) | Playwright coverage |
| **[Business Manager Docs](./business-manager-docs)** | `@eversis-ba-docs-planner` → writer | Word `.docx` release docs |
| **[Repo Docs](./repo-docs)** | `@eversis-repo-docs-writer` (or EM delegate) | README, CHANGELOG, `website/docs` after Implement |
| **[QA workflow](./qa-workflow)** | `@eversis-qa-workflow` | Manual test planning, regression, AC verify, quality health |

:::info Standard flow
Full step-by-step: [Standard Flow](./standard-flow) — **Quick vs Full** at Step 0, then research, plan, implement, review with human gates.
:::

:::info Frontend / UI flow
Figma-driven UI with verification loop: [Frontend Flow](./frontend-flow) — includes the 5-step UI verification loop (`@eversis-review-ui`).
:::

:::info Workshop analysis
Ideate-only with Gates 1, 1.5, 2: [Workshop Analysis Flow](./workshop-flow).
:::

:::info E2E testing
Playwright work inside Implement: [E2E Testing Flow](./e2e-flow).
:::

:::info Repo Docs
Repository markdown after Implement: [Repo Docs](./repo-docs) — `@eversis-repo-docs-writer` (not Word `.docx`).
:::

:::info QA workflow
Manual QA practice (separate from Fine handoff): [QA Workflow](./qa-workflow) — `@eversis-qa-workflow`.
:::

:::info Business Manager Docs
Word `.docx` via `eversis-collections` MCP: [Business Manager Docs](./business-manager-docs).
:::

## Workflow playbooks

- [Standard Flow](./standard-flow)
- [Frontend Flow](./frontend-flow)
- [Workshop Analysis Flow](./workshop-flow)
- [E2E Testing Flow](./e2e-flow)
- [Business Manager Docs](./business-manager-docs)
- [Repo Docs](./repo-docs)
- [QA Workflow](./qa-workflow)
