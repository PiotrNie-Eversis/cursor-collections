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
- [ ] Step 1: Select Quick Flow or Full Flow
- [ ] Step 2: Write the upfront execution plan
- [ ] Step 3: Run the selected flow
- [ ] Step 4: Close validation and review gates
- [ ] Step 5: Declare Fine and produce QA comment draft
```

## Quick vs Full

| | Quick Flow | Full Flow |
| --- | --- | --- |
| **When** | Narrow scope, ≤3 files, no ambiguity, no Figma/UI | Cross-domain, ambiguous, missing research/plan, >3 files, or any Figma/UI |
| **Skips** | Full research/plan/plan-review when criteria met | Nothing — runs research → plan → plan validation → execution |
| **Ends with** | Validation → `@eversis-review` → Fine + fine-handoff | Per-task execution → UI gate → review → Fine + fine-handoff |

**Hard rule:** Any Figma or `[REUSE]` UI verification task **forces Full Flow**.

The Engineering Manager recommends a flow in chat; the user may override.

## Full Flow highlights

1. Ensure `*.research.md` and `*.plan.md` exist (delegate to Context Engineer / Architect when missing).
2. Human plan review → Plan Reviewer (`@eversis-review-plan`) → max 3 iterations.
3. Use plan **Technical Context** when populated; otherwise delegate codebase discovery.
4. Route each plan task via the execution routing table (Software Engineer, DevOps, E2E, Prompt Engineer, UI Reviewer).
5. Enforce per-item UI verification before code review.
6. Declare **Fine** and produce QA comment draft via `eversis-fine-handoff` in the same response.

## Connected Skills

- `eversis-fine-handoff` — mandatory QA comment draft on Fine
- `eversis-creating-implementation-plans` — plan structure and readiness
- `eversis-technical-context-discovering` — when to skip redundant discovery
- `eversis-ui-verifying` — UI verification gate standards
- `eversis-code-reviewing` — final review gate
