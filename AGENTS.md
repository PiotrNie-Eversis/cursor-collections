# Agent instructions (Cursor)

This repository uses the **Eversis Cursor port** of the Copilot Collections workflow (**Ideate → Implement → Review**).

- **Framework doc:** [documentation/cursor-collection.md](documentation/cursor-collection.md)
- **Project rules:** [.cursor/rules/](.cursor/rules/) — start with `eversis-agent-core.mdc` and edit `eversis-project-stack.mdc` per repo. For Implement / Review, optionally attach `eversis-engineering-manager.mdc` and `eversis-code-reviewer.mdc` when using the matching prompts.
- **Prompts:** Canonical **`eversis-*.md`** files live under **`website/docs/prompts/public/`** (user-facing) and **`website/docs/prompts/internal/`** (delegated). Attach with `@website/docs/prompts/...` in Chat or Agent. Catalog: [website/docs/prompts/overview.md](website/docs/prompts/overview.md).

Upstream Copilot artifacts use the `tsh-` prefix; Cursor prompts and rules in this framework use **`eversis-`**.
