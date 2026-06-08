<p align="center">
  <a href="https://cursor.com">
    <img src="https://cursor.com/apple-touch-icon.png" alt="Cursor" width="72" />
  </a>
</p>

<h1 align="center">⚙️ Cursor Collections</h1>

<p align="center">
  An opinionated <strong>Cursor-native</strong> product engineering framework — rules, attachable prompts, MCP, and reusable skills for the full software development lifecycle.<br/>
  <strong>Ideate → Implement → Review</strong> — one toolchain, end to end.
</p>

<p align="center">
  Maintained by <a href="https://eversis.com" target="_blank">Eversis</a>. Based on <a href="https://github.com/TheSoftwareHouse/copilot-collections" target="_blank">Copilot Collections</a> from The Software House.
</p>

---

## 🚀 What this repository provides

Structured **roles**, **prompts** (`eversis-*.md`), **project rules** (`.cursor/rules/*.mdc`), and **skills** (`.cursor/skills/`) organized by lifecycle phase:

### 📋 Ideate — Requirements & planning

- 🧑‍💻 **Rules** — Business Analyst role behavior (attach on demand).
- 💬 **Prompts** — `@eversis-analyze-materials` or `/eversis-analyze-materials`.
- 🧰 **Skills** — Task analysis, transcript processing, task extraction, Jira formatting.

### 🛠 Implement — Architecture & delivery

- 🧑‍💻 **Rules** — `eversis-agent-core.mdc` (always on), `eversis-engineering-manager.mdc` (orchestration).
- 💬 **Prompts** — `@eversis-implement` or `/eversis-implement` (delegates research → plan → code).
- 🧰 **Skills** — Architecture design, technical context discovery, frontend/backend implementation, gap analysis.

### ✅ Quality — Review & testing

- 🧑‍💻 **Rules** — `eversis-code-reviewer.mdc` (PASS / BLOCKER / SUGGESTION output).
- 💬 **Prompts** — `@eversis-review`, `@eversis-review-ui`, `@eversis-review-codebase` (and matching `/` commands).
- 🧰 **Skills** — Code review, UI verification, E2E testing.

### 📄 Business Manager Docs — Release documentation

- 💬 **Prompts** — `@eversis-ba-docs-planner`, `@eversis-ba-docs-writer`.
- 🔌 **MCP** — Word `.docx` chapter tools on the local **`eversis-collections`** server.
- 📖 **Workflow:** [Business Manager Docs](website/docs/workflow/business-manager-docs.md).

### ⚙️ Framework customization — Extending the toolchain

- 💬 **Prompts** — `eversis-create-custom-*.md` under `.cursor/prompts/public/`.
- 🧰 **Skills** — Creating rules, skills, prompts, and project instructions.

### 🔌 Infrastructure

- **MCP integrations** — Atlassian, Figma, Context7, Playwright, and the local **`eversis-collections`** server (skills + Word tools).
- **Cursor setup** — `.cursor/rules/`, `.cursor/commands/` (`/` dropdown loads canonical prompts), [`.cursor/mcp.json`](.cursor/mcp.json).

> **Why the `eversis-` prefix?** All artifacts use the `eversis-` prefix (e.g. `@eversis-implement`) to avoid naming collisions with your own project-specific rules, skills, and prompts.

`/` project commands live in **`.cursor/commands/`** — each instructs the agent to **load** the canonical `.cursor/prompts/public/` file before executing. Legacy `/tsh-*` names from the Copilot era are **not** used.

---

## ⚠️ Prerequisites

- **Editor:** [Cursor IDE](https://cursor.com/) with **`.cursor/rules/`** support (recommended).
- **Node.js** ≥ 18 — to build the local **`eversis-collections`** MCP package.
- **Recommended models:** Claude Sonnet or GPT-4 class models for structured rule and prompt files.

---

## 🧭 Supported workflows

We support the **full product development lifecycle**, organized into three phases. Rules and prompts work best **sequentially**, with human review at each gate.

> **📋 Ideate → 🛠 Implement → ✅ Review**

### Phase 1: 📋 Ideate — Requirements & planning

- Converts raw inputs (workshop transcripts, Figma designs, documents) into structured, actionable work items.
- Runs quality review on extracted tasks before Jira formatting.
- Uses **Gate 1**, **Gate 1.5**, and **Gate 2** before Jira sync — no data is pushed without your approval.
- Produces Jira-ready epics and stories with acceptance criteria under `docs/specs/`.

### Phase 2: 🛠 Implement — Architecture & delivery

- Translates tasks into research docs and phased implementation plans with acceptance checks.
- Writes or modifies code in small, reviewable steps — scoped to the task, respecting existing architecture.
- For UI tasks: includes iterative **Figma verification** via `@eversis-review-ui` until PASS or escalation.
- Declares **Fine** when agent work is complete and produces a **mandatory QA comment draft** ([`eversis-qa-comment`](.cursor/skills/eversis-qa-comment/SKILL.md)) in the same response.

**Single flow: Implement → Review**

| Step | Attach | What happens |
| ---- | ------ | ------------ |
| Implement | `@eversis-implement` or `/eversis-implement` | Engineering Manager orchestrates research → plan → implementation; UI tasks include `@eversis-review-ui` loop; declares Fine + QA draft |
| Review | `@eversis-review` or `/eversis-review` | Structured code review — PASS / BLOCKER / SUGGESTION |

### Phase 3: ✅ Review — Quality & testing

- Performs structured code review against acceptance criteria, security, and reliability.
- Verifies UI implementation against Figma designs (single-pass or in a loop from Implement).
- Creates and maintains Playwright end-to-end tests when delegated from Implement.
- Runs codebase-wide quality analysis via `@eversis-review-codebase` (dead code, duplications, improvements).

---

### Example: Full lifecycle (standard flow)

```text
📋 IDEATE
1️⃣ @eversis-analyze-materials <transcript + workshop materials>
  ↳ 📖 Review extracted tasks, quality review, Jira-formatted output
  ↳ ✅ Approve Gate 1, Gate 1.5, and Gate 2 before Jira sync

🛠 IMPLEMENT
2️⃣ @eversis-implement <JIRA_ID or task description>
  ↳ 🔍 Engineering Manager delegates to Context Engineer for research
  ↳ 📖 Review the generated research document
  ↳ ✅ Confirm to proceed to planning
  ↳ 🧱 Engineering Manager delegates to Architect for planning
  ↳ 📖 Review the implementation plan
  ↳ ✅ Confirm scope, phases, and acceptance criteria
  ↳ 💻 Engineering Manager delegates implementation to specialized agents
  ↳ 📖 Review code changes after each phase
  ↳ 📝 Agent declares Fine — mandatory QA comment draft; approve before Jira

✅ REVIEW
3️⃣ @eversis-review <JIRA_ID or task description>
  ↳ 📖 Review findings and recommendations
  ↳ ✅ Address blockers before merging
```

### Example: Full lifecycle (UI flow with Figma)

```text
📋 IDEATE
1️⃣ @eversis-analyze-materials <transcript + workshop materials>
  ↳ 📖 Review extracted tasks, quality review, Jira-formatted output
  ↳ ✅ Approve Gate 1, Gate 1.5, and Gate 2 before Jira sync

🛠 IMPLEMENT
2️⃣ @eversis-implement <JIRA_ID or task description>
  ↳ 🔍 Engineering Manager delegates to Context Engineer for research
  ↳ 📖 Review research doc — verify Figma links, requirements
  ↳ ✅ Confirm to proceed to planning
  ↳ 🧱 Engineering Manager delegates to Architect for planning
  ↳ 📖 Review plan — check component breakdown, design references
  ↳ ✅ Confirm phases align with Figma structure
  ↳ 💻 Engineering Manager delegates UI tasks to Software Engineer
  ↳ 📖 Review code changes and UI Verification Summary
  ↳ ✅ Manually verify critical UI elements in browser
  ↳ 🔄 Engineering Manager calls @eversis-review-ui in a loop until PASS or escalation

✅ REVIEW
3️⃣ @eversis-review <JIRA_ID or task description>
  ↳ 📖 Review findings — code quality, a11y, performance
  ↳ ✅ Address all blockers before merging
```

You can run any flow with either a **Jira ticket ID** or a **free-form task description**.

> ⚠️ **Important:** Each step requires your review and verification. Open the generated documents, go through them carefully, and iterate as many times as needed until the output looks correct. AI assistance does not replace human judgment — treat each output as a draft that needs your approval before proceeding.

### How the UI verification loop works

1. `@eversis-implement` delegates a UI component to the Software Engineer.
2. Calls `@eversis-review-ui` to perform **single-pass verification** (read-only).
3. `@eversis-review-ui` uses **Figma MCP** (EXPECTED) + **Playwright MCP** (ACTUAL) → returns PASS or FAIL with diff table.
4. If FAIL → the Engineering Manager delegates the fix and calls `@eversis-review-ui` again.
5. Repeats until PASS or max iterations (then escalates per the implement prompt).

### Workflow variants

Besides the full lifecycle examples above, the docs site describes these focused paths:

| Variant | Entry | Use when |
| ------- | ----- | -------- |
| **Standard flow** | `@eversis-implement` → `@eversis-review` | Full SDLC (see examples above) |
| **UI + Figma** | `@eversis-implement` + `@eversis-review-ui` loop | Design-driven UI (see UI example above) |
| **[Workshop Analysis Flow](website/docs/workflow/workshop-flow.md)** | `@eversis-analyze-materials` | Workshop materials → Jira backlog only |
| **[E2E Testing Flow](website/docs/workflow/e2e-flow.md)** | `@eversis-implement` (E2E tasks in plan) | Playwright coverage for critical journeys |
| **[Business Manager Docs](website/docs/workflow/business-manager-docs.md)** | `@eversis-ba-docs-planner` → `@eversis-ba-docs-writer` | Large Word `.docx` release documentation |

Overview: [website/docs/workflow/overview.md](website/docs/workflow/overview.md).

### Example: Workshop Analysis Flow

For converting discovery workshop materials into Jira-ready epics and stories **without** continuing to Implement:

```text
1️⃣ @eversis-analyze-materials <workshop materials>
   ↳ 📝 Agent cleans transcript, analyzes Figma/codebase context, extracts tasks
   ↳ 📖 Review cleaned transcript and extracted tasks

2️⃣ Gate 1 — Task review
   ↳ 📖 Review epic/story breakdown
   ↳ ✅ Approve, or request splits/merges/removals

3️⃣ Gate 1.5 — Quality review
   ↳ 🔍 Agent runs quality passes for gaps and edge cases
   ↳ 📖 Accept or reject each suggestion
   ↳ ✅ Agent applies accepted changes

4️⃣ Gate 2 — Jira push approval
   ↳ 📖 Review final formatted tasks
   ↳ ✅ Confirm target project and approve push
   ↳ 🚀 Agent creates/updates issues in Jira (Atlassian MCP)
```

Artifacts under `docs/specs/`: `cleaned-transcript.md`, `extracted-tasks.md`, `quality-review.md`, `jira-tasks.md`. Full playbook: [Workshop Analysis Flow](website/docs/workflow/workshop-flow.md).

### Example: E2E Testing Flow

E2E work runs **inside** `@eversis-implement` when the plan includes test tasks — the Engineering Manager delegates to the **E2E Engineer** (internal `eversis-implement-e2e` prompt):

```text
1️⃣ @eversis-implement <JIRA_ID or task description>
   ↳ 🔍 Research — identify critical user journeys needing E2E coverage
   ↳ 📖 Review research doc
   ↳ ✅ Confirm scope includes test scenarios
   ↳ 🧱 Plan — confirm E2E tasks and acceptance criteria in the plan
   ↳ ✅ Approve plan before implementation
   ↳ 🧪 E2E Engineer implements Page Objects, fixtures, and Playwright tests
   ↳ 📖 Review test files; run locally (3+ consecutive passes in headless mode)
   ↳ 🔄 Iterate on flaky or failing tests
   ↳ 📝 Fine → mandatory QA comment draft
```

Uses **Playwright MCP** for browser interaction. Not a separate public prompt — always via Implement. Full playbook: [E2E Testing Flow](website/docs/workflow/e2e-flow.md).

### Example: Business Manager Docs

For **Word `.docx` release documentation** — separate from product code (`@eversis-implement`). Planner builds `docs-update-plan.md`; Writer applies chapter edits via **`eversis-collections`** MCP (no dev-server or `@eversis-review-ui`):

```text
1️⃣ @eversis-ba-docs-planner <release / Jira scope + Confluence rules>
   ↳ 📖 Review docs-update-plan.md — chapter_ids, VERIFIED/UNVERIFIED, content types
   ↳ ✅ Approve plan before any `.docx` edits

2️⃣ @eversis-ba-docs-writer
   ↳ backup_docx → generate_summary_map / inspect_document
   ↳ TEXT-SAFE → append_chapter or read_chapter + update_chapter
   ↳ TABLE-CONTAINS → update_table_cell
   ↳ 📖 Verify each chapter after edit
```

Requires **Atlassian MCP** (Jira + Confluence) and built **`eversis-collections`** server. Full playbook: [Business Manager Docs](website/docs/workflow/business-manager-docs.md).

---

## 🚀 Quick start (this repository)

1. **Open this repository in [Cursor](https://cursor.com/).**
2. Read [**AGENTS.md**](AGENTS.md) and [documentation/cursor-collection.md](documentation/cursor-collection.md).
3. **Rules:** start with [`eversis-agent-core.mdc`](.cursor/rules/eversis-agent-core.mdc) and edit [`eversis-project-stack.mdc`](.cursor/rules/eversis-project-stack.mdc) for your stack.
4. In **Chat** or **Agent**, attach `@eversis-implement` or use `/eversis-implement` — paste your ticket or task text.
5. **MCP:** build [`mcp/eversis-collections-mcp/`](mcp/eversis-collections-mcp/) (`npm install && npm run build`), enable **`eversis-collections`** from [`.cursor/mcp.json`](.cursor/mcp.json).
6. **Skills:** with MCP enabled, the agent calls `eversis_skills_list` / `eversis_skills_get` against [`.cursor/skills/`](.cursor/skills/) — see [skills overview](website/docs/skills/overview.md).

---

## 📋 Public prompts at a glance

All bodies live under **`.cursor/prompts/public/`**. Full catalog: [website/docs/prompts/overview.md](website/docs/prompts/overview.md).

| Workflow | Attach |
| -------- | ------ |
| Workshop → Jira | `@eversis-analyze-materials` |
| Implement | `@eversis-implement` |
| Code review | `@eversis-review` |
| UI vs Figma | `@eversis-review-ui` |
| Codebase health | `@eversis-review-codebase` |
| Infra audit | `@eversis-audit-infrastructure` |
| AWS / GCP cost | `@eversis-analyze-aws-costs`, `@eversis-analyze-gcp-costs` |
| BA docs — plan / write | `@eversis-ba-docs-planner`, `@eversis-ba-docs-writer` |
| Create rules / skills / prompts | `eversis-create-custom-*.md` |

Internal delegation prompts (research, plan, implement-ui) live under **`.cursor/prompts/internal/`**.

---

## 🧑‍🤝‍🧑 Agents

Roles are expressed as Cursor **rules** (`.cursor/rules/eversis-*.mdc`) and **prompts**, organized by lifecycle phase. Full roster: [website/docs/agents/](website/docs/agents/).

### 📋 Product ideation

#### 🧑‍💼 Business Analyst

- **Focus:** orchestrating discovery workshop materials into **Jira-ready epics and stories**, or iterating on an existing backlog.
- Cleans transcripts, extracts tasks, runs quality review, and formats for Jira — with **human gates** before sync.
- Preserves traceability and GIVEN/WHEN/THEN acceptance scenarios.
- **Invoke:** `@eversis-analyze-materials` or `/eversis-analyze-materials`.

### 🛠 Development

#### 📝 Context Engineer

- **Focus:** requirements, context, and domain understanding for a task.
- Gathers information from Jira, Confluence, codebase, and attachments; identifies gaps and ambiguities.
- Produces **`*.research.md`** under `docs/specs/` — human approval required before planning.

#### 🧱 Architect

- **Focus:** solution design and **implementation plans** with phases and acceptance checks.
- Breaks down complex work, proposes trade-offs, and aligns with existing architecture.
- Produces **`*.plan.md`** — human approval required before broad code changes.

#### 🎯 Engineering Manager

- **Focus:** **orchestrating** the Implement phase — research → plan → code → review handoff.
- Delegates to specialized roles by task type; enforces human gates and **Fine → QA comment draft**.
- Does not replace implementers — follows the approved plan strictly.
- **Invoke:** `@eversis-implement` or `/eversis-implement` + attach `eversis-engineering-manager.mdc`.

#### 💻 Software Engineer

- **Focus:** implementing the **agreed plan** (backend and frontend).
- Writes and refactors in small, reviewable steps; follows repo conventions and tests where available.
- For UI work: design system, accessibility, and iterative `@eversis-review-ui` with Figma + Playwright MCP.

#### ✍️ Prompt Engineer

- **Focus:** designing and optimizing **LLM application prompts** (runtime prompts, not Cursor packaging).
- Structures prompts for clarity, security, and evaluation — RAG templates, agents, chatbots.

#### 🏗️ DevOps Engineer

- **Focus:** infrastructure, **CI/CD**, observability, and cloud cost governance.
- Terraform, Kubernetes, pipelines, and multi-cloud patterns — expressed as IaC in the repo.

### ✅ Quality

#### 🔍 Code Reviewer

- **Focus:** structured code review and **risk detection** (PASS / BLOCKER / SUGGESTION).
- Verifies acceptance criteria, security, reliability, and test coverage.
- Enforces **`STRICT FORBIDDEN`** limits (scope, doc comments, dependencies) — mirrored in [`eversis-agent-core.mdc`](.cursor/rules/eversis-agent-core.mdc) and [`eversis-code-reviewer.mdc`](.cursor/rules/eversis-code-reviewer.mdc).
- **Invoke:** `@eversis-review` or `/eversis-review` + attach `eversis-code-reviewer.mdc`.

#### 🔎 UI Reviewer

- **Focus:** **read-only** UI verification — Figma (EXPECTED) vs browser (ACTUAL).
- Returns PASS/FAIL with a structured diff; used in a loop from Implement until pass or escalation.
- **Invoke:** `@eversis-review-ui` or `/eversis-review-ui` (standalone or via `@eversis-implement`).

#### 🧪 E2E Engineer

- **Focus:** **Playwright** end-to-end tests for critical user journeys.
- Page Object Model, fixtures, accessibility-first locators; integrates with Playwright MCP.

### ⚙️ Cursor customization

#### ⚙️ Cursor customization engineer

- **Focus:** designing, creating, and reviewing **Cursor packaging** — rules, skills, prompts, [`AGENTS.md`](AGENTS.md).
- Enforces separation: rule = constraints, skill = HOW, prompt = WHAT, instructions = project stack.
- **Invoke:** `@eversis-create-custom-agent` and related `eversis-create-custom-*` prompts.

#### 🔀 Cursor customization orchestrator

- **Focus:** coordinating **multi-step** customization (research → create → review) via isolated sub-steps.
- Reduces context rot on large packaging changes; complements the customization engineer role.
- **Invoke:** composed flow through `eversis-create-custom-*` prompts — see [orchestrator doc](website/docs/agents/cursor-customization-orchestrator.md).

Each role is designed to be used together with the workflow sections above.

**Starter rule packs in this repo:** **`eversis-agent-core.mdc`** (always on), **`eversis-engineering-manager.mdc`**, **`eversis-code-reviewer.mdc`**.

---

## 🔌 MCP Server Configuration

To unlock the full workflow (Jira, Figma, library docs, browser automation, and procedural skills), configure the **Model Context Protocol (MCP)** servers. This repository ships a ready-to-use template in [`.cursor/mcp.json`](.cursor/mcp.json).

You have two options for installation:

### Option 1: User Profile (Recommended)

This is the best option — it enables these tools **globally across all your projects**.

1. Open the **Command Palette**: `Cmd` + `Shift` + `P` (macOS) or `Ctrl` + `Shift` + `P` (Windows/Linux).
2. Type and select **“MCP: Open User Configuration”**.
3. This opens your global `mcp.json` file.
4. Merge the `mcpServers` object from this repository’s [`.cursor/mcp.json`](.cursor/mcp.json) into your user configuration.

### Option 2: Workspace Configuration

Use this if you want MCP tools **only for a specific project**.

1. **Open this repository in Cursor** and enable the workspace MCP when prompted — **or** copy [`.cursor/mcp.json`](.cursor/mcp.json) into your target project (e.g. `my-project/.cursor/mcp.json`).
2. In **Settings → MCP**, enable the servers you need and restart Cursor.

### Build local server: `eversis-collections`

The template references a **local** server (not published to npm). Build it once per checkout:

```bash
cd mcp/eversis-collections-mcp
npm install && npm run build
```

Enable **`eversis-collections`** in **Settings → MCP** and **restart Cursor**.

- 🔌 **eversis-collections** — `eversis_skills_list` / `eversis_skills_get` load `.cursor/skills/` in Agent (`@eversis-implement`, `@eversis-review`; e.g. `eversis-qa-comment` on Fine).
- 📄 **Word tools** — `generate_summary_map`, `read_chapter`, `append_chapter`, … for `@eversis-ba-docs-planner` / `@eversis-ba-docs-writer`.
- 🛠 **Repo scripts** — `eversis_repo_run_script` (`sync-prompts`, `sync-framework-doc`) for contributors.

Use **only** the `eversis-collections` entry in `.cursor/mcp.json` for skills and Word tools together. Tool reference: [MCP README](mcp/eversis-collections-mcp/README.md). Consumer projects: `setup-cursor-local.sh --build-mcp` points at your `CURSOR_COLLECTIONS_HOME` checkout.

### Official Documentation

To learn more about configuring third-party servers, see their official documentation:

- [Atlassian MCP](https://support.atlassian.com/atlassian-rovo-mcp-server/docs/getting-started-with-the-atlassian-remote-mcp-server/)
- [Context7 MCP](https://github.com/upstash/context7)
- [Playwright MCP](https://github.com/microsoft/playwright-mcp)
- [Figma MCP](https://help.figma.com/hc/en-us/articles/32132100833559-Guide-to-the-Figma-MCP-server)
- [Sequential Thinking MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking)

Extended server list (PDF Reader, AWS, GCP): [integrations overview](website/docs/integrations/overview.md).

### Configuring Context7 API Key

For higher rate limits and private repositories, provide a Context7 API key from [context7.com/dashboard](https://context7.com/dashboard).

Cursor can use the `inputs` pattern in `mcp.json` to prompt for the key securely. Add `--api-key` with an input variable:

```json
{
  "mcpServers": {
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "@upstash/context7-mcp@latest",
        "--api-key",
        "${input:context7-api-key}"
      ]
    }
  },
  "inputs": [
    {
      "id": "context7-api-key",
      "description": "Context7 API Key (optional, for higher rate limits)",
      "type": "promptString",
      "password": true
    }
  ]
}
```

> **Note:** Server IDs in `mcp.json` are lowercase (e.g. `context7`, `figma`, `eversis-collections`). If you copied an older template with different names, update your configuration to match the current [`.cursor/mcp.json`](.cursor/mcp.json).

Full auth and OAuth details: [mcp-setup.md](website/docs/getting-started/mcp-setup.md).

### What each MCP is used for

- 🧩 **Atlassian MCP** — Jira and Confluence for `@eversis-implement`, `@eversis-review`, and research/planning; optional QA comment post after Fine.
- 🎨 **Figma MCP** — design context, components, and screenshots for UI implement and `@eversis-review-ui`.
- 📚 **Context7 MCP** — up-to-date library and framework documentation search.
- 🧪 **Playwright MCP** — browser interactions and end-to-end style checks from Agent.
- 🧠 **Sequential Thinking MCP** — structured reasoning for complex analysis (see below).
- 📄 **PDF Reader MCP** — workshop PDFs and attachments for `@eversis-analyze-materials`.
- ☁️ **AWS / GCP MCPs** — cloud APIs, docs, observability, and storage for DevOps and cost prompts.

> Some MCPs require **API keys or OAuth**. Configure authentication as described in each provider’s documentation.

### Sequential Thinking MCP

We use **Sequential Thinking MCP** to handle complex logic, reduce hallucinations, and ensure thorough problem analysis. It allows agents to:

- **Revise** previous thoughts when new information is found.
- **Branch** into alternative lines of thinking.
- **Track** progress through a complex task.

### Verify

After restart, open **Agent** and confirm tools appear (e.g. `eversis_skills_list` after building `eversis-collections`). Disable servers you do not use to reduce noise.

---

## 🧩 Using this framework in another repository

### Option 1 — Quick setup (script, recommended)

#### Step 1 — get `cursor-collections` (once per machine)

```bash
git clone https://github.com/PiotrNie-Eversis/cursor-collections.git \
  "$HOME/.local/share/cursor-collections"
```

Add to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
export CURSOR_COLLECTIONS_HOME="$HOME/.local/share/cursor-collections"
```

```bash
source ~/.zshrc   # or: source ~/.bashrc
```

#### Step 2 — bootstrap your project (once per project)

```bash
# New project:
mkdir ~/my-project && cd ~/my-project && git init

# Existing project:
cd ~/my-existing-project

# Run setup:
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --build-mcp
```

The script links or copies `.cursor/rules/`, `.cursor/prompts/`, `.cursor/commands/`, `.cursor/skills/` (symlinks on macOS/Linux by default); generates `.cursor/mcp.json`; creates `AGENTS.md` and `docs/specs/` if missing; and adds a managed `.gitignore` block for local-only framework files.

#### Keeping consumer projects aligned

When **cursor-collections** releases change (new prompts, rules, skills, MCP tools — e.g. README workflow or QA handoff updates), refresh your projects so they pick up the same framework version:

| Install mode | How to align after you `git pull` the framework |
| ------------ | ----------------------------------------------- |
| **Local + symlink** (default on macOS/Linux) | Update the shared checkout, rebuild MCP, re-run setup in each project |
| **Local + copy** (`--link-mode copy`, Windows default) | Update checkout + re-run with `--sync` |
| **Vendor submodule** | `git submodule update` in the consumer repo + re-run setup |
| **Vendor copy** | Re-run `setup-cursor-local.sh --vendor copy --build-mcp` |

**Typical local workflow (symlink mode):**

```bash
# 1. Update the framework checkout (once per machine)
cd "$CURSOR_COLLECTIONS_HOME"
git pull

# 2. Rebuild MCP if server code changed
cd mcp/eversis-collections-mcp && npm install && npm run build

# 3. Refresh each consumer project (refreshes .gitignore block, mcp.json merge)
cd ~/my-existing-project
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --build-mcp
```

**Copy-mode refresh** (when `.cursor/*` was copied, not symlinked):

```bash
cd "$CURSOR_COLLECTIONS_HOME" && git pull
cd ~/my-existing-project
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --link-mode copy --sync --build-mcp
```

**What updates automatically vs what stays yours**

| Path | Local symlink mode | You customize / commit |
| ---- | ------------------ | ---------------------- |
| Framework rules (`eversis-*.mdc` except stack) | Follows `CURSOR_COLLECTIONS_HOME` after `git pull` | Gitignored in consumer repo |
| Prompts, commands, skills | Symlinked to HOME — same pull | Gitignored |
| **`eversis-project-stack.mdc`** | Seeded once from template | **Commit in your project** — stack, lint, test commands |
| **`AGENTS.md`**, `docs/specs/`, `docs/context/` | Scaffolded if missing | Your team owns content |
| **`.cursor/mcp.json`** | Merged on re-run (local: absolute path to HOME) | Gitignored in local mode; committed in vendor mode |

Read [CHANGELOG.md](CHANGELOG.md) after pulling the framework to see what changed. Deep reference: [installation.md](website/docs/getting-started/installation.md), [cursor-collection.md — Part C](documentation/cursor-collection.md) (per-project bootstrap).

Optional — keep agent research/plan folders out of git:

```bash
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --build-mcp --gitignore-agent-artifacts
```

**Vendor mode** (team commits the same framework version):

```bash
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --vendor submodule --build-mcp
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --vendor copy --build-mcp
```

After setup: **Settings → MCP → enable `eversis-collections` → restart Cursor**.

See [`scripts/setup-cursor-local.sh --help`](scripts/setup-cursor-local.sh) and [Installation docs](website/docs/getting-started/installation.md) for Windows and all flags.

### Option 2 — Manual bootstrap

1. Copy or vendor **`.cursor/rules/`**; customize `eversis-project-stack.mdc`.
2. Copy or link **`.cursor/prompts/`**.
3. Add **`AGENTS.md`** and optional **`docs/specs/`**, **`docs/context/`** per [cursor-collection.md](documentation/cursor-collection.md).
4. Add **`.cursor/mcp.json`**; build and enable **`eversis-collections`** if you vendor skills.

---

## ⚙️ Framework customization

Attach the matching **`eversis-create-custom-*`** prompt to extend rules, skills, prompts, or [AGENTS.md](AGENTS.md). Authoring guides: [skills overview](website/docs/skills/overview.md), **`eversis-creating-skills`**, **`eversis-creating-prompts`**.

---

## 🤝 Contributing and changes

Notable changes: [CHANGELOG.md](CHANGELOG.md). When you add or edit prompts, rules, or skills with markdown links:

```bash
node scripts/validate-cursor-markdown-links.mjs --context=source
node scripts/validate-cursor-markdown-links.mjs --context=source --paths=README.md
```

After prompt changes: `cd website && npm run validate-cursor-links` (or `npm run build`). PRs touching **`.cursor/rules/**`** are checked by **`eversis_cursor_rules_validate`**.

**Docs site:** `npm start` / `npm run build` in [`website/`](website/) runs `sync-prompts` and link validation.

MIT licensed (see repository license file).

---

## 📚 Related documentation

| Resource | Purpose |
| -------- | ------- |
| [documentation/cursor-collection.md](documentation/cursor-collection.md) | Authoritative Cursor framework guide — reuse in any repo |
| [AGENTS.md](AGENTS.md) | Agent instructions for this repository |
| [mcp/eversis-collections-mcp/README.md](mcp/eversis-collections-mcp/README.md) | MCP server tools and Word editing reference |
| [website/docs/getting-started/start-here.md](website/docs/getting-started/start-here.md) | Curated docs onboarding checklist |
| [website/docs/getting-started/installation.md](website/docs/getting-started/installation.md) | Consumer installation (incl. Windows) |
| [website/docs/getting-started/mcp-setup.md](website/docs/getting-started/mcp-setup.md) | Workspace vs user MCP configuration |
| [website/docs/workflow/business-manager-docs.md](website/docs/workflow/business-manager-docs.md) | BA Docs planner/writer playbook |

---

© 2026 [Eversis](https://eversis.com)
