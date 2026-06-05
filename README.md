<h1 align="center">Cursor Collections</h1>

<p align="center">
  <b>Cursor-native</b> product engineering framework — <b>Ideate → Implement → Review</b> with rules, attachable prompts, MCP, and reusable skills.<br/>
  Maintained by <a href="https://eversis.com" target="_blank">Eversis</a>; Cursor rules, <code>eversis-*</code> prompts, and this documentation are curated for Cursor by <b>Eversis</b>. Based on <a href="https://github.com/TheSoftwareHouse/copilot-collections" target="_blank">Copilot Collections</a> from The Software House.
</p>

---

## What this repository provides

Structured **roles**, **prompts** (`eversis-*.md`), **project rules** (`.cursor/rules/*.mdc`), and **skills** (`.cursor/skills/`) for the full product lifecycle:

| Phase                       | Focus                                        | Entry (Cursor)                                                                                                                                                                                                                |
| --------------------------- | -------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Ideate**                  | Requirements and planning                    | `@eversis-analyze-materials` or `/eversis-analyze-materials`                                                                                                                                                                  |
| **Implement**               | Architecture and delivery                    | `@eversis-implement` or `/eversis-implement`                                                                                                                                                                                  |
| **Review**                  | Code and UI quality                          | `@eversis-review` or `/eversis-review`; `@eversis-review-ui` or `/eversis-review-ui`; `@eversis-review-codebase`                                                                                                              |
| **Business Manager Docs**   | Release documentation (Word `.docx`)         | `@eversis-ba-docs-planner` or `/eversis-ba-docs-planner`; `@eversis-ba-docs-writer` or `/eversis-ba-docs-writer` — workflow: [website/docs/workflow/business-manager-docs.md](website/docs/workflow/business-manager-docs.md) |
| **Framework customization** | Rules, skills, prompts, project instructions | Attach `eversis-create-custom-*.md` under `.cursor/prompts/public/`                                                                                                                                                           |

`/` project commands are defined in **`.cursor/commands/`** and appear in the Cursor `/` dropdown — each instructs the agent to **load** the canonical `.cursor/prompts/public/` file (via **`@`** or read) before executing it; workflow bodies are not duplicated in the command stub. Legacy `/tsh-*` names are not used.

**Mandatory QA comment draft (after Implement):** When orchestration reaches **Fine** (agent-side implementation complete), the Engineering Manager **always** produces a labeled QA comment draft in the same response, following the **`eversis-qa-comment`** skill. You review and approve the draft before publication — paste it into Jira, or instruct the agent to post via the **Atlassian MCP** (`addCommentToJiraIssue`). The agent never posts automatically. Docs: [`.cursor/skills/eversis-qa-comment/SKILL.md`](.cursor/skills/eversis-qa-comment/SKILL.md) (overview on docs site: [website/docs/skills/qa-comment.md](website/docs/skills/qa-comment.md)); rule: [`.cursor/rules/eversis-engineering-manager.mdc`](.cursor/rules/eversis-engineering-manager.mdc).

**Skills** live in [`.cursor/skills/`](.cursor/skills/) as `eversis-*` topic folders with `SKILL.md` (procedural how-to). **Use them in Agent** via the **`eversis-collections` MCP** server ([`mcp/eversis-collections-mcp/`](mcp/eversis-collections-mcp/): `npm install && npm run build` once, then enable it through [`.cursor/mcp.json`](.cursor/mcp.json)). **`eversis_*` tools** list, read, and validate the tree, and **`eversis_skill_run_script`** runs allowlisted per-skill scripts; the same server exposes **Word `.docx` chapter tools** (`generate_summary_map`, `read_chapter`, `update_chapter`, `upload_to_sharepoint` stub) used by **Business Manager Docs** prompts — see [AGENTS.md](AGENTS.md). The `.docx` engine handles UTF-8 BOM stripping and locale-specific Word styles (e.g. Polish `Nagwek*`) automatically, and flags section content type (`hasTables`, `hasImages`) in the summary map. This replaces registering the folder as **Cursor Agent Skills**.

**Docs site:** build and preview from [`website/`](website/) (Docusaurus). **`npm run build`** / **`npm start`** in `website/` run **`sync-prompts`** then **`validate-cursor-links`** — broken markdown links under `.cursor/` or in the synced prompt copy fail the build. **Authoritative how-to for using this framework in any repo:** [documentation/cursor-collection.md](documentation/cursor-collection.md) (including § **Link conventions in `.cursor/`** for prompt authors).

---

## Quick start (Cursor)

1. **Open this repository in [Cursor](https://cursor.com/).**
2. Read [**AGENTS.md**](AGENTS.md) and [documentation/cursor-collection.md](documentation/cursor-collection.md).
3. Use [**project rules**](.cursor/rules/): start with `eversis-agent-core.mdc` and edit `eversis-project-stack.mdc` for your stack. Rules use three modes — `alwaysApply: true` (always on), `globs: [...]` YAML list (auto-attached to matching files), or empty `globs` + `alwaysApply: false` (attached on demand with `@`). See [documentation/cursor-collection.md](documentation/cursor-collection.md) for details.
4. In **Chat** or **Agent**, attach a prompt (e.g. `@eversis-implement`) or use a `/` project command (e.g. `/eversis-implement`) — both invoke the same workflow. Paste your ticket or task text after invoking.
5. **MCP:** this repo includes [`.cursor/mcp.json`](.cursor/mcp.json). When you open the folder, **Cursor** detects it and can prompt you to **enable the listed servers in one step**. Build the local package **[`mcp/eversis-collections-mcp/`](mcp/eversis-collections-mcp/)** (`npm install && npm run build`) so the **`eversis-collections`** server starts — it powers **skills** in Agent via `eversis_*` tools and **Business Manager Docs** `.docx` chapter tools (`generate_summary_map`, `read_chapter`, `update_chapter`, `upload_to_sharepoint` stub). Optionally merge the same definitions into your **user** MCP config (Cursor → MCP) for third-party servers in every project.
6. **Skills:** with **`eversis-collections`** enabled, the agent can call tools such as **`eversis_skills_list`** / **`eversis_skills_get`** / **`eversis_skill_run_script`** (allowlisted per-skill scripts) against [`.cursor/skills/`](.cursor/skills/) (no separate Agent Skills registration).

> **Legacy names:** the historic slash-command names `/tsh-*` referred to an older VS Code + GitHub Copilot layout. This repository is **Cursor-only**; use **`eversis-*` markdown prompts** via `@` attachment or the `/eversis-*` Cursor project commands in `.cursor/commands/` — not the old Copilot chat slash-command runtime.

---

## Public prompts (`@` or `/`)

All bodies live under **`.cursor/prompts/public/`**. The primary SDLC prompts and **Business Manager Docs** prompts have matching `/` shortcuts in **`.cursor/commands/`** (six command stubs total — mandatory canonical prompt load + role hints). Full catalog: [website/docs/prompts/overview.md](website/docs/prompts/overview.md).

| Workflow                                       | File to attach                                                             |
| ---------------------------------------------- | -------------------------------------------------------------------------- |
| Workshop → Jira                                | `.cursor/prompts/public/eversis-analyze-materials.md`                      |
| Implement                                      | `.cursor/prompts/public/eversis-implement.md`                              |
| Code review                                    | `.cursor/prompts/public/eversis-review.md`                                 |
| UI vs Figma                                    | `.cursor/prompts/public/eversis-review-ui.md`                              |
| Codebase health                                | `.cursor/prompts/public/eversis-review-codebase.md`                        |
| Infra audit                                    | `.cursor/prompts/public/eversis-audit-infrastructure.md`                   |
| AWS / GCP cost                                 | `eversis-analyze-aws-costs.md`, `eversis-analyze-gcp-costs.md`             |
| BA docs — plan Word chapters                   | `.cursor/prompts/public/eversis-ba-docs-planner.md`                        |
| BA docs — write / update `.docx`               | `.cursor/prompts/public/eversis-ba-docs-writer.md`                         |
| Create rules / skills / prompts / instructions | `eversis-create-custom-agent.md` … `eversis-create-custom-instructions.md` |

Internal (delegation) prompts used by `eversis-implement` and similar live under **`.cursor/prompts/internal/`** — attach when a public prompt points you to them.

---

## Roles and documentation

Conceptual **agents** (who does the work) are described in the docs site, e.g. [website/docs/agents/](website/docs/agents/). In Cursor, **rules** in [`.cursor/rules/`](.cursor/rules/) express role behavior; attach the right `eversis-*.mdc` files when running a prompt (see AGENTS.md).

Core roles: Business Analyst, Context Engineer, Architect, Engineering Manager, Software Engineer, Prompt Engineer, DevOps Engineer, Code Reviewer, UI Reviewer, E2E Engineer, and **framework customization** (Cursor rules, skills, prompts, AGENTS.md).

The **Code Reviewer** role uses [`.cursor/rules/eversis-code-reviewer.mdc`](.cursor/rules/eversis-code-reviewer.mdc), which includes a **`STRICT FORBIDDEN`** section — three hard limits (file scope, documentation comments, new dependencies) classified as **BLOCKER** in the PASS / BLOCKER / SUGGESTION output. The same limits are mirrored in `eversis-agent-core.mdc` so they apply during implementation, not only at review.

---

## Example: standard flow

```text
IDEATE
  @eversis-analyze-materials
  (workshop materials → cleaned transcript → Jira-ready stories; human gates)

IMPLEMENT
  @eversis-implement
  (research → plan → code; human gates after research and plan)
  After Fine: eversis-qa-comment draft (mandatory — produced in Fine turn; human approves; optionally post via Atlassian MCP)

REVIEW
  @eversis-review
```

For UI work, the implement flow can loop with `eversis-review-ui` until pass or escalation (see the implement and review-ui prompts).

---

## Skills

- **Location:** [`.cursor/skills/`](.cursor/skills/) — topic folders with `SKILL.md` and optional `references/`, `assets/`, `examples/`.
- **Use:** Build and enable [**`mcp/eversis-collections-mcp/`**](mcp/eversis-collections-mcp/) (local MCP; not on npm) and turn on **`eversis-collections`** in [`.cursor/mcp.json`](.cursor/mcp.json). Authoring guide: [website/docs/skills/overview.md](website/docs/skills/overview.md) and the `eversis-creating-skills` skill. **Creating prompts** in this monorepo: follow **`eversis-creating-prompts`** — **Dual-context markdown links** (source paths in `.cursor/prompts/` vs slug paths after `sync-prompts`; do not edit the gitignored `website/docs/prompts/` copy by hand).
- **Discovery:** `eversis-agent-core.mdc` (`alwaysApply`) instructs the agent to check `.cursor/skills/` for a matching domain package before broad implementation — preferring `eversis-collections` MCP tools (`eversis_skills_list` / `eversis_skills_get`) when available, otherwise reading `SKILL.md` directly.
- **`eversis-qa-comment`** — **Mandatory** after **Fine**: the agent always produces a labeled English QA comment draft (functional “Main Changes” + verification checklist; no file/line callouts). You approve the draft and publish it — by pasting into Jira or explicitly asking the agent to call **Atlassian MCP** `addCommentToJiraIssue`. Few-shot + readability contrast: `.cursor/skills/eversis-qa-comment/qa-comment.example.md`. Docs: [`.cursor/skills/eversis-qa-comment/SKILL.md`](.cursor/skills/eversis-qa-comment/SKILL.md) (overview on docs site: [website/docs/skills/qa-comment.md](website/docs/skills/qa-comment.md)).

---

## Framework customization

To extend rules, skills, prompts, or project instructions, attach the matching **`eversis-create-custom-*`** prompt and follow the steps. Execution is **in Cursor**: use `.cursor/rules/*.mdc`, [AGENTS.md](AGENTS.md), `.cursor/prompts/`, and the **creating-\*** skills under `.cursor/skills/` (no separate VS Code agent files in this repo).

---

## MCP servers

The workspace file [`.cursor/mcp.json`](.cursor/mcp.json) lists Atlassian, Figma, Context7, Playwright, cloud MCPs, the local **`eversis-collections`** server (build [`mcp/eversis-collections-mcp/`](mcp/eversis-collections-mcp/) first), and more. **`eversis-collections`** provides skill tools and **Word `.docx` chapter tools** for Business Manager Docs (`generate_summary_map`, `read_chapter`, `update_chapter`, `upload_to_sharepoint` stub). After you enable it when prompted (or in **Cursor Settings → MCP**), set any API keys or `inputs` per provider docs. More detail: [website/docs/getting-started/mcp-setup.md](website/docs/getting-started/mcp-setup.md).

---

## Using this framework in another repository

### Quick setup (script)

#### Step 1 — get `cursor-collections` (once per machine)

Clone the framework to a shared location outside your projects. You only do this once:

```bash
git clone https://github.com/PiotrNie-Eversis/cursor-collections.git \
  "$HOME/.local/share/cursor-collections"
```

Then add this line to your shell profile (`~/.zshrc` or `~/.bashrc`) and reload it:

```bash
export CURSOR_COLLECTIONS_HOME="$HOME/.local/share/cursor-collections"
```

```bash
source ~/.zshrc   # or: source ~/.bashrc
```

#### Step 2 — bootstrap your project (once per project)

Go to your project — new or existing — and run the setup script:

```bash
# New project:
mkdir ~/my-project && cd ~/my-project && git init

# Existing project:
cd ~/my-existing-project

# Run setup:
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --build-mcp
```

The script will:

- Copy `.cursor/rules/`, `.cursor/prompts/`, `.cursor/commands/`, `.cursor/skills/` into your project.
- Generate `.cursor/mcp.json` pointing to the shared framework.
- Create `AGENTS.md` and `docs/specs/` if they are missing.
- Add a `.gitignore` block so the generated MCP config stays local (not committed).

Optional — keep agent research/plan folders out of git (solo dev or Jira-only):

```bash
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --build-mcp --gitignore-agent-artifacts
```

This adds `docs/specs/*/` and `docs/context/*/` to `.gitignore` in **local mode only**. Default setup commits those paths; do not use the flag if your team shares specs/plans in git or syncs wiki exports to `docs/context/`.

After the script finishes, **enable the MCP server in Cursor**: Settings → MCP → enable `eversis-collections` → restart Cursor.

#### Vendor mode (optional — for teams)

If you want the framework committed inside your repo (so the whole team uses the same version):

```bash
# Vendor as Git submodule (recommended for teams):
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --vendor submodule --build-mcp

# Vendor as file copy (no submodule overhead):
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --vendor copy --build-mcp
```

In vendor mode the framework lands in `vendor/cursor-collections/` and `.cursor/mcp.json` uses relative paths — safe to commit.

See [`scripts/setup-cursor-local.sh --help`](scripts/setup-cursor-local.sh) and [Installation docs](website/docs/getting-started/installation.md) for Windows instructions and all available flags.

### Manual bootstrap

1. Copy or vendor **`.cursor/rules/`** templates; customize `eversis-project-stack.mdc`.
2. Copy or link **`.cursor/prompts/`** (or maintain your own `eversis-*.md` under a path you prefer).
3. Add **`AGENTS.md`** and optional **`docs/specs/`**, **`docs/context/`**, **`docs/plans/`** per [documentation/cursor-collection.md](documentation/cursor-collection.md).
4. Add **`.cursor/mcp.json`** (or merge its `mcpServers` into your user MCP config). If you vendor **`.cursor/skills/`**, build and enable **`eversis-collections`** (see [`mcp/eversis-collections-mcp/`](mcp/eversis-collections-mcp/)) so **`eversis_*` skill tools** are available in Agent.

---

## Contributing and changes

Notable changes are recorded in [CHANGELOG.md](CHANGELOG.md). When you add or edit prompts, rules, or skills with markdown links, run from the repo root:

```bash
node scripts/validate-cursor-markdown-links.mjs --context=source
# optional extra files outside .cursor/ (e.g. setup templates):
node scripts/validate-cursor-markdown-links.mjs --context=source \
  --paths=scripts/setup-cursor-local/templates/eversis-project-stack.example.mdc
```

After changing prompts in this monorepo, also verify the synced tree: `cd website && npm run validate-cursor-links` (or `npm run build`). PRs that change **`.cursor/rules/**`** are checked by GitHub Actions **`eversis_cursor_rules_validate`**. See [documentation/cursor-collection.md](documentation/cursor-collection.md) § Link conventions in `.cursor/`.

This project is **MIT licensed** (see repository license file).

---

## Summary

- **Cursor-only** — prompts are Markdown; invoke by **`@` attachment**; rules live in **`.cursor/rules/`**.
- **Full lifecycle** — ideation, implementation, review, and optional infra/cost prompts.
- **Skills** in **`.cursor/skills/`** — procedural depth for agents via the **`eversis-collections` MCP** server (`eversis_skills_*` and **`eversis_skill_run_script`** where allowlisted); build [`mcp/eversis-collections-mcp/`](mcp/eversis-collections-mcp/) first. Includes **`eversis-qa-comment`** — mandatory QA comment draft on **Fine**, with optional Atlassian MCP posting after human approval.
- **Business Manager Docs** — **`eversis-ba-docs-planner`** / **`eversis-ba-docs-writer`** with **`eversis-collections`** `.docx` tools on one MCP server ([workflow doc](website/docs/workflow/business-manager-docs.md)). The `.docx` engine supports BOM stripping, locale-aware heading detection, and section content-type classification (`hasTables`, `hasImages`, `tableCount`). ⚠ `update_chapter` is a destructive replace — prefer read-first / append when sections contain tables or images (see MCP README for editing guidance).
- **MCP** — bring Jira, Figma, browser automation, docs, and the local **eversis-collections** server (skills + Word chapter tools) into the same session.

---

© 2026 [Eversis](https://eversis.com)
