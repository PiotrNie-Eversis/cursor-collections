---
sidebar_position: 4
title: "Implement"
slug: implement
prompt_role: "Engineering Manager"
prompt_description: "Implement feature according to the plan."
upstream_agent: "eversis-engineering-manager"
---
# eversis-implement

**Agent:** Engineering Manager  
**File:** `.cursor/prompts/public/eversis-implement.md`

Thin trigger for implementation delivery. The canonical orchestration workflow lives in the **`eversis-orchestrating-implementation`** skill — load it via MCP (`eversis_skills_get`) or read `.cursor/skills/eversis-orchestrating-implementation/SKILL.md`.

## Usage

```text
@eversis-implement
<JIRA_ID or task description — if applicable>
```

Or use the `/eversis-implement` project command (type `/` in Chat or Agent).

Attach **`@eversis-engineering-manager`** (`.cursor/rules/eversis-engineering-manager.mdc`) when running this workflow.

## What It Does

Delegates to **`eversis-orchestrating-implementation`**, which owns:

- **Quick vs Full flow** selection (Figma/UI always forces Full)
- Research → plan → plan validation → implementation → review gates
- Per-task todos, routing table, and UI verification gate
- **Fine** + mandatory QA comment draft via `eversis-fine-handoff`

Load **`eversis-orchestrating-implementation`** for the full workflow (docs: `website/docs/skills/orchestrating-implementation.md`).

## Output

- `*.research.md`, `*.plan.md`, `*.plan-review.md` under `docs/specs/<task-name>/` (when Full flow runs)
- Code changes applied by delegated agents
- Updated plan checkboxes and Changelog entries
- Code review findings
- QA comment draft labeled `Draft QA comment — review before posting to Jira` on **Fine**

---

## Executable prompt (attach in Cursor)

Start implementation delivery for a feature based on a task description, Jira item, or implementation plan. This prompt is a thin trigger — the workflow is defined in **`eversis-orchestrating-implementation`**.

**Attach:** `@eversis-engineering-manager` (`.cursor/rules/eversis-engineering-manager.mdc`).

**Required skill:** Load and follow **`eversis-orchestrating-implementation`** (MCP `eversis_skills_get` or `.cursor/skills/eversis-orchestrating-implementation/SKILL.md`).

**Input:** Provide at least one of: task description, Jira ID, or `*.plan.md`. Include `*.research.md` when available.

**Artifacts:** Write `*.research.md`, `*.plan.md`, and `*.plan-review.md` under `docs/specs/<issue-or-task-kebab>/` (or the team's `specifications/` folder).

**Workflow:** Start at Step 0 in `eversis-orchestrating-implementation` and follow that skill through Step 5 (Fine + `eversis-fine-handoff` in the same response). Do not duplicate orchestration steps in this prompt.

<!-- Eversis port; upstream: tsh-implement:v2 + eversis-orchestrating-implementation -->
