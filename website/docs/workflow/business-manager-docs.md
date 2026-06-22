---
sidebar_position: 6
title: Business Manager Docs
---

# Business Manager Docs

Use this workflow when you need to **update large business or regulatory Word documents** (often `.docx` files with hundreds of pages) after a release — without pasting whole documents into the chat or destroying styles and tables.

It follows the same **relay race** idea as the rest of Cursor Collections: each phase produces a **reviewable artifact** (the “baton”), and humans approve before the next agent runs.

:::tip How this differs from Standard Flow
**[`eversis-implement`](./standard-flow)** is for **product code**: the Engineering Manager drives research → plan → implementation → review, often with UI or E2E verification.

**Business Manager Docs** is for **Word documentation**: a **Planner** builds `docs-update-plan.md` from **Confluence rules** and **Jira release** scope; after your approval, a **Writer** applies chapter-level edits via MCP tools. There is **no** dev-server URL step and **no** `eversis-review-ui` requirement.
:::

## When to Use It

- You have (or can generate) a **document map** — typically `summary.md` from `generate_summary_map` — for a `.docx` source of truth.
- Release work is tracked in **Jira**, and **documentation update rules** live in **Confluence** (read dynamically; not baked into a single static prompt).
- You need **incremental chapter edits** that preserve Word styling (avoid whole-document Markdown round-trips).

Normative requirements and milestones are recorded in the published spec: [**Business Docs Workflow (normative spec)**](../specs/business-docs-workflow) (§3.0 prompt vs rule contract).

## Architecture (High Level)

| Piece | Role |
| ----- | ---- |
| **Atlassian MCP** | Read **Confluence** pages for documentation rules; pull **Jira** issues for the named release or scope. |
| **`eversis-collections` MCP** | **`.docx` tools**: `generate_summary_map`, `read_chapter`, `update_chapter`, and `upload_to_sharepoint` (see server docs under `mcp/eversis-collections-mcp/`). Enable this server after a local build — see [MCP setup](../getting-started/mcp-setup) and [AGENTS.md](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/AGENTS.md). |
| **`summary.md`** | Navigation map for the physical `.docx` (structure / chapter identifiers for agents). Each section entry now includes `hasTables` and `hasImages` flags so the Planner can mark chapters that require special handling. |
| **`docs-update-plan.md`** | Planner output: which chapters change, what to change, and flags such as `[REQUIRES_GRAPHICS_UPDATE]` where diagrams need a human pass. Sections detected as `hasTables: true` should be labelled `TABLE-CONTAINS` to signal the Writer to use read-first / append rather than full replace. |

### Document format compatibility

The `.docx` engine automatically handles two common issues with non-English Word documents:

- **UTF-8 BOM** — MS Office on Windows (any locale) may write a BOM byte before `<?xml>`. The engine strips it before parsing so documents created on Polish, French, or other locale systems work without pre-processing.
- **Locale heading styles** — Word localises built-in style names (e.g. Polish `Nagwek1`–`Nagwek4`, French `Titre1`–`Titre4`). The engine reads `word/styles.xml` and maps every style ID to its canonical English name, so heading detection works correctly on any-language document.

### Editing safety

`update_chapter` **replaces** all paragraphs in a section — inline images and custom paragraph styles are lost. Follow the principle:

1. Always call `read_chapter` first to capture existing text.
2. For text-only additions, append new content to the existing text before passing to `update_chapter`.
3. For sections flagged `hasTables: true` or `hasImages: true` in `summary.md`, defer to a future `append_chapter` / `update_table_cell` tool (tracked in the BA Docs Workflow Evolution plan) or handle manually.

## Prompts vs Role Rules

Following Cursor Collections conventions:

- **Executable workflow (SOP)** — **`.cursor/prompts/public/eversis-ba-docs-*.md`**. In Cursor, attach with **`@`** and the file stem (e.g. **`@eversis-ba-docs-planner`**).
- **Role boundaries** — **`.cursor/rules/eversis-ba-docs-*.mdc`**. Attach when you want explicit MCP and scope discipline (`alwaysApply` is typically off).

Both are normative; if **`@`** does not pull in the rule, add the **`.mdc`** path explicitly (see [AGENTS.md](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/AGENTS.md)).

## Documentation channels (Word vs Repo)

Cursor Collections has **two separate documentation playbooks** — do not mix them:

| Channel | Prompts | Format | Typical trigger |
| ------- | ------- | ------ | ---------------- |
| **BA Docs (Word)** | `@eversis-ba-docs-planner` → `@eversis-ba-docs-writer` | `.docx` | Jira release + Confluence rules |
| **Repo Docs** | `@eversis-repo-docs-writer` | README, CHANGELOG, `website/docs`, `docs/` | Documentation task from `@eversis-implement` plan |

This page documents **BA Docs (Word)** only.

## Roles

### 1. Planner — BA Docs (Word)

- **Prompt:** **`@eversis-ba-docs-planner`**
- **Rule (optional):** **`eversis-ba-docs-planner.mdc`**
- **Inputs:** Jira release (or scope), Confluence page title for documentation rules, `summary.md` (or path to `.docx` to generate a map first).
- **Output:** **`docs-update-plan.md`**
- **Critical behavior:** Read **Confluence first** and use it as the decision matrix (e.g. N/A sections, version expectations), then map Jira work to chapters.

### 2. Writer — BA Docs (Word)

- **Prompt:** **`@eversis-ba-docs-writer`**
- **Rule (optional):** **`eversis-ba-docs-writer.mdc`**
- **Input:** Approved **`docs-update-plan.md`**
- **Output:** Updated `.docx` via `read_chapter` / `update_chapter`
- **Graphics flag:** Where the plan marks **`[REQUIRES_GRAPHICS_UPDATE]`**, follow the Writer prompt: leave a clear in-document marker for BA verification of UML/Visio-style diagrams (exact formatting depends on tooling; see spec §7.1 in the implementation plan discussion).

## Command Sequence

```text
1️⃣ @eversis-ba-docs-planner
   <release / scope> | <Confluence page for doc rules> | summary.md or path to .docx
   ↳ 📖 Read Confluence rules via Atlassian MCP
   ↳ 🔗 Pull Jira issues for the release
   ↳ 🗺️ Map impact to chapters using summary.md
   ↳ 📝 Produce docs-update-plan.md

2️⃣ Gate — Plan approval (human)
   ↳ 📖 Review docs-update-plan.md
   ↳ ✅ Approve, edit, or reject before any Writer run

3️⃣ @eversis-ba-docs-writer
   Implement updates per docs-update-plan.md (attach plan + rules if needed)
   ↳ 📖 read_chapter → edit → update_chapter (iterative)
   ↳ 💾 Save .docx; flag diagram rows for manual graphics review

4️⃣ Gate — Document review (human)
   ↳ 📖 Open Word outputs; fix diagrams/tables if needed
   ↳ 🚀 Publish via your org process (SharePoint / Confluence / etc.)
```

## Workflow Diagram

```
┌─────────────────────────────┐
│  Confluence (rules)         │
│  + Jira (release scope)      │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│  Planner (@ba-docs-planner) │
│  → docs-update-plan.md       │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│  ★ Human approves plan       │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│  Writer (@ba-docs-writer)    │
│  MCP: read/update chapters   │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│  ★ Human reviews .docx       │
│  → publish                   │
└─────────────────────────────┘
```

## Optional Slash Commands

If your workspace includes **`.cursor/commands/`**, you may have thin wrappers such as **`/eversis-ba-docs-planner`** and **`/eversis-ba-docs-writer`** — same prompts, faster invocation from Chat.

## Connecting to Other Flows

This workflow **does not replace** backlog or code delivery. Typical separation:

- **Ideate / backlog** — [`eversis-analyze-materials`](./workshop-flow) and Jira refinement.
- **Code delivery** — [`eversis-implement`](./standard-flow) → [`eversis-review`](./overview#3-review).
- **Regulatory or BA Word docs after release** — **Business Manager Docs** (this page).

:::warning Important
Treat every Planner output and every Writer save as a **draft** until a human approves. AI assistance does not remove accountability for regulated or customer-facing documentation.
:::
