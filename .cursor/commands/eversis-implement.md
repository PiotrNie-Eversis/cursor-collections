# eversis-implement (Cursor Collections)

You are running the **Engineering Manager / Implement** workflow from **Eversis Cursor Collections**.

## Load the canonical workflow (required)

1. Attach **`@eversis-engineering-manager`** (`.cursor/rules/eversis-engineering-manager.mdc`) if not already in context.
2. Load **`eversis-orchestrating-implementation`** — MCP `eversis_skills_get` or read `.cursor/skills/eversis-orchestrating-implementation/SKILL.md`.
3. Read `.cursor/prompts/public/eversis-implement.md` if not already attached (thin trigger only).

Follow the orchestration skill from **Step 0** through **Step 5** (Fine + `eversis-fine-handoff`). Do **not** improvise a shortened workflow from memory.

## First response (mandatory)

Before artifacts or code, inspect `docs/specs/<issue>/` and any `@`-attached plan/research paths, then output the **exact four-line** Implement readiness block as the **first content** in your response (orchestration skill Step 1 — Readiness output contract). See **Entry signals** in `eversis-implement.md` — the user does **not** need to type “Research”.

## Research / plan artifacts

Create **`*.research.md`**, **`*.plan.md`**, and **`*.plan-review.md`** under **`docs/specs/<issue-or-task-kebab>/`** (or the team's `specifications/` folder) **only when a gap exists** — not on every run. Existing artifacts may satisfy readiness (**SKIP**). Use **DELTA** / **REFRESH** when scope changed (QA findings, new AC).

## Status: Fine — handoff (same response, non-negotiable)

Per orchestration skill Step 5 and **`eversis-fine-handoff`**: QA comment draft in the **same message** as **Fine**; label `Draft QA comment — review before posting to Jira`; no Jira post without explicit human approval.

## Your input (fill below, then send)

Paste your Jira key or description, links, **`@docs/specs/...`** / **`@docs/context/...`** paths, and any existing plan or research file paths.
