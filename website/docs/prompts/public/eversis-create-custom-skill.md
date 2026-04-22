---
sidebar_position: 14
title: "Create custom skill"
slug: create-custom-skill
prompt_role: "Cursor customization orchestrator"
prompt_description: "Create a new Agent Skill: SKILL.md under .github/skills/ with gerund-style folder name. Follows tsh-creating-skills."
---
# /eversis-create-custom-skill

**Role:** [Cursor customization orchestrator](../../agents/cursor-customization-orchestrator)  
**File:** `website/docs/prompts/public/eversis-create-custom-skill.md`

Creates a new **Cursor Agent Skill**: a directory under **`.github/skills/<name>/`** with **`SKILL.md`** and optional `references/`, `assets/`, `examples/`. Register the skills root in **Cursor → Agent Skills** so the agent can load it.

## Usage

```text
@website/docs/prompts/public/eversis-create-custom-skill.md
<skill requirements or description>
```

## What it does

1. **Research** — Study existing **`.github/skills/tsh-*/SKILL.md`** for frontmatter, gerund folder names, and progressive disclosure.
2. **Clarify** — Domain, when the skill applies, and what templates/references to add.
3. **Create** — New folder with `SKILL.md` per **`tsh-creating-skills`**.
4. **Review** — Naming, description field quality, and folder layout.

## Output

A new **`.github/skills/<gerund-name>/`** tree.

## Skills loaded

- `tsh-creating-skills`
- `tsh-technical-context-discovering`
- `tsh-codebase-analysing`

---

## Executable prompt (attach in Cursor)

1. Load `.github/skills/tsh-creating-skills/SKILL.md` and follow it end-to-end.
2. New skill folders use **gerund** names (e.g. `reviewing-invoices`) matching the skill’s `name` in frontmatter.
3. Ensure the **description** field is specific so Cursor matches the skill when appropriate.
4. Do not reference VS Code Copilot — skills are consumed by **Cursor** via Agent Skills.

<!-- Cursor Collections -->
