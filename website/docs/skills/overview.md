---
sidebar_position: 1
title: Skills Overview
---

# Skills Overview

Cursor Collections includes **32 reusable skills** — knowledge modules that provide specialized domain expertise, structured processes, and quality templates. They encode tested best practices for every phase of the product lifecycle. Skills are stored in `.github/skills/`. In Agent, use them through the **`eversis-collections` MCP** server (**`eversis_skills_list`**, **`eversis_skills_get`**, **`eversis_skill_run_script`** for allowlisted per-skill scripts, and related tools) after building [`mcp/eversis-collections-mcp/`](https://github.com/PiotrNie-Eversis/cursor-collections/tree/main/mcp/eversis-collections-mcp); do not register the folder separately as Cursor **Agent Skills** for this framework.

## How Skills Work

Each skill folder contains a `SKILL.md` file with:

- **Domain-specific guidelines** — Best practices, checklists, and processes.
- **Templates** — Example output formats (e.g., `plan.example.md`, `research.example.md`).
- **Connected skills** — References to other skills that complement or support this one.

When an agent needs specialized procedures, it can pull **`SKILL.md` content** via **MCP** (e.g. `eversis_skills_get`), run **allowlisted automation** under a skill via **`eversis_skill_run_script`** when one is registered for that topic, or follow rules and prompts. Multiple skills can be combined for tasks spanning different domains.

## Available Skills

### 📋 Product Ideation Skills

| Skill                                                | Description                                            | Used By                        |
| ---------------------------------------------------- | ------------------------------------------------------ | ------------------------------ |
| [eversis-task-analysing](./task-analysis)                | Task context gathering and research                    | Context Engineer, E2E Engineer |
| [eversis-transcript-processing](./transcript-processing) | Workshop transcript cleaning and structuring           | Business Analyst               |
| [eversis-task-extracting](./task-extraction)             | Epic and user story extraction from workshop materials | Business Analyst               |
| [eversis-task-quality-reviewing](./task-quality-review)  | Quality analysis for extracted task lists              | Business Analyst               |
| [eversis-jira-task-formatting](./jira-task-formatting)   | Jira-ready task formatting and import/push management  | Business Analyst               |

### 🛠 Development Skills

| Skill                                                              | Description                                                   | Used By                    |
| ------------------------------------------------------------------ | ------------------------------------------------------------- | -------------------------- |
| [eversis-architecture-designing](./architecture-design)                | Solution architecture design and implementation plan creation | Architect                  |
| [eversis-technical-context-discovering](./technical-context-discovery) | Project conventions and pattern discovery                     | Architect, CR, SE, E2E, CE |
| [eversis-implementing-frontend](./frontend-implementation)             | UI component patterns, composition, design tokens             | Software Engineer          |
| [eversis-implementing-forms](./implementing-forms)                     | Form architecture, schema validation, multi-step flows        | Software Engineer          |
| [eversis-writing-hooks](./writing-hooks)                               | Custom hook/composable patterns, lifecycle, testing           | Software Engineer          |
| [eversis-ensuring-accessibility](./ensuring-accessibility)             | WCAG 2.1 AA compliance, semantic HTML, ARIA, keyboard nav     | Software Engineer          |
| [eversis-optimizing-frontend](./optimizing-frontend)                   | Rendering optimization, code splitting, bundle size           | Software Engineer          |
| [eversis-implementation-gap-analysing](./implementation-gap-analysis)  | Gap analysis between plan and current state                   | Architect, CR, SE          |
| [eversis-sql-and-database-understanding](./sql-and-database)           | Database engineering standards and ORM integration            | Architect, CR, SE          |
| [eversis-codebase-analysing](./codebase-analysis)                      | Deep codebase analysis and dependency mapping                 | Architect, BA, CE, SE      |
| [eversis-engineering-prompts](./prompt-engineering)                    | LLM prompt design, optimization, security, and evaluation     | PE, SE, Architect, CR      |

### ☁️ Cloud & Infrastructure Skills

| Skill                                                                | Description                                                                       | Used By                    |
| -------------------------------------------------------------------- | --------------------------------------------------------------------------------- | -------------------------- |
| [eversis-implementing-ci-cd](./ci-cd-implementation)                     | CI/CD pipeline design patterns and deployment strategies                          | DevOps Engineer            |
| [eversis-implementing-kubernetes](./kubernetes-implementation)           | Kubernetes deployment patterns, Helm charts, and cluster management               | DevOps Engineer            |
| [eversis-implementing-terraform-modules](./terraform-modules)            | Reusable Terraform modules for AWS, Azure, and GCP infrastructure                 | DevOps Engineer            |
| [eversis-implementing-observability](./observability-implementation)     | Observability patterns for logging, monitoring, alerting, and distributed tracing | DevOps Engineer            |
| [eversis-managing-secrets](./secrets-management)                         | Secrets management patterns for cloud and Kubernetes environments                 | DevOps Engineer            |
| [eversis-optimizing-cloud-cost](./cloud-cost-optimization)               | Cloud cost optimization through rightsizing, tagging, and spending analysis       | DevOps Engineer            |
| [eversis-designing-multi-cloud-architecture](./multi-cloud-architecture) | Multi-cloud architecture design across AWS, Azure, and GCP                        | DevOps Engineer, Architect |

### ✅ Quality Skills

| Skill                                          | Description                                                  | Used By         |
| ---------------------------------------------- | ------------------------------------------------------------ | --------------- |
| [eversis-code-reviewing](./code-review)            | Structured code review process                               | Code Reviewer   |
| [eversis-reviewing-frontend](./reviewing-frontend) | Frontend-specific review: components, hooks, rendering, a11y | Code Reviewer   |
| [eversis-ui-verifying](./ui-verification)          | Figma vs implementation verification criteria                | UI Reviewer, SE |
| [eversis-e2e-testing](./e2e-testing)               | Playwright E2E testing patterns and verification             | E2E Engineer    |

### ⚙️ Framework customization skills

| Skill                                                | Description                                  | Used By              |
| ---------------------------------------------------- | -------------------------------------------- | -------------------- |
| [eversis-creating-agents](./creating-agents)             | Creating Cursor rules (`.mdc`) and role docs | Framework maintainer |
| [eversis-creating-skills](./creating-skills)             | Creating custom skills (SKILL.md)            | Framework maintainer |
| [eversis-creating-prompts](./creating-prompts)           | Creating attachable repo prompts (Markdown)  | Framework maintainer |
| [eversis-creating-instructions](./creating-instructions) | Project instructions (AGENTS.md, rules)      | Framework maintainer |

## Agent–Skill Matrix

| Skill                                  | BA  | CE  | Architect | SE  | PE  | CR  | UI Reviewer | E2E | DevOps | Customize |
| -------------------------------------- | --- | --- | --------- | --- | --- | --- | ----------- | --- | ------ | --------- |
| eversis-architecture-designing             |     |     | ✅        |     |     |     |             |     |        |           |
| eversis-code-reviewing                     |     |     |           |     | ✅  | ✅  |             |     |        |           |
| eversis-codebase-analysing                 | ✅  | ✅  | ✅        | ✅  |     |     |             |     | ✅     | ✅        |
| eversis-creating-agents                    |     |     |           |     |     |     |             |     |        | ✅        |
| eversis-creating-instructions              |     |     |           |     |     |     |             |     |        | ✅        |
| eversis-creating-prompts                   |     |     |           |     |     |     |             |     |        | ✅        |
| eversis-creating-skills                    |     |     |           |     |     |     |             |     |        | ✅        |
| eversis-designing-multi-cloud-architecture |     |     | ✅        |     |     |     |             |     | ✅     |           |
| eversis-e2e-testing                        |     |     |           |     |     |     |             | ✅  |        |           |
| eversis-engineering-prompts                |     |     | ✅        | ✅  | ✅  | ✅  |             |     |        |           |
| eversis-ensuring-accessibility             |     |     |           | ✅  |     |     |             |     |        |           |
| eversis-implementing-ci-cd                 |     |     | ✅        |     |     |     |             |     | ✅     |           |
| eversis-implementing-forms                 |     |     |           | ✅  |     |     |             |     |        |           |
| eversis-implementing-frontend              |     |     |           | ✅  |     |     |             |     |        |           |
| eversis-implementing-kubernetes            |     |     | ✅        |     |     |     |             |     | ✅     |           |
| eversis-implementing-observability         |     |     | ✅        |     |     |     |             |     | ✅     |           |
| eversis-implementing-terraform-modules     |     |     | ✅        |     |     |     |             |     | ✅     |           |
| eversis-implementation-gap-analysing       |     |     | ✅        | ✅  |     | ✅  |             |     |        |           |
| eversis-jira-task-formatting               | ✅  |     |           |     |     |     |             |     |        |           |
| eversis-managing-secrets                   |     |     | ✅        |     |     |     |             |     | ✅     |           |
| eversis-optimizing-cloud-cost              |     |     | ✅        |     |     |     |             |     | ✅     |           |
| eversis-optimizing-frontend                |     |     |           | ✅  |     |     |             |     |        |           |
| eversis-reviewing-frontend                 |     |     |           |     |     | ✅  |             |     |        |           |
| eversis-sql-and-database-understanding     |     |     | ✅        | ✅  |     | ✅  |             |     |        |           |
| eversis-task-analysing                     |     | ✅  |           |     |     |     |             | ✅  |        |           |
| eversis-task-extracting                    | ✅  |     |           |     |     |     |             |     |        |           |
| eversis-task-quality-reviewing             | ✅  |     |           |     |     |     |             |     |        |           |
| eversis-technical-context-discovering      |     | ✅  | ✅        | ✅  | ✅  | ✅  |             | ✅  | ✅     | ✅        |
| eversis-transcript-processing              | ✅  |     |           |     |     |     |             |     |        |           |
| eversis-ui-verifying                       |     |     |           | ✅  |     |     | ✅          |     |        |           |
| eversis-writing-hooks                      |     |     |           | ✅  |     |     |             |     |        |           |

## Loading Priority

Skills follow a strict priority hierarchy:

1. **Project constitution** — [AGENTS.md](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/AGENTS.md) and **`.cursor/rules/*.mdc`** (highest priority for behavior).
2. **Existing codebase patterns** — replicate established conventions.
3. **Skill guidelines** — domain best practices and templates.
4. **External documentation** — framework docs, OWASP, industry standards.

This ensures consistency: existing patterns are never overridden unless explicitly requested.
