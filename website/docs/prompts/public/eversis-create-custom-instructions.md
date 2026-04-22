---
sidebar_position: 16
title: "Create custom instructions"
slug: create-custom-instructions
prompt_role: "Cursor customization orchestrator"
prompt_description: "Create custom instructions (.instructions.md or copilot-instructions.md) for Cursor / Copilot Collections upstream. Analyzes existing project conventions, determines the appropriate instruction type and scope, creates the instructions file, and validates against best practices."
upstream_agent: "eversis-copilot-orchestrator"
---
# /eversis-create-custom-instructions

**Agent:** Copilot Orchestrator  
**File:** `website/docs/prompts/public/eversis-create-custom-instructions.md`

Creates custom instructions (`.instructions.md` or `copilot-instructions.md`) for VS Code Copilot. Helps decide between repository-level and file-scoped instructions, analyzes existing project conventions, and creates the instructions file.

## Usage

```text
@website/docs/prompts/public/eversis-create-custom-instructions.md
<conventions or requirements to encode>
```

In **Cursor**, attach the file above (or open it and reference it with `@`) plus your ticket text and context.

## What It Does

1. **Research workspace conventions** — Analyzes the workspace for existing coding standards, project structure, technology stack, and any existing instruction files.
2. **Determine instruction type** — Helps choose between:
   - **Repository-level** (`copilot-instructions.md`) — applies to all Copilot interactions in the workspace.
   - **File-scoped** (`.instructions.md` with `applyTo` glob patterns) — applies only to interactions involving matching files.
3. **Clarify requirements** — Determines what coding standards, framework-specific patterns, or behavioral guidelines to encode.
4. **Create the instructions** — Delegates creation to the artifact creator worker.
5. **Review and validate** — Delegates review to the artifact reviewer. Fixes issues if found.

## Skills Loaded

- `eversis-creating-instructions` — Instructions file creation workflow, type selection, scope decisions, and validation checklist.
- `eversis-technical-context-discovering` — Discover project conventions and workspace patterns.
- `eversis-codebase-analysing` — Analyze workspace for existing coding conventions and patterns.

## Output

An instructions file with appropriate scope and content.

:::info Orchestrator Workflow
This command routes to the Copilot Orchestrator which handles the full research → create → review workflow automatically using specialized sub-agents.
:::

---

## Executable prompt (attach in Cursor)

Create custom instructions for Cursor / Copilot Collections upstream. There are two types: repository-level instructions (`copilot-instructions.md`) that apply to all Copilot interactions, and file-scoped instructions (`.instructions.md` with `applyTo` glob patterns) that target specific files or directories. The user's message following this prompt may contain specific requirements or conventions to encode.

## Required Skills

Before starting, load and follow these skills:
- `eversis-creating-instructions` - for instructions file creation workflow, type selection, scope decisions, and validation checklist
- `eversis-technical-context-discovering` - for discovering project conventions and workspace patterns before creating
- `eversis-codebase-analysing` - for analyzing workspace for existing coding conventions and patterns

## Workflow

1. **Research workspace conventions**: Analyze the workspace for existing coding standards and conventions:
   - Project structure and technology stack
   - Existing coding patterns and standards
   - Any existing instruction files (`.instructions.md` or `copilot-instructions.md`)
   - Note: this repository currently has NO instruction files of either type
2. **Determine instruction type**: Help the user choose the appropriate instruction type:
   - **Repo-level** (`copilot-instructions.md`): applies to all Copilot interactions in the workspace
   - **File-scoped** (`.instructions.md` with `applyTo` glob patterns): applies only to interactions involving matching files
   - Guide the decision based on the user's needs and scope
3. **Clarify requirements**: Determine what conventions, standards, or behaviors to encode:
   - Coding standards and style preferences
   - Framework-specific patterns and conventions
   - Behavioral guidelines for Copilot in this workspace
   - If the user's message already contains requirements, confirm understanding before proceeding
4. **Create the instructions file**: Create the instructions file with appropriate type, scope, and content. Apply the `eversis-creating-instructions` skill workflow for structure and validation.
5. **Review and validate**: Review the created instructions against best practices:
   - Verify scope is appropriate for the instruction type
   - Confirm guidelines are clear and actionable for Copilot
   - Check that file-scoped `applyTo` patterns match intended files (if applicable)

## Guidelines

- **Repo-level instructions** (`copilot-instructions.md`): Place in `.github/` directory. Apply to all Copilot interactions — use for project-wide coding standards, naming conventions, architecture decisions.
- **File-scoped instructions** (`.instructions.md` with `applyTo`): Place alongside the code they govern. Use `applyTo` glob patterns to target specific files or directories.
- This repository currently has NO instruction files — the user is starting from scratch. Communicate this context during the research step.

If the user attaches files or provides a description, use them as input for instruction design.

When in doubt about the instruction type or scope, ask the user for clarification rather than guessing.

<!-- Eversis port; upstream: eversis-create-custom-instructions -->
