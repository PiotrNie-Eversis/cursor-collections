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

You can use any folder name; paths in [AGENTS.md](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/AGENTS.md) and [documentation/cursor-collection.md](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/documentation/cursor-collection.md) are relative to the repo root.

## 2. Open in Cursor

1. **File → Open Folder** and select the cloned `cursor-collections` directory (or add it to a multi-root workspace).
2. Read **`AGENTS.md`** at the repo root and **[documentation/cursor-collection.md](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/documentation/cursor-collection.md)** for the full model.
3. Review **`.cursor/rules/`** — start with `eversis-agent-core.mdc` and customize `eversis-project-stack.mdc` when you copy rules into another project.

## 3. Prompts (attach with `@`)

Public prompts live under **`website/docs/prompts/public/`** as **`eversis-*.md`**. In Chat or Agent, attach e.g.:

`@website/docs/prompts/public/eversis-implement.md`

See the [Prompts overview](../prompts/overview.md) for the full list. Internal prompts are under **`website/docs/prompts/internal/`** and are referenced from the public orchestration prompts.

## 4. Agent Skills (optional)

Procedural skills live under **`.github/skills/tsh-*`**. In **Cursor Settings**, register this folder (or a copy) under **Agent Skills** so the agent can load `SKILL.md` content when descriptions match the task.

## 5. MCP

Copy or merge **`.vscode/mcp.json`** from this repo into **Cursor → MCP** (user or workspace configuration). Details: [MCP setup](./mcp-setup.md).

## Using the framework in another project

Copy **`.cursor/rules/`** templates, add **`AGENTS.md`**, and either vendor **`website/docs/prompts/`** or maintain your own `eversis-*.md` paths. Configure MCP and Agent Skills for the integrations you need. See [documentation/cursor-collection.md](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/documentation/cursor-collection.md) for the generic layout.
