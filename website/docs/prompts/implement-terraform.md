---
sidebar_position: 13
title: /tsh-implement-terraform (internal)
---

# /tsh-implement-terraform *(internal prompt)*

:::info Internal Prompt
This is an **internal prompt** — it is not invoked directly by users. It lives in `.github/internal-prompts/` and is used by the [Engineering Manager](../agents/engineering-manager) agent to delegate Terraform tasks to the DevOps Engineer.

To trigger Terraform implementation, use [`/tsh-implement`](./implement) — the Engineering Manager will automatically delegate infrastructure tasks from the plan to the DevOps Engineer using this internal prompt.
:::

**Agent:** DevOps Engineer
**File:** `.github/internal-prompts/tsh-implement-terraform.prompt.md`

Creates Terraform modules and provisions cloud infrastructure safely following established IaC patterns and safety guardrails.

## Usage

```text
/tsh-implement-terraform <describe what infrastructure to provision or modify>
```

## What It Does

### 1. Context Discovery

- Identifies existing Terraform modules, state backends, and provider configurations.
- Checks for naming conventions, tagging policies, and module structure.
- Discovers existing patterns for resource configuration and variable management.

### 2. Implementation

- Creates reusable Terraform modules with proper input/output variables.
- Applies consistent naming, tagging, and resource configuration.
- Configures state management and backend settings.
- Generates cost estimates for proposed changes.

### 3. Safety Checks

- Runs `terraform validate` and `terraform plan` before any changes.
- Never runs `terraform apply` without explicit user authorization.
- Includes rollback considerations and state management safeguards.

## Skills Loaded

- `tsh-implementing-terraform-modules` — Reusable Terraform modules for AWS, Azure, and GCP.
- `tsh-optimizing-cloud-cost` — Cost estimation and optimization.
- `tsh-technical-context-discovering` — Project conventions and existing patterns.
