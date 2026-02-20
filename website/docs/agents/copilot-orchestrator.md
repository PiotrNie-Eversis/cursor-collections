---
sidebar_position: 9
title: Copilot Orchestrator
---

# Copilot Orchestrator Agent *(experimental)*

**File:** `.github/agents/tsh-copilot-orchestrator.agent.md`

The Copilot Orchestrator coordinates complex, multi-step Copilot customization tasks using specialized sub-agents. It decomposes work into focused subtasks, delegates to workers, and synthesizes results.

## When to Use

Use the Orchestrator **instead of** the Copilot Engineer when the task involves:

- Creating an agent from scratch (requires research → design → create → review).
- Auditing all customization artifacts for consistency.
- Designing multi-agent systems.
- Any task that spans multiple phases of research, creation, and review.

For simple and medium tasks, the [Copilot Engineer](./copilot-engineer) may produce better results.

## How It Works

The Orchestrator solves the "context rot" problem — complex tasks degrade quality when handled by a single agent in one long conversation. Instead, it delegates to three specialized workers, each running in an isolated context window:

1. **Copilot Researcher** (`tsh-copilot-researcher`) — Analyzes existing codebase state, reads documentation, extracts patterns.
2. **Copilot Artifact Creator** (`tsh-copilot-artifact-creator`) — Creates or modifies files based on fully specified requirements.
3. **Copilot Artifact Reviewer** (`tsh-copilot-artifact-reviewer`) — Validates quality, consistency, and best practices.

The standard flow is: **Research → Design decisions → Create → Review → Fix (if needed)**.

## Key Principles

- **Context is precious** — The orchestrator's context contains only user interactions, design decisions, and synthesized summaries. Raw research output stays in worker contexts.
- **Delegate execution, retain judgment** — The orchestrator makes design decisions. Workers execute. Output is always validated.
- **Prompt is the interface** — Workers receive only the delegation prompt, no conversation history. Quality depends entirely on prompt clarity.

## Tool Access

| Tool | Usage |
|---|---|
| **Sequential Thinking** | Decompose complex tasks, evaluate design trade-offs |
| **File Read/Search** | Read and search workspace files for context |
| **Sub-agents** | Delegate to specialized worker agents (researcher, creator, reviewer) |
| **Todo** | Track orchestration progress with structured checklists |

## Sub-Agents

| Worker | When Delegated |
|---|---|
| `tsh-copilot-researcher` | Analyzing existing files, extracting patterns, reading docs |
| `tsh-copilot-artifact-creator` | Creating or modifying customization files |
| `tsh-copilot-artifact-reviewer` | Validating quality and consistency of artifacts |
| `tsh-copilot-engineer` | Moderately complex subtasks that don't decompose cleanly |

## Delegation Flow

```
User Request
    │
    ▼
┌──────────────────┐
│   Orchestrator    │ ← Design decisions live here
└──────┬───────────┘
       │
  ┌────┼────────────────┐
  ▼    ▼                ▼
Research  →  Create  →  Review
  │           │           │
  └───────────┴───────────┘
       │
       ▼
  Synthesized Results → User
```
