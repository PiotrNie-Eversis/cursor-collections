---
slug: /
sidebar_position: 1
title: Introduction
---

# Introduction

**Cursor Collections** is an opinionated **Cursor-native** product engineering framework — rules, attachable prompts, MCP, and reusable skills for the full software development lifecycle.

> **Ideate → Implement → Review** — one toolchain, end to end.

Maintained by [Eversis](https://eversis.com). Based on [Copilot Collections](https://github.com/TheSoftwareHouse/copilot-collections) from The Software House.

:::info Start here
New reader? Follow the curated path: **[Start here](./getting-started/start-here)**.
:::

## What this framework provides

Structured **roles**, **prompts** (`eversis-*.md`), **project rules** (`.cursor/rules/*.mdc`), and **skills** (`.cursor/skills/`) by lifecycle phase:

### 📋 Ideate — Requirements & planning

- **Rules** — Business Analyst role behavior (attach on demand).
- **Prompts** — `@eversis-analyze-materials` or `/eversis-analyze-materials`.
- **Skills** — Task analysis, transcript processing, task extraction, Jira formatting.

### 🛠 Implement — Architecture & delivery

- **Rules** — `eversis-agent-core.mdc` (always on), `eversis-engineering-manager.mdc` (orchestration).
- **Prompts** — `@eversis-implement` or `/eversis-implement` (research → plan → code).
- **Skills** — Architecture design, technical context discovery, frontend/backend implementation, gap analysis.

### ✅ Review — Quality & testing

- **Rules** — `eversis-code-reviewer.mdc` (PASS / BLOCKER / SUGGESTION).
- **Prompts** — `@eversis-review`, `@eversis-review-ui`, `@eversis-review-codebase` (and matching `/` commands).
- **Skills** — Code review, UI verification, E2E testing.

### 📄 Business Manager Docs — Release documentation

- **Prompts** — `@eversis-ba-docs-planner`, `@eversis-ba-docs-writer`.
- **MCP** — Word `.docx` chapter tools on **`eversis-collections`**. [Business Manager Docs workflow](./workflow/business-manager-docs).

### ⚙️ Framework customization

- **Prompts** — `eversis-create-custom-*.md` under `.cursor/prompts/public/`.
- **Skills** — Creating rules, skills, prompts, and project instructions.

### 🔌 Infrastructure

- **MCP** — Atlassian, Figma, Context7, Playwright, and local **`eversis-collections`** (skills + Word tools).
- **Cursor setup** — `.cursor/rules/`, `.cursor/commands/` (`/` loads canonical prompts), [`.cursor/mcp.json`](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/.cursor/mcp.json).

:::info Why the `eversis-` prefix?
All artifacts use the `eversis-` prefix (e.g. `@eversis-implement`) to avoid naming collisions with your own project-specific rules, skills, and prompts.
:::

`/` project commands live in **`.cursor/commands/`** — each loads the canonical `.cursor/prompts/public/` file. Legacy `/tsh-*` names are **not** used.

## Inventory

| Capability | Count | Description |
|---|---|---|
| 🧑‍💻 **Specialized roles** | 12 | [Agents overview](./agents/overview) |
| 💬 **Public prompts** | 12 | [Prompts overview](./prompts/overview) (synced from `.cursor/prompts/`) |
| 🧰 **Reusable skills** | 33 | [Skills overview](./skills/overview) via **`eversis-collections` MCP** |
| 🔌 **MCP (third-party)** | 11 | [Integrations overview](./integrations/overview) |
| 🏠 **MCP (local)** | 1 | **`eversis-collections`** — build [`mcp/eversis-collections-mcp/`](https://github.com/PiotrNie-Eversis/cursor-collections/tree/main/mcp/eversis-collections-mcp) first |
| 🧠 **Workflow variants** | 5 | [Workflow overview](./workflow/overview) |

## The problem

According to Gartner, only **10% of software engineers** see meaningful productivity improvement from AI tools. The gap is often the lack of structure, specialization, and repeatable workflows.

**Cursor Collections** turns AI into an end-to-end product engineering partner — workshop to Jira, through implementation, to structured review — with **human gates** between phases.

## Key benefits

### For product teams

- **Workshop to Jira in minutes** — transcripts, Figma, and documents → structured epics and stories with quality gates.
- **Systematic backlog quality** — multi-pass analysis for lifecycles, error states, and dependencies.

### For developers

- **Instant task context** — Jira, Figma, and codebase patterns in one research document.
- **Structured implementation plans** — phased scope before broad code changes.
- **Pixel-perfect UI delivery** — Figma verification loop where the workflow calls for it.

### For engineering leads

- **Consistent quality gates** — same structured review process across implementers.
- **Faster onboarding** — structured context and plans from day one.

## Quick wins

| Problem | Solution | Time |
|---|---|---|
| Workshop notes not in Jira | `@eversis-analyze-materials` | ~15 min |
| New developer needs context | `@eversis-implement` with ticket | ~3 min |
| No implementation plan | Same — research and plan before code | ~5 min |
| UI vs design | `eversis-implement` + `eversis-review-ui` | varies |
| Inconsistent reviews | `@eversis-review` | ~5 min |
| Technical debt | `@eversis-review-codebase` | ~15 min |

## Explore further

- **[Start here](./getting-started/start-here)** — curated onboarding checklist.
- [Workflow overview](./workflow/overview) — full delivery lifecycle.
- [Framework reference](./framework) — packaging and per-project bootstrap.
- [Use cases](./use-cases) — scenarios the framework covers.
- [For CTOs](./for-ctos) — adoption and impact framing.

## Canonical reference

- **[AGENTS.md](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/AGENTS.md)** — entry points, prefixes, and how files fit together.
- **[Framework reference](./framework)** — same content as `documentation/cursor-collection.md` on [GitHub](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/documentation/cursor-collection.md).

Prompt bodies are **authored** under `.cursor/prompts/`; this site **syncs** them on `npm run build` (see [Prompts overview](./prompts/overview)).
