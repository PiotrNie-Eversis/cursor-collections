---
sidebar_position: 19
title: Creating Instructions
---

# Creating instructions

**Folder:** `.github/skills/tsh-creating-instructions/`  
**Used by:** Framework maintainers (customization track)

Helps place **declarative rules** for **Cursor**: **[AGENTS.md](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/AGENTS.md)**, **`.cursor/rules/eversis-*.mdc`**, and optional scoped rules. This framework does **not** use GitHub Copilot `copilot-instructions.md`.

## Instruction types (Cursor)

| Aspect            | Project constitution                                  | Scoped                                                    |
| ----------------- | ----------------------------------------------------- | --------------------------------------------------------- |
| **Typical files** | `AGENTS.md` + `eversis-project-stack.mdc`             | `eversis-*.mdc` with `globs` (or team `RULE.md` patterns) |
| **Frontmatter**   | Rules use YAML: `description`, `globs`, `alwaysApply` | Same                                                      |
| **Applied when**  | Always-on or stack-wide                               | When matching files are in context                        |

## Instructions vs skills

| Content                                   | Belongs in…                         |
| ----------------------------------------- | ----------------------------------- |
| Stack, commands, non-obvious global rules | `AGENTS.md` / `.mdc`                |
| Step-by-step procedures                   | `SKILL.md` under `.github/skills/`  |
| Runnable workflow text                    | `.cursor/prompts/**/eversis-*.md` |

## Validation checklist

- No duplicated always-on rules across many `.mdc` files
- No long procedural content (use skills)
- Templates: see `.github/skills/tsh-creating-instructions/assets/`

## Connected skills

- `tsh-creating-agents` — role rules vs long prose
- `tsh-creating-skills` — instruction vs skill boundary
- `tsh-creating-prompts` — prompts reference rules, not duplicate them
