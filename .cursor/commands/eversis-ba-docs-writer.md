# eversis-ba-docs-writer (Cursor Collections — BA Docs, Word)

You are running the **BA Docs (Word) writer** workflow from **Eversis Cursor Collections** — **`.docx`** updates only, not README or `website/` markdown.

## Load the canonical prompt (required)

**Before editing OOXML or calling `.docx` chapter tools:**

1. If **`@eversis-ba-docs-writer`** (or `.cursor/prompts/public/eversis-ba-docs-writer.md`) is **already attached** with its full workflow section, you may skip re-reading.
2. Otherwise **read the entire file** `.cursor/prompts/public/eversis-ba-docs-writer.md` using your file-reading capability.

Ensure **`docs-update-plan.md`** (or equivalent) was **human-approved** before executing destructive / broad edits — see the public prompt and [`website/docs/workflow/business-manager-docs.md`](../../website/docs/workflow/business-manager-docs.md).

Build and enable **`eversis-collections` MCP** so **`generate_summary_map`**, **`read_chapter`**, **`update_chapter`**, etc. are available.

## Role rule (optional)

Attach **`.cursor/rules/eversis-ba-docs-writer.mdc`** (`@eversis-ba-docs-writer`) for writer boundaries.

## Your input (fill below, then send)

Approved plan path (**`@`**), target `.docx`, release id, and any deltas since planning.
