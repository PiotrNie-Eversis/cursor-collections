---
sidebar_position: 1
title: Agents Overview
---

# Agents Overview

**Twelve specialized roles** plus **three internal workers** mirror a full product-engineering team across **Ideate → Implement → Review**.

In **Cursor**, those roles are expressed as **rules** (`.cursor/rules/eversis-*.mdc`), **prompts** (bodies in **`.cursor/prompts/public/`** and **`.cursor/prompts/internal/`** as `eversis-*.md`), and **skill packages** (`SKILL.md` under `.cursor/skills/`, used via the **`eversis-collections` MCP** and `eversis_skills_*` tools plus **`eversis_skill_run_script`** where allowlisted; optional `eversis-` names if you fork). **Attach** prompts in Chat or Agent by typing **`@`** and the **file stem** (e.g. **`@eversis-implement`**, **`@eversis-research`**). Use a full path under **`.cursor/prompts/...`** only if the file picker does not disambiguate.

The canonical packaging and mappings are documented in the [Framework reference](../framework) (same as **`documentation/cursor-collection.md`** in the repository). Entry points for this repository are **`AGENTS.md`** (root) and the always-on rule **`.cursor/rules/eversis-agent-core.mdc`**.

**Starter rule packs in this repo:** `eversis-agent-core.mdc` (always apply), `eversis-engineering-manager.mdc` (attach with **`@eversis-implement`**), and `eversis-code-reviewer.mdc` (attach with **`@eversis-review`**). Other roles use the **canonical template** filenames in the table below (`eversis-role-<role>.mdc`); add those files when you split behavior out of the core packs — they are **not** all shipped in cursor-collections (delegated prompts + skills carry most role behavior).

## How roles work

Each role defines:

- **Purpose** — What it optimizes for and what it refuses to do.
- **Packaging** — Which rule file and prompts implement it in Cursor.
- **Tools** — MCP servers, terminal, and Cursor Agent capabilities you enable in **Cursor Settings → MCP**.
- **Skills** — Reusable procedures in **`.cursor/skills/`**; load content through **`eversis-collections` MCP** (`eversis_skills_get`, **`eversis_skill_run_script`** for allowlisted automation, etc.). (`eversis-*` naming when you add your own copies.)
- **Handoffs** — Which prompt or approval gate comes next (human gates after research and plan per **`eversis-agent-core.mdc`**), not ad-hoc mode switches.

## Agent Handoff Diagram

```text
┌────────────────────────┐
│   Business Analyst     │
│ @eversis-analyze-      │
│   materials            │
└───────────┬────────────┘
            │ Start implementation
            ▼
┌────────────────────────┐
│ Engineering Manager    │
│ @eversis-implement     │
│ + @eversis-engineering-│
│   manager.mdc          │
└───────────┬────────────┘
            │ Delegates (internal prompts + roles)
            ├──────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
            ▼          ▼          ▼          ▼          ▼          ▼          ▼
     Context    Architect   Software   DevOps      E2E      Prompt     UI
     Engineer   (plan)      Engineer   Engineer   Engineer  Engineer   Reviewer
            │          │
            │          ▼
            │   Plan Reviewer (review-plan)
            │          │
            ▼          ▼
     Code Reviewer ◄─────────────────────────────────────────────────┘
     @eversis-review
     + eversis-code-reviewer.mdc
```

## Roles by phase

### 📋 Product ideation

#### Business Analyst

- **Focus:** orchestrating discovery workshop materials into **Jira-ready epics and stories**, or iterating on an existing backlog.
- Cleans transcripts, extracts tasks, runs quality review, and formats for Jira — with **human gates** before sync.
- **Invoke:** `@eversis-analyze-materials` or `/eversis-analyze-materials`.

### 🛠 Development

#### Context Engineer

- **Focus:** requirements, context, and domain understanding for a task.
- Gathers information from Jira, Confluence, codebase, and attachments; produces **`*.research.md`** under `docs/specs/`.
- Delegated via `@eversis-implement` → internal research prompt.

#### Architect

- **Focus:** solution design and **implementation plans** with phases, Technical Context, and acceptance checks.
- Produces **`*.plan.md`** — human approval required before plan validation and broad code changes.

#### Plan Reviewer

- **Focus:** adversarial stress-test of implementation plans before coding.
- Produces **`*.plan-review.md`** with verdict `APPROVED` or `REVISIONS NEEDED`.
- Delegated via `@eversis-implement` → internal [Review Plan](../prompts/internal/review-plan) prompt.

#### Engineering Manager

- **Focus:** **orchestrating** the Implement phase — research → plan → plan validation → code → review handoff.
- Delegates by task type; enforces human gates and **Fine → QA comment draft**.
- **Invoke:** `@eversis-implement` or `/eversis-implement` + `eversis-engineering-manager.mdc`.

#### Software Engineer

- **Focus:** implementing the **agreed plan** (backend and frontend).
- For UI: design system, accessibility, and `@eversis-review-ui` with Figma + Playwright MCP.

#### Prompt Engineer

- **Focus:** designing and optimizing **LLM application prompts** (runtime prompts, not Cursor packaging).

#### DevOps Engineer

- **Focus:** infrastructure, **CI/CD**, observability, and cloud cost governance.

### ✅ Quality

#### Code Reviewer

- **Focus:** structured code review (PASS / BLOCKER / SUGGESTION).
- **Invoke:** `@eversis-review` or `/eversis-review` + `eversis-code-reviewer.mdc`.

#### UI Reviewer

- **Focus:** **read-only** UI verification — Figma (EXPECTED) vs browser (ACTUAL).
- **Invoke:** `@eversis-review-ui` or `/eversis-review-ui`.

#### E2E Engineer

- **Focus:** **Playwright** end-to-end tests for critical user journeys.

### ⚙️ Cursor customization

#### Cursor customization engineer

- **Focus:** designing, creating, and reviewing **Cursor packaging** — rules, skills, prompts, `AGENTS.md`.
- **Invoke:** `@eversis-create-custom-agent` and related `eversis-create-custom-*` prompts.

#### Cursor customization orchestrator

- **Focus:** coordinating **multi-step** customization (research → create → review).
- See [orchestrator](./cursor-customization-orchestrator).

---

## Reference tables

### 📋 Product ideation

| Role                                   | Eversis packaging (rules / prompts)                                | Role summary                                                  | Typical MCP / tools                               |
| -------------------------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------- | ------------------------------------------------- |
| [Business Analyst](./business-analyst) | `eversis-role-business-analyst.mdc` · `@eversis-analyze-materials` · [analyze-materials](../prompts/public/analyze-materials) | Converts workshop materials into Jira-ready epics and stories | Atlassian, Figma, PDF Reader, Sequential Thinking |

### 🛠 Development

| Role                                         | Eversis packaging (rules / prompts)                                                                                | Role summary                                                                                    | Typical MCP / tools                                         |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| [Context Engineer](./context-engineer)       | `eversis-role-context-engineer.mdc` · [research](../prompts/internal/research) (via [implement](../prompts/public/implement)) | Gathers requirements, builds context, identifies gaps                                           | Atlassian, Figma, PDF Reader, Sequential Thinking           |
| [Architect](./architect)                     | `eversis-role-architect.mdc` · [plan](../prompts/internal/plan) (via [implement](../prompts/public/implement))                | Designs solutions, creates implementation plans (read-only — no build/test)                     | Atlassian, Context7, Figma, PDF Reader, Sequential Thinking |
| [Plan Reviewer](./plan-reviewer)             | [review-plan](../prompts/internal/review-plan) (via [implement](../prompts/public/implement))                                 | Stress-tests plans before coding; produces `.plan-review.md`                                    | Context7, Sequential Thinking                                 |
| [Engineering Manager](./engineering-manager) | `eversis-role-engineering-manager.mdc` · **`eversis-engineering-manager.mdc`** in this repo · [implement](../prompts/public/implement) | Orchestrates implementation by delegating to specialized roles                                  | Atlassian, Sequential Thinking                              |
| [Software Engineer](./software-engineer)     | `eversis-role-software-engineer.mdc` · [implement](../prompts/public/implement) (internal delegates on role page)            | Implements code against the plan                                                                | Context7, Figma, Playwright, Sequential Thinking            |
| [Prompt Engineer](./prompt-engineer)         | `eversis-role-prompt-engineer.mdc` · [engineer-prompt](../prompts/internal/engineer-prompt) (via [implement](../prompts/public/implement)) | Designs, optimizes, and secures LLM application prompts (runtime prompts, not Cursor packaging) | Context7, Sequential Thinking                               |

### 🏗 Infrastructure and DevOps

| Role                                 | Eversis packaging (rules / prompts)                             | Role summary                                                          | Typical MCP / tools                                                                          |
| ------------------------------------ | --------------------------------------------------------------- | --------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| [DevOps Engineer](./devops-engineer) | `eversis-role-devops-engineer.mdc` · [implement](../prompts/public/implement) (internal delegates on role page) | Infrastructure automation, CI/CD, cloud governance, cost optimization | Context7, Sequential Thinking, AWS API, AWS Docs, GCP Gcloud, GCP Observability, GCP Storage |

### ✅ Quality

| Role                             | Eversis packaging (rules / prompts)                                                                 | Role summary                                                                         | Typical MCP / tools                              |
| -------------------------------- | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ | ------------------------------------------------ |
| [Code Reviewer](./code-reviewer) | `eversis-role-code-reviewer.mdc` · **`eversis-code-reviewer.mdc`** in this repo · [review](../prompts/public/review) | Reviews code quality, security, correctness (structured PASS / BLOCKER / SUGGESTION) | Atlassian, Context7, Figma, Sequential Thinking  |
| [UI Reviewer](./ui-reviewer)     | `eversis-role-ui-reviewer.mdc` · [review-ui](../prompts/public/review-ui)                            | Verifies UI matches Figma design (read-only verification)                            | Figma, Playwright, Context7                      |
| [E2E Engineer](./e2e-engineer)   | `eversis-role-e2e-engineer.mdc` · [implement-e2e](../prompts/internal/implement-e2e) (via [implement](../prompts/public/implement)) | Creates and maintains Playwright E2E tests                                           | Playwright, Context7, Figma, Sequential Thinking |

### ⚙️ Cursor customization (delegated prompts)

| Role                                                                     | Eversis packaging (rules / prompts)                                                   | Role summary                                                                                            | Typical MCP / tools           |
| ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ----------------------------- |
| [Cursor customization engineer](./cursor-customization-engineer)         | `eversis-role-cursor-customization.mdc` · [create-custom-agent](../prompts/public/create-custom-agent) (and related create-custom prompts) | Designs, creates, reviews, and improves Cursor packaging — rules, skills, prompts, project instructions | Context7, Sequential Thinking |
| [Cursor customization orchestrator](./cursor-customization-orchestrator) | Composed workflow · [create-custom-agent](../prompts/public/create-custom-agent) (and related) | Coordinates complex, multi-step Cursor customization (research → create → review)                       | Sequential Thinking           |

### 🔧 Internal workers (not user-invocable)

These workers are not used as standalone **`@`** prompts. They are delegated from the [Cursor customization orchestrator](./cursor-customization-orchestrator) flow (isolated context per step).

| Worker                          | Page                                                                               | Role                                                                          |
| ------------------------------- | ---------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| Customization researcher        | [cursor-customization-researcher](./cursor-customization-researcher)               | Analyzes codebases and documentation, extracts patterns (read-only summaries) |
| Customization artifact creator  | [cursor-customization-artifact-creator](./cursor-customization-artifact-creator)   | Creates and modifies Cursor packaging files per specification                 |
| Customization artifact reviewer | [cursor-customization-artifact-reviewer](./cursor-customization-artifact-reviewer) | Validates quality and consistency of artifacts (read-only findings)           |
