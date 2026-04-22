# Eversis prompt library (Cursor)

Place **user-facing** prompt bodies under **`public/`** as **`eversis-*.md`** (same layout as [website/docs/prompts/public/](../website/docs/prompts/public/) in Copilot Collections). Port content from [`.github/prompts/`](../.github/prompts/) (upstream **`tsh-*.prompt.md`**) and rename consistently.

Place **internal** (orchestration-only) prompts under **`internal/`**, mirroring [`.github/internal-prompts/`](../.github/internal-prompts/).

Invoke in Cursor by attaching the file, e.g. `@prompts/public/eversis-implement.md`, plus specs and context.

See the mapping table in [documentation/cursor-collection.md](../documentation/cursor-collection.md#artifact-mapping-tsh--eversis).

**Maintenance:** `eversis-*.md` files are **ported from** [`.github/prompts/`](../.github/prompts/) and [`.github/internal-prompts/`](../.github/internal-prompts/) (Copilot source of truth) with Cursor-specific edits. Skill references (`tsh-*`) point at [`.github/skills/`](../.github/skills/). The [website docs](../website/docs/prompts/) may lag this tree.
