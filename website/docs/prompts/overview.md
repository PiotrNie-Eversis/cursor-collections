---
sidebar_position: 1
title: Prompts Overview
---

# Prompts Overview

This framework includes **12 public prompts** — Markdown workflow definitions for **Cursor** (Chat or Agent). They live under `website/docs/prompts/public/` as `eversis-*.md` files. **Attach** the file with `@` (for example `@website/docs/prompts/public/eversis-implement.md`); the `/eversis-*` labels in the table below match the docs site slugs, not a separate runtime.

## How Prompts Work

Each prompt file defines:

- **Role** — Who executes the workflow (conceptual; backed by **rules** in `.cursor/rules/` when you use them).
- **Description** — Short summary of the workflow’s purpose.
- **Instructions** — Detailed steps, required skills, and output format.

In **Cursor**, the **attachable body** is the Markdown file. The **Executable prompt** section at the bottom of each catalog page is the full body to follow in Agent mode.

## Public Prompts

These are the user-facing prompts. Doc paths use stable URLs (`slug`); files on disk are `eversis-*.md`.

### Product Ideation

| Catalog label | Description |
| --- | --- |
| [/eversis-analyze-materials](./public/analyze-materials) | Process workshop materials into Jira-ready epics and stories |

### Development

| Catalog label | Description |
| --- | --- |
| [/eversis-implement](./public/implement) | Orchestrate research → plan → implementation |

### Quality

| Catalog label | Description |
| --- | --- |
| [/eversis-review](./public/review) | Review implementation against plan and standards |
| [/eversis-review-ui](./public/review-ui) | Single-pass Figma vs implementation comparison |
| [/eversis-review-codebase](./public/review-codebase) | Comprehensive code quality analysis |

### Framework customization

| Catalog label | Description |
| --- | --- |
| [/eversis-create-custom-agent](./public/create-custom-agent) | New Cursor rules / role documentation |
| [/eversis-create-custom-skill](./public/create-custom-skill) | New Agent Skill (SKILL.md) |
| [/eversis-create-custom-prompt](./public/create-custom-prompt) | New attachable prompt Markdown |
| [/eversis-create-custom-instructions](./public/create-custom-instructions) | AGENTS.md and project instruction layout |

### Infrastructure and cost

| Catalog label | Description |
| --- | --- |
| [/eversis-audit-infrastructure](./public/audit-infrastructure) | Infra security and best-practices audit |
| [/eversis-analyze-aws-costs](./public/analyze-aws-costs) | AWS cost and tagging compliance |
| [/eversis-analyze-gcp-costs](./public/analyze-gcp-costs) | GCP cost and labeling compliance |

## Delegation via Implement

When you run **[eversis-implement](./public/implement)** (attach the file), the workflow describes how the **Engineering Manager** pattern delegates research, planning, and implementation. You do not need to open every internal prompt by hand — follow the public `eversis-implement.md` body; it references **`website/docs/prompts/internal/`** when needed.

| Phase | Delegated to (conceptual) |
| --- | --- |
| Research | Context Engineer (see [internal research](./internal/research)) |
| Planning | Architect (see [internal plan](./internal/plan)) |
| Implementation | Software Engineer, Prompt Engineer, DevOps, E2E, etc. (per task) |
| UI verification | UI Reviewer and internal UI prompts as applicable |

## Input Format

All prompts accept either:

- A **Jira ticket ID** (with context attached in chat)
- A **task description** (e.g. add pagination to the user list API)

The agent adapts based on the input type.
