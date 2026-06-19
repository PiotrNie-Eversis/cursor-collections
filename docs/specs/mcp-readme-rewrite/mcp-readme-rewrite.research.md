# Research: Restructure `mcp/eversis-collections-mcp/README.md`

**Task:** Improve readability of the MCP package README using progressive disclosure and visual workflow mapping (inspired by a product-engineering README benchmark).

**Status:** Approved — implementation complete (2026-06-07).

---

## Problem statement

The current [`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md) is **technical-first** and assumes the reader already understands Cursor Collections, MCP, and why this local server exists. A newcomer opening the MCP folder (or following a link from `documentation/cursor-collection.md`) sees:

1. A bullet list of tool names (lines 4–7)
2. **Build instructions** before any “why” (lines 10–20)
3. A dense **tools table** (lines 38–51)
4. Low-level **document engine** details (BOM, locale styles, section flags) before workflow context

By contrast, product-engineering README benchmark `README.md` delivers:

- **3-second comprehension:** one-liner + lifecycle tagline
- **15-second architecture:** phased matrix (Ideation → Dev → Quality) with Agents / Prompts / Skills
- **Workflow simulation:** text flowcharts with `↳` and status emojis
- **Installation last:** only after value is established

Stakeholder feedback (product owner) confirms the MCP README “is very difficult to read, especially for people not familiar with Cursor Collections.”

---

## Scope boundary

| In scope | Out of scope (unless explicitly approved later) |
| -------- | ----------------------------------------------- |
| Rewrite **`mcp/eversis-collections-mcp/README.md`** only | Full root [`README.md`](../../../README.md) rewrite |
| Align tone/structure with product-engineering README benchmark **principles**, adapted to **Cursor + MCP package** context | Duplicating the entire 900-line product-engineering README benchmark README into the MCP folder |
| Preserve **all factual content** (tools, env vars, doc compatibility, security, CLI) — relocate, don’t delete | Changing MCP server code or `.cursor/mcp.json` |
| Add **links** to authoritative framework docs where full lifecycle belongs | Rewriting `website/docs/getting-started/mcp-setup.md` in this task |

**Rationale:** The MCP README is linked from [`documentation/cursor-collection.md`](../../../documentation/cursor-collection.md), root README, CHANGELOG, and setup plans. It must stand alone for “what is this package?” while **not** competing with root README / docs site for the full Ideate → Implement → Review catalog.

---

## Current document map (information architecture)

| Document | Role today | Overlap with MCP README |
| -------- | ---------- | ------------------------ |
| [`README.md`](../../../README.md) (root) | Framework entry: lifecycle table, quick start, MCP one-liner | High — skills, MCP build, BA docs |
| [`documentation/cursor-collection.md`](../../../documentation/cursor-collection.md) | Authoritative Cursor framework guide | Medium — MCP + skills section |
| [`website/docs/getting-started/mcp-setup.md`](../../../website/docs/getting-started/mcp-setup.md) | Workspace vs user MCP config, third-party servers | Medium — build steps, server table |
| [`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md) | Package README: tools, docx engine, env, tests | **Should be** the canonical deep reference for **this server** |

**Gap:** MCP README tries to be *only* a reference manual. It never answers: *“I cloned cursor-collections — why must I build this, and what changes in my Cursor session?”*

---

## Audience analysis

| Persona | Needs from MCP README | Current pain |
| ------- | --------------------- | ------------ |
| **New to Cursor Collections** | What the server does; how it fits Ideate → Implement → Review; minimal install path | No lifecycle context; jargon (`stdio`, `allowlist`, `SKILL.md frontmatter`) upfront |
| **Consumer project dev** | `CURSOR_COLLECTIONS_HOME`, enable MCP after `setup-cursor-local.sh`, verify it works | Env vars buried at bottom; install assumes monorepo cwd |
| **Framework contributor** | Tool table, docx compatibility, `npm test` / `npm run validate`, security model | Content exists but hard to scan |
| **BA Docs user** | Word chapter tools + destructive `update_chapter` warning | Warning exists but appears after long compatibility tables |

---

## Feature analysis: what works in product-engineering README benchmark README

Applied to **this** task (principles, not copy-paste):

1. **Visual anchors** — Phase emojis (📋 Ideate, 🛠 Implement, ✅ Review) map cleanly to Cursor Collections ([root README table](../../../README.md)).
2. **WHO / HOW / WHAT** — external benchmark: Agents / Skills / Prompts. Cursor Collections: **Rules** (`.cursor/rules/`), **Skills** (`.cursor/skills/`), **Prompts** (`.cursor/prompts/public/`), orchestrated via **`@eversis-*`** and **`/` commands**.
3. **Progressive disclosure** — Value → workflows → prerequisites → install → deep reference.
4. **Text flowcharts** — Example flows using `↳ 📖 Review`, `↳ ✅ Approve` match human gates in `eversis-implement`.
5. **MCP section** — Option 1 (workspace) vs Option 2 (user / `CURSOR_COLLECTIONS_HOME`) — directly applicable.
6. **Micro-templates** — Focus / How to use / Outcome for tools or tool **groups** (not 11 separate essays).


---

## Factual inventory (must remain accurate)

### Server identity

- **Package:** `eversis-collections-mcp` — **not published to npm**; build from repo clone.
- **MCP id in config:** `eversis-collections` (stdio, `node mcp/eversis-collections-mcp/dist/index.js` relative to repo root).
- **Single server** for skills **and** Word `.docx` tools (no separate docs MCP).

### Tool groups

| Group | Tools | Primary workflows |
| ----- | ----- | ----------------- |
| **Skills** | `eversis_skills_list`, `eversis_skills_get`, `eversis_skills_validate`, `eversis_skill_run_script` | Agent loads procedural `SKILL.md` during implement/review; CI validation |
| **Repo scripts** | `eversis_repo_run_script` | `sync-prompts`, `sync-framework-doc` |
| **Word / BA Docs** | `generate_summary_map`, `read_chapter`, `update_chapter`, `upload_to_sharepoint` (stub) | `@eversis-ba-docs-planner`, `@eversis-ba-docs-writer` |
| **Security** | Allowlisted scripts only (`skillScripts.ts`, `repoScripts.ts`) | Document in deep dive |

### Environment

- **`CURSOR_COLLECTIONS_HOME`** — canonical absolute path to framework checkout.
- **`EVERSIS_COLLECTIONS_ROOT`** — deprecated alias.
- Walk-up auto-detection from cwd before env vars.

### Docx engine (deep dive content)

- UTF-8 BOM stripping; locale-aware headings via `word/styles.xml`; section flags `hasTables`, `hasImages`, `tableCount`.
- **`update_chapter`** is destructive replace — TEXT-SAFE sections only; read-first / append pattern.

### Quality commands

- `npm install && npm run build`, `npm test`, `npm run validate` (`--strict`).

---

## Proposed information architecture (target MCP README)

Order follows **progressive disclosure**:

```text
1. Hero — one-liner + tagline (skills + Word tools in Cursor Agent via MCP)
2. What this server unlocks — 3-row matrix (Skills | BA Docs | Framework scripts)
3. Where it fits — short Ideate → Implement → Review bridge + links to root README / cursor-collection.md
4. Supported workflows — 2–3 text flowcharts (Implement+skill, BA docs, validate in CI)
5. Prerequisites — Cursor, Node ≥18, framework checkout
6. Installation — Option A workspace monorepo | Option B consumer project (CURSOR_COLLECTIONS_HOME + setup script link)
7. Verify it works — enable MCP in Cursor, optional `eversis_skills_list` smoke check
8. Tools at a glance — compact table (keep current table, slightly grouped)
9. Deep dive — Document compatibility, Editing guidance, Environment, Security, Tests & CLI
10. Related docs — mcp-setup.md, business-manager-docs workflow, AGENTS.md
```

**Length target:** ~150–220 lines (vs current ~95 lines of dense reference). Acceptable increase because **scan-friendly** sections replace walls of tables upfront.

---

## Risks and constraints

| Risk | Mitigation |
| ---- | ---------- |
| Duplicating root README | MCP README links out; lifecycle matrix is **summary** (3 rows), not full prompt catalog |
| Stale links | Run `node scripts/validate-cursor-markdown-links.mjs --context=source --paths=mcp/eversis-collections-mcp/README.md` after edit |
| User template uses fictional `@cc-*` rules | Map to real **`eversis-*`** prompts and MCP tool names |
| Breaking references from cursor-collection.md | Keep filename/path; anchor headings optional |
| Emoji overload | Use phase emojis consistently (match root README / product-engineering README benchmark); avoid decorating every bullet |

---

## Acceptance criteria (research phase)

- [x] Current README pain points documented
- [x] Scope limited to MCP package README
- [x] product-engineering README patterns mapped to Cursor Collections equivalents
- [x] All technical facts inventoried for preservation
- [x] Target IA proposed
- [ ] **Human approval** to proceed to implementation plan

---

## Open questions for human review

**Resolved (2026-06-07):**

1. **Workflow depth:** MCP-touching flows only + one sentence + link for full lifecycle.
2. **Tool micro-templates:** Each registered tool documented with Focus / How to use / Outcome (14 tools — server exposes more than the previous README listed).
3. **Diagram:** Small mermaid flowchart added (Agent → MCP → skills / docx / scripts).

---

## References

- Current: [`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md)
- Benchmark: product-engineering README benchmark README
- Framework: [`README.md`](../../../README.md), [`documentation/cursor-collection.md`](../../../documentation/cursor-collection.md)
- MCP setup (site): [`website/docs/getting-started/mcp-setup.md`](../../../website/docs/getting-started/mcp-setup.md)
- BA Docs workflow: [`website/docs/workflow/business-manager-docs.md`](../../../website/docs/workflow/business-manager-docs.md)
