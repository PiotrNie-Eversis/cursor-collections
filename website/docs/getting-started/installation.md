---
sidebar_position: 2
title: Installation
---

# Installation

:::info Curated path
Follow **[Start here](./start-here)** for the full onboarding checklist.
:::

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
3. Review **`.cursor/rules/`** — start with `eversis-agent-core.mdc` and customize `eversis-project-stack.mdc` (stack, quality commands, and **Agent skills policy**) when you copy rules into another project.

### Bootstrap a consumer project with Cursor Agent

Instead of copying paths manually, ask **Cursor Agent** in your target project:

```text
Run setup-cursor-local.sh from cursor-collections with --build-mcp for this workspace.
```

The agent should execute (adjust `CURSOR_COLLECTIONS_HOME` if needed):

```bash
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --build-mcp
```

From the framework checkout you can pass `--target` to bootstrap another folder. For CI or scripted setup, add `--non-interactive` and optionally `--mcp-servers=context7,eversis-collections,figma`. Full flag reference is in [Quick setup (script)](#quick-setup-script) below.

Cursor uses the setup script plus MCP merge — not VS Code `chat.*Locations` JSON for prompts or agents.

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

The setup script lives in the **cursor-collections** repository (`scripts/setup-cursor-local.sh`), not in your consumer project. Run it either from the framework checkout (with optional `--target`) or from the consumer project using `$CURSOR_COLLECTIONS_HOME`:

```bash
# From the consumer project (recommended):
cd ~/my-existing-project
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --build-mcp

# From the cursor-collections checkout:
bash scripts/setup-cursor-local.sh --target ~/my-existing-project --build-mcp
```

Examples by install mode:

```bash
# Local mode (framework lives outside the consumer repo — default):
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --build-mcp

# Vendor as Git submodule (committed, versioned):
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --vendor submodule --build-mcp

# Vendor as file copy (simpler, no submodule overhead):
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --vendor copy --build-mcp

# Optional: gitignore agent research/plan subfolders (local mode only):
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --build-mcp --gitignore-agent-artifacts

# Non-interactive MCP selection (CI / scripts):
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --build-mcp --non-interactive \
  --mcp-servers=context7,eversis-collections,figma
```

The script:
- Clones `cursor-collections` to `$CURSOR_COLLECTIONS_HOME` if missing (defaults to `~/.local/share/cursor-collections` on Unix).
- Copies or symlinks `.cursor/rules/`, `.cursor/prompts/`, `.cursor/commands/`, `.cursor/skills/` into the target project.
- With **`--build-mcp`** in an **interactive terminal**, asks whether to configure MCPs, then shows a **checkbox list** (↑↓ move, **Space** toggle, **Enter** confirm). Fallback: number toggle (`1` or `1,3,11` then Enter). Set `MCP_PROMPT_UI=toggle` to skip checkbox UI. Selected entries are merged into `.cursor/mcp.json`; `eversis-collections` gets the correct path to your checkout. This runs even when `.cursor/mcp.json` already exists from an earlier minimal setup.
- **Re-run without `--build-mcp`** only refreshes the `eversis-collections` path. Use `--mcp-servers=…` to change the set non-interactively.
- With `--non-interactive` and no `--mcp-servers`, only `eversis-collections` is merged.
- Adds a `.gitignore` block in local mode (MCP paths, prompts, skills, and framework rules — `.cursor/rules/eversis-*.mdc` except `eversis-project-stack.mdc`).
- Scaffolds `AGENTS.md` and `docs/specs/` if absent.
- Prints a **Next steps** summary (enable MCP in Cursor, customise the stack rule, etc.).

After you pull a newer `cursor-collections` checkout, **re-run** the setup script in each consumer project (local mode) so the managed `.gitignore` block stays current.

### Keeping consumer projects aligned

When **cursor-collections** releases change (new prompts, rules, skills, MCP tools), refresh consumer projects after you `git pull` the framework:

| Install mode | How to align after `git pull` |
| ------------ | ----------------------------- |
| **Local + symlink** (default on macOS/Linux) | Update shared checkout, rebuild MCP, re-run setup in each project |
| **Local + copy** (`--link-mode copy`, Windows default) | Update checkout + re-run with `--sync` |
| **Vendor submodule** | `git submodule update` in consumer repo + re-run setup |
| **Vendor copy** | Re-run `setup-cursor-local.sh --vendor copy --build-mcp` |

**Typical local workflow (symlink mode):**

```bash
cd "$CURSOR_COLLECTIONS_HOME" && git pull
cd mcp/eversis-collections-mcp && npm install && npm run build
cd ~/my-existing-project
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --build-mcp
```

**What updates automatically vs what stays yours**

| Path | Local symlink mode | You customize / commit |
| ---- | ------------------ | ---------------------- |
| Framework rules (`eversis-*.mdc` except stack) | Follows `CURSOR_COLLECTIONS_HOME` after `git pull` | Gitignored in consumer repo |
| Prompts, commands, skills | Symlinked to HOME | Gitignored |
| **`eversis-project-stack.mdc`** | Seeded once | **Commit in your project** — include **Agent skills policy** (which `eversis-*` skills apply) |
| **`AGENTS.md`**, `docs/specs/`, `docs/context/` | Scaffolded if missing | Your team owns content |
| **`.cursor/mcp.json`** | Merged on re-run | Gitignored in local mode |

**`--gitignore-agent-artifacts` (local mode only, default off):** adds `docs/specs/*/` and `docs/context/*/` to `.gitignore` so Implement research/plan folders stay local. Ignored with a warning in vendor mode. Do not use if you commit specs/plans to git or run CI wiki sync into `docs/context/`.

### Setup script flag reference

The script bootstraps **cursor-collections** into a consumer project: `.cursor/rules`, `prompts`, `commands`, `skills`, `.cursor/mcp.json`, `AGENTS.md`, and related scaffolding.

**Install mode** (the main decision — no flag means **local**):

| Mode | How to enable | Where the framework lives |
| ---- | ------------- | ------------------------- |
| **Local** (default) | Omit `--vendor` | Outside the repo (`$CURSOR_COLLECTIONS_HOME`) |
| **Vendor submodule** | `--vendor submodule` | `vendor/cursor-collections/` (Git submodule) |
| **Vendor copy** | `--vendor copy` | `vendor/cursor-collections/` (file copy) |

#### Flags

| Flag | What it does | When to use |
| ---- | ------------ | ----------- |
| **`--build-mcp`** | Runs `npm install` + `npm run build` in `mcp/eversis-collections-mcp/` (produces `dist/index.js`). With this flag, always rebuilds even when `dist/` already exists. | First setup and after `git pull` on the framework. Without it, builds only when `dist/index.js` is missing. In an interactive TTY, also opens the MCP server picker (unless `--mcp-servers` is set). |
| **`--collections-home DIR`** | Path to the `cursor-collections` checkout. Overrides `CURSOR_COLLECTIONS_HOME` and the OS default (`~/.local/share/cursor-collections` on Unix). | Non-default checkout location. |
| **`--target DIR`** | Consumer project directory. Default: Git root of the current repo (with an interactive prompt in monorepos). | Run the script from somewhere other than the target project. |
| **`--vendor submodule`** | Runs `git submodule add … vendor/cursor-collections`. Downstream steps use the vendored path; `.cursor/mcp.json` uses **relative** paths. | Team repos; pinned framework version in git. |
| **`--vendor copy`** | Copies selected framework dirs into `vendor/cursor-collections/`. No submodule overhead. | Submodules not allowed; simpler inspection/diff. |
| **`--vendor`** (no value) | Interactive menu: submodule vs copy. | When you want vendor mode but have not chosen a strategy. With `--non-interactive`, defaults to **copy**. |
| **`--link-mode auto`** | Symlink on Unix, copy on Windows (default). | Default — usually no need to set. |
| **`--link-mode symlink`** | Symlinks `.cursor/prompts`, `commands`, `skills`; per-file symlinks for framework rules. `eversis-project-stack.mdc` stays a **local file** in the project. | macOS/Linux; framework updates via `git pull` in `CURSOR_COLLECTIONS_HOME` apply immediately. |
| **`--link-mode copy`** | Physical copy of framework `.cursor/*` into the project. | Windows without symlink permissions; air-gapped snapshots. |
| **`--sync`** | Overwrites existing copied `.cursor/*` dirs (copy mode only). | After `git pull` on the framework when the script previously skipped existing dirs. |
| **`--non-interactive`** | Skips all prompts; uses defaults. Monorepo → Git root. MCP → only `eversis-collections` unless `--mcp-servers` is set. | CI, scripts, unattended setup. |
| **`--mcp-servers=LIST`** | Comma-separated MCP server ids merged into `.cursor/mcp.json` (no checkbox). Spaces in the list are ignored. Takes precedence over `--non-interactive` for MCP selection. | Scripted MCP config; see allowed ids below. |
| **`--force`** | Continues when `COLLECTIONS_HOME` looks incomplete (normally aborts). | Rare recovery when you know the checkout is valid. |
| **`--minimal`** | **Not implemented** — prints a warning and runs full setup. | Ignore for now. |
| **`--gitignore-agent-artifacts`** | Local mode only: adds `docs/specs/*/` and `docs/context/*/` to `.gitignore`. Ignored (with warning) in vendor mode. | Solo work; keep Implement research/plan local. Do not use if specs/plans are committed or CI syncs wiki into `docs/context/`. |
| **`--help`**, **`-h`** | Prints usage and exits. | Quick reference in the terminal. |

**Allowed `--mcp-servers` ids** (from `scripts/lib/setup-cursor-local/mcp-server-list.json`):

`context7`, `sequential-thinking`, `figma`, `atlassian`, `pdf-reader`, `awslabs.aws-api-mcp-server`, `awslabs.aws-documentation-mcp-server`, `gcp-gcloud`, `gcp-observability`, `gcp-storage`, `eversis-collections`, `playwright`

**Common recipes:**

```bash
# Personal setup (interactive MCP picker):
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --build-mcp

# Team — submodule:
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --vendor submodule --build-mcp

# CI — no prompts, three MCP servers:
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --build-mcp --non-interactive \
  --mcp-servers=context7,eversis-collections,figma

# Windows / copy mode — refresh after framework update:
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --link-mode copy --build-mcp --sync
```

Run `bash scripts/setup-cursor-local.sh --help` from the framework checkout for the inline help text.

#### Environment variables

| Variable | Purpose |
| -------- | ------- |
| `CURSOR_COLLECTIONS_HOME` | Canonical path to the `cursor-collections` checkout. Read by both the setup script and the `eversis-collections` MCP server. |
| `CURSOR_COLLECTIONS_REPO_URL` | Override the Git clone URL (default: upstream GitHub repo). |
| `MCP_PROMPT_UI=toggle` | Use the number-toggle MCP picker instead of the default checkbox UI (↑↓, Space, Enter). |

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
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --link-mode copy --build-mcp
```

### Manual bootstrap

You can also set up the framework manually — the script is an addition, not a replacement for the checklist in [Part C of the Framework reference](../framework#part-c--per-project-bootstrap).

Copy **`.cursor/rules/`** templates, add **`AGENTS.md`**, and either vendor **`.cursor/prompts/`** (recommended) or maintain your own `eversis-*.md` paths. Add **`.cursor/mcp.json`** (or your own MCP list), build **`mcp/eversis-collections-mcp/`** if you use this repo's skills, and configure any other integrations you need. See the [Framework reference](../framework) for the full step-by-step checklist.
