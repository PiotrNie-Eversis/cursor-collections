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

Copy **`.cursor/rules/`** templates, add **`AGENTS.md`**, and either vendor **`.cursor/prompts/`** (recommended) or maintain your own `eversis-*.md` paths. If you use this repo’s Docusaurus site, run **`npm run sync-docs-assets`** from `website/` (or rely on `prestart` / `prebuild`) so prompt pages and the framework doc exist under `website/docs/` before building. Add **`.cursor/mcp.json`** (or your own MCP list), build **`mcp/eversis-collections-mcp/`** if you use this repo’s skills, and configure any other integrations you need. See [Framework reference](../framework) (same content as `documentation/cursor-collection.md` in the repo) for the generic layout.
