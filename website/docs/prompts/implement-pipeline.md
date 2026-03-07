---
sidebar_position: 14
title: /tsh-implement-pipeline
---

# /tsh-implement-pipeline

**Agent:** DevOps Engineer
**File:** `.github/prompts/tsh-implement-pipeline.prompt.md`

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
