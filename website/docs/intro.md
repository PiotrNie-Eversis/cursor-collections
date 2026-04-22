---
slug: /
sidebar_position: 1
title: Introduction
---

# Introduction

**Cursor Collections** is a **Cursor-native** product engineering framework — from workshop to Jira, through implementation, to structured review and testing. It uses **rules** (`.cursor/rules/`), **attachable prompts** (`eversis-*.md`), **MCP**, and **Agent Skills** (`.github/skills/`).

Built by [The Software House](https://tsh.io); the Eversis Cursor layer (rules, prompts, and this site) is maintained for **Cursor** only.

## The Problem

According to Gartner, only **10% of software engineers** see meaningful productivity improvement from AI tools. The gap is often the lack of structure, specialization, and repeatable workflows.

**Cursor Collections** turns AI into an end-to-end product engineering partner — from converting a workshop transcript into a Jira backlog, through architecture design and implementation, to code review, UI verification, and E2E testing — with **human gates** between phases.

## What It Provides

| Capability | Count | Description |
|---|---|---|
| 🧑‍💻 **Specialized roles** | 12 | Business Analyst, Context Engineer, Architect, Engineering Manager, Software Engineer, Prompt Engineer, Code Reviewer, UI Reviewer, E2E Engineer, DevOps Engineer, and framework customization (rules, skills, prompts) |
| 💬 **Public prompts** | 12 | Attach `eversis-*.md` from `.cursor/prompts/public/` (e.g. analyze, implement, review, create-custom-*) |
| 🔧 **Delegation** | via `eversis-implement` | Engineering Manager pattern: research → plan → implementation with role rules and internal prompts |
| 🧰 **Reusable skills** | 31 | Topic packages under `.github/skills/tsh-*/` — load as **Cursor Agent Skills** |
| 🔌 **MCP integrations** | 11 | Atlassian, Figma Dev Mode, Context7, Playwright, Sequential Thinking, PDF Reader, AWS API, AWS Documentation, GCP Gcloud, GCP Observability, GCP Storage |
| 🧠 **Structured workflows** | 5 | Standard flow, UI flow, E2E flow, workshop analysis, framework customization |

## Key Benefits

### For Product Teams
- **Workshop to Jira in minutes** — Process transcripts, Figma designs, and documents into structured epics and stories with a quality review gate.
- **Systematic backlog quality** — Multi-pass analysis catches gaps in lifecycles, error states, and dependencies.

### For Developers
- **Instant task context** — Pull requirements from Jira, designs from Figma, and patterns from the codebase into one research document.
- **Structured implementation plans** — Phased plans with clear scope before broad code changes.
- **Pixel-perfect UI delivery** — Figma verification loop where the workflow calls for it.

### For Engineering Leads
- **Consistent quality gates** — Same structured review process across implementers.
- **Faster onboarding** — Structured context and plans from day one.

## Quick Wins

| Problem | Solution | Time |
|---|---|---|
| Workshop notes not in Jira | Attach `eversis-analyze-materials.md` | ~15 min |
| New developer needs context | Attach `eversis-implement.md` with ticket | ~3 min |
| No implementation plan | Same — research and plan before code | ~5 min |
| UI vs design | `eversis-implement` + `eversis-review-ui` as needed | varies |
| Inconsistent reviews | Attach `eversis-review.md` | ~5 min |
| E2E gaps | Implement flow delegates to E2E patterns | varies |
| Technical debt | `eversis-review-codebase.md` | ~15 min |
| Cloud costs | `eversis-analyze-aws-costs` / `eversis-analyze-gcp-costs` | ~10 min |
| Infra gaps | `eversis-audit-infrastructure.md` | ~15 min |

## How It Works

> **Ideate → Implement → Review**

1. **Ideate** — Workshop materials → Jira-ready epics and stories.
2. **Implement** — Research, plan, and code with specialized **rules** and **prompts**.
3. **Review** — Structured review against criteria, plus optional UI and codebase passes.

Each phase produces a documented artifact; the next phase waits on **human approval** where the prompts require it.

## Next Steps

- [Prerequisites](./getting-started/prerequisites) — Cursor and tooling.
- [Installation](./getting-started/installation) — Clone and open in Cursor.
- [MCP Setup](./getting-started/mcp-setup) — Jira, Figma, and other tools.
- [Workflow Overview](./workflow/overview) — Full delivery lifecycle.
- [Use Cases](./use-cases) — Scenarios the framework covers.
- [Quick Wins](./getting-started/quick-wins) — Daily routines.
