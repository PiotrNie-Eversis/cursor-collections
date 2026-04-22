---
sidebar_position: 1
title: Prompts Overview
---

# Prompts Overview

This framework includes **12 public prompts** — Markdown workflow definitions for **Cursor** (Chat or Agent). They live under `website/docs/prompts/public/` as `eversis-*.md` files. In **VS Code Copilot**, the upstream equivalents were slash commands backed by `.github/prompts/`; in Cursor you **attach** the file with `@` (see **How to “run” a prompt in Cursor** in `documentation/cursor-collection.md` at the repository root).

## How Prompts Work

Each prompt file defines:

- **Agent binding** — Which agent executes the workflow.
- **Model** — The AI model to use (e.g., Claude Opus 4.6), when specified upstream.
- **Description** — Short summary of the command’s purpose.
- **Instructions** — Detailed workflow steps, required skills, and output format.

In **Cursor**, open or attach e.g. `@website/docs/prompts/public/eversis-implement.md` instead of typing `/eversis-implement` in VS Code chat. The **Executable prompt** section at the bottom of each catalog page is the full body to follow in Agent mode.

## Public Prompts

These are the user-facing prompts. Doc paths below use stable URLs (`slug`); files on disk are `eversis-*.md`.

### 📋 Product Ideation Commands

| Upstream (Copilot) | Agent | Description |
|---|---|---|
| [/eversis-analyze-materials](./public/analyze-materials) | Business Analyst | Process workshop materials into Jira-ready epics and stories |

### 🛠 Development Commands

| Upstream (Copilot) | Agent | Description |
|---|---|---|
| [/eversis-implement](./public/implement) | Engineering Manager | Orchestrate the full cycle: research → plan → implementation |

### ✅ Quality Commands

| Upstream (Copilot) | Agent | Description |
|---|---|---|
| [/eversis-review](./public/review) | Code Reviewer | Review implementation against plan and standards |
| [/eversis-review-ui](./public/review-ui) | UI Reviewer | Single-pass Figma vs implementation comparison |
| [/eversis-review-codebase](./public/review-codebase) | Architect | Comprehensive code quality analysis |

### ⚙️ Cursor Customization Commands

| Upstream (Copilot) | Agent | Description |
|---|---|---|
| [/eversis-create-custom-agent](./public/create-custom-agent) | Cursor customization orchestrator | Create a new custom agent |
| [/eversis-create-custom-skill](./public/create-custom-skill) | Cursor customization orchestrator | Create a new custom skill |
| [/eversis-create-custom-prompt](./public/create-custom-prompt) | Cursor customization orchestrator | Create a new custom prompt |
| [/eversis-create-custom-instructions](./public/create-custom-instructions) | Cursor customization orchestrator | Create custom instruction files |

### 🏗 Infrastructure & Cost Analysis Commands

| Upstream (Copilot) | Agent | Description |
|---|---|---|
| [/eversis-audit-infrastructure](./public/audit-infrastructure) | DevOps Engineer | Audit infrastructure for security gaps, cost waste, and best practices |
| [/eversis-analyze-aws-costs](./public/analyze-aws-costs) | DevOps Engineer | AWS cost optimization and tagging compliance audit |
| [/eversis-analyze-gcp-costs](./public/analyze-gcp-costs) | DevOps Engineer | GCP cost optimization and labeling compliance audit |

## Delegation via Implement

When you run [`/eversis-implement`](./public/implement) (in Cursor: attach `eversis-implement`), the Engineering Manager automatically handles the full development cycle. It first gathers context and creates an implementation plan (if needed), then delegates tasks to specialized agents. You don’t need to invoke individual agents — the orchestration is handled for you.

| Phase | Delegated To |
|---|---|
| Research (context gathering) | Context Engineer (via [internal research prompt](./internal/research)) |
| Planning (architecture) | Architect (via [internal plan prompt](./internal/plan)) |
| Backend / general code | Software Engineer |
| Frontend with Figma | Software Engineer (via [internal UI prompt](./internal/implement-ui)) |
| E2E tests | E2E Engineer |
| LLM application prompts | Prompt Engineer (via [internal engineer-prompt](./internal/engineer-prompt)) |
| Kubernetes, Terraform, CI/CD, observability | DevOps Engineer |
| UI verification | UI Reviewer |

## Input Format

All prompts accept either:

- A **Jira ticket ID** (attach `@website/docs/prompts/public/eversis-implement.md` and specify `PROJ-123` in chat)
- A **task description** (e.g. add pagination to the user list API)

The agent adapts its behavior based on the input type — pulling context from Jira/Confluence for ticket IDs, or working from the description and codebase for free-form text.
