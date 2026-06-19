# Research: Improve Agents section in root `README.md`

**Task:** Upgrade the **Agents** section in [`README.md`](../../../README.md) to follow the structure and depth of product-engineering README benchmark — Agents.

**Parent work:** [`root-readme-rewrite`](../root-readme-rewrite/root-readme-rewrite.plan.md) (README restructure complete 2026-06-07).

**Status:** Approved — implementation complete (2026-06-07).

---

## Problem statement

After the README restructure, the **Agents** block (lines 169–187) is a **single two-column table** — one line per role. That satisfies a “condensed list” decision from the parent task but **under-delivers** compared to the product-engineering README benchmark benchmark the stakeholder cited.

### Current README (gap)

```markdown
## 🧑‍💻 Agents (condensed)
| Agent | One-line focus |
| **Business Analyst** | Converts workshop materials... |
...
```

| Gap | Impact |
| --- | ------ |
| **No phase grouping** | Reader cannot map agents to 📋 Ideate / 🛠 Implement / ✅ Quality / ⚙️ Customize |
| **No Focus-first pattern** | external benchmark leads each agent with `Focus: **bold goal**` then supporting bullets — easier to scan |
| **No per-agent emoji anchors** | external benchmark uses 📋 📝 🧱 💻 🔍 etc. for visual filtering |
| **Thin descriptions** | One line omits behaviors readers need (gates, delegation, MCP usage, UI loop) |
| **Missing roles** | **Engineering Manager** and **Cursor customization orchestrator** not listed as agent blocks |
| **Packaging not shown** | external benchmark implies prompts; Cursor README should note `@` prompt + rule file where helpful |

### product-engineering README pattern (benchmark)

Source: README.md — Agents (§ lines 189–263).

Structure:

```text
## 🧑‍🤝‍🧑 Agents
 Intro: configured as agents/sub-agents, organized by lifecycle phase

 ### 📋 Product Ideation Agents
 #### 📋 Business Analyst
 - Focus: **main goal**
 - 3–5 behavior bullets

 ### 🛠 Development Agents
 #### Context Engineer, Architect, Software Engineer
 (same pattern)

 ### ✅ Quality Agents
 #### Code Reviewer, UI Reviewer, E2E Engineer

 ### ⚙️ Cursor customization agents
 #### Cursor customization engineer, Cursor customization orchestrator (experimental)

 Closing: "Each agent is designed to be used together with the workflow prompts below."
```

**Notable:** external benchmark does **not** list Engineering Manager, Prompt Engineer, or DevOps Engineer in the Agents README section — those are implied via `/eversis-implement` delegation. **Cursor Collections should list them explicitly** because the docs site and implement flow treat them as first-class roles ([`website/docs/agents/overview.md`](../../../website/docs/agents/overview.md)).

---

## Scope boundary

| In scope | Out of scope |
| -------- | ------------ |
| Replace § **Agents (condensed)** in [`README.md`](../../../README.md) | Rewriting [`website/docs/agents/*.md`](../../../website/docs/agents/) |
| Phase-grouped agent blocks with **Focus** + supporting bullets | Full external benchmark-style **Skills** encyclopedia (separate section; link to skills overview) |
| Link to [agents overview](../../../website/docs/agents/) for deep dive | Internal customization workers (researcher, creator, reviewer) — docs site only |

---

## Agent inventory (Cursor Collections)

Mapped from [`website/docs/agents/overview.md`](../../../website/docs/agents/overview.md) and agent pages.

### 📋 Product ideation

| Agent | Primary invoke | Rule (canonical / starter) |
| ----- | -------------- | -------------------------- |
| **Business Analyst** | `@eversis-analyze-materials` | `eversis-role-business-analyst.mdc` |

### 🛠 Development

| Agent | Primary invoke | Rule |
| ----- | -------------- | ---- |
| **Context Engineer** | `@eversis-research` (via `@eversis-implement`) | `eversis-role-context-engineer.mdc` |
| **Architect** | `@eversis-plan` (via `@eversis-implement`) | `eversis-role-architect.mdc` |
| **Engineering Manager** | `@eversis-implement` | **`eversis-engineering-manager.mdc`** (starter in this repo) |
| **Software Engineer** | delegated from `@eversis-implement` | `eversis-role-software-engineer.mdc` |
| **Prompt Engineer** | delegated from `@eversis-implement` | `eversis-role-prompt-engineer.mdc` |
| **DevOps Engineer** | delegated from `@eversis-implement` | `eversis-role-devops-engineer.mdc` |

### ✅ Quality

| Agent | Primary invoke | Rule |
| ----- | -------------- | ---- |
| **Code Reviewer** | `@eversis-review` | **`eversis-code-reviewer.mdc`** (starter) |
| **UI Reviewer** | `@eversis-review-ui` | `eversis-role-ui-reviewer.mdc` |
| **E2E Engineer** | delegated from `@eversis-implement` | `eversis-role-e2e-engineer.mdc` |

### ⚙️ Cursor customization

| Agent | Primary invoke | Rule |
| ----- | -------------- | ---- |
| **Cursor customization engineer** | `eversis-create-custom-*.md` | `eversis-role-cursor-customization.mdc` |
| **Cursor customization orchestrator** | composed `eversis-create-custom-*` flow | orchestrator docs only |

---

## Proposed content pattern (per agent)

Adapt external benchmark **Focus + bullets**, compressed for README (not 6 bullets each):

```markdown
#### 📋 Business Analyst

- **Focus:** orchestrating workshop materials into Jira-ready epics and stories.
- Delegates transcript cleanup, extraction, and quality review while you keep human gates before Jira sync.
- Produces artifacts such as `extracted-tasks.md` and `jira-tasks.md` under `docs/specs/`.
- **Invoke:** `@eversis-analyze-materials` or `/eversis-analyze-materials`.
```

**Template fields:**

| Field | Required | Notes |
| ----- | -------- | ----- |
| **Focus** (bold) | Yes | One sentence — mirror external benchmark first bullet |
| Behavior bullets | 2–3 | Delegation, gates, outputs, MCP — pick highest-signal |
| **Invoke** | Optional one line | Cursor-specific; external benchmark uses slash commands in separate Prompts section — we can add invoke here because README prompt table is above/below |

**Do not duplicate** the full Skills section — one bullet may reference skills loaded automatically (e.g. “loads `eversis-task-analysing` during research”).

---

## Draft agent copy (for implementation)

### 📋 Product ideation

#### 📋 Business Analyst

- **Focus:** orchestrating discovery workshop materials into **Jira-ready epics and stories**, or iterating on an existing backlog.
- Cleans transcripts, extracts tasks, runs quality review, and formats for Jira — with **human gates** before sync.
- Preserves traceability and GIVEN/WHEN/THEN acceptance scenarios.
- **Invoke:** `@eversis-analyze-materials`.

### 🛠 Development

#### 📝 Context Engineer

- **Focus:** requirements, context, and domain understanding for a task.
- Gathers information from Jira, Confluence, codebase, and attachments; identifies gaps and ambiguities.
- Produces **`*.research.md`** under `docs/specs/` — human approval required before planning.
- **Invoke:** delegated via `@eversis-implement` (internal `@eversis-research`).

#### 🧱 Architect

- **Focus:** solution design and **implementation plans** with phases and acceptance checks.
- Breaks down complex work, proposes trade-offs, and aligns with existing architecture.
- Produces **`*.plan.md`** — human approval required before broad code changes.
- **Invoke:** delegated via `@eversis-implement` (internal `@eversis-plan`).

#### 🎯 Engineering Manager

- **Focus:** **orchestrating** the Implement phase — research → plan → code → review handoff.
- Delegates to specialized roles by task type; enforces human gates and **Fine → QA comment draft**.
- Does not replace implementers — follows the approved plan strictly.
- **Invoke:** `@eversis-implement` + attach `eversis-engineering-manager.mdc`.

#### 💻 Software Engineer

- **Focus:** implementing the **agreed plan** (backend and frontend).
- Writes and refactors in small, reviewable steps; follows repo conventions and tests where available.
- For UI work: design system, accessibility, and iterative `@eversis-review-ui` with Figma + Playwright MCP.
- **Invoke:** delegated via `@eversis-implement`.

#### ✍️ Prompt Engineer

- **Focus:** designing and optimizing **LLM application prompts** (runtime prompts, not Cursor packaging).
- Structures prompts for clarity, security, and evaluation — RAG templates, agents, chatbots.
- **Invoke:** delegated via `@eversis-implement` when the task is prompt/RAG work.

#### 🏗️ DevOps Engineer

- **Focus:** infrastructure, **CI/CD**, observability, and cloud cost governance.
- Terraform, Kubernetes, pipelines, and multi-cloud patterns — expressed as IaC in the repo.
- **Invoke:** delegated via `@eversis-implement` for infra tasks.

### ✅ Quality

#### 🔍 Code Reviewer

- **Focus:** structured code review and **risk detection** (PASS / BLOCKER / SUGGESTION).
- Verifies acceptance criteria, security, reliability, and test coverage.
- Enforces **`STRICT FORBIDDEN`** limits (scope, doc comments, dependencies) — mirrored in `eversis-agent-core.mdc`.
- **Invoke:** `@eversis-review` + attach `eversis-code-reviewer.mdc`.

#### 🔎 UI Reviewer

- **Focus:** **read-only** UI verification — Figma (EXPECTED) vs browser (ACTUAL).
- Returns PASS/FAIL with a structured diff; used in a loop from Implement until pass or escalation.
- **Invoke:** `@eversis-review-ui` (standalone or via `@eversis-implement`).

#### 🧪 E2E Engineer

- **Focus:** **Playwright** end-to-end tests for critical user journeys.
- Page Object Model, fixtures, accessibility-first locators; integrates with Playwright MCP.
- **Invoke:** delegated via `@eversis-implement` for E2E tasks.

### ⚙️ Cursor customization

#### ⚙️ Cursor customization engineer

- **Focus:** designing, creating, and reviewing **Cursor packaging** — rules, skills, prompts, `AGENTS.md`.
- Enforces separation: rule = constraints, skill = HOW, prompt = WHAT, instructions = project stack.
- **Invoke:** `@eversis-create-custom-agent` and related `eversis-create-custom-*` prompts.

#### 🔀 Cursor customization orchestrator

- **Focus:** coordinating **multi-step** customization (research → create → review) via isolated sub-steps.
- Reduces context rot on large packaging changes; complements the customization engineer role.
- **Invoke:** composed flow through `eversis-create-custom-*` prompts (see [orchestrator doc](../../../website/docs/agents/cursor-customization-orchestrator.md)).

**Closing line (from external benchmark):** *Each role is expressed as Cursor **rules** and **prompts** — use them together with the workflow sections above.*

**Starter rules callout (keep):** `eversis-agent-core.mdc`, `eversis-engineering-manager.mdc`, `eversis-code-reviewer.mdc`.

---

## Information architecture (target README section)

Replace table with:

```text
## 🧑‍🤝‍🧑 Agents
 1-line intro + link to website/docs/agents/

 ### 📋 Product ideation
 #### Business Analyst (4 bullets)

 ### 🛠 Development
 #### Context Engineer, Architect, Engineering Manager, Software Engineer,
 Prompt Engineer, DevOps Engineer

 ### ✅ Quality
 #### Code Reviewer, UI Reviewer, E2E Engineer

 ### ⚙️ Cursor customization
 #### customization engineer, orchestrator

 Starter rules callout
 Closing sentence
```

**Estimated length:** ~95–115 lines (vs current ~18 lines). Acceptable within README target ~250–320 lines total (current ~308).

---

## Risks and constraints

| Risk | Mitigation |
| ---- | ---------- |
| README becomes too long | Cap at **3–4 bullets** per agent; link to docs site for encyclopedia |
| Drift from agent pages | Copy aligned to `website/docs/agents/*.md` summaries, not invented |
| Contradicts prior “one-line table” decision | Stakeholder explicitly requested external benchmark Agents depth — **supersedes** condensed table |
| Broken anchors / links | Run `validate-cursor-markdown-links.mjs --paths=README.md` after edit |

---

## Acceptance criteria (research)

- [x] Gap between current Agents table and external README benchmark documented
- [x] Full agent inventory for Cursor Collections
- [x] Per-agent draft copy prepared (Focus + bullets)
- [x] Scope limited to README Agents section
- [x] IA and length estimate proposed
- [x] **Human approval** to proceed to plan / implementation

---

## Open questions for human review

**Resolved (2026-06-07):**

1. **Invoke line:** Primary agents only (BA, EM, Code Reviewer, UI Reviewer, customization); omit on delegates.
2. **Engineering Manager emoji:** 🎯
3. **CHANGELOG:** Additional line under `2026-06-07`.

---

## References

- Benchmark: product-engineering README benchmark README — Agents
- Current: [`README.md`](../../../README.md) § Agents (condensed)
- Canonical roles: [`website/docs/agents/overview.md`](../../../website/docs/agents/overview.md)
- Parent spec: [`root-readme-rewrite.research.md`](../root-readme-rewrite/root-readme-rewrite.research.md)
