---
sidebar_position: 5
title: Software Engineer
---

# Software Engineer Agent

**Rule pack (canonical):** `.cursor/rules/eversis-role-software-engineer.mdc`  
**Delegated prompts:** `.cursor/prompts/internal/eversis-implement-common-task.md`, `.cursor/prompts/internal/eversis-implement-ui-common-task.md`, and related paths composed from **`@eversis-implement`**

The Software Engineer agent implements software solutions based on provided requirements and technical designs. It executes against implementation plans created by the Architect.

## Responsibilities

- Implementing code changes following the plan step by step.
- Writing clean, efficient, and maintainable code.
- Following best practices and coding standards.
- Adhering to security considerations and quality assurance guidelines from the plan.
- Reviewing own code to ensure it meets requirements.
- Communicating with the Architect when ambiguities arise.

## Key Behaviors

- **Strictly follows the plan** — Does not deviate unless explicitly instructed.
- **No dead code** — Does not create unused functions or future-only code.
- **No unnecessary files** — Focus on delivering required changes efficiently.
- **Well-documented** — Includes comments and documentation for future maintainability.

## Tool Access

| Tool | Usage |
| --- | --- |
| **Atlassian** | Search for task requirements and related context (search only) |
| **Context7** | Search API documentation, find solutions to errors, research best practices |
| **Figma** | Extract design specifications for frontend tasks |
| **Playwright** | Verify UI implementation by interacting with the running application |
| **Sequential Thinking** | Implement complex algorithms, debug issues, plan refactoring |
| **Terminal** | Run build tools, tests, linters, and scripts (`eversis-testing-and-terminal.mdc`) |
| **Cursor Agent** | Read, modify, and search workspace files |
| **Todo** | Track implementation progress with structured checklists |

## Skills Loaded

- `eversis-technical-context-discovering` — Establish project conventions and patterns before implementing.
- `eversis-implementation-gap-analysing` — Verify what exists vs what needs to be built.
- `eversis-codebase-analysing` — Understand existing architecture for complex features.
- `eversis-implementing-frontend` — Component patterns, composition, design tokens, Figma-to-code workflow.
- `eversis-implementing-forms` — Schema validation, field composition, error handling, multi-step form flows.
- `eversis-writing-hooks` — Custom hooks: naming, composition, stable returns, effect cleanup, testing.
- `eversis-ensuring-accessibility` — WCAG 2.1 AA compliance: semantic HTML, ARIA, keyboard navigation, focus management.
- `eversis-optimizing-frontend` — Code splitting, memoization, bundle size, rendering optimization, memory management.
- `eversis-ui-verifying` — Tolerances and structure checklist for Figma verification.
- `eversis-sql-and-database-understanding` — SQL queries, database schemas, migrations, ORM patterns.
- `eversis-engineering-prompts` — LLM prompt design: structure patterns, optimization, security, templates.

## Handoffs

After completing implementation, the Software Engineer can hand off to:

- **Code Reviewer** — **`@eversis-review`** (review implementation against the plan)
- **E2E Engineer** — when the plan delegates test work via **`.cursor/prompts/internal/eversis-implement-e2e.md`**
