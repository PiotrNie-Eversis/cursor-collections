---
sidebar_position: 1
title: Agents Overview
---

# Agents Overview

**Twelve specialized roles** plus **three internal workers** mirror a full product-engineering team across the **full delivery lifecycle** — from product ideation through development, infrastructure, and quality assurance.

In **Cursor**, those roles are expressed as **rules** (`.cursor/rules/eversis-*.mdc`), **prompts** (bodies in **`.cursor/prompts/public/`** and **`.cursor/prompts/internal/`** as `eversis-*.md`), and **skill packages** (`SKILL.md` under `.github/skills/`, used via the **`eversis-collections` MCP** and `eversis_skills_*` tools; optional `eversis-` names if you fork). **Attach** prompts in Chat or Agent by typing **`@`** and the **file stem** (e.g. **`@eversis-implement`**, **`@eversis-research`**). Use a full path under **`.cursor/prompts/...`** only if the file picker does not disambiguate.

The canonical packaging and mappings are documented in the [Framework reference](../framework) (same as **`documentation/cursor-collection.md`** in the repository). Entry points for this repository are **`AGENTS.md`** (root) and the always-on rule **`.cursor/rules/eversis-agent-core.mdc`**.

**Starter rule packs in this repo:** `eversis-agent-core.mdc` (always apply), `eversis-engineering-manager.mdc` (attach with **`@eversis-implement`**), and `eversis-code-reviewer.mdc` (attach with **`@eversis-review`**). Other roles use the **canonical** filenames in the table below (`eversis-role-<role>.mdc`); add those files when you split behavior out of the core packs.

## How roles work

Each role defines:

- **Purpose** — What it optimizes for and what it refuses to do.
- **Packaging** — Which rule file and prompts implement it in Cursor.
- **Tools** — MCP servers, terminal, and Cursor Agent capabilities you enable in **Cursor Settings → MCP**.
- **Skills** — Reusable procedures in **`.github/skills/`**; load content through **`eversis-collections` MCP** (`eversis_skills_get`, etc.). (`eversis-*` naming when you add your own copies.)
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
            │                                                        │
            ▼                                                        │
     Code Reviewer ◄─────────────────────────────────────────────────┘
     @eversis-review
     + eversis-code-reviewer.mdc
```

## Role summary

### 📋 Product ideation

| Role                                   | Eversis packaging (rules / prompts)                                | Role summary                                                  | Typical MCP / tools                               |
| -------------------------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------- | ------------------------------------------------- |
| [Business Analyst](./business-analyst) | `eversis-role-business-analyst.mdc` · `@eversis-analyze-materials` | Converts workshop materials into Jira-ready epics and stories | Atlassian, Figma, PDF Reader, Sequential Thinking |

### 🛠 Development

| Role                                         | Eversis packaging (rules / prompts)                                                                                | Role summary                                                                                    | Typical MCP / tools                                         |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| [Context Engineer](./context-engineer)       | `eversis-role-context-engineer.mdc` · `@eversis-research` (via `@eversis-implement`)               | Gathers requirements, builds context, identifies gaps                                           | Atlassian, Figma, PDF Reader, Sequential Thinking           |
| [Architect](./architect)                     | `eversis-role-architect.mdc` · `@eversis-plan` (via `@eversis-implement`)                          | Designs solutions, creates implementation plans                                                 | Atlassian, Context7, Figma, PDF Reader, Sequential Thinking |
| [Engineering Manager](./engineering-manager) | `eversis-role-engineering-manager.mdc` · **`eversis-engineering-manager.mdc`** in this repo · `@eversis-implement` | Orchestrates implementation by delegating to specialized roles                                  | Atlassian, Sequential Thinking                              |
| [Software Engineer](./software-engineer)     | `eversis-role-software-engineer.mdc` · internal implement prompts                                                  | Implements code against the plan                                                                | Context7, Figma, Playwright, Sequential Thinking            |
| [Prompt Engineer](./prompt-engineer)         | `eversis-role-prompt-engineer.mdc` · `@eversis-engineer-prompt` (via `@eversis-implement`)                         | Designs, optimizes, and secures LLM application prompts (runtime prompts, not Cursor packaging) | Context7, Sequential Thinking                               |

### 🏗 Infrastructure and DevOps

| Role                                 | Eversis packaging (rules / prompts)                             | Role summary                                                          | Typical MCP / tools                                                                          |
| ------------------------------------ | --------------------------------------------------------------- | --------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| [DevOps Engineer](./devops-engineer) | `eversis-role-devops-engineer.mdc` · internal implement prompts | Infrastructure automation, CI/CD, cloud governance, cost optimization | Context7, Sequential Thinking, AWS API, AWS Docs, GCP Gcloud, GCP Observability, GCP Storage |

### ✅ Quality

| Role                             | Eversis packaging (rules / prompts)                                                                 | Role summary                                                                         | Typical MCP / tools                              |
| -------------------------------- | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ | ------------------------------------------------ |
| [Code Reviewer](./code-reviewer) | `eversis-role-code-reviewer.mdc` · **`eversis-code-reviewer.mdc`** in this repo · `@eversis-review` | Reviews code quality, security, correctness (structured PASS / BLOCKER / SUGGESTION) | Atlassian, Context7, Figma, Sequential Thinking  |
| [UI Reviewer](./ui-reviewer)     | `eversis-role-ui-reviewer.mdc` · `@eversis-review-ui`                                               | Verifies UI matches Figma design (read-only verification)                            | Figma, Playwright, Context7                      |
| [E2E Engineer](./e2e-engineer)   | `eversis-role-e2e-engineer.mdc` · `@eversis-implement-e2e` (via `@eversis-implement`)               | Creates and maintains Playwright E2E tests                                           | Playwright, Context7, Figma, Sequential Thinking |

### ⚙️ Cursor customization (delegated prompts)

| Role                                                                     | Eversis packaging (rules / prompts)                                                   | Role summary                                                                                            | Typical MCP / tools           |
| ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ----------------------------- |
| [Cursor customization engineer](./cursor-customization-engineer)         | `eversis-role-cursor-customization.mdc` · public `eversis-create-custom-*.md` prompts | Designs, creates, reviews, and improves Cursor packaging — rules, skills, prompts, project instructions | Context7, Sequential Thinking |
| [Cursor customization orchestrator](./cursor-customization-orchestrator) | Composed workflow · `@eversis-create-custom-agent` (and related)                      | Coordinates complex, multi-step Cursor customization (research → create → review)                       | Sequential Thinking           |

### 🔧 Internal workers (not user-invocable)

These workers are not used as standalone **`@`** prompts. They are delegated from the [Cursor customization orchestrator](./cursor-customization-orchestrator) flow (isolated context per step).

| Worker                          | Page                                                                               | Role                                                                          |
| ------------------------------- | ---------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| Customization researcher        | [cursor-customization-researcher](./cursor-customization-researcher)               | Analyzes codebases and documentation, extracts patterns (read-only summaries) |
| Customization artifact creator  | [cursor-customization-artifact-creator](./cursor-customization-artifact-creator)   | Creates and modifies Cursor packaging files per specification                 |
| Customization artifact reviewer | [cursor-customization-artifact-reviewer](./cursor-customization-artifact-reviewer) | Validates quality and consistency of artifacts (read-only findings)           |
