---
sidebar_position: 1
title: Skills Overview
---

# Skills Overview

Cursor Collections includes **32 reusable skills** — knowledge modules that provide specialized domain expertise, structured processes, and quality templates. They encode tested best practices for every phase of the product lifecycle. Skills are stored in `.github/skills/`. In Agent, use them through the **`eversis-collections` MCP** server (**`eversis_skills_list`**, **`eversis_skills_get`**, and related tools) after building [`mcp/eversis-collections-mcp/`](https://github.com/PiotrNie-Eversis/cursor-collections/tree/main/mcp/eversis-collections-mcp); do not register the folder separately as Cursor **Agent Skills** for this framework.

## How Skills Work

Each skill folder contains a `SKILL.md` file with:

- **Domain-specific guidelines** — Best practices, checklists, and processes.
- **Templates** — Example output formats (e.g., `plan.example.md`, `research.example.md`).
- **Connected skills** — References to other skills that complement or support this one.

When an agent needs specialized procedures, it can pull **`SKILL.md` content** via **MCP** (e.g. `eversis_skills_get`) or follow rules and prompts. Multiple skills can be combined for tasks spanning different domains.

## Available Skills

### 📋 Product Ideation Skills

| Skill                                                | Description                                            | Used By                        |
| ---------------------------------------------------- | ------------------------------------------------------ | ------------------------------ |
| [tsh-task-analysing](./task-analysis)                | Task context gathering and research                    | Context Engineer, E2E Engineer |
| [tsh-transcript-processing](./transcript-processing) | Workshop transcript cleaning and structuring           | Business Analyst               |
| [tsh-task-extracting](./task-extraction)             | Epic and user story extraction from workshop materials | Business Analyst               |
| [tsh-task-quality-reviewing](./task-quality-review)  | Quality analysis for extracted task lists              | Business Analyst               |
| [tsh-jira-task-formatting](./jira-task-formatting)   | Jira-ready task formatting and import/push management  | Business Analyst               |

### 🛠 Development Skills

| Skill                                                              | Description                                                   | Used By                    |
| ------------------------------------------------------------------ | ------------------------------------------------------------- | -------------------------- |
| [tsh-architecture-designing](./architecture-design)                | Solution architecture design and implementation plan creation | Architect                  |
| [tsh-technical-context-discovering](./technical-context-discovery) | Project conventions and pattern discovery                     | Architect, CR, SE, E2E, CE |
| [tsh-implementing-frontend](./frontend-implementation)             | UI component patterns, composition, design tokens             | Software Engineer          |
| [tsh-implementing-forms](./implementing-forms)                     | Form architecture, schema validation, multi-step flows        | Software Engineer          |
| [tsh-writing-hooks](./writing-hooks)                               | Custom hook/composable patterns, lifecycle, testing           | Software Engineer          |
| [tsh-ensuring-accessibility](./ensuring-accessibility)             | WCAG 2.1 AA compliance, semantic HTML, ARIA, keyboard nav     | Software Engineer          |
| [tsh-optimizing-frontend](./optimizing-frontend)                   | Rendering optimization, code splitting, bundle size           | Software Engineer          |
| [tsh-implementation-gap-analysing](./implementation-gap-analysis)  | Gap analysis between plan and current state                   | Architect, CR, SE          |
| [tsh-sql-and-database-understanding](./sql-and-database)           | Database engineering standards and ORM integration            | Architect, CR, SE          |
| [tsh-codebase-analysing](./codebase-analysis)                      | Deep codebase analysis and dependency mapping                 | Architect, BA, CE, SE      |
| [tsh-engineering-prompts](./prompt-engineering)                    | LLM prompt design, optimization, security, and evaluation     | PE, SE, Architect, CR      |

### ☁️ Cloud & Infrastructure Skills

| Skill                                                                | Description                                                                       | Used By                    |
| -------------------------------------------------------------------- | --------------------------------------------------------------------------------- | -------------------------- |
| [tsh-implementing-ci-cd](./ci-cd-implementation)                     | CI/CD pipeline design patterns and deployment strategies                          | DevOps Engineer            |
| [tsh-implementing-kubernetes](./kubernetes-implementation)           | Kubernetes deployment patterns, Helm charts, and cluster management               | DevOps Engineer            |
| [tsh-implementing-terraform-modules](./terraform-modules)            | Reusable Terraform modules for AWS, Azure, and GCP infrastructure                 | DevOps Engineer            |
| [tsh-implementing-observability](./observability-implementation)     | Observability patterns for logging, monitoring, alerting, and distributed tracing | DevOps Engineer            |
| [tsh-managing-secrets](./secrets-management)                         | Secrets management patterns for cloud and Kubernetes environments                 | DevOps Engineer            |
| [tsh-optimizing-cloud-cost](./cloud-cost-optimization)               | Cloud cost optimization through rightsizing, tagging, and spending analysis       | DevOps Engineer            |
| [tsh-designing-multi-cloud-architecture](./multi-cloud-architecture) | Multi-cloud architecture design across AWS, Azure, and GCP                        | DevOps Engineer, Architect |

### ✅ Quality Skills

| Skill                                          | Description                                                  | Used By         |
| ---------------------------------------------- | ------------------------------------------------------------ | --------------- |
| [tsh-code-reviewing](./code-review)            | Structured code review process                               | Code Reviewer   |
| [tsh-reviewing-frontend](./reviewing-frontend) | Frontend-specific review: components, hooks, rendering, a11y | Code Reviewer   |
| [tsh-ui-verifying](./ui-verification)          | Figma vs implementation verification criteria                | UI Reviewer, SE |
| [tsh-e2e-testing](./e2e-testing)               | Playwright E2E testing patterns and verification             | E2E Engineer    |

### ⚙️ Framework customization skills

| Skill                                                | Description                                  | Used By              |
| ---------------------------------------------------- | -------------------------------------------- | -------------------- |
| [tsh-creating-agents](./creating-agents)             | Creating Cursor rules (`.mdc`) and role docs | Framework maintainer |
| [tsh-creating-skills](./creating-skills)             | Creating custom skills (SKILL.md)            | Framework maintainer |
| [tsh-creating-prompts](./creating-prompts)           | Creating attachable repo prompts (Markdown)  | Framework maintainer |
| [tsh-creating-instructions](./creating-instructions) | Project instructions (AGENTS.md, rules)      | Framework maintainer |

## Agent–Skill Matrix

| Skill                                  | BA  | CE  | Architect | SE  | PE  | CR  | UI Reviewer | E2E | DevOps | Customize |
| -------------------------------------- | --- | --- | --------- | --- | --- | --- | ----------- | --- | ------ | --------- |
| tsh-architecture-designing             |     |     | ✅        |     |     |     |             |     |        |           |
| tsh-code-reviewing                     |     |     |           |     | ✅  | ✅  |             |     |        |           |
| tsh-codebase-analysing                 | ✅  | ✅  | ✅        | ✅  |     |     |             |     | ✅     | ✅        |
| tsh-creating-agents                    |     |     |           |     |     |     |             |     |        | ✅        |
| tsh-creating-instructions              |     |     |           |     |     |     |             |     |        | ✅        |
| tsh-creating-prompts                   |     |     |           |     |     |     |             |     |        | ✅        |
| tsh-creating-skills                    |     |     |           |     |     |     |             |     |        | ✅        |
| tsh-designing-multi-cloud-architecture |     |     | ✅        |     |     |     |             |     | ✅     |           |
| tsh-e2e-testing                        |     |     |           |     |     |     |             | ✅  |        |           |
| tsh-engineering-prompts                |     |     | ✅        | ✅  | ✅  | ✅  |             |     |        |           |
| tsh-ensuring-accessibility             |     |     |           | ✅  |     |     |             |     |        |           |
| tsh-implementing-ci-cd                 |     |     | ✅        |     |     |     |             |     | ✅     |           |
| tsh-implementing-forms                 |     |     |           | ✅  |     |     |             |     |        |           |
| tsh-implementing-frontend              |     |     |           | ✅  |     |     |             |     |        |           |
| tsh-implementing-kubernetes            |     |     | ✅        |     |     |     |             |     | ✅     |           |
| tsh-implementing-observability         |     |     | ✅        |     |     |     |             |     | ✅     |           |
| tsh-implementing-terraform-modules     |     |     | ✅        |     |     |     |             |     | ✅     |           |
| tsh-implementation-gap-analysing       |     |     | ✅        | ✅  |     | ✅  |             |     |        |           |
| tsh-jira-task-formatting               | ✅  |     |           |     |     |     |             |     |        |           |
| tsh-managing-secrets                   |     |     | ✅        |     |     |     |             |     | ✅     |           |
| tsh-optimizing-cloud-cost              |     |     | ✅        |     |     |     |             |     | ✅     |           |
| tsh-optimizing-frontend                |     |     |           | ✅  |     |     |             |     |        |           |
| tsh-reviewing-frontend                 |     |     |           |     |     | ✅  |             |     |        |           |
| tsh-sql-and-database-understanding     |     |     | ✅        | ✅  |     | ✅  |             |     |        |           |
| tsh-task-analysing                     |     | ✅  |           |     |     |     |             | ✅  |        |           |
| tsh-task-extracting                    | ✅  |     |           |     |     |     |             |     |        |           |
| tsh-task-quality-reviewing             | ✅  |     |           |     |     |     |             |     |        |           |
| tsh-technical-context-discovering      |     | ✅  | ✅        | ✅  | ✅  | ✅  |             | ✅  | ✅     | ✅        |
| tsh-transcript-processing              | ✅  |     |           |     |     |     |             |     |        |           |
| tsh-ui-verifying                       |     |     |           | ✅  |     |     | ✅          |     |        |           |
| tsh-writing-hooks                      |     |     |           | ✅  |     |     |             |     |        |           |

## Loading Priority

Skills follow a strict priority hierarchy:

1. **Project constitution** — [AGENTS.md](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/AGENTS.md) and **`.cursor/rules/*.mdc`** (highest priority for behavior).
2. **Existing codebase patterns** — replicate established conventions.
3. **Skill guidelines** — domain best practices and templates.
4. **External documentation** — framework docs, OWASP, industry standards.

This ensures consistency: existing patterns are never overridden unless explicitly requested.
