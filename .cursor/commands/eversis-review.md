# eversis-review (Cursor Collections)

You are running the **Code Review** workflow from **Eversis Cursor Collections**.

## Load the canonical prompt (required)

**Before any review verdict, BLOCKER classification, or repo-wide suggestions:**

1. If **`@eversis-review`** (or `.cursor/prompts/public/eversis-review.md`) is **already attached** with the full **Executable prompt** section, you may skip re-reading.
2. Otherwise **read the entire file** `.cursor/prompts/public/eversis-review.md` using your file-reading capability.

Follow that file’s **Executable prompt** end-to-end, including **all human gates**. Do **not** replace **PASS / BLOCKER / SUGGESTION** structure with an informal summary unless the prompt allows it.

## Role rule

Attach **`.cursor/rules/eversis-code-reviewer.mdc`** (in Cursor: `@eversis-code-reviewer`) **now** if it is not already in context, or when the loaded prompt tells you to.

## Your input (fill below, then send)

Paste the merge request context, **`@`** paths to changed files or plan, ticket id, and any acceptance criteria.
