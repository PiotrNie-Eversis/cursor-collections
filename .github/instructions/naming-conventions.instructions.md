---
name: cursor-collections
description: "Naming conventions for Cursor Collections: eversis prompts and rules, tsh- skill directories."
applyTo: '.github/**'
---

# Naming conventions

## Prefixes in this monorepo

- **`eversis-`** — User-facing and internal **prompts** as Markdown: `website/docs/prompts/public/eversis-*.md` and `website/docs/prompts/internal/eversis-*.md`.
- **`eversis-`** — **Cursor rules** in `.cursor/rules/eversis-*.mdc`.
- **`tsh-`** — **Skill directory names** under `.github/skills/tsh-*/` (historical; topic packages). The `name` in `SKILL.md` frontmatter should match the directory name.

## What we do not add

- **No** `.github/prompts/*.prompt.md` or `.github/agents/*.agent.md` in this repository (Cursor-only deliverable).

## Cross-references

When docs reference skills, use the `tsh-*` folder/skill `name` (e.g. `tsh-creating-skills`).

When docs reference attachable prompts, use repo-relative paths: `website/docs/prompts/public/eversis-implement.md`.
