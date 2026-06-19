# Plans (`docs/plans/`)

Legacy location for **flat implementation plans** as `*.md` files (scope, rationale, steps, risks).

## Framework repository policy (Cursor Collections)

In **this** monorepo, **`docs/plans/*.md` plan files are gitignored** — only this **`README.md`** stays committed. Existing plans (e.g. `cursor-rules-globs.md`) remain on disk for local `@` attachment but are **not pushed**.

**New work:** use **`docs/specs/<issue-kebab>/*.plan.md`** (and `*.research.md`, `*.plan-review.md`) under the Implement workflow — see [`docs/specs/README.md`](../specs/README.md).

Referenced by research/review steps and `@docs/plans/` in Cursor when you keep local copies here.

**Consumer projects** are not scaffolded with `docs/plans/` by default; teams may add and commit their own layout if needed.
