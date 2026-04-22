---
sidebar_position: 13
title: "Create custom agent"
slug: create-custom-agent
prompt_role: "Cursor customization orchestrator"
prompt_description: "Create a new custom agent (.agent.md) for Cursor / Copilot Collections upstream. Analyzes existing agents for patterns, guides through design decisions, creates the agent file, and validates against best practices."
upstream_agent: "eversis-copilot-orchestrator"
---
# /eversis-create-custom-agent

**Agent:** Copilot Orchestrator  
**File:** `website/docs/prompts/public/eversis-create-custom-agent.md`

Creates a new custom agent (`.agent.md`) for VS Code Copilot. Analyzes existing agents for patterns, guides through design decisions, creates the agent file, and validates against best practices.

## Usage

```text
@website/docs/prompts/public/eversis-create-custom-agent.md
<agent requirements or description>
```

In **Cursor**, attach the file above (or open it and reference it with `@`) plus your ticket text and context.

## What It Does

1. **Research existing agents** — Analyzes agents in `.github/agents/` for naming conventions, structural patterns, tool configurations, and skill references.
2. **Clarify requirements** — Determines the agent's purpose, responsibilities, target workflows, and tool needs with the user.
3. **Design the agent** — Makes design decisions based on research findings and user input: agent name, description, personality, tool list, and skill references.
4. **Create the agent** — Delegates creation to the artifact creator worker.
5. **Review and validate** — Delegates review to the artifact reviewer. Fixes issues if found.

## Skills Loaded

- `eversis-creating-agents` — Agent file creation workflow, templates, and validation checklist.
- `eversis-technical-context-discovering` — Discover project conventions and workspace patterns.
- `eversis-codebase-analysing` — Analyze existing agents for structural patterns.

## Output

A new agent file in `.github/agents/` following workspace conventions.

:::info Orchestrator Workflow
This command routes to the Copilot Orchestrator which handles the full research → create → review workflow automatically using specialized sub-agents.
:::

---

## Executable prompt (attach in Cursor)

Create a new custom agent for Cursor / Copilot Collections upstream. The orchestrator handles research of existing agents, design decisions, agent file creation, and review against best practices. The user's message following this prompt may contain specific agent requirements or a description of the desired agent.

## Required Skills

Before starting, load and follow these skills:
- `eversis-creating-agents` - for agent file creation workflow, templates, and validation checklist
- `eversis-technical-context-discovering` - for discovering project conventions and workspace patterns before creating
- `eversis-codebase-analysing` - for analyzing existing agents for structural patterns and naming conventions

## Workflow

1. **Research existing agents**: Analyze `.github/agents/*.agent.md` (upstream GitHub Copilot). For Cursor, compare with `.cursor/rules/*.mdc` patterns.
   - Naming conventions and file placement
   - Structural patterns (sections, headings, formatting)
   - Tool configurations and skill references
   - Behavioral constraints and personality definitions
2. **Clarify requirements**: Determine the agent's design parameters with the user:
   - Purpose and primary responsibilities
   - Target workflows and use cases
   - Tool needs and skill references
   - If the user's message already contains requirements, confirm understanding before proceeding
3. **Design the agent**: Make design decisions based on research findings and user input:
   - Agent name, description, and personality
   - Tool list and skill references
   - Behavioral constraints and operational boundaries
   - How the agent fits within the existing agent ecosystem
4. **Create the agent file**: Add `eversis-*.agent.md` under **`.github/agents/`** for upstream. For Cursor-native projects, prefer **`.cursor/rules/eversis-*.mdc`** plus prompts under `prompts/`. Apply the `eversis-creating-agents` skill workflow for structure and validation.
5. **Review and validate**: Review the created agent against best practices:
   - Verify skill and tool references point to valid targets
   - Confirm structural consistency with existing agents
   - Check that the agent integrates well with the existing ecosystem

If the user attaches files or provides a description, use them as input for agent design.

Follow the conventions established by existing agents in the workspace.

When in doubt about design decisions, ask the user for clarification rather than guessing.

<!-- Eversis port; upstream: eversis-create-custom-agent -->
