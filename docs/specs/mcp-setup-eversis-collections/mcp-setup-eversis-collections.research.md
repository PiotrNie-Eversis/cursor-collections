# Research: Better docs for `eversis-collections` MCP (MCP Server Reference)

**Date:** 2026-06-13  
**Phase:** Research (`@eversis-implement`)  
**Trigger:** Stakeholder question — should the local **`eversis-collections`** MCP be better described in the docs site, especially under [MCP setup — MCP Server Reference](../../../website/docs/getting-started/mcp-setup.md#mcp-server-reference)?

---

## Executive summary

**Yes — the docs site under-describes `eversis-collections` relative to its importance and relative to how third-party MCPs are documented.**

The framework’s **only local, first-party MCP** (14 tools, skills + Word + repo automation) is summarized in **one dense table row** on `mcp-setup.md`, while third-party servers get a multi-column reference table, dedicated integration pages (e.g. [Sequential Thinking](../../../website/docs/integrations/sequential-thinking.md)), and “Used By” agent mapping. The **canonical deep reference** was recently improved in [`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md) ([`mcp-readme-rewrite`](../mcp-readme-rewrite/mcp-readme-rewrite.research.md)), but that rewrite **explicitly excluded** the docs site — creating an imbalance: newcomers on the docs site still see a thin pointer to GitHub instead of a self-contained explanation of *why* and *when* to build the server.

**Recommendation:** Treat this as a **docs-site information-architecture** task — expand the MCP Server Reference for `eversis-collections` and add a dedicated integration page (mirroring third-party pattern), with progressive disclosure linking to the package README for tool-level detail.

---

## Problem statement

Readers landing on **MCP setup → MCP Server Reference** need to understand:

1. **Why** `eversis-collections` is required (not optional like most third-party MCPs).
2. **What** it unlocks in Cursor Agent (skills discovery, QA comment skill, BA Docs, allowlisted scripts).
3. **How** it differs from registering `.cursor/skills/` as Cursor Agent Skills.
4. **Which workflows** depend on it (`@eversis-implement`, `@eversis-review`, `@eversis-ba-docs-*`).
5. **How to verify** it works and what to do when the framework lives outside the workspace (`CURSOR_COLLECTIONS_HOME`).

Today, that section answers (5) partially and (1)–(4) only by implication or by sending readers off-repo to the package README.

---

## Current state (docs site)

### `website/docs/getting-started/mcp-setup.md`

| Section | What it says about `eversis-collections` | Gap |
| ------- | ---------------------------------------- | --- |
| **At a glance** | Build command; one bullet: `eversis_skills_*` + Word tools; link to package README | No workflow mapping; no tool count; no consumer-project path |
| **MCP Server Reference → Local** | Single table row: long Purpose cell listing partial tool names | No **Used By** column (third-party table has it); incomplete Word tool list |
| **MCP Server Reference → Third-party** | Full table with Purpose + Used By | `eversis-collections` visually “less important” despite being the framework’s core bridge |
| **Official Documentation** | Links for Atlassian, Context7, Playwright, Figma, Sequential Thinking | **No link** for `eversis-collections` (only GitHub README via inline link earlier) |

**Incomplete tool inventory in the Local table row** — mentions only four Word tools:

- Listed: `generate_summary_map`, `read_chapter`, `update_chapter`, `upload_to_sharepoint`
- Missing from docs (but live in MCP): `append_chapter`, `update_table_cell`, `list_section_elements`, `inspect_document`, `backup_docx`

Skills tools are summarized as “list/read/validate” + `eversis_skill_run_script`; repo tool `eversis_repo_run_script` is mentioned in prose but not in the at-a-glance bullet.

### `website/docs/integrations/overview.md`

- One **Local server** table row — same density problem as `mcp-setup.md`.
- Word tool list again **truncated** (four tools, same omissions).
- Full `mcp.json` example includes `eversis-collections` at the bottom with no commentary.
- **No** entry in the “Configured Servers” table (lines 28–40) — only the 11 third-party servers get dedicated rows with “Used By”.

### Dedicated integration page

| Server | `website/docs/integrations/<name>.md` |
| ------ | ------------------------------------- |
| Sequential Thinking | ✅ Exists — capabilities, agents, config JSON, when not to use |
| Figma, Atlassian, Context7, … | ✅ Each has a page |
| **`eversis-collections`** | ❌ **Missing** — no first-party integration doc on the site |

### Cross-links elsewhere

- [`installation.md`](../../../website/docs/getting-started/installation.md) — stronger on build + `CURSOR_COLLECTIONS_HOME` + setup script flags.
- [`skills/overview.md`](../../../website/docs/skills/overview.md) — explains MCP consumption model but assumes reader already knows why.
- [`business-manager-docs.md`](../../../website/docs/workflow/business-manager-docs.md) — lists four Word tools; points to package README and MCP setup.
- [`intro.md`](../../../website/docs/intro.md) — counts “MCP (local): 1” but defers detail to integrations overview.

**Pattern:** The docs site **distributes** fragments about `eversis-collections` across getting-started, skills, and workflow pages, but never gives it the **same narrative treatment** as Sequential Thinking or Figma.

---

## Canonical reference (package README) — post-rewrite

[`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md) now provides:

- Value proposition (“What this server unlocks”) with **3 tool groups** and workflow triggers
- Mermaid architecture diagram
- Text flowcharts for Implement, BA Docs, contributor validation
- Full **14-tool** table + Focus / How to use / Outcome per tool
- Environment (`CURSOR_COLLECTIONS_HOME`), security allowlist, doc compatibility, editing guidance

This is the **right** depth for package maintainers and BA Docs implementers. It is **not** ideal as the **only** onboarding path from the docs site because:

1. It lives on GitHub (or deep in the monorepo), not in the Docusaurus nav.
2. `mcp-setup.md` already positions itself as the setup hub — readers expect the answer there.
3. Sequential Thinking gets **both** a summary in MCP setup **and** a dedicated page — `eversis-collections` does not.

Prior research ([`mcp-readme-rewrite`](../mcp-readme-rewrite/mcp-readme-rewrite.research.md)) scoped **out** rewriting `mcp-setup.md` — that boundary is now the main source of the gap.

---

## Comparison: documentation depth

| Aspect | Third-party MCP (e.g. Sequential Thinking) | `eversis-collections` (local) |
| ------ | -------------------------------------------- | ------------------------------ |
| At-a-glance bullet | ✅ + link to details page | ✅ one line, no details page |
| MCP Server Reference table | Purpose + **Used By** | Purpose only (one row) |
| Dedicated integration page | ✅ | ❌ |
| Config JSON snippet | ✅ on integration page | Only in integrations overview full example |
| “When to use / not use” | ✅ | ❌ |
| Tool count / grouping | N/A (1 tool) | **14 tools**, 3 groups — **not summarized on site** |
| Build / env requirements | npx, no auth | **Build required**, `CURSOR_COLLECTIONS_HOME`, walk-up detection — **under-documented on mcp-setup** |
| Official doc link footer | ✅ | ❌ (package README link only) |

**Asymmetry is inverted:** the **most critical** MCP for the framework is documented **least** like a product feature on the docs site.

---

## Audience analysis

| Persona | What they need at MCP Server Reference | Current pain |
| ------- | -------------------------------------- | ------------ |
| **New framework adopter** | “Why must I run npm build?” + verify step | Build steps exist; **value** is one bullet |
| **Consumer project dev** | `CURSOR_COLLECTIONS_HOME`, setup script, path in `mcp.json` | Buried in `installation.md`, not in MCP Server Reference |
| **Implement / Review user** | Skills via MCP vs Agent Skills UI; `@eversis-implement` → `eversis_skills_get` | Not stated on mcp-setup |
| **BA Docs user** | Full Word tool chain + `backup_docx` / content-type routing | Partial tool list; safety rules only in package README |
| **Docs contributor** | Single source of truth hierarchy (site vs package README) | Unclear — site duplicates incomplete lists |

---

## Factual inventory (must stay accurate in any doc update)

### Server identity

- **MCP id:** `eversis-collections`
- **Type:** stdio (`node mcp/eversis-collections-mcp/dist/index.js` relative to repo root, or absolute path after `setup-cursor-local.sh`)
- **Not on npm** — build from clone
- **Single server** for skills **and** Word tools (no separate docs MCP)

### 14 tools (3 groups)

| Group | Tools |
| ----- | ----- |
| **Skills** | `eversis_skills_list`, `eversis_skills_get`, `eversis_skills_validate`, `eversis_skill_run_script` |
| **Repo** | `eversis_repo_run_script` (`sync-prompts`, `sync-framework-doc`) |
| **Word / BA Docs** | `generate_summary_map`, `read_chapter`, `append_chapter`, `update_chapter`, `update_table_cell`, `list_section_elements`, `inspect_document`, `backup_docx`, `upload_to_sharepoint` (stub) |

### Workflow dependencies (high level)

| Workflow | MCP dependency |
| -------- | -------------- |
| `@eversis-implement` / `@eversis-review` | Skill discovery + `eversis-qa-comment` on Fine |
| `@eversis-ba-docs-planner` / `@eversis-ba-docs-writer` | Word chapter tools |
| Contributor CI | `eversis_skills_validate` (CLI equivalent: `npm run validate` in package) |
| Docs site sync | `eversis_repo_run_script` → `sync-prompts` |

### Critical consumer note

Do **not** register `.cursor/skills/` as Cursor **Agent Skills** for this framework — use MCP tools ([`AGENTS.md`](../../../AGENTS.md), [`skills/overview.md`](../../../website/docs/skills/overview.md)).

---

## Options (for plan phase)

### Option A — Expand `mcp-setup.md` MCP Server Reference only (minimal)

- Replace single-row Local table with:
  - Short **“Why local”** callout (required for skills; not npx)
  - **Tool groups** table (3 rows, link to package README for per-tool detail)
  - **Used By** column aligned with third-party table
  - **Consumer path** pointer (`CURSOR_COLLECTIONS_HOME`, link to installation §4)
  - Add package README to **Official Documentation** list

**Pros:** Smallest diff; fixes the anchor the stakeholder asked about.  
**Cons:** `mcp-setup.md` grows; still no nav entry under Integrations.

### Option B — New `website/docs/integrations/eversis-collections.md` (recommended core)

Mirror [sequential-thinking.md](../../../website/docs/integrations/sequential-thinking.md) structure:

- Server key, type, build path
- **Capabilities** (skills, Word, repo scripts)
- **Which agents / prompts use it**
- **Configuration** (workspace vs consumer / env var)
- **Workflow diagrams** (abbreviated from package README — progressive disclosure)
- **When NOT to use** (e.g. don’t register skills folder as Agent Skills)
- Link to package README for tool reference + doc compatibility

Update:

- `mcp-setup.md` Local section → short summary + link to new page
- `integrations/overview.md` → add row in Configured Servers table; fix tool list
- `mcp-setup.md` at-a-glance Sequential Thinking pattern: “[details](../integrations/eversis-collections)”

**Pros:** Consistent IA; discoverable in Integrations nav; package README stays deep reference.  
**Cons:** Two places to maintain summaries (mitigate: site = summary, README = canonical detail).

### Option C — Option B + align fragmented pages

Also update incomplete tool lists in:

- `business-manager-docs.md`
- `integrations/overview.md` Local table
- Optional: `intro.md` counts / links

**Pros:** Removes stale partial inventories repo-wide.  
**Cons:** Wider diff; needs link validation pass.

---

## Recommendation

**Proceed with Option B**, with a **light Option A** edit so `#mcp-server-reference` remains useful when deep-linked:

1. **Create** `website/docs/integrations/eversis-collections.md` (first-party integration page).
2. **Restructure** `mcp-setup.md` § MCP Server Reference — Local subsection becomes summary + link; fix tool list omissions in any remaining prose.
3. **Add** `eversis-collections` to Integrations overview “Configured Servers” table and Official Documentation links on `mcp-setup.md`.
4. **Keep** [`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md) as **canonical tool-level reference** — docs site links down, does not duplicate Focus/How/Outcome for all 14 tools.

**Do not** duplicate the full package README into the docs site (maintainability). **Do** copy the **workflow mapping** and **three tool groups** — that is what readers miss today.

---

## Scope boundary (proposed)

| In scope | Out of scope (unless approved) |
| -------- | ------------------------------ |
| Docs site pages under `website/docs/getting-started/` and `website/docs/integrations/` | Changing MCP server code or `.cursor/mcp.json` |
| Cross-link fixes for incomplete Word tool lists on site | Rewriting `mcp/eversis-collections-mcp/README.md` again |
| Docusaurus sidebar / nav if auto-generated from folder | Root `README.md` MCP section (separate spec: [`readme-mcp-section`](../readme-mcp-section/readme-mcp-section.research.md)) |
| `npm run validate-cursor-links` after edits | New npm dependencies |

---

## Risks

| Risk | Mitigation |
| ---- | ---------- |
| **Dual maintenance** (site summary vs package README) | Site summarizes groups + workflows; README owns tool API; single “Tools at a glance” table only in README |
| **Stale tool lists** | One grouped table on integration page; other pages link instead of enumerating |
| **Consumer vs monorepo paths** | Document both in integration page; link to `installation.md` for setup script |
| **Over-long mcp-setup** | Move narrative to integration page; keep mcp-setup as setup hub |

---

## Acceptance criteria (for plan / implement)

- [ ] Reader at `mcp-setup#mcp-server-reference` understands **why** `eversis-collections` is required and **what workflows** it enables without opening GitHub.
- [ ] All **14 tools** appear in docs site inventory (grouped), or site explicitly defers to package README with accurate group counts.
- [ ] **`eversis-collections` has a dedicated integration page** comparable in structure to Sequential Thinking.
- [ ] **Used By** mapping (agents/prompts) present for local server, consistent with third-party table.
- [ ] **`CURSOR_COLLECTIONS_HOME`** and consumer bootstrap documented from MCP setup or linked integration page.
- [ ] **Agent Skills anti-pattern** documented (“use MCP, don’t register `.cursor/skills/`”).
- [ ] Link validation passes (`npm run validate-cursor-links` / `npm run build` in `website/`).

---

## Open questions (human input before plan)

1. **Naming:** Integration page title — `eversis-collections` (matches `mcp.json` key) vs “Cursor Collections MCP” (human-friendly)?
2. **Depth:** Should the integration page include abbreviated **BA Docs editing rules** (`append_chapter` vs `update_chapter`), or only link to [`business-manager-docs.md`](../../../website/docs/workflow/business-manager-docs.md)?
3. **Scope:** Option B only, or Option C (sweep other pages for incomplete tool lists) in the same delivery?
4. **Sidebar:** Should the local server appear **first** in Integrations (before third-party SaaS) to reflect priority?

---

## Suggested plan phases (preview — not approved)

1. **IA + integration page** — draft `eversis-collections.md`, wire nav/links.
2. **MCP setup patch** — restructure `#mcp-server-reference` Local block; add Official Documentation entry.
3. **Consistency pass** — overview + business-manager-docs tool lists (if Option C approved).
4. **Quality gate** — `validate-cursor-links`, `npm run build` in `website/`.

---

## References

- Stakeholder anchor: [MCP setup — MCP Server Reference](../../../website/docs/getting-started/mcp-setup.md#mcp-server-reference)
- Package deep reference: [`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md)
- Prior MCP README rewrite: [`docs/specs/mcp-readme-rewrite/`](../mcp-readme-rewrite/mcp-readme-rewrite.research.md)
- Benchmark integration page: [`website/docs/integrations/sequential-thinking.md`](../../../website/docs/integrations/sequential-thinking.md)
- Framework contract: [`AGENTS.md`](../../../AGENTS.md), [`documentation/cursor-collection.md`](../../../documentation/cursor-collection.md)
