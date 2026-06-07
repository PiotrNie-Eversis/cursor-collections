# Plan: Align README MCP section with copilot-collections style

**Research:** [`readme-mcp-section.research.md`](./readme-mcp-section.research.md)  
**Status:** Complete (2026-06-07).

---

## Goal

Restructure [`README.md`](../../../README.md) § **🔌 MCP Server Configuration** to match [copilot-collections — MCP Server Configuration](https://github.com/TheSoftwareHouse/copilot-collections#-mcp-server-configuration), while preserving Cursor-specific requirements.

**Non-goals:** Change `.cursor/mcp.json`, MCP package code, or `website/docs/getting-started/mcp-setup.md`.

---

## Human decisions (approved 2026-06-07)

| Question | Decision |
| -------- | -------- |
| Option order | User Profile recommended first |
| Context7 JSON | Condensed snippet + link to mcp-setup.md |
| `eversis-collections` placement | After Option 1/2 |
| CHANGELOG | Line under `2026-06-07` |

---

## Task checklist

| ID | Type | Task | Status |
| -- | ---- | ---- | ------ |
| T1 | `[MODIFY]` | Phase 1 — Title + intro | ✅ |
| T2 | `[MODIFY]` | Phase 2 — Option 1 / Option 2 | ✅ |
| T3 | `[MODIFY]` | Phase 3 — Build eversis-collections | ✅ |
| T4 | `[MODIFY]` | Phase 4 — Official docs + Context7 | ✅ |
| T5 | `[MODIFY]` | Phase 5 — Usage bullets + Sequential Thinking + Verify | ✅ |
| T6 | `[REUSE]` | Phase 6 — Link validation + CHANGELOG | ✅ |

---

## Definition of done

1. [x] Section order matches approved IA
2. [x] Factual content preserved or linked
3. [x] `mcpServers` in JSON; no `.vscode/` references
4. [x] Third-party tables removed; emoji bullets used
5. [x] Link validation passes
6. [x] Human approved plan → implemented

---

## Changelog

| Date | Change |
| ---- | ------ |
| 2026-06-07 | Plan from approved research |
| 2026-06-07 | README MCP section rewritten |
