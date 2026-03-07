---
sidebar_position: 9
title: GCP Gcloud
---

# GCP Gcloud MCP

**Server key:** `gcp-gcloud`
**Type:** stdio
**Package:** `@google-cloud/gcloud-mcp`

Provides access to Google Cloud operations and resource management for infrastructure automation.

## Capabilities

- Manage GCP resources across projects and regions.
- Query resource configurations and status.
- Execute GCP operations for infrastructure management.
- Support for Compute, Networking, IAM, and other GCP services.

## Which Agents Use It

| Agent | When |
|---|---|
| **DevOps Engineer** | Managing GCP infrastructure, querying resource state, cost analysis |

## Configuration

```json
{
  "gcp-gcloud": {
    "command": "npx",
    "args": ["-y", "@google-cloud/gcloud-mcp"]
  }
}
```

## Prerequisites

- Node.js installed (for running via `npx`).
- Google Cloud SDK (`gcloud`) authenticated with appropriate permissions.
- Active GCP project configured.

## Authentication

Uses Application Default Credentials (ADC) — authenticate via `gcloud auth application-default login` or a service account key.
