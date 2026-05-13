---
sidebar_position: 12
title: "BA docs — Writer"
slug: ba-docs-writer
prompt_role: "Technical writer (Word)"
prompt_description: "Apply docs-update-plan.md to .docx via eversis-collections MCP (.docx tools)."
upstream_agent: "eversis-ba-docs-writer"
---
# eversis-ba-docs-writer

**Role:** Documentation implementer (Word)  
**File:** `.cursor/prompts/public/eversis-ba-docs-writer.md`

Applies an **approved** `docs-update-plan.md` to `.docx` files using **eversis-collections MCP** (`.docx` tools — do not paste whole documents into chat).

## Usage

```text
@eversis-ba-docs-writer
@docs-update-plan.md | path to .docx
```

Attach the **approved** plan. Optionally attach **`.cursor/rules/eversis-ba-docs-writer.mdc`**. Ensure **eversis-collections** MCP is enabled (includes `.docx` tools). Enable **Atlassian** only if you need to re-fetch context — Writer normally does not edit Confluence rules.

<workflow>

1. **Human gate** — Confirm `docs-update-plan.md` is **accepted by the BA** after Planner. If the user has not confirmed, **stop** and ask them to approve or revise the plan first (aligned with `eversis-agent-core.mdc` relay).

2. **Iterate the plan** — For each section in `docs-update-plan.md`, call **`read_chapter`** as needed, draft **business-language** replacement text (translate technical jargon per plan/rules), then **`update_chapter`**.

3. **Graphics flag** — Where the plan has **`[WYMAGA_AKTUALIZACJI_GRAFIKI]`**, insert the agreed placeholder text and apply **warning styling** (e.g. red + bold) per product decision — native Word review comments may not be available through plain OOXML body replacement (see implementation plan §7.1).

4. **Versions / metadata** — Apply version or status updates only as required by the **Confluence** rules the Planner already used (do not invent policy).

5. **Finish** — Save changes to `.docx`; remind the human to visually verify tables, numbering, and diagrams before SharePoint/Confluence upload.

</workflow>

## Related

- **Planner prompt:** `@eversis-ba-docs-planner`
- **Spec:** `docs/specs/business-docs-workflow/business-docs-workflow.spec.md`

<!-- Eversis — BA documentation relay -->
