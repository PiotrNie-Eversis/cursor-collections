---
role: "Cursor customization orchestrator"
description: "Create a new custom prompt (.prompt.md) for Cursor / Copilot Collections upstream. Analyzes existing prompts for patterns, identifies the right agent to route to, creates the prompt file, and validates the workflow end-to-end."
upstream_agent: "tsh-copilot-orchestrator"
---
Create a new custom prompt for Cursor / Copilot Collections upstream. Every prompt must specify an agent and model in YAML frontmatter — the orchestrator handles research of existing prompts and agents, design decisions, prompt file creation, and end-to-end validation. The user's message following this prompt may contain specific requirements or a description of the desired prompt.

## Required Skills

Before starting, load and follow these skills:
- `tsh-creating-prompts` - for prompt file creation workflow, templates, and validation checklist
- `tsh-technical-context-discovering` - for discovering project conventions and workspace patterns before creating
- `tsh-codebase-analysing` - for analyzing existing prompts for structural patterns and routing conventions

## Workflow

1. **Research existing prompts**: Analyze **upstream** prompts in `.github/prompts/*.prompt.md` and the **Cursor** copies under `prompts/public/eversis-*.md` for patterns and conventions:
   - Frontmatter format (agent, model, description fields)
   - Body structure (intro, Required Skills, Workflow, optional sections)
   - Skill reference format and conventions
   - Body size and level of detail
2. **Research available agents**: Read `.github/agents/*.agent.md` (upstream). In Cursor, map targets to `.cursor/rules/*.mdc` and `prompts/` as needed.
   - Available agent names and their responsibilities
   - Which agent is best suited for the prompt's workflow
   - Existing agent-to-prompt routing patterns
3. **Clarify requirements**: Determine the prompt's design parameters with the user:
   - Purpose, target workflow, and expected user interaction
   - Which agent should handle the prompt (based on agent research)
   - Required skills the prompt should reference
   - If the user's message already contains requirements, confirm understanding before proceeding
4. **Create the prompt file**: Add **upstream** `tsh-*.prompt.md` under `.github/prompts/` (Copilot). Add the **Eversis** copy as `prompts/public/eversis-*.md` (Cursor) with `role`/`description` frontmatter. Apply the `tsh-creating-prompts` skill workflow for structure and validation.
5. **Review and validate**: Review the created prompt against best practices:
   - Verify the routing agent exists in `.github/agents/` (or the Cursor equivalent you document)
   - Confirm structural consistency with existing prompts
   - Validate end-to-end workflow (prompt → skills → output)

## Important

- **Upstream** prompts use `agent` and `model` in YAML frontmatter. **Eversis** copies use `role`, `description`, and optional `upstream_agent` — follow the existing `eversis-*.md` pattern in this repo.
- Read `.github/agents/` before choosing the routing target for a new **upstream** prompt.

If the user attaches files or provides a description, use them as input for prompt design.

When in doubt about design decisions, ask the user for clarification rather than guessing.

<!-- Eversis port; upstream: tsh-create-custom-prompt -->
