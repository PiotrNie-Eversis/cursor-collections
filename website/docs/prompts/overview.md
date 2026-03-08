---
sidebar_position: 1
title: Prompts Overview
---

# Prompts Overview

Copilot Collections includes **15 public prompts** and **7 internal prompts** — slash commands that trigger specific workflow actions across the full product lifecycle. Public prompts are stored in `.github/prompts/` and become available as `/command` shortcuts in VS Code chat. Internal prompts are stored in `.github/internal-prompts/` and are used by the Engineering Manager agent to delegate work to specialized agents — they are not invoked directly by users.

## How Prompts Work

Each prompt file defines:

- **Agent binding** — Which agent executes the command.
- **Model** — The AI model to use (e.g., Claude Opus 4.6).
- **Description** — Shown in VS Code's command palette.
- **Instructions** — Detailed workflow steps, required skills, and output format.

When you type `/tsh-research`, `/tsh-plan`, etc. in the VS Code chat, the corresponding prompt file is loaded and executed by the bound agent.

## Public Prompts

These are the user-facing commands available in VS Code chat.

### 📋 Product Ideation Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-analyze-materials](./analyze-materials) | Business Analyst | Process workshop materials into Jira-ready epics and stories |

### 🛠 Development Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-research](./research) | Context Engineer | Gather context and requirements for a task |
| [/tsh-plan](./plan) | Architect | Create a structured implementation plan |
| [/tsh-implement](./implement) | Engineering Manager | Orchestrate implementation by delegating to specialized agents |
| [/tsh-implement-ui](./implement-ui) | Engineering Manager | Orchestrate UI implementation with iterative Figma verification |

### ✅ Quality Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-review](./review) | Code Reviewer | Review implementation against plan and standards |
| [/tsh-review-ui](./review-ui) | UI Reviewer | Single-pass Figma vs implementation comparison |
| [/tsh-review-codebase](./review-codebase) | Architect | Comprehensive code quality analysis |

### ⚙️ Copilot Customization Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-create-custom-agent](./create-custom-agent) | Copilot Orchestrator | Create a new custom agent |
| [/tsh-create-custom-skill](./create-custom-skill) | Copilot Orchestrator | Create a new custom skill |
| [/tsh-create-custom-prompt](./create-custom-prompt) | Copilot Orchestrator | Create a new custom prompt |
| [/tsh-create-custom-instructions](./create-custom-instructions) | Copilot Orchestrator | Create custom instruction files |

### 🏗 Infrastructure & Cost Analysis Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-audit-infrastructure](./audit-infrastructure) | DevOps Engineer | Audit infrastructure for security gaps, cost waste, and best practices |
| [/tsh-analyze-aws-costs](./analyze-aws-costs) | DevOps Engineer | AWS cost optimization and tagging compliance audit |
| [/tsh-analyze-gcp-costs](./analyze-gcp-costs) | DevOps Engineer | GCP cost optimization and labeling compliance audit |

## Internal Prompts

These prompts are **not invoked directly by users**. They are used by the [Engineering Manager](../agents/engineering-manager) agent to delegate tasks to specialized agents with consistent context. They live in `.github/internal-prompts/`.

| Internal Prompt | Delegated To | Purpose |
|---|---|---|
| `tsh-implement-common-task` | Software Engineer | Standard implementation task delegation |
| `tsh-implement-ui-common-task` | Software Engineer | UI implementation with Figma design references |
| `tsh-implement-e2e` | E2E Engineer | End-to-end test creation and verification |
| `tsh-deploy-kubernetes` | DevOps Engineer | Kubernetes deployments, Helm charts, workload resources |
| `tsh-implement-terraform` | DevOps Engineer | Terraform modules and cloud infrastructure provisioning |
| `tsh-implement-pipeline` | DevOps Engineer | CI/CD pipeline creation and modification |
| `tsh-implement-observability` | DevOps Engineer | Observability solutions: metrics, logs, traces, alerting |

## Input Format

All prompts accept either:

- A **Jira ticket ID**: `/tsh-research PROJ-123`
- A **task description**: `/tsh-research Add pagination to the user list API`

The agent adapts its behavior based on the input type — pulling context from Jira/Confluence for ticket IDs, or working from the description and codebase for free-form text.
