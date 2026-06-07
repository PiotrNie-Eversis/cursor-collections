# Research: Improve README Supported workflows section

**Task:** Expand [`README.md`](../../../README.md) § **🧭 Supported workflows** (~lines 72–135) to follow the structure and depth of [copilot-collections — Supported Workflow](https://github.com/TheSoftwareHouse/copilot-collections#-supported-workflow).

**Related README work:** [`root-readme-rewrite`](../root-readme-rewrite/), [`readme-agents-descriptions`](../readme-agents-descriptions/), [`readme-mcp-section`](../readme-mcp-section/) — all complete.

**Status:** Approved — implementation complete (2026-06-07).

---

## Problem statement

The current **Supported workflows** block has **four short flowcharts** and a one-line human-gates callout. It communicates the relay-race idea but **skips the copilot-collections “phase primer”** that helps newcomers understand *what each phase does* before reading example commands.

### Current structure (README ~72–135)

```text
1. One sentence + human gates callout
2. Example: Full lifecycle (standard) — flowchart only
3. Example: UI flow — minimal (implement + review-ui only, no ideate)
4. Example: Standalone ideation — 3 lines
5. Example: BA Docs — 3 lines + link
```

**Strengths to keep:** `@eversis-*` naming, Fine → QA comment line in standard flow, BA Docs as Cursor-specific extra.

### Copilot-collections structure (benchmark)

```text
1. Intro — full lifecycle, three phases
2. Blockquote: Product Ideation → Development → Quality
3. ### Phase 1 — bullet capabilities (gates, artifacts)
4. ### Phase 2 — bullet capabilities + **Single flow table** (Implement | Review)
5. ### Phase 3 — bullet capabilities (review, UI, E2E, codebase health)
6. ---
7. Example: Full Lifecycle (Standard Flow) — detailed flowchart
8. Example: Full Lifecycle (UI Flow with Figma) — **full 3-phase** flowchart
9. Note: Jira ID or free-form task
10. Important callout (long human-judgment paragraph)
11. ### How the UI Verification Loop Works — 5 numbered steps
12. Example: Standalone Product Ideation — optional explore + gates + artifact list callout
```

| Gap | Current README | Copilot benchmark |
| --- | -------------- | ----------------- |
| **Phase descriptions** | Absent | Three `### Phase N` sections with 4 bullets each |
| **Implement → Review table** | Absent | Compact 2-row table |
| **UI example depth** | Implement-only snippet | Full ideate → implement (Figma gates) → quality |
| **UI loop explainer** | Mentioned in one line | Dedicated 5-step numbered section |
| **Standalone ideation** | 3 lines | Flowchart + artifact filenames + gate callout |
| **Jira vs free-form** | Not stated | Explicit sentence |
| **Human judgment callout** | Short blockquote | Fuller ⚠️ Important paragraph |
| **Ideate gates** | Generic “approve” | Named gates (copilot: 0–2; **Cursor: 1, 1.5, 2** per BA agent doc) |
| **Explore before ideate** | N/A | `/tsh-explore-materials` optional — **not in Cursor Collections** |

---

## Scope boundary

| In scope | Out of scope |
| -------- | ------------ |
| Rewrite **Supported workflows** section in root [`README.md`](../../../README.md) only | `website/docs/workflow/overview.md` rewrite |
| Map copilot patterns to **`eversis-*`** and Cursor gates/artifacts | Invent `/tsh-explore-materials` or Gate 0 if not in repo |
| Preserve **Fine → QA comment** (Cursor-specific; copilot standard flow omits it) | Changing prompt bodies or implement workflow code |
| Keep **BA Docs** as Cursor-specific example subsection | Duplicating full BA Docs playbook |

**Accuracy source for gates/artifacts:** [`website/docs/agents/business-analyst.md`](../../../website/docs/agents/business-analyst.md), [`documentation/cursor-collection.md`](../../../documentation/cursor-collection.md).

---

## Factual inventory (Cursor Collections)

### Phase naming

- **Ideate** (not “Product Ideation”) — align with README hero: **Ideate → Implement → Review**.
- Copilot “Development” = Cursor **Implement**; copilot “Quality” = Cursor **Review** (+ UI/E2E/codebase prompts).

### Ideate gates (this repo)

From Business Analyst doc — **no Gate 0**, **no `eversis-explore-materials`** public prompt:

| Gate | When |
| ---- | ---- |
| **Gate 1** | After task extraction — review epic/story breakdown |
| **Gate 1.5** | After quality review — accept/reject suggestions |
| **Gate 2** | After Jira formatting — review before Jira push |

### Ideate artifacts (examples)

`cleaned-transcript.md`, `extracted-tasks.md`, `quality-review.md`, `jira-tasks.md` under `docs/specs/<workshop>/` (BA doc also lists paths; framework uses `docs/specs/`).

### Implement internal flow

Research (`*.research.md`) → human gate → Plan (`*.plan.md`) → human gate → code → **Fine** → **QA comment draft** (`eversis-qa-comment`) → Review optional/auto.

### UI verification loop

From `eversis-implement` / engineering-manager rules:

1. `@eversis-implement` delegates UI work to Software Engineer  
2. `@eversis-review-ui` — single-pass, read-only  
3. Figma MCP (EXPECTED) + Playwright MCP (ACTUAL) → PASS/FAIL + diff  
4. FAIL → fix → `@eversis-review-ui` again  
5. Until PASS or max iterations / escalation  

### Review phase capabilities (map to copilot Phase 3 bullets)

- `@eversis-review` — structured code review  
- `@eversis-review-ui` — Figma verification  
- `@eversis-review-codebase` — codebase health (copilot mentions dead code / duplications)  
- E2E via implement delegation (Playwright)

### Cursor-only workflows to retain

- **Business Manager Docs** — planner → writer + MCP Word tools  
- **Fine → QA comment** in standard implement flowchart  

---

## Proposed information architecture (target section)

```text
## 🧭 Supported Workflow   (or keep plural "workflows" — see open questions)

Intro: full lifecycle; rules + prompts work sequentially

> Ideate → Implement → Review

### Phase 1: 📋 Ideate — Requirements & planning
  4 bullets (inputs, quality review, gates 1/1.5/2, artifacts)

### Phase 2: 🛠 Implement — Architecture & delivery
  4 bullets (research/plan/code, scoped changes, UI Figma loop, Fine/QA)
  **Single flow: Implement → Review** table (@eversis-implement | @eversis-review)

### Phase 3: ✅ Review — Quality & testing
  4 bullets (code review, UI verify, E2E, codebase health)

---

### Example: Full lifecycle (standard flow)
  Enhanced flowchart (gates named; Fine/QA line kept)

### Example: Full lifecycle (UI flow with Figma)
  Full 3-phase flowchart (like copilot)

You can run any flow with Jira ticket ID or free-form task description.

> Important: human judgment callout (expanded)

### How the UI verification loop works
  5 numbered steps (@eversis-*)

### Example: Standalone ideation
  Flowchart + artifact list + Gate 1/1.5/2 callout
  (no explore-materials — not in this repo)

### Example: Business Manager Docs
  (keep — Cursor-specific)

Links: workflow overview, eversis-qa-comment SKILL.md
```

**Length target:** ~120–150 lines (vs current ~64). Offset by removing redundancy with Agents section — workflows stay command-oriented.

---

## Draft copy highlights

### Phase 2 table (Cursor)

| Step | Attach | What happens |
| ---- | ------ | ------------ |
| Implement | `@eversis-implement` | Engineering Manager orchestrates research → plan → implementation; UI tasks include `@eversis-review-ui` loop; declares **Fine** + QA draft |
| Review | `@eversis-review` | Structured review — PASS / BLOCKER / SUGGESTION |

### UI verification loop (numbered)

1. `@eversis-implement` delegates a UI component to the Software Engineer  
2. Calls `@eversis-review-ui` for **single-pass** verification (read-only)  
3. `@eversis-review-ui` uses **Figma MCP** (EXPECTED) + **Playwright MCP** (ACTUAL) → PASS or FAIL with diff table  
4. If FAIL → Engineering Manager delegates fix and calls `@eversis-review-ui` again  
5. Repeats until PASS or max iterations (then escalates per implement prompt)  

### Standalone ideation callout

> Depending on materials, the Business Analyst can produce `cleaned-transcript.md`, `extracted-tasks.md`, `quality-review.md`, and `jira-tasks.md`. **Gate 1, Gate 1.5, and Gate 2** remain mandatory before Jira sync.

---

## Risks and constraints

| Risk | Mitigation |
| ---- | ---------- |
| Copying copilot Gate 0 / explore-materials | Use Cursor BA doc gates only; no explore prompt |
| Section too long | Phase bullets capped at 4 lines each |
| Duplicates Agents / Quick start | Workflows = *when to run what*; agents = *who* |
| `/` vs `@` inconsistency | Show both where Quick start does (`@eversis-implement` or `/eversis-implement`) in table |

---

## Acceptance criteria (research)

- [x] Gap vs copilot Supported Workflow documented
- [x] Cursor-accurate gates, artifacts, UI loop inventoried
- [x] Target IA and draft highlights prepared
- [x] Scope limited to README workflows section
- [x] **Human approval** to proceed to plan

---

## Open questions for human review

**Resolved (2026-06-07):**

1. **Section title:** **Supported workflows** (plural).
2. **Gate naming:** Gate 1, 1.5, 2 only.
3. **Implement → Review table:** Include `/` aliases.
4. **BA Docs example:** Keep as fourth example.
5. **CHANGELOG:** New line on implement.

**Plan:** [`readme-workflows-section.plan.md`](./readme-workflows-section.plan.md)

---

## References

- Benchmark: [copilot-collections — Supported Workflow](https://github.com/TheSoftwareHouse/copilot-collections#-supported-workflow)
- Current: [`README.md`](../../../README.md) § Supported workflows
- Gates: [`website/docs/agents/business-analyst.md`](../../../website/docs/agents/business-analyst.md)
- Workflow: [`website/docs/workflow/overview.md`](../../../website/docs/workflow/overview.md)
- QA handoff: [`.cursor/skills/eversis-qa-comment/SKILL.md`](../../../.cursor/skills/eversis-qa-comment/SKILL.md)
