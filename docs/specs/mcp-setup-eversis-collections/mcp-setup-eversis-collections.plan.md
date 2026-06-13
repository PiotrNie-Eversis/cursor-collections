# Plan: Cursor Collections MCP — docs site integration page

**Research:** [`mcp-setup-eversis-collections.research.md`](./mcp-setup-eversis-collections.research.md)  
**Status:** Complete (2026-06-13)

---

## Goal

Give **`eversis-collections`** the same discoverability and narrative treatment as third-party MCPs on the docs site: a dedicated **Integrations** page titled **Cursor Collections MCP**, an expanded **MCP Server Reference** entry in [`mcp-setup.md`](../../../website/docs/getting-started/mcp-setup.md), and minimal cross-links so readers understand **why** the local server is required without opening GitHub first.

**Canonical tool-level reference stays** in [`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md) — the docs site summarizes groups and workflows only.

---

## Human decisions (approved 2026-06-13)

| Question | Decision |
| -------- | -------- |
| Page title | **Cursor Collections MCP** (body notes server key `eversis-collections`) |
| BA Docs depth | **Abbreviated safety callout** (3 bullets) + link to [Business Manager Docs workflow](../../../website/docs/workflow/business-manager-docs.md) |
| Scope | **Option B only** — integration page + `mcp-setup.md` + `integrations/overview.md`; no sweep of `business-manager-docs.md`, `intro.md`, etc. |
| Sidebar | **First after Integrations Overview** (`sidebar_position: 2`); bump existing pages 2→11 to 3→12 |

---

## Non-goals

- Change MCP server code, `.cursor/mcp.json`, or npm dependencies
- Rewrite [`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md) (one reciprocal link in Related docs is allowed)
- Root [`README.md`](../../../README.md) MCP section ([`readme-mcp-section`](../readme-mcp-section/readme-mcp-section.research.md) is separate)
- Full BA Docs playbook on the integration page
- Per-tool Focus / How / Outcome for all 14 tools on the docs site

---

## Task checklist

| ID | Type | Task | Status |
| -- | ---- | ---- | ------ |
| T1 | `[CREATE]` | `website/docs/integrations/eversis-collections.md` | ✅ |
| T2 | `[MODIFY]` | Sidebar renumber (11 files + new page) | ✅ |
| T3 | `[MODIFY]` | `website/docs/getting-started/mcp-setup.md` | ✅ |
| T4 | `[MODIFY]` | `website/docs/integrations/overview.md` | ✅ |
| T5 | `[MODIFY]` | Reciprocal link in package README Related docs | ✅ |
| T6 | `[REUSE]` | Link validation + `npm run build` | ✅ |

---

## Definition of done

- [x] Reader at `mcp-setup#mcp-server-reference` understands **why** `eversis-collections` is required and **what workflows** it enables without opening GitHub first
- [x] All **14 tools** appear in grouped inventory on integration page
- [x] Dedicated integration page comparable in structure to Sequential Thinking
- [x] **Used By** mapping present for local server
- [x] **`CURSOR_COLLECTIONS_HOME`** and consumer bootstrap documented (integration page + link to installation)
- [x] **Agent Skills anti-pattern** documented
- [x] Link validation and docs build pass

---

## Changelog

| Date | Change |
| ---- | ------ |
| 2026-06-13 | Plan drafted from approved research + human decisions on open questions |
| 2026-06-13 | Implemented: integration page, sidebar renumber, mcp-setup + overview updates, package README link, build OK |
