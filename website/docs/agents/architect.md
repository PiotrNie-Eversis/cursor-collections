---
sidebar_position: 2
title: Architect
---

# Architect Agent

**Rule pack (canonical):** `.cursor/rules/eversis-role-architect.mdc`  
**Delegated prompt:** `.cursor/prompts/internal/eversis-plan.md` (via `@eversis-implement`)

The Architect designs technical solutions and implementation plans from approved research, turning requirements into phased, executable work.

## Responsibilities

- Solution architecture: components, interactions, data flow.
- Implementation plans with phases, tasks, and clear definition of done.
- Alignment with requirements, practices, and quality expectations.
- Security and QA considerations at design time.
- Clarifying ambiguities with product/analysis context.

## What it produces

- **Solution architecture** — Components, interactions, data flow.
- **Implementation plan** — Phased tasks and checkpoints.
- **Test strategy** — Automated testing focus (no manual QA scripts).
- **Security considerations** — What implementers must address.
- **Quality assurance** — Standards for the implementation pass.

## Tools (typical)

| Tool | Usage |
| --- | --- |
| **Atlassian** | Gather requirements from Jira issues and Confluence pages |
| **Context7** | Evaluate libraries, verify compatibility, search integration patterns |
| **Figma** | Translate visual requirements into technical specifications  |
| **PDF Reader** | Read and extract content from PDF requirement documents  |
| **Sequential Thinking** | Design complex architectures, evaluate trade-offs, break down features |
| **Terminal** | Run build tools, scripts, and validation commands   |
| **Cursor Agent** | Read, search, and edit workspace files |
| **Todo** | Track task progress with structured checklists |

## Skills (Eversis naming)

- `eversis-architecture-designing` — Solution design, components, data flows, implementation plan creation.
- `eversis-codebase-analysing` — Analyze current architecture, components, and patterns.
- `eversis-implementation-gap-analysing` — Focus the plan on necessary changes without duplicating existing work.
- `eversis-technical-context-discovering` — Establish project conventions and patterns before designing.
- `eversis-sql-and-database-understanding` — Database schema design, indexing strategies, transaction patterns.
- `eversis-designing-multi-cloud-architecture` — Cross-provider infrastructure design and service selection across AWS, Azure, and GCP.
- `eversis-optimizing-cloud-cost` — Cost implications of architectural decisions, pricing model comparison.
- `eversis-implementing-ci-cd` — CI/CD pipeline design, deployment strategies, delivery workflows.
- `eversis-implementing-terraform-modules` — IaC structure, Terraform module hierarchy, Terragrunt patterns.
- `eversis-managing-secrets` — Secrets management, credential rotation, vault integration.
- `eversis-implementing-kubernetes` — K8s workload configurations, scaling strategies, Helm chart structure.
- `eversis-implementing-observability` — Monitoring architecture, SLO frameworks, alerting, distributed tracing. — LLM prompt architecture: prompt template strategy, system prompt design, few-shot vs zero-shot decisions.

## Handoffs

After human approval of the plan, implementation runs through **`@eversis-implement`** and the [Engineering Manager](./engineering-manager), including UI flows via **`.cursor/prompts/internal/eversis-implement-ui.md`** when Figma is in scope.
