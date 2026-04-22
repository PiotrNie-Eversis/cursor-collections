# Agent instructions (Cursor)

This repository uses the **Eversis Cursor port** of the Copilot Collections workflow (**Ideate → Implement → Review**).

- **Framework doc:** [documentation/cursor-collection.md](documentation/cursor-collection.md)
- **Project rules:** [.cursor/rules/](.cursor/rules/) — start with `eversis-agent-core.mdc` and edit `eversis-project-stack.mdc` per repo. For Implement / Review, optionally attach `eversis-engineering-manager.mdc` and `eversis-code-reviewer.mdc` when using the matching prompts.
- **Prompts:** Add ported prompts under **`prompts/public/`** as `eversis-*.md` (user-facing) and **`prompts/internal/`** for delegated prompts; invoke with `@` in Chat/Agent. See [prompts/README.md](prompts/README.md).

Upstream Copilot artifacts use the `tsh-` prefix; Cursor prompts and rules in this framework use **`eversis-`**.
