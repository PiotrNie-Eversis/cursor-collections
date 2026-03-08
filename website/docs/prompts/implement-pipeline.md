---
sidebar_position: 14
title: /tsh-implement-pipeline (internal)
---

# /tsh-implement-pipeline *(internal prompt)*

:::info Internal Prompt
This is an **internal prompt** — it is not invoked directly by users. It lives in `.github/internal-prompts/` and is used by the [Engineering Manager](../agents/engineering-manager) agent to delegate CI/CD pipeline tasks to the DevOps Engineer.

To trigger pipeline implementation, use [`/tsh-implement`](./implement) — the Engineering Manager will automatically delegate pipeline tasks from the plan to the DevOps Engineer using this internal prompt.
:::

**Agent:** DevOps Engineer
**File:** `.github/internal-prompts/tsh-implement-pipeline.prompt.md`

Creates or modifies CI/CD pipelines with proper deployment stages, environment protection, and secure authentication.

## Usage

```text
/tsh-implement-pipeline <describe the pipeline to create or modify>
```

## What It Does

### 1. Context Discovery

- Identifies the CI/CD platform (GitHub Actions, GitLab CI, Bitbucket Pipelines, Jenkins).
- Checks for existing pipeline patterns, caching strategies, and environment configurations.
- Discovers secret management and authentication patterns.

### 2. Implementation

- Creates pipeline configuration following the project's CI/CD platform conventions.
- Implements deployment stages with proper environment protection rules.
- Configures caching and parallelization for optimal build times.
- Sets up secure authentication for deployments.

### 3. Safety Checks

- Validates pipeline configuration syntax.
- Ensures environment protection rules are in place for production deployments.
- Verifies secrets are properly referenced, not hardcoded.

## Skills Loaded

- `tsh-implementing-ci-cd` — CI/CD pipeline design patterns and deployment strategies.
- `tsh-managing-secrets` — Secrets management for CI/CD environments.
- `tsh-technical-context-discovering` — Project conventions and existing patterns.
