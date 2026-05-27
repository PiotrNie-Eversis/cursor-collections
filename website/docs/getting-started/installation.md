---
sidebar_position: 2
title: Installation
---

# Installation

Use this framework from **[Cursor](https://cursor.com/)** with this repository on disk (clone or submodule).

## 1. Clone the repository

```bash
cd ~/projects
git clone https://github.com/PiotrNie-Eversis/cursor-collections.git cursor-collections
```

You can use any folder name; paths in [AGENTS.md](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/AGENTS.md) and the source file `documentation/cursor-collection.md` (also published on this site as [Framework reference](../framework)) are relative to the repo root.

## 2. Open in Cursor

1. **File → Open Folder** and select the cloned `cursor-collections` directory (or add it to a multi-root workspace).
2. Read **`AGENTS.md`** at the repo root and the [Framework reference](../framework) on this site (or **`documentation/cursor-collection.md`** in the repository) for the full model.
3. Review **`.cursor/rules/`** — start with `eversis-agent-core.mdc` and customize `eversis-project-stack.mdc` when you copy rules into another project.

## 3. Prompts (attach with `@`)

Public prompts live under **`.cursor/prompts/public/`** as **`eversis-*.md`**. In Chat or Agent, attach e.g.:

`@eversis-implement`

See the [Prompts overview](../prompts/overview.md) for the full list. Internal prompts are under **`.cursor/prompts/internal/`** and are referenced from the public orchestration prompts.

## 4. Skills + local MCP (`eversis-collections`)

Procedural skills live under **`.cursor/skills/eversis-*/`** as **`SKILL.md`** (and optional `references/` / `assets/`). **Do not** register that path under Cursor **Agent Skills** for this framework.

Instead, build the local package at **`mcp/eversis-collections-mcp/`** from the repo root:

```bash
cd mcp/eversis-collections-mcp && npm install && npm run build
```

Then enable MCP in **Cursor** (see below). The **`eversis-collections`** server exposes **`eversis_*` tools** (e.g. **`eversis_skills_list`**, **`eversis_skills_get`**, **`eversis_skills_validate`**, **`eversis_skill_run_script`**) so Agent can work with the skill tree deterministically.

## 5. MCP (third-party + local)

This repository ships **`.cursor/mcp.json`**, including third-party servers and **`eversis-collections`**. When you open the folder in **Cursor**, the editor detects it and you can **enable the listed MCP servers** from the prompt or **Cursor → MCP**. Build **`eversis-collections`** (step 4) before relying on skill tools. To use the same third-party stack in every project, optionally merge that file into your **user** MCP configuration. Details: [MCP setup](./mcp-setup.md).

## Using the framework in another project

### Quick setup (script)

From the **cursor-collections** checkout, run one command to bootstrap any existing project:

```bash
# Local mode (framework lives outside the consumer repo — default):
bash scripts/setup-cursor-local.sh --build-mcp

# Vendor as Git submodule (committed, versioned):
bash scripts/setup-cursor-local.sh --vendor submodule --build-mcp

# Vendor as file copy (simpler, no submodule overhead):
bash scripts/setup-cursor-local.sh --vendor copy --build-mcp

# Optional: gitignore agent research/plan subfolders (local mode only):
bash scripts/setup-cursor-local.sh --build-mcp --gitignore-agent-artifacts
```

The script:
- Clones `cursor-collections` to `$CURSOR_COLLECTIONS_HOME` if missing (defaults to `~/.local/share/cursor-collections` on Unix).
- Copies or symlinks `.cursor/rules/`, `.cursor/prompts/`, `.cursor/commands/`, `.cursor/skills/` into the target project.
- Merges the `eversis-collections` entry into the project's `.cursor/mcp.json`.
- Adds a `.gitignore` block in local mode (so MCP paths stay out of version control).
- Scaffolds `AGENTS.md` and `docs/specs/` if absent.
- Prints a **Next steps** summary (enable MCP in Cursor, customise the stack rule, etc.).

**`--gitignore-agent-artifacts` (local mode only, default off):** adds `docs/specs/*/` and `docs/context/*/` to `.gitignore` so Implement research/plan folders stay local. Ignored with a warning in vendor mode. Do not use if you commit specs/plans to git or run CI wiki sync into `docs/context/`.

See `scripts/setup-cursor-local.sh --help` for the full flag reference.

#### Environment variables

| Variable | Purpose |
| -------- | ------- |
| `CURSOR_COLLECTIONS_HOME` | Canonical path to the `cursor-collections` checkout. Read by both the setup script and the `eversis-collections` MCP server. |
| `CURSOR_COLLECTIONS_REPO_URL` | Override the Git clone URL (default: upstream GitHub repo). |

Export `CURSOR_COLLECTIONS_HOME` in your shell profile (`~/.zshrc`, `~/.bashrc`) so re-runs and the MCP server resolve the path automatically:

```bash
export CURSOR_COLLECTIONS_HOME="$HOME/.local/share/cursor-collections"
```

#### Consumer project installation modes

| Mode | `.cursor/mcp.json` in git | MCP path style | When to use |
| ---- | ------------------------- | -------------- | ----------- |
| **local** (default) | No — gitignored | Absolute (`$CURSOR_COLLECTIONS_HOME`) | Personal / per-machine setup; framework shared across projects |
| **`--vendor submodule`** | Yes | Relative (`vendor/cursor-collections/…`) | Team repos; pinned version; everyone gets the same framework version |
| **`--vendor copy`** | Yes | Relative (`vendor/cursor-collections/…`) | When Git submodules are not allowed; easy to inspect and diff |

#### Windows

Use **Git Bash** or **WSL** to run the script. Symlinks require Developer Mode or Administrator rights — the script defaults to **`--link-mode copy`** on Windows (MINGW/Cygwin/MSYS) so no special permissions are needed.

```bash
# Windows Git Bash — explicit copy mode:
bash scripts/setup-cursor-local.sh --link-mode copy --build-mcp
```

### Manual bootstrap

You can also set up the framework manually — the script is an addition, not a replacement for the checklist in [Part C of the Framework reference](../framework#part-c--per-project-bootstrap).

Copy **`.cursor/rules/`** templates, add **`AGENTS.md`**, and either vendor **`.cursor/prompts/`** (recommended) or maintain your own `eversis-*.md` paths. Add **`.cursor/mcp.json`** (or your own MCP list), build **`mcp/eversis-collections-mcp/`** if you use this repo's skills, and configure any other integrations you need. See the [Framework reference](../framework) for the full step-by-step checklist.
