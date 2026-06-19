# Specs (`docs/specs/`)

Place **feature specifications** and Implement artifacts here under `docs/specs/<issue-kebab>/`: `*.research.md`, `*.plan.md`, `*.plan-review.md`, `*.spec.md`, acceptance criteria, and links to tickets.

For larger initiatives you may add a sibling `*.implementation-plan.md` in the same folder to track phased repo work without mixing normative requirements into the spec.

Referenced by the Eversis **Implement** workflow and `.cursor/prompts/public/eversis-implement.md`.

## Framework repository policy (Cursor Collections)

In **this** monorepo, **`docs/specs/*/` subfolders are gitignored** — research, plans, and session specs stay **local** and are not pushed. Only this **`README.md`** remains committed under `docs/specs/`.

The same **local-only policy** applies to **`docs/context/*/`** and **`docs/plans/*.md`** (except [`docs/plans/README.md`](../plans/README.md)) — see those READMEs.

- Use `@docs/specs/<task>/` in Cursor as today; files remain on disk.
- Share approved plans via Jira, chat, or exports — not via git in this repo.
- **Normative BA Docs spec** (Business Manager Docs) lives on the docs site: [Business Docs Workflow](../website/docs/specs/business-docs-workflow.md).

**Consumer projects** using `setup-cursor-local.sh` may commit specs by default. Opt in to the same local-only pattern with **`--gitignore-agent-artifacts`** (see [installation](../website/docs/getting-started/installation.md)).
