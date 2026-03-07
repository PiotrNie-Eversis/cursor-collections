---
sidebar_position: 19
title: Creating Instructions
---

# Creating Instructions

**Folder:** `.github/skills/tsh-creating-instructions/`
**Used by:** Copilot Engineer

Covers repository-level instructions (`copilot-instructions.md`) and granular file-based instructions with `applyTo` glob patterns. Provides templates and a decision framework for instruction vs. skill placement.

## Instruction Types

| Aspect | Repository-level | Granular custom |
|---|---|---|
| **File** | `.github/copilot-instructions.md` | `*.instructions.md` |
| **Count per repo** | Exactly one | Multiple |
| **Frontmatter** | Not required | Recommended (`applyTo`, `name`, `description`) |
| **Applied when** | Every Copilot interaction | Files matching `applyTo` pattern are in context |
| **Location** | `.github/copilot-instructions.md` | `.github/instructions/` folder |
| **Purpose** | Project constitution — architecture, stack, fundamental rules | Scoped conventions — file-type or domain-specific rules |

## Decision Framework: Instructions vs. Skills

| Content Type | Belongs In |
|---|---|
| Always-applied project conventions | Instructions |
| File-type-specific coding standards | Granular instructions with `applyTo` |
| Reusable multi-step workflows | Skills |
| Domain-specific knowledge and templates | Skills |
| Workflow triggers and task definitions | Prompts |

## Key Guidelines

- Repository-level instructions are the "constitution" — the first file any developer or AI agent should read.
- Granular instructions use `applyTo` glob patterns to automatically apply when matching files are in context.
- Instructions must NOT trigger workflows (prompt territory) or define agent behavior (agent territory).

## Validation Checklist

- Correct file location (`.github/copilot-instructions.md` or `.github/instructions/`)
- `applyTo` pattern is valid and scoped appropriately (granular only)
- No workflow steps (skill territory)
- No personality or behavioral content (agent territory)
- Content is concise and focused on conventions/constraints

## Connected Skills

- `tsh-creating-agents` — For understanding how agents consume instructions.
- `tsh-creating-skills` — For deciding whether content belongs in instruction vs. skill.
