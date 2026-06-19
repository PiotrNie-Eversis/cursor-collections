# Plan: Improve `website/` readability after README rewrite

**Research:** [`website-readability.research.md`](./website-readability.research.md) 
**Status:** Complete (2026-06-07).

---

## Goal

Align the Docusaurus site (`website/`) with the restructured root [`README.md`](../../../README.md) so readers get a **consistent story** across GitHub and the docs site: **Ideate → Implement → Review**, curated onboarding, short workflow overview with links to depth, scannable agents, and cohesive MCP setup — without duplicating the full README on every page.

Apply **Confluence-like docs chrome** on `/docs/**` (split-theme): light canvas, blue accents, breadcrumbs, TOC, panel admonitions — while the **homepage** keeps purple/dark marketing (research Option **A**).

**Non-goals:** Change `.cursor/` rules, prompts, skills, or MCP server code; auto-sync README into the site (no sync markers); MDX partials (defer B); rewrite historical entries in `website/src/pages/changelog.md`; clone Atlassian assets or full Confluence UI; whole-site light rebrand (Option B).

---

## Human decisions (approved 2026-06-07)

| # | Decision |
| - | -------- |
| 1 | **Full homepage marketing rewrite** (hero, features, quick wins, getting started, CTAs) — **purple/dark** brand (split-theme) |
| 2 | **Agents overview:** Focus blocks **above** reference tables (tables kept) |
| 3 | **Workflow overview:** **Short** + `:::info` admonitions linking to variant flow pages |
| 4 | **New** [`getting-started/start-here.md`](../../../website/docs/getting-started/start-here.md) curated path + streamlined `intro.md` |
| 5 | **Drift prevention:** **A + D** (parity checklist + site SSOT policy); optional **A+** grep CI gate in Phase 6 |
| 6 | **Navbar:** top-level **“Get started”** → `start-here` |
| 7 | **Confluence-like UI:** **Option A — docs only** (Tier 1 + light Tier 2); homepage stays branded; see Phase 7 |

---

## Split-theme model

```text
/ and marketing React → purple/dark (Phases 3, 7 navbar exception on docs routes)
/docs/** → Confluence-like light chrome (Phase 7)
```

| Surface | Theme |
| ------- | ----- |
| Homepage `/` | Dark/purple marketing |
| Docs `/docs/**` | Light `#F4F5F7` shell, white content, blue `#0C66E4` links |
| Navbar on doc pages | Light variant (white bg, dark text) when `docs-doc-page` |

---

## SSOT policy (D)

| Surface | Owns |
| ------- | ---- |
| **README** | GitHub scan — summaries, one flowchart per variant max, links to site |
| **Site docs** | Depth — flowcharts on `workflow/*-flow.md`, agent reference tables, MCP tables, installation refresh table |
| **Homepage React** | Marketing copy aligned with README; **short**; links to `start-here` |

When editing README sections listed in the [parity map](#readme--site-parity-checklist-a), update the mapped site pages in the same PR when messaging changes.

---

## Implementation phases

### Phase 1 — Navbar and config (`[MODIFY]`)

**Files:** [`website/docusaurus.config.ts`](../../../website/docusaurus.config.ts)

- [ ] Add navbar item **“Get started”** (`position: left`, after Docs or before Framework) → `/docs/getting-started/start-here`
- [ ] Verify `onBrokenLinks: throw` still passes after new route exists (Phase 2 creates the doc)

*Note:* Breadcrumbs + TOC config deferred to Phase 7 (Confluence docs chrome).

---

### Phase 2 — Curated path and docs landing (`[CREATE]` / `[MODIFY]`)

**Create:** [`website/docs/getting-started/start-here.md`](../../../website/docs/getting-started/start-here.md)

- [ ] Frontmatter: `sidebar_position: 0`, `title: Start here`
- [ ] Ordered checklist (links only, ~40–60 lines):
 1. [Prerequisites](./prerequisites) — Cursor, Node ≥ 18, Git
 2. [Installation](./installation) — clone / consumer `setup-cursor-local.sh`
 3. [MCP setup](./mcp-setup) — build `eversis-collections`, enable servers
 4. First prompt — `@eversis-implement` or `/eversis-implement` + link to [prompts overview](../prompts/overview)
 5. [Workflow overview](../workflow/overview) — pick a variant
 6. Optional: [Framework reference](../framework), [Agents overview](../agents/overview)
- [ ] One-line tagline: Ideate → Implement → Review; human gates callout (`:::tip`)
- [ ] **Confluence hub pattern:** footer **“In this section”** — bullet list of sibling getting-started pages (prerequisites, installation, mcp-setup, quick-wins)

**Modify:** [`website/docs/getting-started/prerequisites.md`](../../../website/docs/getting-started/prerequisites.md)

- [ ] Add **Node.js ≥ 18** for building `eversis-collections` MCP (match README)

**Modify:** [`website/docs/intro.md`](../../../website/docs/intro.md)

- [ ] Short opener (2–3 sentences) — value prop before mechanics
- [ ] Add **phase capability matrix** mirroring README § What this repository provides (Ideate / Implement / Review / BA Docs / Customize / Infrastructure)
- [ ] Add `eversis-` prefix callout (`:::tip` or `:::info` — prefer info on Confluence-themed docs)
- [ ] Keep counts table or demote below matrix (preserve factual counts)
- [ ] Prominent CTA → [Start here](./getting-started/start-here)
- [ ] Trim or relocate long first paragraph on rules/prompts/MCP to “Canonical reference” / links
- [ ] **Hub footer:** links to start-here, workflow overview, agents overview, framework

**Modify:** [`website/docs/getting-started/_category_.json`](../../../website/docs/getting-started/_category_.json)

- [ ] Set `collapsible: true` (Confluence folder feel; Phase 7 sidebar CSS reinforces)

Repeat for other doc folders in Phase 7: `workflow/_category_.json`, `agents/_category_.json`, `integrations/_category_.json`, `skills/_category_.json`.

---

### Phase 3 — Homepage full marketing rewrite (`[MODIFY]`)

**Unchanged intent:** purple/dark marketing — **not** Confluence space-home (Option A).

**Hero:** [`website/src/components/HeroSection/index.tsx`](../../../website/src/components/HeroSection/index.tsx)

- [ ] Subcopy: Cursor-native framework; **Ideate → Implement → Review**; human gates
- [ ] Optional credit line: Eversis; based on product-engineering README benchmark (match README tone)
- [ ] Primary CTA → `/docs/getting-started/start-here`; secondary → GitHub or `/docs/`

**Features:** [`website/src/components/HomepageFeatures/index.tsx`](../../../website/src/components/HomepageFeatures/index.tsx)

- [ ] Replace “Product Ideation, Development, and Quality” with **Ideate / Implement / Review** (and BA Docs / customization where a card fits)
- [ ] Card copy aligned with README phase matrix (rules, prompts, skills per phase — concise)

**Quick wins:** [`website/src/components/QuickWins/index.tsx`](../../../website/src/components/QuickWins/index.tsx)

- [ ] `trackLabel`: Ideate / Implement / Review (not Product Ideation / Development / Quality)

**Workflow:** [`website/src/components/WorkflowShowcase/index.tsx`](../../../website/src/components/WorkflowShowcase/index.tsx)

- [ ] Fix caption: attach `@eversis-*.md` in Chat/Agent **or** use **`/eversis-*` project commands** from `.cursor/commands/` (remove “not built-in slash commands”)

**SDLC diagram:** [`website/src/components/SdlcDiagram/index.tsx`](../../../website/src/components/SdlcDiagram/index.tsx)

- [ ] Phase tag “Product Ideation” → **Ideate** (align labels with README)

**Getting started:** [`website/src/components/GettingStartedSection/index.tsx`](../../../website/src/components/GettingStartedSection/index.tsx)

- [ ] Expand to **6 steps** (parity with README Quick start lines 254–259):
 1. Open in Cursor
 2. Read AGENTS.md + framework doc
 3. Rules (`eversis-agent-core`, `eversis-project-stack`)
 4. Attach `@eversis-implement` or `/eversis-implement`
 5. MCP — build + enable `eversis-collections`
 6. Skills via `eversis_skills_list` / `eversis_skills_get`
- [ ] Primary button → `/docs/getting-started/start-here`

**Other homepage:** [`website/src/components/SocialProof/index.tsx`](../../../website/src/components/SocialProof/index.tsx) — grep and align phase terminology if present

**Layout meta:** [`website/src/pages/index.tsx`](../../../website/src/pages/index.tsx) — update `description` if it still says “ideation” in external benchmark terms

---

### Phase 4 — Workflow overview (`[MODIFY]`)

**File:** [`website/docs/workflow/overview.md`](../../../website/docs/workflow/overview.md)

Keep page **short** (~80–100 lines max). Do **not** paste README-length flowcharts.

- [ ] Tighten phase primers; add **Gate 1 / 1.5 / 2** mention under Ideate (one line + link to [workshop-flow](./workshop-flow))
- [ ] Add **Implement → Review** table (match README)
- [ ] Replace bullet “Workflow Variants” with **variants table** (Variant | Entry | Use when) — mirror README
- [ ] Add per-variant **`:::info`** admonitions with one-sentence teaser + link:
 - [Standard flow](./standard-flow)
 - [Frontend flow](./frontend-flow) — include UI loop one-liner + “5 steps” link to child page
 - [Workshop analysis](./workshop-flow)
 - [E2E testing](./e2e-flow)
 - [Business Manager Docs](./business-manager-docs)
- [ ] Keep existing `<SdlcDiagram />` and human-gates `:::warning`
- [ ] Preserve **Fine → QA comment** block
- [ ] **Hub footer:** “Workflow playbooks” — links to all variant pages (Confluence child-list pattern)

**Terminology sweep** (same phase, grep fixes):

- [ ] [`website/docs/use-cases.md`](../../../website/docs/use-cases.md) — “Product Ideation” → **Ideate** (section heading + body)
- [ ] [`website/docs/for-ctos.md`](../../../website/docs/for-ctos.md) — lifecycle terms → Ideate / Implement / Review where describing **current** framework (preserve historical quotes only if clearly dated)
- [ ] [`website/docs/skills/overview.md`](../../../website/docs/skills/overview.md) — “Product Ideation Skills” → **Ideate skills** (or 📋 Ideate)
- [ ] Workflow variant pages: normalize **`@` or `/`** phrasing where only `/` appears ([`standard-flow.md`](../../../website/docs/workflow/standard-flow.md), [`frontend-flow.md`](../../../website/docs/workflow/frontend-flow.md))
- [ ] **Do not** edit historical narrative in [`website/src/pages/changelog.md`](../../../website/src/pages/changelog.md)

---

### Phase 5 — Agents, MCP, installation (`[MODIFY]`)

**Agents:** [`website/docs/agents/overview.md`](../../../website/docs/agents/overview.md)

- [ ] Insert **phase-grouped Focus blocks** above tables (source: README § Agents lines 287–366):
 - 📋 Product ideation — Business Analyst
 - 🛠 Development — Context Engineer, Architect, Engineering Manager, Software Engineer, Prompt Engineer, DevOps Engineer
 - ✅ Quality — Code Reviewer, UI Reviewer, E2E Engineer
 - ⚙️ Cursor customization — engineer + orchestrator
- [ ] Each block: **Focus** (bold), 2–4 bullets, **Invoke** line where applicable
- [ ] Rename existing tables section to **Reference tables** — table content unchanged
- [ ] Keep handoff diagram

**MCP:** [`website/docs/getting-started/mcp-setup.md`](../../../website/docs/getting-started/mcp-setup.md)

- [ ] Add **executive summary** at top (before “This repository”):
 - Option 1 User profile / Option 2 Workspace (short)
 - Build `eversis-collections` one-liner + link to [MCP package README](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/mcp/eversis-collections-mcp/README.md)
 - “What each MCP is used for” bullet list (emoji, match README)
 - Sequential Thinking one paragraph + link to [sequential-thinking](../integrations/sequential-thinking)
 - **Verify** checklist (open Agent, confirm `eversis_skills_list`)
- [ ] Keep existing detailed sections below (no deletion)

**Installation:** [`website/docs/getting-started/installation.md`](../../../website/docs/getting-started/installation.md)

- [ ] Add **Keeping consumer projects aligned** table from README (install mode → how to refresh after `git pull`)
- [ ] Link to `start-here` at top

---

### Phase 6 — Drift prevention, README links, validation (`[CREATE]` / `[MODIFY]` / `[REUSE]`)

**Parity checklist (A)** — document in plan Changelog when done; optional one line in README § Related documentation → `start-here`.

**Optional A+ — grep gate:** [`scripts/check-readme-site-parity.mjs`](../../../scripts/check-readme-site-parity.mjs) *(new)*

- [ ] Fail if scoped paths contain forbidden **current-guidance** strings:
 - `Product Ideation` (phase name)
 - `not built-in` + `slash command`
 - `/eversis-`
- [ ] Scope: `website/docs/`, `website/src/components/`, `README.md` (exclude `changelog.md` history)
- [ ] Wire into `website/package.json` `prebuild` **or** manual script only — confirm at implementation

**README cross-links:**

- [ ] Verify existing README → site links still valid
- [ ] Add **`start-here.md`** to README Quick start or Related documentation table (one line)

**Validation (`[REUSE]`):**

- [ ] `cd website && npm run build` (sync-docs-assets + validate-cursor-links)
- [ ] `node scripts/validate-cursor-markdown-links.mjs --context=source --paths=README.md` if README touched
- [ ] Manual smoke: `/` homepage → Get started → start-here → workflow overview → agents overview
- [ ] Grep: no `Product Ideation` in `website/src/components/` or live docs (exclude changelog history)

**CHANGELOG:**

- [ ] Entry: website readability + Confluence docs theme (split-theme)

---

### Phase 7 — Confluence-like docs chrome (`[MODIFY]` / optional `[CREATE]`)

**Scope:** Option **A** — Tier 1 (CSS + config) + light Tier 2 (categories, hub footers already in Phases 2–4). **No** homepage Confluence rebrand. **No** DocSidebar swizzle unless time permits (optional T21).

#### 7a — Docusaurus config

**File:** [`website/docusaurus.config.ts`](../../../website/docusaurus.config.ts)

- [ ] `themeConfig.colorMode.defaultMode: 'light'`
- [ ] `themeConfig.colorMode.disableSwitch: false` — allow user toggle; docs default light
- [ ] Under `presets[classic].docs`:
 - `breadcrumbs: true`
 - `tableOfContents: { position: 'right', minHeadingLevel: 2, maxHeadingLevel: 4 }`
- [ ] Keep homepage dark: ensure marketing page CSS does not inherit docs-only tokens (scoped under `.docs-wrapper`)

#### 7b — Confluence palette (docs only)

**File:** [`website/src/css/custom.css`](../../../website/src/css/custom.css)

Add section **“Confluence-like docs chrome”** — variables scoped to `.docs-wrapper` and `[class*='docPage']`:

| Token | Value |
| ----- | ----- |
| Primary / links | `#0C66E4` |
| Page background | `#F4F5F7` |
| Content surface | `#FFFFFF` |
| Body text | `#172B4D` |
| Muted text | `#6B778C` |
| Borders | `#DFE1E6` |

- [ ] Doc article max-width readable (~900px content column feel)
- [ ] **Tables** (`.theme-doc-markdown table`): header bg `#F4F5F7`, borders `#DFE1E6`, full width
- [ ] **Panel admonitions** (`.alert`, `.alert--info`, `--tip`, `--warning`, `--danger`):
 - Soft background fill (not heavy purple)
 - `border-left: 4px solid` per type (info=blue, warning=amber, tip=teal/grey-green)
 - Title font-weight 600
- [ ] Retune **`alert--brand`** on docs pages only: either map to info-blue or keep purple as “Eversis” exception — **prefer info styling** for `:::brand` in docs hub pages
- [ ] **Sidebar** (`.theme-doc-sidebar`): active link — blue text + left border or bg tint; slightly denser line-height; category label uppercase/muted
- [ ] **TOC** right rail: smaller type, muted links, active heading blue
- [ ] **Breadcrumbs**: muted path, current page darker

#### 7c — Light navbar on documentation routes

**File:** [`website/src/css/custom.css`](../../../website/src/css/custom.css)

- [ ] When `html.docs-doc-page` (or Docusaurus doc body class): navbar white bg, dark link text, dark search field — **homepage `/` keeps dark navbar**
- [ ] Test: `/` dark nav → click Docs → light nav on doc pages

#### 7d — Category folders (Tier 2 light)

**Files:** `website/docs/*/_category_.json`

- [ ] `getting-started`, `workflow`, `agents`, `integrations`, `skills`: `"collapsible": true` where missing
- [ ] Consistent `label` strings (match sidebar reader expectations)

#### 7e — Optional sidebar swizzle (`[CREATE]` — defer if blocked)

- [ ] Only if Tier 1 insufficient: `npm run swizzle @docusaurus/theme-classic DocSidebar` — Confluence chevron + indent (estimate +0.5–1 day)
- [ ] Skip if CSS-only sidebar active state is acceptable

#### 7f — Validation

- [ ] Visual check: `start-here`, `workflow/overview`, `agents/overview` on desktop — breadcrumbs, right TOC, panels, tables
- [ ] Visual check: homepage `/` still dark/purple — no regression
- [ ] `npm run build` passes

---

## Task checklist

| ID | Type | Task | Phase | Status |
| -- | ---- | ---- | ----- | ------ |
| T1 | `[MODIFY]` | Navbar “Get started” in `docusaurus.config.ts` | 1 | ⬜ |
| T2 | `[CREATE]` | `getting-started/start-here.md` + hub footer | 2 | ⬜ |
| T3 | `[MODIFY]` | `intro.md` restructure + phase matrix + hub footer | 2 | ⬜ |
| T4 | `[MODIFY]` | `prerequisites.md` — Node ≥ 18 | 2 | ⬜ |
| T5 | `[MODIFY]` | Homepage hero + CTAs | 3 | ⬜ |
| T6 | `[MODIFY]` | Homepage features, quick wins, workflow showcase, SDLC diagram | 3 | ⬜ |
| T7 | `[MODIFY]` | `GettingStartedSection` — 6 steps + CTA | 3 | ⬜ |
| T8 | `[MODIFY]` | `workflow/overview.md` — short + variants + admonitions + hub footer | 4 | ⬜ |
| T9 | `[MODIFY]` | Terminology sweep (use-cases, for-ctos, skills overview, flow pages) | 4 | ⬜ |
| T10 | `[MODIFY]` | `agents/overview.md` — Focus blocks above tables | 5 | ⬜ |
| T11 | `[MODIFY]` | `mcp-setup.md` — executive summary | 5 | ⬜ |
| T12 | `[MODIFY]` | `installation.md` — consumer refresh table | 5 | ⬜ |
| T13 | `[MODIFY]` | README link to `start-here` | 6 | ⬜ |
| T14 | `[CREATE]` | Optional `check-readme-site-parity.mjs` | 6 | ⬜ |
| T15 | `[REUSE]` | `npm run build` + link validation + smoke read-through | 6 | ⬜ |
| T16 | `[MODIFY]` | `CHANGELOG.md` entry | 6 | ⬜ |
| T17 | `[MODIFY]` | `docusaurus.config.ts` — light default, breadcrumbs, TOC | 7 | ⬜ |
| T18 | `[MODIFY]` | `custom.css` — Confluence docs palette, panels, tables, sidebar, TOC | 7 | ⬜ |
| T19 | `[MODIFY]` | `custom.css` — light navbar on `docs-doc-page` only | 7 | ⬜ |
| T20 | `[MODIFY]` | `_category_.json` collapsible on doc folders | 7 | ⬜ |
| T21 | `[CREATE]` | Optional DocSidebar swizzle | 7 | ⬜ |
| T22 | `[REUSE]` | Phase 7 visual QA + `npm run build` | 7 | ⬜ |

**Suggested implementation order:** T1 → T2–T4 → T5–T7 → T8–T9 → T10–T12 → T17–T20 → T18–T19 → T13–T16 → T22 (T21 only if needed).

---

## README ↔ site parity checklist (A)

Use when changing **messaging** (not typo fixes in one file only):

| README section | Update site page(s) |
| -------------- | ------------------- |
| What this repository provides | `intro.md`, homepage `HomepageFeatures` |
| Prerequisites | `prerequisites.md` |
| Supported workflows (summary) | `workflow/overview.md`; depth on `workflow/*-flow.md` |
| Quick start | `start-here.md`, `GettingStartedSection`, `installation.md` |
| Public prompts at a glance | `prompts/overview.md` (synced), `intro.md` / quick-wins if table rows change |
| Agents | `agents/overview.md` Focus blocks |
| MCP Server Configuration | `mcp-setup.md`, optionally `integrations/overview.md` summary |
| Using in another repository | `installation.md` |
| Framework customization | `skills/creating-*.md`, agents customization pages |
| Contributing | changelog page, validation commands |

**Theme parity:** Confluence docs styling changes only `custom.css` + config — no README parity row unless doc **content** changes.

---

## Risks

| Risk | Mitigation |
| ---- | ---------- |
| Homepage + README duplicate quick start | `start-here` is canonical ordered path |
| Split-theme navbar flash wrong colors | Scope light navbar to `docs-doc-page`; test `/` vs `/docs/intro` |
| Purple `:::brand` clashes with Confluence panels | Restyle `alert--brand` under `.docs-wrapper` or use `:::info` on hub pages |
| `disableSwitch: false` surprises dark-preference users | Docs still readable; homepage unchanged |
| DocSidebar swizzle upgrade pain | T21 optional; CSS-only sidebar first |
| Agent Focus blocks drift from README | `agents/overview.md` is SSOT for site |
| A+ script false positives | Scope paths; exclude changelog history |

---

## Definition of done

### Readability (Phases 1–6)

1. [ ] Homepage, navbar, and docs use **Ideate → Implement → Review** consistently (no “Product Ideation” in live UI/docs components)
2. [ ] **`/docs/getting-started/start-here`** linked from navbar, homepage CTAs, and `intro.md`
3. [ ] `workflow/overview.md` short; variant depth on child pages via admonitions + hub footer
4. [ ] `agents/overview.md` has Focus blocks above reference tables
5. [ ] `mcp-setup.md` executive summary; `installation.md` consumer refresh table
6. [ ] `@` and `/eversis-*` documented consistently
7. [ ] README links to `start-here` where appropriate

### Confluence docs chrome (Phase 7)

8. [ ] `/docs/**` uses light Confluence-like palette (blue links, grey shell, white content)
9. [ ] Breadcrumbs and right-hand TOC enabled on doc pages
10. [ ] Panel admonitions and tables match Confluence-style (soft fill, left border, table headers)
11. [ ] Homepage `/` retains purple/dark marketing; doc routes use light navbar
12. [ ] Hub pages (`start-here`, `intro`, `workflow/overview`) include child-page link footers

### Quality

13. [ ] `cd website && npm run build` passes
14. [ ] CHANGELOG updated
15. [ ] Human approved research + plan

---

## Changelog

| Date | Change |
| ---- | ------ |
| 2026-06-07 | Initial plan from approved research; A + D drift policy; optional A+ grep gate in T14 |
| 2026-06-07 | Added Phase 7 — Confluence docs chrome (Option A, split-theme); tasks T17–T22; hub footers in Phases 2–4; human decision #7 |
