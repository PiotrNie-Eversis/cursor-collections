# Plan: Fix docs dark mode contrast (Option B)

**Research:** [`website-dark-mode-contrast.research.md`](./website-dark-mode-contrast.research.md)  
**Parent:** [`website-readability.plan.md`](./website-readability.plan.md) Phase 7  
**Status:** Complete (2026-06-07).

---

## Goal

Fix the Phase 7 regression where **dark mode** on `/docs/**` shows **dark background** (`#111116`) with **light-theme text** (`#172B4D`, `#6B778C`) and a **forced white navbar**. Deliver a **working Confluence-inspired dark docs theme** while preserving the current **light docs** look and **dark marketing homepage**.

**Non-goals:** React swizzles (ColorModeToggle, DocSidebar, navbar); new design system; changing doc content; homepage light mode redesign.

---

## Human decisions (approved)

| # | Decision |
| - | -------- |
| 1 | **Keep color mode toggle** — Option B (real dark docs palette) |
| 2 | **Dark docs required** — full theme, not “docs always light” |
| 3 | **Navbar on docs in dark mode** — **dark** (match content chrome) |
| 4 | **Scope** — CSS-only in [`custom.css`](../../../website/src/css/custom.css) + optional [`docusaurus.config.ts`](../../../website/docusaurus.config.ts) |

---

## Design tokens

### Light (unchanged — regression baseline)

Scoped under `html.docs-doc-page .docs-wrapper` / existing `.docs-wrapper` block.

| Token | Value |
| ----- | ----- |
| Background | `#F4F5F7` |
| Surface | `#FFFFFF` |
| Text | `#172B4D` |
| Muted | `#6B778C` |
| Primary | `#0C66E4` |
| Border | `#DFE1E6` |
| Navbar (docs) | `#FFFFFF` |

### Dark (new — Confluence / Atlassian-inspired)

Scoped under `html.docs-doc-page[data-theme='dark']` (and `[data-theme='dark'] .docs-wrapper`).

| Token | Value | Notes |
| ----- | ----- | ----- |
| Background | `#1D2125` | Atlassian dark surface |
| Surface (article) | `#22272B` | Elevated panel |
| Text | `#B6C2CF` | Body |
| Muted | `#8C9BAB` | TOC, breadcrumbs, labels |
| Heading | `#DEE4EA` | Slightly brighter than body |
| Primary / links | `#579DFF` | Active links, sidebar active |
| Border | `#38414A` | Sidebar, tables, hr |
| Navbar (docs) | `#1D2125` | Same family as shell; border `#38414A` |
| Search field | `#22272B` | Input on dark navbar |
| Admonition fills | Darkened variants | See Phase 2 table |

**Homepage `/`:** unchanged — `main.homePage` keeps dark marketing tokens regardless of toggle.

---

## Implementation phases

### Phase 1 — Restructure Confluence CSS blocks (`[MODIFY]`)

**File:** [`website/src/css/custom.css`](../../../website/src/css/custom.css)

- [ ] **Delete** the broken block `[data-theme='dark'] .docs-wrapper { … light colors … }` (lines ~576–582).
- [ ] **Scope light rules** under `html.docs-doc-page[data-theme='light']` where hard-coded hex is used (navbar, TOC, breadcrumbs, sidebar labels, tables, panels) — avoids leaking light colors to dark homepage/changelog when not on docs.
- [ ] **Add section comment** structure:
  ```text
  /* Confluence docs — light */
  html.docs-doc-page[data-theme='light'] …
  /* Confluence docs — dark */
  html.docs-doc-page[data-theme='dark'] …
  ```
- [ ] Set explicit `background-color` on `html.docs-doc-page .docs-wrapper` and doc `main` for **both** themes (not variables alone).

---

### Phase 2 — Dark docs token block (`[MODIFY]`)

**File:** [`website/src/css/custom.css`](../../../website/src/css/custom.css)

Under `html.docs-doc-page[data-theme='dark'] .docs-wrapper` (and descendants):

- [ ] CSS variables — full `--ifm-*` set per dark token table above.
- [ ] **Sidebar** — `border-color: #38414a`; category labels `#8c9bab`; active link `#579dff`.
- [ ] **TOC** — links `#8c9bab`, active `#579dff`.
- [ ] **Breadcrumbs** — muted `#8c9bab`, current `#dee4ea`.
- [ ] **Tables** — `th { background: #2c333a }`, borders `#38414a`, cell text inherits.
- [ ] **Admonitions** (dark panel fills):

| Type | Background | Border | Text |
| ---- | ---------- | ------ | ---- |
| info | `#1c2b41` | `#579dff` | `#dee4ea` |
| tip | `#1c3329` | `#4bce97` | `#dee4ea` |
| warning | `#332e1b` | `#f5cd47` | `#dee4ea` |
| danger | `#3d1f1f` | `#f87168` | `#dee4ea` |
| brand (docs) | `#2b2a3d` | `#8f7ee7` | `#dee4ea` |

- [ ] **Code blocks** — rely on Infima `prism` dark theme (verify inline `code` contrast); add `--docusaurus-highlighted-code-line-bg` override if needed under dark docs scope.
- [ ] **Pagination** / doc footer — spot-check `theme-doc-paginator` link colors.

---

### Phase 3 — Theme-aware docs navbar (`[MODIFY]`)

**File:** [`website/src/css/custom.css`](../../../website/src/css/custom.css)

Replace unqualified `html.docs-doc-page .navbar` rules with **split selectors**:

**Light** — keep current white navbar (`html.docs-doc-page[data-theme='light']`):

- [ ] Navbar bg `#ffffff`, border `#dfe1e6`, links `#42526e`, hover/active `#0c66e4`, search field light.

**Dark** — new (`html.docs-doc-page[data-theme='dark']`):

- [ ] Navbar bg `#1d2125 !important`, border `#38414a`
- [ ] Title + links `#b6c2cf`, hover/active `#579dff`, hover bg `rgba(87, 157, 255, 0.08)`
- [ ] CTO link `#a78bfa` (readable on dark)
- [ ] Search input bg `#22272b`, border `#38414a`, text `#dee4ea`
- [ ] Dropdown menu bg `#22272b`, border `#38414a`, links `#b6c2cf`
- [ ] GitHub button — border `rgba(255,255,255,0.14)`, text `rgba(255,255,255,0.75)` (match global dark navbar pattern)

**Non-doc routes** (`/`, `/changelog`): existing global `.navbar` dark styles unchanged.

---

### Phase 4 — Config touch-up (optional) (`[MODIFY]`)

**File:** [`website/docusaurus.config.ts`](../../../website/docusaurus.config.ts)

- [ ] Confirm `colorMode.disableSwitch: false` and `respectPrefersColorScheme: true` remain (toggle kept).
- [ ] Optional: set `defaultMode: 'light'` explicitly (already set) — no change required unless QA prefers `dark`.
- [ ] **No** `customCss` path changes.

---

### Phase 5 — Validation (`[REUSE]`)

- [ ] `cd website && npm run build`
- [ ] Manual visual QA (light + dark) on:
  - `/docs/` (intro)
  - `/docs/getting-started/start-here`
  - `/docs/workflow/overview` (admonitions + diagram)
  - `/docs/agents/overview` (tables)
- [ ] Toggle dark/light on docs — navbar and content **both** switch; no white navbar on dark docs.
- [ ] Homepage `/` in **light** toggle — still dark via `main.homePage` (unchanged).
- [ ] Homepage `/` in **dark** toggle — still readable (existing global dark + homePage).
- [ ] Contrast spot-check: body text on `#1D2125` / `#22272B` ≥ WCAG AA (~4.5:1) for `#B6C2CF` on `#1D2125`.

**CHANGELOG:**

- [ ] One-line under 2026-06-07: fix docs dark mode contrast; theme-aware Confluence navbar.

**Research / plan artifacts:**

- [ ] Mark research open questions resolved; plan status → Complete after implementation.

---

## Task checklist

| ID | Type | Task | Phase | Status |
| -- | ---- | ---- | ----- | ------ |
| T1 | `[MODIFY]` | Remove broken `[data-theme='dark'] .docs-wrapper` light override | 1 | ✅ |
| T2 | `[MODIFY]` | Scope light Confluence rules to `html.docs-doc-page[data-theme='light']` | 1 | ✅ |
| T3 | `[MODIFY]` | Add explicit background-color on docs wrapper/main (light + dark) | 1 | ✅ |
| T4 | `[MODIFY]` | Dark docs CSS variable block | 2 | ✅ |
| T5 | `[MODIFY]` | Dark sidebar, TOC, breadcrumbs, tables | 2 | ✅ |
| T6 | `[MODIFY]` | Dark panel admonitions | 2 | ✅ |
| T7 | `[MODIFY]` | Split light/dark docs navbar rules | 3 | ✅ |
| T8 | `[MODIFY]` | Verify docusaurus.config.ts colorMode (optional) | 4 | ✅ |
| T9 | `[REUSE]` | `npm run build` + visual QA | 5 | ✅ |
| T10 | `[MODIFY]` | CHANGELOG entry | 5 | ✅ |

**Suggested order:** T1 → T2 → T4–T6 → T3 → T7 → T8 → T9 → T10.

---

## Risks

| Risk | Mitigation |
| ---- | ---------- |
| Light mode regression | Scope new dark rules only under `[data-theme='dark']`; keep light selectors explicit |
| `html.docs-doc-page` missing on some doc routes | Verify Docusaurus adds class on all `/docs/**`; fallback `[data-theme='dark'] .docs-wrapper` duplicate |
| SDLC diagram in markdown (React) | Diagram uses own CSS module — test on workflow overview in dark mode |
| Footer on docs pages | Light footer may clash in dark mode — add `html.docs-doc-page[data-theme='dark'] .footer` override if QA fails |
| Search plugin dropdown | Test local search UI in dark navbar |
| Duplicate `.alert--brand` rules | Docs dark brand panel scoped under `.docs-wrapper`; global purple brand for non-docs unchanged |

---

## Definition of done

1. [ ] Dark mode on `/docs/**`: readable text (`#B6C2CF`+ on `#1D2125` / `#22272B`), no `#172B4D` on dark bg
2. [ ] Light mode on `/docs/**`: unchanged Confluence light appearance
3. [ ] Docs navbar **dark** when `data-theme='dark'`, **white** when light
4. [ ] Color mode toggle works on docs pages
5. [ ] Homepage marketing shell unchanged
6. [ ] `npm run build` passes
7. [ ] CHANGELOG updated
8. [ ] Human approved plan

---

## Changelog

| Date | Change |
| ---- | ------ |
| 2026-06-07 | Initial plan — Option B; dark docs + dark docs navbar; CSS-only scope |
