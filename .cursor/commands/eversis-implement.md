# eversis-implement (Cursor Collections)

You are running the **Engineering Manager / Implement** workflow from **Eversis Cursor Collections**.

## Load the canonical prompt (required)

**Before any codebase analysis, planning, or code edits:**

1. If **`@eversis-implement`** (or the full path `.cursor/prompts/public/eversis-implement.md`) is **already attached** in this thread and you have the full file body including the **Executable prompt** section, you may skip re-reading.
2. Otherwise **read the entire file** `.cursor/prompts/public/eversis-implement.md` using your file-reading capability.

Do **not** improvise a shortened workflow from memory — follow that file’s **Executable prompt** end-to-end, including **all human gates** (e.g. confirm after research, confirm before broad implementation, UI verification gate before review where applicable).

## Role rule

Attach **`.cursor/rules/eversis-engineering-manager.mdc`** (in Cursor: `@eversis-engineering-manager`) **now** if it is not already in context, or when the loaded prompt tells you to.

## Research / plan artifacts (when producing research or plans)

Per internal prompts **eversis-research** / **eversis-plan**: write **`*.research.md`** and **`*.plan.md`** under **`docs/specs/<issue-or-task-kebab>/`** in the **consumer** repository (or the team’s agreed specs folder, e.g. `specifications/`). Prefer files over pasting long artifacts only in chat so the next turn and reviewers can `@`-attach them.

## Status: Fine — handoff (same response, non-negotiable)

Per [workflow overview — Status: Fine](../../website/docs/workflow/overview.md) and step 10 of the loaded **`eversis-implement`** Executable prompt:

- When you declare **Fine**, the **QA comment draft must appear in that same message** — no “I’ll add QA in the next turn”.
- Follow **`.cursor/skills/eversis-fine-handoff/SKILL.md`** (or MCP **`eversis_skills_get`** / `eversis-fine-handoff`). Do **not** use `website/docs/skills/fine-handoff.md` as the spec for output shape — it is onboarding / narrative only; see [documentation/cursor-collection.md](../../documentation/cursor-collection.md) § QA handoff after Fine.
- Use the label **`Draft QA comment — review before posting to Jira`**. Do **not** call Jira / Atlassian comment APIs until the human explicitly approves.

## Your input (fill below, then send)

Paste your Jira key or description, links, **`@docs/specs/...`** / **`@docs/context/...`** paths (in the **open workspace** repo), and — if you already have one — the **plan file path** or **`@`** attachment.
