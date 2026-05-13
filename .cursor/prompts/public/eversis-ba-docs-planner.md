---
sidebar_position: 11
title: "BA docs — Planner"
slug: ba-docs-planner
prompt_role: "Business analyst (documentation)"
prompt_description: "Build docs-update-plan.md from Confluence rules, a Jira release, and summary.md."
upstream_agent: "eversis-ba-docs-planner"
---
# eversis-ba-docs-planner

**Role:** Documentation planner (BA)  
**File:** `.cursor/prompts/public/eversis-ba-docs-planner.md`

Produces `docs-update-plan.md`: which document chapters to update after a release, aligned with **Confluence** documentation rules and **Jira** release scope.

## Usage

```text
@eversis-ba-docs-planner
<Jira release id or version> | Confluence page title for doc rules | path or @ to summary.md
```

In **Cursor**, attach this prompt. Optionally attach **`.cursor/rules/eversis-ba-docs-planner.mdc`** so role boundaries apply. Enable **Atlassian MCP** (Jira + Confluence).

<workflow>

1. **Human gate (planning)** — Treat this run as producing a **draft** artifact. The BA must **review and approve** `docs-update-plan.md` before anyone runs **`@eversis-ba-docs-writer`** (same relay idea as `eversis-agent-core.mdc`: no execution on unapproved plan).

2. **Confluence first (critical)** — Using Atlassian MCP, read the Confluence page the user named (documentation definitions / update rules). Use it as the **decision matrix** (N/A docs, version rules, formatting expectations).

3. **Jira release** — Fetch issues linked to the release the user specified; filter to what affects **business / regulatory documentation** per the Confluence rules.

4. **Map to `summary.md`** — Use the user-supplied `summary.md` (document map) to match issues to **chapter_id** / section identifiers. If `summary.md` is missing, say so and stop or offer to call **`generate_summary_map`** via **eversis-collections** MCP if a `.docx` path is available.

5. **Write `docs-update-plan.md`** — Structured markdown: per chapter (or chapter_id), short **what to change**, and add **`[WYMAGA_AKTUALIZACJI_GRAFIKI]`** where UML/Visio/architecture diagrams need a human pass.

6. **Stop** — Output the file path or full content of `docs-update-plan.md` and remind the human: **do not start Writer until this plan is accepted.**

</workflow>

## Related

- **Spec:** `docs/specs/business-docs-workflow/business-docs-workflow.spec.md`
- **Writer prompt:** `@eversis-ba-docs-writer`

<!-- Eversis — BA documentation relay -->
