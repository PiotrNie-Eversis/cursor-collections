# Context (`docs/context/`)

Place **internal knowledge** here: architecture notes, ADRs, wiki sync exports, onboarding. Use clear filenames.

**Task baseline (workshop continuity):** `docs/context/<project>/task-baseline.md` — optional epic/story index refreshed after successful Jira push from `@eversis-analyze-materials`. See [Jira Task Formatting](../../website/docs/skills/jira-task-formatting.md#step-9-baseline-refresh).

Referenced by research/plan steps and `@docs/context/` in Cursor.

## Framework repository policy (Cursor Collections)

In **this** monorepo, **`docs/context/*/` subfolders are gitignored** — project baselines, ADR folders, and wiki exports stay **local** and are not pushed. Only this **`README.md`** remains committed under `docs/context/`.

- Use `@docs/context/<project>/` in Cursor as today; files remain on disk.
- Share approved context via Confluence, Jira, or team exports — not via git in this repo.

**Consumer projects** may commit `docs/context/` by default. Opt in to the same local-only pattern with **`--gitignore-agent-artifacts`** (see [installation](../../website/docs/getting-started/installation.md)).
