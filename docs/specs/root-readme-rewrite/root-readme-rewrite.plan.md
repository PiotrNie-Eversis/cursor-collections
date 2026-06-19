# Plan: Restructure root `README.md`

**Research:** [`root-readme-rewrite.research.md`](./root-readme-rewrite.research.md) 
**Status:** Complete (2026-06-07).

---

## Goal

Rewrite the repository root README so a **new GitHub visitor** understands within ~15 seconds what Cursor Collections is and how Ideate → Implement → Review fits together, while **existing users** still find consumer setup, MCP enablement, and contributing commands via progressive disclosure at the bottom.

**Non-goals:** Change MCP package README (done), MCP code, `.cursor/mcp.json`, `documentation/cursor-collection.md`, or docs site pages in this task.

---

## Human decisions (approved 2026-06-07)

| Question | Decision |
| -------- | -------- |
| Agent encyclopedia in README | **Condensed list** — name + one line; link to `website/docs/agents/` |
| Closing Summary section | **Remove** |
| Centered HTML hero | **Keep** + **Cursor logo** at top |
| CHANGELOG | **Yes** — one-line docs entry |

---

## Implementation phases

### Phase 1 — Hero and value matrix (`[MODIFY]`) ✅

**File:** `README.md`

- [x] Keep centered hero + Eversis / product-engineering README benchmark attribution
- [x] Add crisp tagline under hero: Ideate → Implement → Review
- [x] Replace dense opening with **🚀 What this repository provides** phase matrix
- [x] Add `eversis-` prefix callout block
- [x] Remove inline QA/MCP/docx-engine paragraphs from opening (relocated to workflows + links)

---

### Phase 2 — Prerequisites and workflows (`[MODIFY]`) ✅

- [x] **⚠️ Prerequisites** — Cursor IDE, Node ≥ 18, `.cursor/rules/`
- [x] **🧭 Supported workflows** — standard, UI, standalone ideation, BA Docs flowcharts
- [x] Human-gates callout
- [x] Removed duplicate § Example: standard flow

---

### Phase 3 — Quick start and prompt catalog (`[MODIFY]`) ✅

- [x] Refactored **Quick start** — 6 numbered steps
- [x] **📋 Public prompts at a glance** — compact table + catalog link
- [x] **🧑‍💻 Agents (condensed)** — name + one line table; STRICT FORBIDDEN link

---

### Phase 4 — MCP and consumer installation (`[MODIFY]`) ✅

- [x] **🔌 MCP server configuration** with build steps and links
- [x] **Using this framework** below MCP — Option 1 script + Option 2 manual
- [x] Removed standalone MCP servers and Skills sections

---

### Phase 5 — Footer sections (`[MODIFY]`) ✅

- [x] Framework customization
- [x] Contributing and changes
- [x] **📚 Related documentation** table
- [x] Removed Summary section
- [x] Copyright footer

---

### Phase 6 — Validation (`[REUSE]`) ✅

- [x] Link validation on README.md
- [x] CHANGELOG.md entry
- [x] Self-review against research inventory

---

## Task checklist

| ID | Type | Task | Status |
| -- | ---- | ---- | ------ |
| T1 | `[MODIFY]` | Phase 1 — Hero + phase matrix + prefix callout | ✅ |
| T2 | `[MODIFY]` | Phase 2 — Prerequisites + workflow flowcharts | ✅ |
| T3 | `[MODIFY]` | Phase 3 — Quick start + prompt table + agents | ✅ |
| T4 | `[MODIFY]` | Phase 4 — MCP section + relocated consumer install | ✅ |
| T5 | `[MODIFY]` | Phase 5 — Footer + remove Summary | ✅ |
| T6 | `[REUSE]` | Phase 6 — Link validation + CHANGELOG | ✅ |

---

## Definition of done

1. [x] Progressive disclosure order: value → workflows → quick start → install → contributing
2. [x] New reader can answer what / why / how without reading setup script details first
3. [x] All pre-change factual content preserved or linked
4. [x] No duplicate encyclopedia blocks for skills/MCP/QA
5. [x] Link validation passes for `README.md`
6. [x] Human approved research + plan

---

## Changelog

| Date | Change |
| ---- | ------ |
| 2026-06-07 | Initial plan from research |
| 2026-06-07 | Human decisions applied; README rewritten; validation passed |
