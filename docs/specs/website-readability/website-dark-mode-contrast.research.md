# Research: Dark mode low contrast on docs site

**Task:** Fix dark mode readability — background `#111116` with Confluence light-theme text (`#172b4d`, `#6b778c`); navbar stays `#ffffff` on doc routes while dark mode is active.

**Parent:** [`website-readability`](./website-readability.plan.md) Phase 7 (Confluence docs chrome, split-theme).

**Status:** Approved — human decisions recorded; see [`website-dark-mode-contrast.plan.md`](./website-dark-mode-contrast.plan.md).

---

## Problem statement

After Phase 7, users who enable **dark mode** (toggle or `prefers-color-scheme: dark`) see **unreadable docs**:

| Symptom | Reported values | Expected (light docs) | Expected (true dark) |
| ------- | --------------- | --------------------- | -------------------- |
| Page background | `#111116` | `#F4F5F7` / `#FFFFFF` | `#111116` or Confluence dark `#1D2125` |
| Body text | `#172B4D` | `#172B4D` on light bg | `#EDF1F4` / `#B6C2CF` on dark bg |
| Muted text | `#6B778C` | `#6B778C` on light bg | lighter grey on dark bg |
| Navbar (docs routes) | `#FFFFFF` | `#FFFFFF` (Option A) | `#2C2F30` or dark Confluence header |

**Result:** Dark background + dark text → very low contrast (WCAG failure).

Navbar issue: on doc pages, navbar is **forced white** via `html.docs-doc-page .navbar { background: #ffffff !important }` **regardless of** `data-theme` — so in dark mode the chrome is a **light navbar + dark content shell**, another inconsistent hybrid.

---

## Root cause analysis

### 1. Conflicting design decisions (Phase 7)

| Decision | Config / CSS | Effect |
| -------- | ------------ | ------ |
| **Option A — docs always light** | `.docs-wrapper` Confluence tokens (light text, light bg vars) | Docs should look light even when user prefers dark |
| **Enable color mode toggle** | `docusaurus.config.ts`: `disableSwitch: false`, `respectPrefersColorScheme: true` | `html[data-theme='dark']` activates global dark Infima palette |
| **Homepage always dark** | `main.homePage { --bg: #111116; ... }` | Marketing `/` stays dark independently |

These three interact badly: **global dark theme wins on backgrounds**; **scoped light theme wins on text variables** — but not consistently on every surface.

### 2. CSS evidence ([`website/src/css/custom.css`](../../../website/src/css/custom.css))

**Global dark mode** (applies to entire site when toggle on):

```css
[data-theme='dark'] {
  --ifm-background-color: #111116;
  --ifm-background-surface-color: #1A1A20;
  --text: #EDF1F4;
  /* ... */
}
```

**Docs Confluence block** (intended to keep docs light):

```css
.docs-wrapper {
  --ifm-font-color-base: #172b4d;
  --ifm-background-color: #f4f5f7;
  /* ... */
}

[data-theme='dark'] .docs-wrapper {
  --ifm-background-color: #f4f5f7;   /* tries to force light */
  --ifm-font-color-base: #172b4d;    /* forces LIGHT text colors */
  /* ... */
}
```

**Why background still shows `#111116`:**

- Docusaurus paints `body` / `main` / doc layout containers using **inherited** `html[data-theme='dark']` variables.
- `.docs-wrapper` variable overrides apply to the wrapper subtree but **not all doc chrome** (sidebar, TOC, breadcrumbs, article padding areas) may read the same cascade path.
- Hard-coded colors on sidebar/TOC/breadcrumbs (e.g. `color: #6b778c` on `.table-of-contents__link`) **ignore** `--ifm-font-color-*` and stay light-theme greys on dark bg.
- No `background-color` **declaration** on `.docs-wrapper` / `main` — only CSS variables; Infima may resolve background from parent `html` before variables propagate.

**Why text shows `#172B4D` / `#6B778C`:**

- Explicit Confluence palette on `.docs-wrapper` and hard-coded hex on TOC, breadcrumbs, menu category labels, tables — all **light-mode colors**.
- Global `[data-theme='dark']` sets `--text: #EDF1F4` for homepage tokens but **does not override** docs-specific `--ifm-font-color-base` inside `.docs-wrapper`.

### 3. Navbar forced light on all doc routes

```css
html.docs-doc-page .navbar {
  background: #ffffff !important;
  /* dark text links #42526e */
}
```

- No `[data-theme='dark']` qualifier → navbar **always white** on `/docs/**`.
- If user expects dark mode globally, navbar ignores it on docs (by design for Option A) but **content area may still go dark** → worst of both worlds.

### 4. Homepage / changelog

- **`main.homePage`** sets dark bg + light text — homepage dark mode should work if user toggles dark (inherits global dark + homePage tokens).
- **`/changelog`** is a custom page, not `docs-doc-page` — may get global dark bg without Confluence text overrides → verify separately.

---

## Affected surfaces (inventory)

| Surface | Light mode OK? | Dark mode broken? | Mechanism |
| ------- | -------------- | ----------------- | --------- |
| `/docs/**` article body | ✅ | ✅ contrast | Mixed vars + hard-coded Confluence colors |
| Doc sidebar | ✅ | ✅ | `menu__link` colors not theme-aware |
| TOC right rail | ✅ | ✅ | `#6b778c` hard-coded |
| Breadcrumbs | ✅ | ✅ | `#6b778c` / `#172b4d` hard-coded |
| Panel admonitions | ✅ | ⚠️ | Light fills (`#deebff`) on dark bg |
| Tables | ✅ | ⚠️ | `th { background: #f4f5f7 }` on dark bg |
| Navbar on docs | ✅ (Option A) | ⚠️ white bar + dark content | Forced `!important` |
| Homepage `/` | ✅ (forced dark) | ? | `main.homePage` override |
| Footer | ✅ | ? | Separate light footer styles |

---

## Fix strategies (options)

### Option A — Enforce “docs always light” (strict split-theme)

**Aligns with original Phase 7 decision.** Dark mode toggle does **not** affect `/docs/**` appearance.

| Approach | Detail |
| -------- | ------ |
| **A1. CSS hard lock** | `html.docs-doc-page .docs-wrapper, html.docs-doc-page main` → explicit `background-color: #f4f5f7` / `#fff` + light text; reset **all** hard-coded TOC/sidebar/breadcrumb colors under `html.docs-doc-page` only |
| **A2. Neutralize dark on docs** | `html.docs-doc-page[data-theme='dark']` → re-apply full light token set at `html` level for doc subtree (mirror `:root` light vars) |
| **A3. Hide toggle on docs** | Swizzle `ColorModeToggle` or custom navbar — show toggle only on homepage; docs always render as light |
| **A4. Disable global dark** | Revert `disableSwitch: true`, `defaultMode: 'light'` — homepage dark via `main.homePage` only (pre-Phase-7 behavior) |

**Pros:** Confluence look preserved; minimal design work.  
**Cons:** No dark docs for users who want it; toggle feels broken on docs if not hidden.

**Recommendation if keeping Option A:** **A4 + A1** — disable site-wide dark toggle (homepage stays dark via CSS); docs always light; remove misleading `respectPrefersColorScheme` for docs.

---

### Option B — Real dark mode for docs (Confluence dark)

**Honor the color mode toggle** with a proper dark docs palette.

| Token | Light (current) | Dark (proposed) |
| ----- | --------------- | --------------- |
| Background | `#F4F5F7` | `#1D2125` (Atlassian dark surface) |
| Content surface | `#FFFFFF` | `#22272B` |
| Text | `#172B4D` | `#B6C2CF` |
| Muted | `#6B778C` | `#8C9BAB` |
| Primary link | `#0C66E4` | `#579DFF` |
| Border | `#DFE1E6` | `#A6C5E229` or `#38414A` |
| Navbar (docs) | `#FFFFFF` | `#1D2125` or `#22272B` |

Implementation:

- Replace `[data-theme='dark'] .docs-wrapper { ... light colors ... }` with **dark Confluence tokens**.
- Scope all hard-coded hex (TOC, breadcrumbs, sidebar, tables, panels) under `[data-theme='dark'] .docs-wrapper` overrides.
- Change navbar rule to:
  - `html.docs-doc-page[data-theme='light'] .navbar` → white
  - `html.docs-doc-page[data-theme='dark'] .navbar` → dark header (match `#2C2F30` or Confluence dark)

**Pros:** Toggle works; accessible dark mode.  
**Cons:** ~1–2h CSS pass; must test admonitions, tables, code blocks, search.

---

### Option C — Hybrid (homepage dark only, docs light only, no toggle)

Simplest operational fix:

```ts
// docusaurus.config.ts
colorMode: {
  defaultMode: 'light',
  disableSwitch: true,
  respectPrefersColorScheme: false,
}
```

```css
/* homepage only */
main.homePage { /* dark tokens — already exists */ }

/* docs always light — remove [data-theme='dark'] .docs-wrapper light-on-light block */
html.docs-doc-page .docs-wrapper { /* light Confluence only */ }
```

**Pros:** No contrast bug; matches “split-theme” intent; smallest diff.  
**Cons:** Users cannot choose dark docs or dark homepage via toggle.

---

## Recommendation

| Priority | Action |
| -------- | ------ |
| **Immediate (hotfix)** | Pick **C** or **B** — do **not** ship current state (broken hybrid). |
| **If product wants Confluence-light docs only** | **Option C** — disable toggle, docs always light, homepage CSS-dark. ~30 min. |
| **If product wants working dark mode** | **Option B** — full dark Confluence token set for `[data-theme='dark'] .docs-wrapper` + theme-aware navbar. ~2–4h including visual QA. |

**Do not** keep current CSS: it explicitly sets light text colors under `[data-theme='dark'] .docs-wrapper` while global dark sets `#111116` background — that is the reported bug.

---

## Acceptance criteria (fix phase)

1. [ ] **Light mode** (`data-theme='light'`): docs unchanged from current Confluence look (regression-free).
2. [ ] **Dark mode** (if toggle enabled): body text contrast ≥ WCAG AA (4.5:1 normal text) on all doc pages — spot-check intro, workflow overview, agents overview.
3. [ ] **Navbar:** consistent with content area (both light or both dark on docs routes).
4. [ ] **Homepage `/`:** remains dark marketing shell regardless of fix path.
5. [ ] `cd website && npm run build` passes.

---

## Human decisions (resolved 2026-06-07)

| # | Question | Decision |
| - | -------- | -------- |
| 1 | Keep color mode toggle? | **Yes** — Option B (real dark docs palette) |
| 2 | Docs in dark mode | **Required** |
| 3 | Navbar on docs in dark mode | **Dark** (match content chrome) |
| 4 | Scope | **CSS-only** — `custom.css` + optional `docusaurus.config.ts` |

---

## References

- Bug introduced: [`website/src/css/custom.css`](../../../website/src/css/custom.css) lines 545–714 (Phase 7)
- Config: [`website/docusaurus.config.ts`](../../../website/docusaurus.config.ts) `colorMode`
- Parent plan: [`website-readability.plan.md`](./website-readability.plan.md) Phase 7
- Split-theme research: [`website-readability.research.md`](./website-readability.research.md) § Confluence-like appearance
