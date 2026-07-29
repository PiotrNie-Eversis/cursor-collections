---
sidebar_position: 4
title: Orchestrating Implementation
---

# Orchestrating Implementation

**Folder:** `.cursor/skills/eversis-orchestrating-implementation/`  
**Used by:** Engineering Manager via [`eversis-implement`](../prompts/public/implement)

Canonical workflow owner for the Implement phase. The public **`@eversis-implement`** prompt is a thin trigger; this skill contains the full orchestration procedure.

## Progress checklist

```text
- [ ] Step 0: Create flow-start todos
- [ ] Step 1: Select Quick Flow or Full Flow + Implement readiness block
- [ ] Step 2: Write the upfront execution plan
- [ ] Step 3: Run the selected flow
- [ ] Step 4: Close validation and review gates
- [ ] Step 5: Declare Fine and produce QA comment draft
```

## Implement readiness (mandatory first output)

Before creating artifacts, delegating, or writing product code, inspect `docs/specs/<issue>/` and any `@`-attached plan/research paths. Print this block in the **first response** of the thread (including Quick Flow, QA follow-ups, and handoff continuations):

```text
## Implement readiness
- **Flow:** Quick | Full | QA follow-up
- **Research:** SKIP (<path>) | CREATE | DELTA (<reason>)
- **Plan:** SKIP (<path>) | CREATE | REFRESH (<reason>)
- **Next gate:** Awaiting approval before code | Proceeding (<one-line reason>)
```

| Value | Meaning |
| --- | --- |
| **SKIP** | Existing artifact adequately covers current scope |
| **CREATE** | No adequate artifact — write a new file |
| **DELTA** | Research exists but scope grew (QA findings, new AC) — brief addendum in chat, Changelog, or research file |
| **REFRESH** | Plan exists but needs new tasks/phases for changed scope |

**Proceeding** is allowed when artifacts are ready **and** the user attached an approved plan, gave a QA fix list, or explicitly asked to implement. Otherwise use **Awaiting approval**.

You do **not** need to type “Research” in the prompt — the agent inspects the folder and attached `@*.plan.md` automatically ([Entry signals](../prompts/public/implement) in the Implement prompt).

## Entry signals (automatic)

| Signal | Default |
| --- | --- |
| No `*.research.md` / `*.plan.md` | Full Flow → create missing artifacts → human gate |
| `@*.plan.md` + adequate `*.research.md` in same folder | Implement phase — **SKIP** new research/plan unless scope changed |
| QA checklist / bugfix with existing plan | Quick or Full implement phase — **SKIP** full research; note new findings (DELTA) |
| Narrow fix, ≤3 files, plan/context ready | Quick Flow allowed |

## Quick vs Full

| | Quick Flow | Full Flow |
| --- | --- | --- |
| **When** | Narrow scope, ≤3 files, no ambiguity, no Figma/UI, planning readiness met | Cross-domain, ambiguous, missing research/plan, >3 files, or any Figma/UI |
| **Skips** | Full research/plan/plan-review when criteria met and artifacts exist | Nothing — runs research → plan → plan validation → execution when gaps exist |
| **Ends with** | Validation → `@eversis-review` → Fine + fine-handoff | Per-task execution → UI gate → review → Fine + fine-handoff |

**Hard rule:** Any Figma or `[REUSE]` UI verification task **forces Full Flow**.

The Engineering Manager recommends a flow in chat; the user may override.

## Full Flow highlights

1. **Check existing artifacts first** — create `*.research.md` / `*.plan.md` only when missing or inadequate (delegate to Context Engineer / Architect when needed).
2. Human plan review → Plan Reviewer (`@eversis-review-plan`) → max 3 iterations.
3. Use plan **Technical Context** when populated; otherwise delegate codebase discovery.
4. Route each plan task via the execution routing table (Software Engineer, DevOps, E2E, Prompt Engineer, UI Reviewer).
5. **Domain skills gate** — load stack-specific skills only when `eversis-project-stack.mdc` § Agent skills policy and the plan allow it.
6. Enforce per-item UI verification before code review.
7. Declare **Fine** and produce QA comment draft via `eversis-fine-handoff` in the same response.

## Connected Skills

- `eversis-fine-handoff` — mandatory QA comment draft on Fine
- `eversis-creating-implementation-plans` — plan structure and readiness
- `eversis-technical-context-discovering` — when to skip redundant discovery
- `eversis-ui-verifying` — UI verification gate standards
- `eversis-code-reviewing` — final review gate
