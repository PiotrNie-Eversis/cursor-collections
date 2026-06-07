# Plan: Restructure `mcp/eversis-collections-mcp/README.md`

**Research:** [`mcp-readme-rewrite.research.md`](./mcp-readme-rewrite.research.md)  
**Status:** Complete (2026-06-07).

---

## Goal

Rewrite the MCP package README so a **new reader** understands within ~15 seconds what `eversis-collections` MCP does and when to build it, while **contributors** retain full technical reference (tools, docx engine, env, security, tests) via progressive disclosure at the bottom.

**Non-goals:** Change MCP code, `.cursor/mcp.json`, root README, or docs site pages in this task.

---

## Implementation phases

### Phase 1 — Outline and hero ( `[MODIFY]` ) ✅

**File:** `mcp/eversis-collections-mcp/README.md`

- [x] Replace opening technical bullet list with hero, one-liner, tagline
- [x] Add **“What this server unlocks”** matrix (3 categories)
- [x] Add **“Where it fits”** with links to root README and cursor-collection.md

**Acceptance:** Reader understands purpose without reading install steps.

---

### Phase 2 — Supported workflows ( `[MODIFY]` ) ✅

- [x] Workflow A — Implement with skills (text flowchart)
- [x] Workflow B — Business Manager Docs (enhanced with backup/inspect/append tools)
- [x] Workflow C — Contributor validate
- [x] Human gates callout

**Acceptance:** Workflows use real `eversis-*` names.

---

### Phase 3 — Prerequisites and installation ( `[MODIFY]` ) ✅

- [x] Prerequisites (Cursor, Node ≥ 18, checkout)
- [x] Option 1 — Workspace (this repository)
- [x] Option 2 — Consumer project (shared install)
- [x] Verify section + link to MCP setup doc
- [x] “Not published to npm” under installation

**Acceptance:** Both monorepo and consumer paths documented.

---

### Phase 4 — Tools reference ( `[MODIFY]` ) ✅

- [x] Tools at a glance table (14 tools — full server surface)
- [x] Per-tool Focus / How to use / Outcome (human decision: all tools, not groups only)
- [x] Security paragraph after tool reference

**Acceptance:** All registered tools documented; table matches server.

---

### Phase 5 — Deep dive ( `[MODIFY]` ) ✅

- [x] Document compatibility (BOM, locale, section flags)
- [x] Editing guidance (append vs replace; backup_docx)
- [x] Environment table + walk-up detection
- [x] Tests and CLI merged section

**Acceptance:** `CURSOR_COLLECTIONS_HOME`, `hasTables`, `allowlist` present.

---

### Phase 6 — Related docs and validation ( `[REUSE]` ) ✅

- [x] Related documentation footer (5 links)
- [x] Link validation passed
- [x] CHANGELOG — no entry (doc-only, per plan)

**Acceptance:** Link validator OK.

---

## Task checklist

| ID | Type | Task | Status |
| -- | ---- | ---- | ------ |
| T1 | `[MODIFY]` | Phase 1 — Hero + unlocks matrix + framework bridge | ✅ |
| T2 | `[MODIFY]` | Phase 2 — Workflow flowcharts | ✅ |
| T3 | `[MODIFY]` | Phase 3 — Prerequisites + install options | ✅ |
| T4 | `[MODIFY]` | Phase 4 — Tools table + per-tool micro-templates | ✅ |
| T5 | `[MODIFY]` | Phase 5 — Deep dive relocation | ✅ |
| T6 | `[REUSE]` | Phase 6 — Related docs + link validation | ✅ |

---

## Definition of done

1. [x] Progressive disclosure order (value → workflows → install → reference)
2. [x] New reader can answer what / why / how without reading BOM details
3. [x] All pre-change technical content preserved in deep dive
4. [x] Link validation passes
5. [x] Human approved research + plan

---

## Changelog

| Date | Change |
| ---- | ------ |
| 2026-06-07 | Initial plan from research |
| 2026-06-07 | Implemented README rewrite; human decisions on open questions applied |
| 2026-06-07 | All phases complete; plan checkboxes updated |
