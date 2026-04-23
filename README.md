<h1 align="center">Cursor Collections</h1>

<p align="center">
  <b>Cursor-native</b> product engineering framework — <b>Ideate → Implement → Review</b> with rules, attachable prompts, MCP, and reusable skills.<br/>
  Maintained by <a href="https://tsh.io" target="_blank">The Software House</a>; Cursor rules, <code>eversis-*</code> prompts, and this documentation are curated for Cursor by <b>Eversis</b>.
</p>

---

## What this repository provides

Structured **roles**, **prompts** (`eversis-*.md`), **project rules** (`.cursor/rules/*.mdc`), and **skills** (`.github/skills/`) for the full product lifecycle:

| Phase                       | Focus                                        | Entry (Cursor)                                                                                                |
| --------------------------- | -------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| **Ideate**                  | Requirements and planning                    | Attach `@eversis-analyze-materials`                                            |
| **Implement**               | Architecture and delivery                    | Attach `@eversis-implement`                                                    |
| **Review**                  | Code and UI quality                          | Attach `@eversis-review`, `@eversis-review-ui`, `@eversis-review-codebase` |
| **Framework customization** | Rules, skills, prompts, project instructions | Attach `eversis-create-custom-*.md` under `.cursor/prompts/public/` |

**Skills** live in [`.github/skills/`](.github/skills/) as `tsh-*` topic folders with `SKILL.md` (procedural how-to). Wire them as **Cursor Agent Skills** (user or project skills path) so agents can load them by description.

**Docs site:** build and preview from [`website/`](website/) (Docusaurus). **Authoritative how-to for using this framework in any repo:** [documentation/cursor-collection.md](documentation/cursor-collection.md).

---

## Quick start (Cursor)

1. **Open this repository in [Cursor](https://cursor.com/).**
2. Read [**AGENTS.md**](AGENTS.md) and [documentation/cursor-collection.md](documentation/cursor-collection.md).
3. Use [**project rules**](.cursor/rules/): start with `eversis-agent-core.mdc` and edit `eversis-project-stack.mdc` for your stack.
4. In **Chat** or **Agent**, attach a prompt, e.g. `@eversis-implement`, plus your ticket or task text.
5. **MCP:** this repo includes [`.cursor/mcp.json`](.cursor/mcp.json). When you open the folder, **Cursor** detects it and can prompt you to **enable the listed servers in one step**. Optionally merge the same definitions into your **user** MCP config (Cursor → MCP) if you want Jira, Figma, Playwright, and the rest in every project.
6. **Optional:** add this repo’s skill trees to your **Cursor Agent Skills** location so `tsh-*` skills resolve when relevant.

> **Legacy names:** the historic slash-command names `/tsh-*` referred to an older VS Code + GitHub Copilot layout. This repository is **Cursor-only**; use **`eversis-*` markdown prompts** and `@` attachment, not Copilot chat slash commands.

---

## Public prompts (attach with `@`)

All bodies live under **`.cursor/prompts/public/`**. Full catalog: [website/docs/prompts/overview.md](website/docs/prompts/overview.md).

| Workflow                                       | File to attach                                                             |
| ---------------------------------------------- | -------------------------------------------------------------------------- |
| Workshop → Jira                                | `.cursor/prompts/public/eversis-analyze-materials.md`                 |
| Implement                                      | `.cursor/prompts/public/eversis-implement.md`                         |
| Code review                                    | `.cursor/prompts/public/eversis-review.md`                            |
| UI vs Figma                                    | `.cursor/prompts/public/eversis-review-ui.md`                         |
| Codebase health                                | `.cursor/prompts/public/eversis-review-codebase.md`                   |
| Infra audit                                    | `.cursor/prompts/public/eversis-audit-infrastructure.md`              |
| AWS / GCP cost                                 | `eversis-analyze-aws-costs.md`, `eversis-analyze-gcp-costs.md`             |
| Create rules / skills / prompts / instructions | `eversis-create-custom-agent.md` … `eversis-create-custom-instructions.md` |

Internal (delegation) prompts used by `eversis-implement` and similar live under **`.cursor/prompts/internal/`** — attach when a public prompt points you to them.

---

## Roles and documentation

Conceptual **agents** (who does the work) are described in the docs site, e.g. [website/docs/agents/](website/docs/agents/). In Cursor, **rules** in [`.cursor/rules/`](.cursor/rules/) express role behavior; attach the right `eversis-*.mdc` files when running a prompt (see AGENTS.md).

Core roles: Business Analyst, Context Engineer, Architect, Engineering Manager, Software Engineer, Prompt Engineer, DevOps Engineer, Code Reviewer, UI Reviewer, E2E Engineer, and **framework customization** (Cursor rules, skills, prompts, AGENTS.md).

---

## Example: standard flow

```text
IDEATE
  @eversis-analyze-materials
  (workshop materials → cleaned transcript → Jira-ready stories; human gates)

IMPLEMENT
  @eversis-implement
  (research → plan → code; human gates after research and plan)

REVIEW
  @eversis-review
```

For UI work, the implement flow can loop with `eversis-review-ui` until pass or escalation (see the implement and review-ui prompts).

---

## Skills

- **Location:** [`.github/skills/`](.github/skills/) — topic folders with `SKILL.md` and optional `references/`, `assets/`, `examples/`.
- **Use:** Register the folder root with **Cursor → Agent Skills** (global or project) so the agent can load skills that match the task. Authoring guide: [website/docs/skills/overview.md](website/docs/skills/overview.md) and the `tsh-creating-skills` skill.

**Why `tsh-` folder names?** Historical prefix for topic packages; skills remain compatible with the framework docs. You can add your own skills alongside them.

---

## Framework customization

To extend rules, skills, prompts, or project instructions, attach the matching **`eversis-create-custom-*`** prompt and follow the steps. Execution is **in Cursor**: use `.cursor/rules/*.mdc`, [AGENTS.md](AGENTS.md), `.cursor/prompts/`, and the **creating-\*** skills under `.github/skills/` (no separate VS Code agent files in this repo).

---

## MCP servers

The workspace file [`.cursor/mcp.json`](.cursor/mcp.json) lists Atlassian, Figma, Context7, Playwright, cloud MCPs, and more. After you enable it when prompted (or in **Cursor Settings → MCP**), set any API keys or `inputs` per provider docs. More detail: [website/docs/getting-started/mcp-setup.md](website/docs/getting-started/mcp-setup.md).

---

## Using this framework in another repository

1. Copy or vendor **`.cursor/rules/`** templates; customize `eversis-project-stack.mdc`.
2. Copy or link **`.cursor/prompts/`** (or maintain your own `eversis-*.md` under a path you prefer).
3. Add **`AGENTS.md`** and optional **`docs/specs/`**, **`docs/context/`** per [documentation/cursor-collection.md](documentation/cursor-collection.md).
4. Add **`.cursor/mcp.json`** (or merge its `mcpServers` into your user MCP config) and **Agent Skills** for the skill packs you need.

---

## Contributing and changes

Notable changes are recorded in [CHANGELOG.md](CHANGELOG.md). This project is **MIT licensed** (see repository license file).

---

## Summary

- **Cursor-only** — prompts are Markdown; invoke by **`@` attachment**; rules live in **`.cursor/rules/`**.
- **Full lifecycle** — ideation, implementation, review, and optional infra/cost prompts.
- **Skills** in **`.github/skills/`** — procedural depth for agents when wired as Agent Skills.
- **MCP** — bring Jira, Figma, browser automation, and docs into the same session.

---

© 2026 [The Software House](https://tsh.io)
