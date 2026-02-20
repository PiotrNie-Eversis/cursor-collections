---
sidebar_position: 1
title: Prompts Overview
---

# Prompts Overview

Copilot Collections includes **22 ready-to-use prompts** — slash commands that trigger specific workflow actions across the full product lifecycle. They are stored in `.github/prompts/` as `.prompt.md` files and become available as `/command` shortcuts in VS Code chat.

## How Prompts Work

Each prompt file defines:

- **Agent binding** — Which agent executes the command.
- **Model** — The AI model to use (e.g., Claude Opus 4.6).
- **Description** — Shown in VS Code's command palette.
- **Instructions** — Detailed workflow steps, required skills, and output format.

When you type `/tsh-research`, `/tsh-plan`, etc. in the VS Code chat, the corresponding prompt file is loaded and executed by the bound agent.

## Available Prompts

### 📋 Product Ideation Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-analyze-materials](./analyze-materials) | Business Analyst | Process workshop materials into Jira-ready epics and stories |
| [/tsh-clean-transcript](./clean-transcript) | Business Analyst | Clean a raw workshop transcript |
| [/tsh-create-jira-tasks](./create-jira-tasks) | Business Analyst | Format extracted tasks for Jira and push |

### 🛠 Development Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-research](./research) | Context Engineer | Gather context and requirements for a task |
| [/tsh-plan](./plan) | Architect | Create a structured implementation plan |
| [/tsh-implement](./implement) | Software Engineer | Execute the implementation plan |
| [/tsh-implement-ui](./implement-ui) | Software Engineer | Implement UI with iterative Figma verification |

### ✅ Quality Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-review](./review) | Code Reviewer | Review implementation against plan and standards |
| [/tsh-review-ui](./review-ui) | UI Reviewer | Single-pass Figma vs implementation comparison |
| [/tsh-review-codebase](./review-codebase) | Architect | Comprehensive code quality analysis |
| [/tsh-implement-e2e](./implement-e2e) | E2E Engineer | Create end-to-end tests with Playwright |

### ⚙️ Copilot Customization Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-create-custom-agent](./create-custom-agent) | Copilot Orchestrator | Create a new custom agent |
| [/tsh-create-custom-skill](./create-custom-skill) | Copilot Orchestrator | Create a new custom skill |
| [/tsh-create-custom-prompt](./create-custom-prompt) | Copilot Orchestrator | Create a new custom prompt |
| [/tsh-create-custom-instructions](./create-custom-instructions) | Copilot Orchestrator | Create custom instruction files |

### 🏗 Infrastructure & DevOps Commands

| Command | Agent | Description |
|---|---|---|
| [/tsh-deploy-kubernetes](./deploy-kubernetes) | DevOps Engineer | Create Kubernetes deployments, Helm charts, and workload resources |
| [/tsh-implement-terraform](./implement-terraform) | DevOps Engineer | Create Terraform modules and provision cloud infrastructure safely |
| [/tsh-implement-pipeline](./implement-pipeline) | DevOps Engineer | Create or modify CI/CD pipelines with deployment stages |
| [/tsh-implement-observability](./implement-observability) | DevOps Engineer | Implement observability solutions including metrics, logs, traces, and alerting |
| [/tsh-audit-infrastructure](./audit-infrastructure) | DevOps Engineer | Audit infrastructure for security gaps, cost waste, and best practices |
| [/tsh-analyze-aws-costs](./analyze-aws-costs) | DevOps Engineer | AWS cost optimization and tagging compliance audit |
| [/tsh-analyze-gcp-costs](./analyze-gcp-costs) | DevOps Engineer | GCP cost optimization and labeling compliance audit |

## Input Format

All prompts accept either:

- A **Jira ticket ID**: `/tsh-research PROJ-123`
- A **task description**: `/tsh-research Add pagination to the user list API`

The agent adapts its behavior based on the input type — pulling context from Jira/Confluence for ticket IDs, or working from the description and codebase for free-form text.
