# Agent instructions (Cursor)

This repository implements the **Eversis Cursor** workflow: **Ideate → Implement → Review**, using Cursor rules, attachable markdown prompts, MCP, and procedural **`SKILL.md` packages** under **`.github/skills/`** (consumed in Agent through the **`eversis-collections` MCP** server and `eversis_*` tools — build `mcp/eversis-collections-mcp/` first).

- **Framework doc:** [documentation/cursor-collection.md](documentation/cursor-collection.md)
- **Project rules:** [.cursor/rules/](.cursor/rules/) — start with `eversis-agent-core.mdc` and edit `eversis-project-stack.mdc` per repo. For Implement / Review, optionally attach `eversis-engineering-manager.mdc` and `eversis-code-reviewer.mdc` when using the matching prompts.
- **Prompts:** Canonical **`eversis-*.md`** files live under **`.cursor/prompts/public/`** (user-facing) and **`.cursor/prompts/internal/`** (delegated). Attach with **`@eversis-*`** or **`@.cursor/prompts/...`** in Chat or Agent. Catalog (built from synced copies): [website/docs/prompts/overview.md](website/docs/prompts/overview.md).

**Prefixes:** The **`eversis-`** name is used for rules, prompt files, and **skill package directories** in this framework (e.g. `.github/skills/eversis-creating-skills/`). **Do not** register **`.github/skills/`** as Cursor **Agent Skills**; use the **`eversis-collections`** entry in [`.cursor/mcp.json`](.cursor/mcp.json) after building the local MCP package.
