---
sidebar_position: 1
title: Business Docs Workflow (normative spec)
---

# Design Specification: Business Documentation Update Automation (Business Manager Docs)

Normative requirements for the [Business Manager Docs workflow](../workflow/business-manager-docs). Playbook and command sequence live on that page; this document is the SSOT for roles, rules, and milestones.

## 1. Context and Business Goal

- **Problem:** Manually updating extensive project documents (e.g. `.docx` files over 400 pages, such as COS2, WUM, or DAWIS) after each TTO/Release is time-consuming, error-prone, and requires tedious mapping of code/Jira task changes to non-technical business language.
- **Goal:** Create a fully integrated Cursor IDE workflow, based on AI agents and a **Relay Race** architecture, that reduces documentation update time by 70% while preserving the original formatting of base documents (including table structure and diagrams).

## 2. Solution Architecture

In line with Cursor Collections framework principles, the process avoids holding the entire document in the context window and relies on server-side tools. The **"Single Source of Truth"** approach ensures that document guidelines are loaded dynamically from external sources (Confluence).

### 2.1. Main Components

- **Atlassian MCP Server** (Key element integrating Jira and Confluence):
- **Issues (Jira):** Used to fetch raw business context (Epics, Tasks, Release comments) from Jira.
- **Business rules (Confluence):** Used to dynamically fetch current documentation update rules for a given project (e.g. "DAWIS Documentation Definitions & Updating Rules").

- **`.docx` tools on the `eversis-collections` MCP server** (`mcp/eversis-collections-mcp/`, Node: JSZip + `@xmldom/xmldom` on `word/document.xml`): Safe interaction with `.docx` files while preserving styles (without a full round-trip through Pandoc).
- `generate_summary_map(docx_path)` -> Creates the navigation file `summary.md`.
- `read_chapter(docx_path, chapter_id)` -> Retrieves the content of a specific chapter.
- `update_chapter(docx_path, chapter_id, new_content)` -> Overwrites the content.
- `upload_to_sharepoint(docx_path)` -> Publication after approval.

- **Navigation file (summary.md):** Roadmap of the physical `.docx` document. Contains the table of contents and tags for the Agent, enabling fast structural navigation.

## 3. Roles and Instructions (Cursor: prompts + rules)

The workflow relies on two specialized agents working together and communicating through a shared artifact (`docs-update-plan.md`).

### 3.0. Prompts (`@eversis-ba-docs-*`) vs rules (`.mdc`) in Cursor Collections

Following **Cursor Collections** monorepo convention, we separate:

- **Public prompt** — `.cursor/prompts/public/eversis-*.md`: **executable workflow** content (Docusaurus frontmatter + SOP steps). In Cursor, **`@` + file stem** (e.g. `@eversis-ba-docs-planner`) usually resolves **this prompt**.
- **Role rule** — `.cursor/rules/eversis-*.mdc`: **who the agent is**, boundaries, MCP tool behavior; attached on demand (**`@`** to the `.mdc` file or picker selection), often with `alwaysApply: false`.

In practice for this workflow **both artifacts are normative**: the prompt starts the track; the rule reinforces the role and framework consistency. If `@` does not pull both into one session, the user **explicitly attaches** the second file (full path under `.cursor/…`), as in [AGENTS.md](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/AGENTS.md).

### Role 1: Lead Analyst (Planner)

- **Prompt (workflow):** `.cursor/prompts/public/eversis-ba-docs-planner.md`
- **Role rule:** `.cursor/rules/eversis-ba-docs-planner.mdc`
- **Responsibility:** Understand the Release scope, verify Confluence guidelines, and map changes to the appropriate document sections.
- **Input:** Jira Release ID + Confluence page title with update rules + `summary.md` file.
- **Output:** `docs-update-plan.md` artifact.
- **Rules:**

1. **[CRITICAL STEP]** Before analyzing tasks from the Release, use the Atlassian MCP tool to read the Confluence page (e.g. "DAWIS Documentation Definitions & Updating Rules"). Use these rules as a decision matrix defining update boundary conditions (e.g. whether a document gets "N/A" status, version requirements).
2. Use Atlassian MCP to fetch all tasks linked to the Release in Jira.
3. Identify which tasks affect business requirements and align them with the `summary.md` table of contents.
4. Mark document chapter numbers that require updates and briefly describe WHAT must be changed.
5. If a change affects architecture/a UML/Visio diagram, add the flag `[REQUIRES_GRAPHICS_UPDATE]` to the plan.

### Role 2: Technical Writer (Implementer)

- **Prompt (workflow):** `.cursor/prompts/public/eversis-ba-docs-writer.md`
- **Role rule:** `.cursor/rules/eversis-ba-docs-writer.mdc`
- **Responsibility:** Physical content update in the `.docx` file using Eversis Docs MCP tools.
- **Input:** `docs-update-plan.md` file.
- **Output:** Modified document ready for verification.
- **Rules:**

1. Work iteratively. Read the `docs-update-plan.md` plan section by section.
2. Use the `read_chapter` tool, modify the text, translating any technical language into system behavior descriptions.
3. Use the `update_chapter` tool to save the change.
4. Where you encounter the flag `[REQUIRES_GRAPHICS_UPDATE]`, insert a clear, red text comment in the Word document: `>>> FOR BA REVIEW: CHECK AND UPDATE DIAGRAM ACCORDING TO RELEASE <<<`.

## 4. Workflow (Relay Race)

Operating procedure (SOP) from the perspective of a Business Analyst using Cursor:

### Step 1: Research and Planning

1. **Human:** Enters a command in the chat/Composer window with the workflow prompt attached (stem matches the file from §3.0), e.g.:
   `@eversis-ba-docs-planner Prepare a DAWIS documentation update plan for Release 2.4.5. Project rules are on the Confluence page "DAWIS Documentation Definitions & Updating Rules".`
   If needed, **additionally** attaches the role rule `.cursor/rules/eversis-ba-docs-planner.mdc` (full path) when the session must enforce the role description from `.mdc`.
2. **Agent (Planner):** Fetches rules from Confluence via MCP, then fetches tasks from Jira (Release 2.4.5), filters them according to the fetched rules, and generates a ToDo list in `docs-update-plan.md`.
3. **Verification gate (Human):** BA reviews the generated plan. Rejects, corrects, or approves the Agent's conclusions in the markdown file.

### Step 2: Execution (Implementing Changes)

1. **Human:** Issues a command to the second agent (Writer prompt from §3.0), optionally with parallel attachment of `.cursor/rules/eversis-ba-docs-writer.mdc`:
   `@eversis-ba-docs-writer Implement changes to the relevant documents according to the plan in docs-update-plan.md`
2. **Agent (Writer):** Using its MCP (responsible for documents), opens specific Word documents, updates the indicated chapters, assigns new version numbers (according to rules extracted in Step 1), and saves the files.

### Step 3: Review and Publication

1. **Human:** Reviews the finished `.docx` files (paying special attention to red markers at UML/Visio diagrams). Makes any manual corrections to graphics.
2. **Human:** Invokes the script/command that sends files to the target SharePoint or Confluence.

## 5. Implementation Milestones

- [ ] **Phase 1:** Create in the repository **pairs: public prompt** (`.cursor/prompts/public/eversis-ba-docs-*.md`) + **role rule** (`.cursor/rules/eversis-ba-docs-*.mdc`) for Planner and Writer; prompts direct among other things to fetching rules from Confluence (see §3.0).
- [ ] **Phase 2:** Configure the Atlassian MCP server and add Confluence token access (to read spaces with DAWIS / COS2 documentation).
- [ ] **Phase 3:** Create the Eversis Docs MCP server in Python (`python-docx`), capable of reading and editing text while preserving styles (instead of Markdown format).
- [ ] **Phase 4:** Prepare a script or MCP action that generates the navigation file `summary.md` (table of contents and `.docx` file metadata).
- [ ] **Phase 5:** Run a dry-run (E2E) test updating a document from a historical sprint and compare the result with work done manually by a human.
