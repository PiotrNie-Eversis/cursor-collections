---
sidebar_position: 4
title: Engineering Manager
---

# Engineering Manager Agent

**Rule pack (canonical):** `.cursor/rules/eversis-role-engineering-manager.mdc`  
**In this repository:** attach **`.cursor/rules/eversis-engineering-manager.mdc`** when running **`@website/docs/prompts/public/eversis-implement.md`**.

The Engineering Manager orchestrates the **Implement** phase: it does not replace implementers — it follows the approved plan, delegates work by task type, and enforces human gates from **`eversis-agent-core.mdc`** (approve research, then plan, then code).

## Delegation flow

```
Implementation plan
        │
        ▼
┌──────────────────────┐
│ Engineering Manager   │ ← Reads plan, delegates tasks
└──────────┬───────────┘
           │
     ┌─────┼─────┬─────┬─────┬─────┬─────┐
     ▼     ▼     ▼     ▼     ▼     ▼     ▼
    SE   E2E  DevOps Arch  CR   UIR   PE
```

The Engineering Manager is bound to the public prompt **`@website/docs/prompts/public/eversis-implement.md`**. When you run it, it parses the implementation plan, identifies individual tasks, and routes each one to the appropriate specialized role. For UI tasks with Figma references, it uses the internal prompt **`website/docs/prompts/internal/eversis-implement-ui.md`** to orchestrate the verification loop (including **`@website/docs/prompts/public/eversis-review-ui.md`** when visual checks are required).

## Agent Delegation

| Role | Handles | When used |
| --- | --- | --- |
| **Software Engineer** | Application code, features, bug fixes | Task involves writing or modifying application code |
| **E2E Engineer** | Playwright E2E | Task requires writing or updating E2E test suites |
| **DevOps Engineer** | Infrastructure, CI/CD, deployments | Task involves infrastructure changes or pipeline configuration |
| **Architect** | Codebase analysis, technical context | Before implementation starts, to establish codebase understanding (via `eversis-plan.md`) |
| **Code Reviewer** | Code quality, best practices | After implementation completes, or when no review phase is defined |
| **Prompt Engineer** | LLM application prompts | Task involves designing, optimizing, or securing LLM prompts |
| **UI Reviewer** | Figma verification, visual correctness | After UI implementation, to verify against design specifications |

## How to Use

Attach **`@website/docs/prompts/public/eversis-implement.md`**, optionally **`@.cursor/rules/eversis-engineering-manager.mdc`**, plus ticket text and `@docs/specs/` / `@docs/context/` as needed. The model follows internal prompts such as **`website/docs/prompts/internal/eversis-research.md`**, **`website/docs/prompts/internal/eversis-plan.md`**, and task-specific **`eversis-implement-*.md`** files.

See also the [Implement workflow](../prompts/public/implement) documentation page.

## Tool Access

| Tool | Usage |
| --- | --- |
| **Atlassian** | Gathers Jira tickets and Confluence documentation for task context |
| **Sequential Thinking** | Decides which agent to delegate to when the task type is ambiguous |
| **Terminal** | Runs commands to verify environment state |
| **Cursor Agent** | Navigates the codebase and implementation plan |
| **Todo** | Tracks task completion within the plan |

## Key Behaviors

- **Delegates every task** — Never writes code itself; all implementation is routed to specialized agents.
- **Routes based on task type** — Application code → Software Engineer, E2E tests → E2E Engineer, infrastructure → DevOps Engineer, LLM prompts → Prompt Engineer.
- **Packages context automatically** — Each delegation includes structured context from the implementation plan.
- **Runs codebase analysis first** — Invokes the [Architect](./architect) to establish technical context before starting implementation.
- **Respects human gates** — Stops for approval after research and after planning before broad code changes (`eversis-agent-core.mdc`).
- **Auto-triggers Code Reviewer** — Automatically runs the Code Reviewer at the end of implementation if no review phase is defined in the plan.
- **Tracks progress** — Updates plan checkboxes after each completed task.
- **Asks before deviating** — Requests user confirmation before deviating from the implementation plan.
- **Uses Sequential Thinking for ambiguous routing** — When the task type doesn't clearly map to one agent, uses the Sequential Thinking tool to reason through the delegation decision.

## Handoffs

- **From** [Architect](./architect) — execution against the signed-off plan.
- **To** [Code Reviewer](./code-reviewer) — **`@website/docs/prompts/public/eversis-review.md`** with **`eversis-code-reviewer.mdc`** when appropriate.
- **To** [UI Reviewer](./ui-reviewer) — **`@website/docs/prompts/public/eversis-review-ui.md`** for visual verification.
