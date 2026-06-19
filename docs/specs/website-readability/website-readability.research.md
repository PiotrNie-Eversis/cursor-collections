# Research: Improve `website/` readability after README rewrite

**Task:** After the root [`README.md`](../../../README.md) improvements (agents, MCP, supported workflows, phase matrix), research how to improve **readability and scan speed** of the Docusaurus docs site under [`website/`](../../../website/).

**Upstream work (complete 2026-06-07):**

- [`root-readme-rewrite`](../root-readme-rewrite/)
- [`readme-agents-descriptions`](../readme-agents-descriptions/)
- [`readme-mcp-section`](../readme-mcp-section/)
- [`readme-workflows-section`](../readme-workflows-section/)
- [`mcp-readme-rewrite`](../mcp-readme-rewrite/) (MCP package README)

**Status:** Approved — human decisions recorded (2026-06-07). Sync tooling recommendation documented; ready for `website-readability.plan.md`.

---

## Problem statement

The root README is now a **high-quality scan surface**: phase matrix, progressive disclosure, external benchmark-style agent blocks, expanded workflow flowcharts, and a cohesive MCP section. The **docs site** (`website/`) remains the authoritative deep dive for agents, workflows, skills, and integrations — but it **does not yet mirror** the README’s readability wins. New readers who land on GitHub first, then open the site, hit **terminology drift**, **split narratives**, and **denser tables** before they reach the same mental model.

### Observed pain points

| Issue | Evidence | Impact |
| ----- | -------- | ------ |
| **Terminology drift** | Homepage [`HomepageFeatures`](../../../website/src/components/HomepageFeatures/index.tsx) uses “Product Ideation, Development, and Quality”; [`QuickWins`](../../../website/src/components/QuickWins/index.tsx) uses the same; README uses **Ideate → Implement → Review** | Reader must mentally remap phases on every page |
| **Two entry surfaces** | Marketing homepage (`/`) vs docs intro (`/docs/`) — different structure, no shared “start here” path | No single 15-second onboarding story on the site |
| **Workflow depth gap** | README § Supported workflows has phase primers, full lifecycle flowcharts, UI loop explainer, variants table, workshop/E2E/BA examples; [`workflow/overview.md`](../../../website/docs/workflow/overview.md) is shorter and links out | Site overview feels **less helpful** than README for newcomers |
| **Agents scan pattern** | README: phase-grouped `Focus` blocks; [`agents/overview.md`](../../../website/docs/agents/overview.md): three wide tables (packaging + summary + MCP) | Tables are accurate but **harder to skim** than README agent section |
| **MCP narrative split** | README: one progressive MCP section (user vs workspace, build, per-server bullets, Sequential Thinking, verify); site splits across [`mcp-setup.md`](../../../website/docs/getting-started/mcp-setup.md) + [`integrations/overview.md`](../../../website/docs/integrations/overview.md) | Setup story requires **3+ clicks**; no README-equivalent “scan page” |
| **`@` vs `/` inconsistency** | [`WorkflowShowcase`](../../../website/src/components/WorkflowShowcase/index.tsx) caption: prompts are “not built-in `/` slash commands”; README documents **`/eversis-*` project commands** in `.cursor/commands/` | Contradicts current framework; confuses Cursor newcomers |
| **No README → site propagation** | Only **prompts** and **framework doc** sync automatically (`sync-prompts`, `sync-framework-doc` in [`website/package.json`](../../../website/package.json)); README content is hand-maintained | **Ongoing drift risk** after every README edit |
| **Dense docs landing** | [`intro.md`](../../../website/docs/intro.md) opens with a long single paragraph on rules/prompts/MCP/skills before value prop | High cognitive load before “what is this?” |
| **Sidebar is filesystem order** | [`sidebars.ts`](../../../website/sidebars.ts) autogenerates from folders | No curated “read in this order” path matching README progressive disclosure |
| **Consumer alignment buried** | README has visual “Keeping consumer projects aligned” table; [`installation.md`](../../../website/docs/getting-started/installation.md) has script detail but less scannable summary | Teams miss refresh workflow after `git pull` on framework |

### What works today (preserve)

- **Homepage visual design** — hero, SDLC diagram, feature cards, quick wins (strong marketing layer).
- **Synced prompt catalog** — `website/docs/prompts/` generated from `.cursor/prompts/`; link validation in `prebuild`.
- **Per-topic depth** — individual agent pages, workflow variants (`standard-flow`, `frontend-flow`, `workshop-flow`, `e2e-flow`, `business-manager-docs`), integration pages.
- **Framework reference** — `documentation/cursor-collection.md` synced to `/docs/framework`.
- **Admonitions and Mermaid** — Docusaurus supports `:::tip` / `:::warning` and diagrams (used in workflow overview).
- **Navbar IA** — Docs, Framework, Workflow, Components dropdown, Use Cases, For CTOs.

---

## Scope boundary

| In scope | Out of scope (unless explicitly approved later) |
| -------- | ----------------------------------------------- |
| **Readability / IA** improvements for `website/` (Markdown docs + homepage React sections) | Changing `.cursor/` rules, prompts, skills, or MCP server code |
| **Align terminology and scan patterns** with the new README | Duplicating entire README into the site (README stays GitHub entry) |
| **Reduce drift** between README and site (content strategy + targeted edits) | Auto-syncing README into Docusaurus (no sync script exists today) |
| **Propose phased plan** with acceptance checks | Implementing changes in this research turn |

**Rationale:** README = **GitHub scan surface**; website = **guided deep dive**. After the README rewrite, the site should feel like a **natural continuation**, not a parallel spec.

---

## Document ecosystem (roles after README rewrite)

| Surface | Role | Target relationship |
| ------- | ---- | ------------------- |
| **[`README.md`](../../../README.md)** | GitHub entry; workflows + quick start + MCP summary | **Scan surface** — links into site for depth |
| **`website/` homepage (`/`)** | Marketing + emotional buy-in + CTA | Mirror README **tagline and phase names**; link to curated docs path |
| **[`website/docs/getting-started/start-here.md`](../../../website/docs/getting-started/start-here.md)** *(new)* | Curated onboarding path | **Primary “Get started”** destination — ordered reading list; navbar + homepage CTA |
| **[`website/docs/intro.md`](../../../website/docs/intro.md)** | Docs landing (`/docs/`) | Value prop + phase matrix + benefits; links to `start-here.md` for setup path |
| **Workflow cluster** | `workflow/overview.md` + variant pages | **SSOT for lifecycle** — overview stays **short**; depth on variant pages |
| **Agents cluster** | `agents/overview.md` + role pages | **SSOT for roster** — README condensed blocks link here |
| **Getting started cluster** | `prerequisites`, `installation`, `mcp-setup`, `quick-wins` | **SSOT for setup** — README Quick start + MCP link here |
| **Integrations cluster** | `integrations/overview.md` + per-server pages | **SSOT for MCP detail** — README MCP section links here |
| **[`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md)** | Tool-level MCP reference | Linked from mcp-setup / integrations — not duplicated on homepage |

---

## Gap analysis: README section → website counterpart

### 1. What this repository provides (phase matrix)

| README (current) | Website | Gap |
| ---------------- | ------- | --- |
| Phase matrix: 📋 Ideate / 🛠 Implement / ✅ Quality / 📄 BA Docs / ⚙️ Customize — each with Rules, Prompts, Skills | `intro.md` § What It Provides: **counts table** (12 agents, 32 skills, …) | Site lists **inventory** but not **WHO/HOW/WHAT per phase** |
| `eversis-` prefix callout | Mentioned in intro paragraph, not a callout | Easy to miss |
| `/` commands note | `WorkflowShowcase` says prompts are **not** slash commands | **Contradicts** README |

**Recommendation:** Phase matrix on `intro.md`; curated path on new **`getting-started/start-here.md`**. Full homepage marketing rewrite aligns hero/copy with README; fix **`@` + `/` project commands** everywhere.

### 2. Supported workflows

| README (current) | Website | Gap |
| ---------------- | ------- | --- |
| Phase 1–3 primers with bullets | `workflow/overview.md` § The Phases — present but **shorter** | Site lacks README-level **gate naming** (Gate 1, 1.5, 2) on overview |
| Full lifecycle text flowcharts (standard + UI) | `standard-flow.md`, `frontend-flow.md` — **good detail** | Overview does not **embed or preview** flowcharts; reader must discover variant pages |
| UI verification loop (5 steps) | `frontend-flow.md` § How the Verification Loop Works | Not on **overview**; README reader expects it earlier |
| Workflow variants **table** | Overview lists bullet links only | Less scannable than README table |
| Workshop / E2E / BA examples with gate flowcharts | `workshop-flow.md`, `e2e-flow.md`, `business-manager-docs.md` | README examples are **richer** than overview teasers |
| Implement → Review table | Absent on site overview | README pattern worth copying to overview |

**Recommendation:** Keep `workflow/overview.md` **short** — phase primers, variants **table**, human-gates admonition, SDLC diagram. Use **`:::tip` / `:::info` expand admonitions** linking to `standard-flow`, `frontend-flow`, `workshop-flow`, `e2e-flow`, `business-manager-docs` for README-level flowcharts (do not duplicate ~150 lines on overview).

### 3. Agents

| README (current) | Website | Gap |
| ---------------- | ------- | --- |
| Phase-grouped `####` blocks with **Focus** + bullets + **Invoke** | `agents/overview.md` — three dense tables | Tables good for power users; **poor first scan** |
| Engineering Manager, customization orchestrator as first-class blocks | Present in tables | README prose is **more approachable** |
| Link to `website/docs/agents/` | Site **is** the deep dive | Individual role pages should **open with Focus** line matching README |

**Recommendation:** **Add** phase-grouped **Focus blocks above** existing tables (tables move to “Reference tables” — not removed). Optional: one-line Focus on individual agent pages in a later pass.

### 4. MCP server configuration

| README (current) | Website | Gap |
| ---------------- | ------- | --- |
| Option 1 User Profile / Option 2 Workspace | `mcp-setup.md` — similar structure | Mostly aligned |
| Build `eversis-collections` + bullet capabilities | Split across mcp-setup + integrations overview | Reader repeats build instructions in multiple pages |
| “What each MCP is used for” emoji list | integrations overview table + per-page detail | README list is **more scannable** than site tables |
| Sequential Thinking explainer | `integrations/sequential-thinking.md` | Not summarized on mcp-setup **landing** |
| Verify step | Partially in mcp-setup | README “open Agent, confirm tools” — add explicit verify checklist on site |

**Recommendation:** Add **`mcp-setup.md` executive summary** (mirror README subsections). Cross-link MCP package README. Consider **single “MCP quick reference”** admonition block reused on intro + mcp-setup.

### 5. Quick start / installation

| README (current) | Website | Gap |
| ---------------- | ------- | --- |
| 6-step Quick start (this repo) | `GettingStartedSection` — 4 steps; `installation.md` — longer | Homepage steps omit **rules** and **skills via MCP** |
| Consumer `CURSOR_COLLECTIONS_HOME` + refresh table | `installation.md` has script detail | README **alignment table** more scannable |
| Prerequisites (Cursor, Node ≥ 18) | `prerequisites.md` — Cursor + Git; Node only implied via MCP build | Add **Node for MCP build** explicitly |

**Recommendation:** Align homepage steps with README Quick start. Add README-style **consumer refresh table** to `installation.md`.

### 6. Public prompts at a glance

| README | Website | Gap |
| ------ | ------- | --- |
| Compact workflow table + link to full catalog | `prompts/overview.md` (synced) | Largely aligned — ensure intro/quick-wins tables **match** README rows |

---

## Homepage vs docs: dual-entry problem

```text
Reader path A: github.com → README (good scan) → "website/docs/..." link → intro.md (dense)
Reader path B: docs site / → Hero + Features (external benchmark terms) → /docs (intro)
```

**Approved unified story (site-wide):**

1. **Full homepage marketing rewrite** — hero, feature cards, quick wins, getting-started section, and CTAs aligned with README (tagline, phase names, Eversis/external benchmark lineage, human gates).
2. **Tagline:** “Ideate → Implement → Review” everywhere (replace “Product Ideation / Development / Quality”).
3. **Hero subcopy:** Mirror README centered hero — Cursor-native framework, full SDLC, human gates at each step.
4. **Homepage CTA:** Primary → **`/docs/getting-started/start-here`**; secondary → workflow overview or intro.
5. **Navbar:** Top-level **“Get started”** → `start-here.md` (and/or installation).
6. **WorkflowShowcase caption:** Fix `@` + `/eversis-*` project commands wording.

---

## Proposed information architecture (website)

Progressive disclosure for **docs** (not necessarily sidebar order — can use “Recommended reading” on intro):

```text
0. getting-started/start-here.md — curated path (navbar “Get started”, homepage CTA)
1. intro.md — value prop, phase matrix, eversis- callout, link to start-here
2. getting-started/prerequisites.md — Cursor, Node, Git
3. getting-started/installation.md — clone, consumer script, refresh table
4. getting-started/mcp-setup.md — MCP executive summary + links
5. workflow/overview.md — SHORT: primers, variants table, expand admonitions → variant pages
6. workflow/*-flow.md — deep playbooks + README-level flowcharts (existing / enhanced)
7. agents/overview.md — Focus blocks above reference tables
8. agents/*.md — role depth (existing)
9. prompts/overview.md — synced catalog (existing)
10. skills/overview.md — MCP consumption model (existing)
11. integrations/overview.md — server reference (existing)
```

**Sidebar:** `start-here.md` gets `sidebar_position: 0` (or label) under Getting started; navbar **Get started** points here regardless of autogenerated order.

---

## Content strategy: preventing future drift

Four approaches were evaluated. **Read this section before the implementation plan** — it defines what tooling (if any) the plan should include.

### Options compared

| Approach | Effort | Maintenance | Fit for this repo |
| -------- | ------ | ----------- | ----------------- |
| **A. Manual parity checklist** | Low | Human updates parity map when README or site changes | ✅ Immediate; no build changes |
| **B. Shared snippets (MDX partials)** | Medium | Edit one partial; included in multiple MDX pages | ⚠️ Requires MDX adoption for affected pages |
| **C. README sync markers + script** | High | README `<!-- sync:section-id -->` → generated `.md` in `website/docs/_generated/` | ⚠️ README becomes build input; GitHub render may show markers |
| **D. README summary + site SSOT policy** | Low | README stays scan-sized; depth only on site | ✅ Matches current split (README entry, site deep dive) |

### What duplicates today (drift risk)

| Content block | Copies today | After this initiative |
| ------------- | ------------ | --------------------- |
| Phase names (Ideate / Implement / Review) | README, homepage React, intro, workflow, quick wins | 4+ surfaces — **highest drift risk** |
| Quick start steps (6 steps) | README, `GettingStartedSection`, `installation.md`, `start-here.md` | 4 surfaces — **medium risk** |
| Agent Focus one-liners | README, `agents/overview.md` (new blocks) | 2 surfaces — **acceptable** if overview is SSOT |
| Workflow flowcharts | README (~80 lines), variant flow pages | README **should link** to site; reduce README flow length over time (policy D) |
| MCP setup summary | README, `mcp-setup.md`, `integrations/overview.md` | 3 surfaces — **medium risk** |
| Phase capability matrix | README, `intro.md` (planned) | 2 surfaces — **acceptable** with checklist |

### Recommendation (for plan — not yet committed to implementation)

**Phase 1 (this initiative): A + D**

1. **A — Parity checklist** — Add a short **“README ↔ site parity”** subsection to the plan (and optionally a row in `CHANGELOG.md` contributor notes): when you edit README § X, update site page Y. Use the parity map below as the checklist body.
2. **D — SSOT policy** — Document explicitly:
 - **Site owns depth** — workflow flowcharts, agent tables, MCP tables, installation refresh table.
 - **README owns GitHub scan** — summaries, one flowchart per variant max, links to site (`start-here`, `workflow/*`, `agents/overview`, `mcp-setup`).
 - **Homepage owns marketing** — aligned messaging but links out; no long duplicated prose.

**Defer B and C** for this initiative unless implementation reveals painful triple-copy (e.g. same 6-step quick start edited in four files in one PR).

### When to adopt B (snippet partials) — future trigger

Adopt **B** if **both** are true after this work ships:

- The same block (e.g. 6-step quick start, phase matrix, MCP bullet list) is maintained in **≥3 files** and drifts in a second PR within one release cycle.
- The block is **Markdown-friendly** (not React homepage copy).

**Implementation sketch (future):**

- Store canonical snippets in `docs/context/website-snippets/` or `website/src/snippets/` (plain `.md`).
- Convert affected docs pages to **MDX** (`intro.md` → `intro.mdx`) and `import QuickStart from '@site/...'`.
- Homepage React would still **duplicate** or import via a small JSON manifest — partials do not help React without a shared `content/manifest.json`.

**Cost:** MDX migration touches Docusaurus link validation (`validate-cursor-links` contexts); needs plan extension.

### When to adopt C (README sync script) — future trigger

Adopt **C** only if the team wants **README sections to be generated from site** (inverse SSOT) or **bidirectional sync** — unlikely given README is the GitHub face.

**Why defer:** Markers in README look noisy on GitHub; `sync-readme-sections.mjs` is a new script to test in CI; overlaps with existing `sync-prompts` / `sync-framework-doc` mental model but different source file.

**Lighter alternative:** A **lint-only** script `check-readme-site-parity.mjs` that greps for forbidden terms (“Product Ideation”, “not slash commands”) across README + `website/` — **no content sync**, just CI guard. Consider in plan Phase 5 as optional **A+** (checklist + grep gate).

### Parity map (README → website) — use as checklist (A)

| README section | Website SSOT page(s) |
| -------------- | -------------------- |
| What this repository provides | `intro.md` |
| Get started (curated path) | `getting-started/start-here.md` *(new)* |
| Prerequisites | `getting-started/prerequisites.md` |
| Supported workflows (summary) | `workflow/overview.md` + variant pages (depth) |
| Quick start | `start-here.md` + `installation.md` + homepage `GettingStartedSection` |
| Public prompts at a glance | `prompts/overview.md` |
| Agents | `agents/overview.md` |
| MCP Server Configuration | `getting-started/mcp-setup.md` + `integrations/overview.md` |
| Using in another repository | `getting-started/installation.md` |
| Framework customization | `skills/creating-*.md`, `agents/cursor-customization-*.md` |
| Contributing | `changelog` page + repo CONTRIBUTING norms |

---

## Phased implementation outline (for plan artifact)

Aligned with **human decisions** below. Plan should expand each phase with file-level tasks.

### Phase 1 — Homepage full marketing rewrite (high impact)

- [ ] **Hero** (`HeroSection`): README-aligned tagline — Cursor-native framework, **Ideate → Implement → Review**, human gates; Eversis + product-engineering README benchmark credit line; CTAs → `start-here` + GitHub.
- [ ] **Feature cards** (`HomepageFeatures`): phase names, descriptions, and card grouping match README § What this repository provides (not “Product Ideation / Development / Quality”).
- [ ] **Quick wins** (`QuickWins`): track labels → Ideate / Implement / Review.
- [ ] **Workflow showcase** (`WorkflowShowcase`): fix `@` + `/eversis-*` caption; optional subcopy aligned with README workflow intro.
- [ ] **Getting started** (`GettingStartedSection`): 6 steps parity with README Quick start; primary CTA → `/docs/getting-started/start-here`.
- [ ] **Social proof / other homepage sections**: grep and align terminology.
- [ ] **`docusaurus.config.ts`**: navbar top-level **“Get started”** → `/docs/getting-started/start-here`.

### Phase 2 — New curated path + docs landing

- [ ] **Create** `getting-started/start-here.md` — ordered checklist (prerequisites → installation → MCP → first prompt → workflow overview); links only, no encyclopedia.
- [ ] **`getting-started/_category_.json`**: position `start-here` first in sidebar.
- [ ] **Restructure** `intro.md`: short opener → phase matrix → benefits → prominent link to `start-here`.
- [ ] Add Node ≥ 18 to `prerequisites.md` (MCP build).

### Phase 3 — Workflow overview (short + expand links)

- [ ] Keep `workflow/overview.md` **concise**: phase primers, Implement→Review table, variants **table**, human-gates admonition, existing diagram.
- [ ] Add **`:::info` expand admonitions** per variant (standard, frontend/UI loop, workshop, E2E, BA docs) → child pages — **do not** paste README-length flowcharts on overview.

### Phase 4 — Agents and MCP scan surfaces

- [ ] **`agents/overview.md`**: add README-style **Focus blocks above** tables; rename table section to “Reference tables” (tables unchanged).
- [ ] **`mcp-setup.md`**: executive summary at top (mirror README MCP scan structure).
- [ ] **`installation.md`**: consumer **refresh alignment table** (from README).

### Phase 5 — Drift prevention + quality gate

- [ ] Document **A + D** parity checklist in plan changelog / contributor note (see Content strategy).
- [ ] Optional **A+**: `check-readme-site-parity.mjs` grep gate for forbidden terms (defer full script unless plan approves).
- [ ] `cd website && npm run build` (sync + link validation).
- [ ] Manual read-through: README → homepage → start-here → no terminology whiplash.
- [ ] Update `CHANGELOG.md`.

---

## Risks and constraints

| Risk | Mitigation |
| ---- | ---------- |
| Duplicating README creates two SSOTs | Site owns depth; README keeps summaries + links; use parity map |
| Full homepage rewrite increases React maintenance | Keep homepage copy **short**; link to `start-here` and docs SSOT; parity checklist covers homepage + README |
| Autogenerated sidebar order confuses “start here” | Add explicit “Next steps” / “Recommended reading” on `intro.md`, not only sidebar reorder |
| Wide agent tables relied on by power users | Move tables down, do not delete |
| MDX partials increase build complexity | Defer unless Phase 2–3 duplication is painful |
| `frontend-flow.md` uses `/eversis-*` only | Normalize to **`@` or `/`** phrasing site-wide (match README) |

---

## Acceptance criteria (research phase)

- [x] README improvements inventoried and mapped to website pages
- [x] Pain points documented with file references
- [x] Scope defined (website readability; no `.cursor/` code changes)
- [x] SSOT / drift strategy proposed
- [x] Phased implementation outline drafted
- [x] Human decisions recorded (all open questions resolved)
- [x] Sync tooling options explained with recommendation (A + D; defer B/C; optional A+ grep gate)
- [x] **Human approval** to proceed to `website-readability.plan.md`

---

## Confluence-like appearance (additional question)

**Question:** How can the docs site feel more like **Confluence** (familiar to teams using Atlassian MCP / Jira workflow)?

This is **visual and information architecture**, not content parity with a Confluence space. Treat it as a **follow-on** to the readability plan unless you explicitly widen scope.

### Current site vs Confluence cues

| Aspect | Cursor Collections site today | Typical Confluence (Cloud) |
| ------ | ----------------------------- | -------------------------- |
| **Default mode** | **Dark** forced (`colorMode.disableSwitch: true`) | **Light** default; optional dark |
| **Accent** | Purple `#6D28D9` (product marketing) | Atlassian **blue** `#0C66E4` / neutral links |
| **Navbar** | Dark bar `#2C2F30`, product-site feel | White/light header, space switcher, search prominent |
| **Docs canvas** | White/dark doc area inside grey shell | White page on **light grey** `#F4F5F7` surround |
| **Sidebar** | Docusaurus default tree (minimal custom CSS) | **Expandable page tree**, current page highlighted, nested hierarchy |
| **Page chrome** | Title + MD content | **Large title**, optional **byline/metadata**, **breadcrumbs**, **TOC** right rail |
| **Callouts** | Infima admonitions + custom `:::brand` (purple) | **Panel** macros — soft fill, **left accent bar**, neutral titles (Info / Note / Warning) |
| **Tables** | Default Markdown tables | Light borders, header row background, full width |
| **Homepage** | Dark marketing landing (`/`) | Confluence has **space home** — simpler, link cards, recent/child pages |
| **Typography** | Inter + JetBrains Mono | Atlassian Sans / system stack, 14–16px body, restrained headings |

**Gap:** The site optimizes for a **modern product landing** + dark chrome. Confluence optimizes for **long-form reading** and **hierarchical wiki navigation** in a **light, neutral** shell.

### What to copy (high value, low legal risk)

Copy **patterns**, not Atlassian assets or exact CSS:

1. **Docs-first light theme** for `/docs/*` — even if homepage stays darker for marketing (split theme).
2. **Blue link/accent** on documentation pages (Confluence familiarity for Jira users).
3. **Page layout:** breadcrumbs + optional right-hand **TOC** (`tableOfContents` in Docusaurus).
4. **Panel-style admonitions** — map `:::info`, `:::tip`, `:::warning` to Confluence-like panels (soft background, 4px left border, no heavy purple).
5. **Sidebar tree** — clearer active state, slightly denser line height, folder-style category labels (Getting Started, Workflow, …).
6. **“Child pages” / next steps** — at bottom of hub pages (`start-here`, `workflow/overview`, `intro`) — mirrors Confluence **child page list** macro.
7. **Tables** — light header row, `display: table` full width, subtle `#DFE1E6`-style borders.

### What not to copy

- Atlassian logos, Confluence iconography, or proprietary illustration sets.
- Exact Confluence Cloud DOM/CSS (fragile, license noise).
- Full **space / page comment / @mention** UI — out of scope for static Docusaurus.
- Forced light mode on homepage if brand wants dark marketing — use **split surfaces** instead.

### Recommended approach (tiered)

#### Tier 1 — Docs chrome only (~1–2 days, best ROI)

**Scope:** `website/src/css/custom.css` + `docusaurus.config.ts` — **no React swizzle** required.

| Change | Implementation |
| ------ | -------------- |
| Light docs default | `themeConfig.colorMode.defaultMode: 'light'`; enable switch **or** keep dark homepage via separate layout (see Tier 2) |
| Confluence palette (docs) | CSS variables under `.docs-wrapper`: `--ifm-color-primary: #0C66E4`, background `#F4F5F7`, surface `#FFFFFF`, text `#172B4D`, muted `#6B778C`, border `#DFE1E6` |
| Navbar on docs routes | Light navbar variant when `body` has docs class (Docusaurus adds `docs-doc-page`) — white bg, dark text |
| TOC | `docs: { toc: { position: 'right', minHeadingLevel: 2, maxHeadingLevel: 4 } }` in preset |
| Breadcrumbs | `docs: { breadcrumbs: true }` in preset |
| Panels | Override `.alert` styles: lighter fill, left border 4px, title weight 600 — align colors: info=blue, warning=amber, tip=green-grey |
| Tables | `.markdown table th { background: #F4F5F7 }`, border `#DFE1E6` |

**Homepage:** Can remain current dark marketing **or** simplify to a Confluence-style **space home** (link grid to `start-here`, workflow, agents) — see Tier 3.

#### Tier 2 — Navigation feel (~2–3 days)

| Change | Implementation |
| ------ | -------------- |
| Sidebar swizzle | `@theme/DocSidebar` — Confluence-like indent, chevrons, active page blue bar |
| Doc page header | `@theme/DocItem/Content` wrapper — larger `h1`, optional “Last updated” from `git` plugin (optional dependency) |
| Category labels | `_category_.json` `label` + `collapsible: true` per folder — matches Confluence folder nodes |
| Hub page footers | Markdown component or MDX `ChildPagesList` — auto-list siblings from sidebar metadata (custom small component) |

#### Tier 3 — Marketing / homepage Confluence mode (optional)

| Change | Implementation |
| ------ | -------------- |
| Replace dark feature grid | **Space home**: title, 2-line description, 3-column **link cards** (Get started, Workflow, Agents) — similar to Confluence space overview |
| Drop hero animation | Confluence homes are utilitarian; reduces maintenance |
| Single visual system | Entire site light + blue — closest to Confluence but **diverges from current purple brand** |

### Split-theme recommendation (pragmatic)

If you want **both** brand marketing and Confluence familiarity:

```text
/ (homepage) → keep purple/dark OR simplify to light “space home”
/docs/** → Confluence-like light chrome (Tier 1 CSS)
```

Docusaurus supports scoping CSS via `.docs-wrapper`, `[class*='docPage']`, and `data-theme` — implement Confluence tokens **only under docs**, not on `/`.

### Content patterns (no CSS — works with readability plan)

These align with the approved readability work and **feel** Confluence-like:

| Pattern | Where |
| ------- | ----- |
| Short hub page + **child links** | `start-here.md`, `workflow/overview.md` |
| **Panel** admonitions instead of long prose | Variant teasers on workflow overview |
| **Status / info** tables | Workflow variants, agent Focus blocks |
| Breadcrumb-friendly titles | Frontmatter `title` matches sidebar label |

Add to **current plan** as content-only items (no extra phase).

### Relationship to `website-readability` plan

| Item | Current plan | Confluence-like |
| ---- | ------------ | ----------------- |
| `start-here.md`, intro, workflow hubs | ✅ Phase 2–4 | ✅ Matches Confluence hub pages |
| Homepage full marketing rewrite | ✅ Phase 3 | ⚠️ **Tension** — dark marketing ≠ Confluence; resolve via Tier 3 vs split-theme |
| CSS / theme | ❌ Not in plan | **New phase** — recommend **`website-confluence-theme`** follow-on spec OR **Phase 7** if approved |
| Navbar “Get started” | ✅ Phase 1 | ✅ Same as Confluence “start here” entry |

### Confluence scope (resolved 2026-06-07)

**Decision:** **Option A — docs only** (split-theme). Implemented as **Phase 7** in [`website-readability.plan.md`](./website-readability.plan.md).

| Option | Status |
| ------ | ------ |
| **A** | ✅ **Selected** — Tier 1 CSS on `/docs/**`; homepage stays purple marketing |
| **B** | Declined — whole-site light + space-home |
| **C** | Declined — deferred as separate spec |

---

## Human decisions (resolved 2026-06-07)

| # | Question | Decision |
| - | -------- | -------- |
| 1 | Homepage scope | **Full marketing rewrite** — hero, features, quick wins, getting started, CTAs aligned with README (not terminology-only) |
| 2 | Agents overview | **Add Focus blocks above tables** — keep reference tables below |
| 3 | Workflow overview length | **Keep overview short** — use expand admonitions linking to variant pages for README-level depth |
| 4 | Curated onboarding doc | **Add `getting-started/start-here.md`** — in addition to streamlined `intro.md` |
| 5 | Sync tooling | **See [Content strategy](#content-strategy-preventing-future-drift)** — recommend **A + D** for this initiative; defer B/C; optional grep CI gate (A+). Confirm in plan. |
| 6 | Navbar | **Add top-level “Get started”** → `start-here.md` (and installation as needed) |
| 7 | Confluence-like UI | **Option A — docs only** (split-theme); Phase 7 in [plan](./website-readability.plan.md); homepage stays purple/dark |

---

## References

- Updated README: [`README.md`](../../../README.md)
- Benchmark (product-engineering README benchmark): README
- Prior README research: [`root-readme-rewrite.research.md`](../root-readme-rewrite/root-readme-rewrite.research.md), [`readme-workflows-section.research.md`](../readme-workflows-section/readme-workflows-section.research.md), [`readme-agents-descriptions.research.md`](../readme-agents-descriptions/readme-agents-descriptions.research.md), [`readme-mcp-section.research.md`](../readme-mcp-section/readme-mcp-section.research.md)
- Site entry: [`website/docs/intro.md`](../../../website/docs/intro.md), [`website/src/pages/index.tsx`](../../../website/src/pages/index.tsx)
- Build/sync: [`website/package.json`](../../../website/package.json)
