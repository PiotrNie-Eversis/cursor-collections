---
sidebar_position: 8
title: Use Cases
---

# Use Cases

:::info The AI Productivity Gap
According to Gartner, only **10% of software engineers** see meaningful productivity improvement from AI tools. The gap isn't the technology — it's the lack of structure, specialization, and repeatable workflows around it. Copilot Collections bridges that gap by providing an end-to-end AI product engineering framework that turns AI potential into real delivery gains.
:::

Real-world problems that Copilot Collections solves for product and engineering teams — organized by lifecycle phase.

---

## Product Ideation

### Workshop Outputs to Jira Backlog

**Problem:** Discovery workshops produce valuable transcripts, Figma boards, and shared notes — but converting them into structured, actionable Jira tickets is a manual, error-prone process. Tasks are vague, edge cases are missed, and the backlog doesn't reflect what was actually discussed.

**Solution:** The `/tsh-analyze-materials` prompt + Business Analyst agent processes raw workshop materials end-to-end. Transcripts are cleaned and structured. Epics and user stories are extracted with acceptance criteria and dependencies. A 10-pass quality review catches missing entity lifecycles, error states, notification gaps, and more. A three-gate review process ensures human approval before anything reaches Jira.

**Time to value:** ~15 minutes instead of 1–2 days.

---

### Improving Existing Jira Backlogs

**Problem:** Backlogs accumulated over time contain vague stories, missing acceptance criteria, undocumented dependencies, and inconsistent formatting. Grooming sessions barely keep up.

**Solution:** The Business Analyst agent's **Import Mode** fetches existing Jira issues, converts them to a local format, and runs the same 10-pass quality review used for new workshop outputs. Suggestions are presented individually for accept/reject, and approved changes are pushed back to Jira.

**Time to value:** ~10 minutes per epic.

---

## Development

### Onboarding New Team Members

**Problem:** New developers join a project and spend days understanding the codebase, conventions, and task requirements before they can contribute.

**Solution:** The `/tsh-research` prompt + Context Engineer agent automatically gathers context from Jira, Confluence, Figma, and the codebase. The `/tsh-plan` prompt + Architect agent creates a step-by-step implementation plan. New developers get a structured understanding of the task and a clear path forward within **minutes instead of days**.

**Time to value:** ~5 minutes per task.

---

### Context Scattered Across Tools

**Problem:** Requirements live in Jira, designs in Figma, documentation in Confluence, code in GitHub. Developers constantly context-switch to gather information.

**Solution:** MCP integrations (Atlassian, Figma, Context7, Playwright, PDF Reader) bring all context into a single Copilot chat session. The Context Engineer agent synthesizes information from all sources into one research document.

**Time to value:** ~3 minutes instead of 30–60 minutes of tool-hopping.

---

### No Structured Delivery Workflow

**Problem:** Teams lack a consistent process. Some devs jump straight to coding, skip planning, and produce code that doesn't fully meet requirements. Reviews are ad-hoc.

**Solution:** The enforced **Ideate → Research → Plan → Implement → Review** workflow ensures every task goes through proper analysis, planning, implementation, and review. Each phase produces a documented artifact that feeds the next phase.

**Time to value:** Immediate — the workflow is built into every prompt.

---

### UI Implementation Doesn't Match Designs

**Problem:** Frontend implementations deviate from Figma designs — wrong spacing, colors, component variants. QA catches these late, causing rework.

**Solution:** The `/tsh-implement-ui` prompt runs an automated Figma verification loop (up to 5 iterations) comparing the running app via Playwright against Figma specs. The UI Reviewer agent provides structured PASS/FAIL reports with exact pixel values before the code ever reaches human review.

**Time to value:** ~20 minutes per component, with 95–99% design accuracy.

---

### Database Schema and Query Quality Issues

**Problem:** ORMs hide performance problems. Developers create schemas without proper indexes, normalisation, or migration safety checks.

**Solution:** The `tsh-sql-and-database-understanding` skill provides comprehensive patterns for schema design (naming conventions, PK strategies, normalisation), indexing strategies, join optimization, locking mechanics, and query debugging with `EXPLAIN ANALYZE`. Supports TypeORM, Prisma, Doctrine, Eloquent, Entity Framework, Hibernate, and GORM.

**Time to value:** Applied automatically during `/tsh-plan` and `/tsh-review`.

---

## Quality

### Inconsistent Code Quality Across Teams

**Problem:** Different developers follow different patterns, leading to inconsistent codebases that are hard to maintain. Code reviews catch issues late in the cycle.

**Solution:** Skills like `tsh-technical-context-discovering`, `tsh-code-reviewing`, and `tsh-implementing-frontend` encode tested best practices. The Code Reviewer agent enforces them automatically. The `/tsh-review-codebase` prompt detects dead code, duplications, and anti-patterns repository-wide.

**Time to value:** ~5 minutes per review.

---

### Security and Best Practices Are Afterthoughts

**Problem:** Security reviews happen at the end of a sprint — if at all. Best practices like DRY, KISS, and proper error handling are inconsistently applied.

**Solution:** Every plan includes security considerations. The Code Reviewer agent checks for security vulnerabilities, missing input validation, and exposed secrets. The SQL & Database skill enforces least-privilege, parameterized queries, and proper indexing.

**Time to value:** Built into every `/tsh-plan` and `/tsh-review`.

---

### Flaky or Missing E2E Tests

**Problem:** E2E tests are written inconsistently, use brittle selectors, and break on unrelated changes. Teams don't trust them and skip them.

**Solution:** The E2E Engineer agent + `tsh-e2e-testing` skill enforces Page Object patterns, accessibility-first locators, dynamic test data, and a verification loop with flaky detection. Tests are verified for **3+ consecutive passes** before being committed.

**Time to value:** ~10 minutes per test suite.

---

## Infrastructure & DevOps

### Cloud Costs Spiraling Out of Control

**Problem:** Cloud bills keep growing but nobody knows which resources are wasteful. Unused instances, over-provisioned databases, and missing reserved instance commitments go unnoticed. Tagging is inconsistent, making cost attribution impossible.

**Solution:** The `/tsh-analyze-aws-costs` and `/tsh-analyze-gcp-costs` prompts + DevOps Engineer agent perform a hybrid audit — analyzing IaC code first, then validating against live infrastructure via cloud provider APIs. The `tsh-optimizing-cloud-cost` skill provides rightsizing recommendations, tagging compliance checks, and savings plan coverage analysis.

**Time to value:** ~10 minutes per audit.

---

### Infrastructure Security Gaps and Drift

**Problem:** Infrastructure configurations drift from their IaC definitions. Security misconfigurations, exposed resources, and missing encryption go undetected until a security audit or incident.

**Solution:** The `/tsh-audit-infrastructure` prompt performs a comprehensive audit across Terraform, Kubernetes, and CI/CD configurations. It identifies security vulnerabilities, compliance gaps, and resources not captured in IaC. Findings are prioritized by severity with specific remediation guidance.

**Time to value:** ~15 minutes per audit.

---

### No Consistent CI/CD or Deployment Strategy

**Problem:** Each team builds CI/CD pipelines differently. Deployment practices vary — some deploy manually, others have partial automation. No consistent environment protection or rollback strategy.

**Solution:** The `/tsh-implement-pipeline` prompt + DevOps Engineer agent creates CI/CD pipelines following the project's platform conventions (GitHub Actions, GitLab CI, Bitbucket Pipelines). The `tsh-implementing-ci-cd` skill enforces caching, parallelization, environment protection, and secure authentication patterns.

**Time to value:** ~15 minutes per pipeline.

---

### Kubernetes Deployments Without Standards

**Problem:** Kubernetes manifests are copy-pasted between projects. Health probes are missing or misconfigured. Resource limits aren't set. Deployments fail without rollback strategies.

**Solution:** The `/tsh-deploy-kubernetes` prompt creates production-ready Kubernetes deployments with Helm charts, proper health probes, resource management, scaling policies, and security configurations. The `tsh-implementing-kubernetes` skill enforces patterns for every workload type.

**Time to value:** ~10 minutes per deployment.

---

### Terraform Modules Are Not Reusable

**Problem:** Infrastructure code is duplicated across projects. Each team writes Terraform from scratch without shared modules. No consistent naming, tagging, or state management patterns.

**Solution:** The `/tsh-implement-terraform` prompt creates reusable Terraform modules with proper variable design, output values, naming conventions, and cost estimation. The `tsh-implementing-terraform-modules` skill provides patterns for AWS, Azure, and GCP with safety guardrails.

**Time to value:** ~15 minutes per module.

---

### No Observability or Monitoring

**Problem:** Services run without proper monitoring. Issues are discovered by users, not by alerts. Logs are unstructured and hard to search. No distributed tracing across microservices.

**Solution:** The `/tsh-implement-observability` prompt sets up comprehensive monitoring — metrics collection, structured logging, distributed tracing, and alerting. The `tsh-implementing-observability` skill provides patterns for the RED method, SLO tracking, and alert severity design.

**Time to value:** ~15 minutes per service.

---

## Copilot Customization

### Extending the Framework for Your Team

**Problem:** Your team has domain-specific workflows, coding conventions, or tooling that generic AI tools don't understand.

**Solution:** The Copilot Engineer and Copilot Orchestrator agents help you create custom agents, skills, prompts, and instructions that encode your team's specific knowledge. The `/tsh-create-custom-*` commands guide you through research, creation, and review — ensuring consistency with the existing framework.

**Time to value:** ~15 minutes per customization artifact.
