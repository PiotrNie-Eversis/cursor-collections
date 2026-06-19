# eversis-repo-docs-writer (Cursor Collections — Repo Docs)

You are running the **Repo Docs writer** workflow from **Eversis Cursor Collections** — **repository markdown** only (README, CHANGELOG, `docs/`, `website/docs`), **not** Word `.docx`.

## Load the canonical prompt (required)

**Before editing documentation:**

1. If **`@eversis-repo-docs-writer`** (or `.cursor/prompts/public/eversis-repo-docs-writer.md`) is **already attached** with its full workflow section, you may skip re-reading.
2. Otherwise **read the entire file** `.cursor/prompts/public/eversis-repo-docs-writer.md` using your file-reading capability.

Load **`.cursor/skills/eversis-writing-repo-documentation/SKILL.md`** (or MCP `eversis_skills_get` for `eversis-writing-repo-documentation`).

For **Word** release docs, stop and use **`@eversis-ba-docs-writer`** instead — see [`website/docs/workflow/business-manager-docs.md`](../../website/docs/workflow/business-manager-docs.md).

## Your input (fill below, then send)

Delegated plan task or explicit doc targets (**`@`** paths), plus any Technical Context from `@eversis-implement`.
