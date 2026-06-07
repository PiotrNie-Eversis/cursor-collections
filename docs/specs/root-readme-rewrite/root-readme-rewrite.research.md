# Research: Restructure root `README.md`

**Task:** Improve readability of the repository entry README using progressive disclosure and visual workflow mapping (inspired by [TheSoftwareHouse/copilot-collections](https://github.com/TheSoftwareHouse/copilot-collections)), incorporating stakeholder analysis from the product owner.

**Status:** Approved — implementation complete (2026-06-07).

---

## Problem statement

The current [`README.md`](../../../README.md) is the **first touchpoint** for anyone discovering Cursor Collections on GitHub. Stakeholder feedback: it is **difficult to read**, especially for people unfamiliar with the Cursor Collections concept. A reader who knows [copilot-collections](https://github.com/TheSoftwareHouse/copilot-collections) can grasp that project in seconds; the Eversis README does not achieve the same scan speed.

### Observed pain points (information architecture)

| Issue | Evidence in current README | Impact |
| ----- | -------------------------- | ------ |
| **Value buried under mechanics** | Lines 24–28: mandatory QA comment, MCP build, `.docx` engine, link validation — all inside “What this repository provides” before workflows | New reader sees implementation detail before understanding *why* the repo exists |
| **Repetition** | Skills + MCP + QA comment appear in § What provides, § Quick start, § Skills, § MCP servers, § Summary | Cognitive load; hard to know which section to read |
| **Weak visual anchors** | One lifecycle table (lines 14–20) without phase emojis or WHO/HOW/WHAT breakdown | Does not match copilot-collections scan pattern |
| **No workflow simulation** | § Example: standard flow (lines 76–92) is a minimal 8-line block | Misses opportunity to show human gates (`↳ 📖 Review`, `↳ ✅ Approve`) |
| **Installation too early / too long** | § Using this framework (lines 117–196) is ~80 lines mid-document | Consumer setup competes with “what is this?” for attention |
| **Inconsistent entry naming** | Mix of `@eversis-*`, file paths, `/` commands without a single “how to invoke” story up front | Cursor newcomers confuse `@` attachment vs `/` commands vs rules |
| **Dense prompt table without templates** | Lines 49–60: accurate but not scannable for non-experts | Copilot README uses Focus / How / Outcome per agent; we have no equivalent at README level |

### What works today (preserve)

- Centered hero with Eversis attribution and copilot-collections lineage (lines 1–7).
- Accurate lifecycle phases: Ideate → Implement → Review (+ BA Docs, customization).
- Real `eversis-*` naming (not legacy `/tsh-*`).
- Consumer bootstrap via `setup-cursor-local.sh` and vendor modes — **must stay**, relocated.
- Links to authoritative docs: `documentation/cursor-collection.md`, `AGENTS.md`, docs site.
- Contributing / link validation commands (lines 199–210).

---

## Scope boundary

| In scope | Out of scope (unless explicitly approved later) |
| -------- | ----------------------------------------------- |
| Rewrite **[`README.md`](../../../README.md)** (repository root) only | [`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md) — **already rewritten** ([`mcp-readme-rewrite`](../mcp-readme-rewrite/mcp-readme-rewrite.plan.md)) |
| Apply copilot-collections **principles** adapted to **Cursor** (rules, `@` prompts, `/` commands, MCP) | Copying copilot’s 700+ line agent encyclopedia into root README |
| Preserve **all factual content** — relocate, condense, link; do not silently drop setup steps, QA contract, or MCP build | Changing `.cursor/` layout, MCP code, or docs site pages |
| Add **MCP configuration** section (high-level; detail in MCP README + mcp-setup doc) | Rewriting [`documentation/cursor-collection.md`](../../../documentation/cursor-collection.md) or [`website/docs/getting-started/installation.md`](../../../website/docs/getting-started/installation.md) in this task |

**Rationale:** Root README = **3-second value prop + 15-second architecture + workflows**; deep how-to stays in `cursor-collection.md` and the docs site. MCP package README already owns tool-level reference.

---

## Document ecosystem (avoid duplication)

| Document | Role | Relationship after rewrite |
| -------- | ---- | -------------------------- |
| **`README.md`** (root) | GitHub entry; onboarding + workflow map | **Primary scan surface** — progressive disclosure |
| [`documentation/cursor-collection.md`](../../../documentation/cursor-collection.md) | Authoritative Cursor framework guide | Linked as “deep dive / reuse in any repo” |
| [`AGENTS.md`](../../../AGENTS.md) | Agent instructions for this repo | Linked from Quick start step 2 |
| [`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md) | MCP server reference | Linked from MCP section — no tool micro-templates duplicated |
| [`website/docs/getting-started/installation.md`](../../../website/docs/getting-started/installation.md) | Installation (incl. Windows) | Linked from install section |
| [`website/docs/getting-started/mcp-setup.md`](../../../website/docs/getting-started/mcp-setup.md) | Workspace vs user MCP | Linked from MCP section |
| [`website/docs/prompts/overview.md`](../../../website/docs/prompts/overview.md) | Full prompt catalog | Linked instead of duplicating long tables |

---

## Benchmark: copilot-collections README patterns

Source: [copilot-collections `README.md`](https://github.com/TheSoftwareHouse/copilot-collections/blob/main/README.md) (fetched 2026-06-07).

| Pattern | Copilot implementation | Cursor Collections equivalent |
| ------- | ---------------------- | ----------------------------- |
| **One-liner + tagline** | “Opinionated GitHub Copilot setup…” + “Product Ideation → Development → Quality” | “Cursor-native product engineering framework” + **Ideate → Implement → Review** |
| **Phase matrix** | 📋 Ideation / 🛠 Dev / ✅ Quality / ⚙️ Customization — each with Agents, Prompts, Skills | Same phases + **Rules** (`.cursor/rules/*.mdc`) + **Commands** (`.cursor/commands/`) |
| **Prefix callout** | `tsh-` avoids collisions | `eversis-` prefix callout (already in framework) |
| **Prerequisites** | Copilot Pro, VS Code ≥ 1.109 | **Cursor IDE**, Node for MCP build, `.cursor/rules/` support |
| **Workflow flowcharts** | Full lifecycle, UI flow, standalone ideation with `↳` gates | Map to `@eversis-analyze-materials`, `@eversis-implement`, `@eversis-review`, `@eversis-review-ui`, Fine → QA draft |
| **Agents deep dive** | Per-agent Focus blocks | **Condensed** in README — link to `website/docs/agents/` for full roster |
| **Installation last** | VS Code User Settings vs per-project | **Option 1:** consumer `setup-cursor-local.sh`; **Option 2:** manual copy; vendor submodule/copy |
| **MCP section** | Listed under Infrastructure | **🔌 MCP** — workspace `.cursor/mcp.json`, build `eversis-collections`, link to MCP README |

**Do not import:** VS Code User Settings, `.github/agents`, `/tsh-*` commands, Copilot Pro license requirement.

**Stakeholder template note:** The user-provided template uses fictional `@cc-*` rules — map to real **`eversis-*`** prompts, rules, and MCP tools only.

---

## Audience analysis

| Persona | Needs from root README | Current gap |
| ------- | ---------------------- | ----------- |
| **GitHub visitor (new)** | What is this? What problem does it solve? Can I use it in my stack? | Too much MCP/QA detail before emotional buy-in |
| **Cursor user (first week)** | How to attach `@eversis-implement`, enable rules, enable MCP | Quick start exists but drowned in adjacent paragraphs |
| **Team lead / EM** | Human gates, Fine → QA handoff, consumer vs vendor setup | Gates mentioned but not visualized like copilot flowcharts |
| **BA / docs author** | BA Docs prompts + Word MCP one-liner | Present but scattered |
| **Framework contributor** | Link validation, CHANGELOG, contributing | Adequate at bottom; keep after install |

---

## Factual inventory (must remain accurate)

### Framework identity

- **Product:** Cursor Collections (Eversis) — **Cursor-only**; based on [copilot-collections](https://github.com/TheSoftwareHouse/copilot-collections).
- **Lifecycle:** Ideate → Implement → Review (+ Business Manager Docs, framework customization).
- **Invocation:** `@eversis-*` attachment in Chat/Agent; `/eversis-*` project commands in `.cursor/commands/` (load canonical prompt from `.cursor/prompts/public/`).

### Phase → entry points (primary)

| Phase | Attach / command | Notes |
| ----- | ---------------- | ----- |
| Ideate | `@eversis-analyze-materials` / `/eversis-analyze-materials` | Workshop → Jira-ready stories |
| Implement | `@eversis-implement` / `/eversis-implement` | Research → plan → code; human gates |
| Review | `@eversis-review`, `@eversis-review-ui`, `@eversis-review-codebase` | UI loop with Figma + Playwright MCP |
| BA Docs | `@eversis-ba-docs-planner`, `@eversis-ba-docs-writer` | Word `.docx` via `eversis-collections` MCP |
| Customize | `eversis-create-custom-*.md` prompts | Rules, skills, prompts, AGENTS.md |

### Structural assets

- **Rules:** `.cursor/rules/*.mdc` — `eversis-agent-core.mdc` (always on), `eversis-project-stack.mdc` (per repo), role rules on demand.
- **Prompts:** `.cursor/prompts/public/` (user), `internal/` (delegation).
- **Skills:** `.cursor/skills/eversis-*/SKILL.md` — consumed via **`eversis-collections` MCP** (`eversis_skills_*`), not Cursor Agent Skills UI.
- **MCP:** `.cursor/mcp.json` — build [`mcp/eversis-collections-mcp/`](../../../mcp/eversis-collections-mcp/) first; includes Atlassian, Figma, Playwright, etc.

### Mandatory contracts (must stay visible)

- **Human gates** after research and plan in Implement.
- **Fine → QA comment draft** in same response (`eversis-qa-comment` skill); human approves before Jira; never auto-post.
- **Legacy `/tsh-*`** not used — `eversis-*` only.

### Consumer setup (preserve commands)

```bash
git clone … "$HOME/.local/share/cursor-collections"
export CURSOR_COLLECTIONS_HOME="$HOME/.local/share/cursor-collections"
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --build-mcp
# optional: --vendor submodule|copy, --gitignore-agent-artifacts
```

### Quality / contributing

- `node scripts/validate-cursor-markdown-links.mjs --context=source`
- `cd website && npm run validate-cursor-links` / `npm run build`
- MIT license; CHANGELOG.md

---

## Proposed information architecture (target root README)

Progressive disclosure order (top → bottom):

```text
1. Hero — title, one-liner, tagline (Ideate → Implement → Review), Eversis + copilot-collections credit
2. 🚀 What this repository provides — phase matrix (📋 Ideate | 🛠 Implement | ✅ Quality | 📄 BA Docs | ⚙️ Customize)
   └── Per phase: Rules | Prompts | Skills (WHO / HOW / WHAT)
3. 💡 eversis- prefix callout — collision avoidance
4. ⚠️ Prerequisites — Cursor IDE, Node (MCP build), recommended models (optional one line)
5. 🧭 Supported workflows — text flowcharts:
   └── Standard lifecycle | UI + Figma loop | Standalone ideation | BA Docs (short)
   └── Human-gates callout box
6. 🚀 Quick start (this repo) — 5–6 numbered steps (open in Cursor → AGENTS.md → rules → attach prompt → MCP → skills)
7. 📋 Public prompts at a glance — compact table + link to full catalog
8. 🔌 MCP server configuration — workspace enable, build eversis-collections, link to MCP README + mcp-setup.md
9. 🧩 Installation in another repository — Option 1 script (recommended) | Option 2 manual | vendor modes (condensed)
10. 🛠 Framework customization — one short paragraph + link
11. 🤝 Contributing & quality — link validation, CHANGELOG, license
12. 📚 Related documentation — cursor-collection.md, docs site, agents overview
13. Summary — 4–5 bullet recap (optional; keep short or merge into §1)
```

**Length target:** ~180–250 lines (similar to current ~227) but **lower density per screen** — more whitespace, flowcharts, and links vs inline encyclopedia.

**Content to demote / deduplicate:**

- `.docx` BOM/locale/`hasTables` details → link to MCP README only.
- Repeated MCP build paragraphs → one install mention + links.
- Long QA comment prose → one workflow line + link to `eversis-qa-comment` SKILL.md.

---

## Risks and constraints

| Risk | Mitigation |
| ---- | ---------- |
| Duplicating `cursor-collection.md` | README summarizes; every deep topic links out |
| Duplicating new MCP README | Single MCP section + “see MCP README for tools” |
| Breaking inbound links from CHANGELOG / docs | Keep major heading names where possible (`Quick start`, `Using this framework in another repository`); run link validator on README |
| Emoji overload | Phase emojis only in matrix + flowcharts (match copilot-collections discipline) |
| Stale prompt table | Link to `website/docs/prompts/overview.md` as SSOT; table lists primary SDLC + BA only |
| User template fictional `@cc-*` | Use only verified `eversis-*` names in plan |

---

## Acceptance criteria (research phase)

- [x] Current README pain points documented with line references
- [x] Scope limited to root README (MCP README excluded — done)
- [x] Copilot-collections patterns mapped to Cursor equivalents
- [x] Factual inventory for preservation
- [x] Target IA proposed
- [x] Relationship to other docs defined
- [x] **Human approval** to proceed to implementation

---

## Open questions for human review

**Resolved (2026-06-07):**

1. **Agent deep dive depth:** Condensed agent list (name + one line) + link to `website/docs/agents/`.
2. **Summary section:** Remove standalone Summary.
3. **Centered HTML hero:** Keep centered hero + Cursor logo at top.
4. **CHANGELOG entry:** Yes — added under 2026-06-07.

---

## References

- Current: [`README.md`](../../../README.md)
- Benchmark: [copilot-collections README](https://github.com/TheSoftwareHouse/copilot-collections/blob/main/README.md)
- Framework deep dive: [`documentation/cursor-collection.md`](../../../documentation/cursor-collection.md)
- MCP package (completed): [`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md), [`mcp-readme-rewrite.research.md`](../mcp-readme-rewrite/mcp-readme-rewrite.research.md)
- Stakeholder analysis: user message in Implement thread (progressive disclosure guide + template)
