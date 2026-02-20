---
sidebar_position: 12
title: /tsh-deploy-kubernetes
---

# /tsh-deploy-kubernetes

**Agent:** DevOps Engineer
**File:** `.github/prompts/tsh-deploy-kubernetes.prompt.md`

Creates Kubernetes deployments, Helm charts, and configures workload resources following production-ready patterns.

## Usage

```text
/tsh-deploy-kubernetes <describe what to deploy or modify in Kubernetes>
```

## What It Does

### 1. Context Discovery

- Identifies existing Kubernetes manifests, Helm charts, and Kustomize overlays.
- Checks for project-specific infrastructure instructions.
- Discovers existing deployment patterns, naming conventions, and namespace structure.

### 2. Implementation

- Creates deployments with proper health probes, resource limits, and scaling policies.
- Generates Helm charts with values files for multi-environment support.
- Configures secrets handling, ConfigMaps, and service accounts.
- Implements network policies and security configurations.

### 3. Safety Checks

- Validates manifests before applying.
- Prefers `--dry-run` for initial verification.
- Includes rollback strategies and deployment safeguards.

## Skills Loaded

- `tsh-implementing-kubernetes` — Deployment patterns, Helm charts, cluster management.
- `tsh-managing-secrets` — Secrets management for Kubernetes environments.
- `tsh-technical-context-discovering` — Project conventions and existing patterns.
