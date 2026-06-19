---
name: eversis-orchestrating-implementation
description: Owns the canonical implementation orchestration workflow for feature implementation, including flow selection, planning readiness, delegated execution routing, todo control, and review gates. Use when handling implementation orchestration, eversis-implement, or feature implementation workflows that must coordinate specialized agents without writing product code directly.
user-invocable: false
---

# Orchestrating Implementation

This skill is the canonical workflow owner for implementation orchestration in the Engineering Manager role. It selects the right flow, prepares execution context, routes delegated work, and closes quality gates without writing product code itself.

<principles>
<canonical-source-of-truth>
This skill is the single canonical source of truth for the implementation-orchestration workflow. Keep flow selection, planning readiness, task routing, todo protocol, execution-plan steps, and review gates here rather than duplicating them in agents or prompts.
</canonical-source-of-truth>

<never-writes-product-code>
This skill never writes product code itself. It orchestrates delegation, validation, review, and escalation.
</never-writes-product-code>

<todo-role>
The todo list is the progress-control surface. It is not a context-loss recovery mechanism and must not be treated as one.
</todo-role>
</principles>

## Workflow

Use the checklist below and keep it synchronized with the todo list:

```text
Implementation orchestration progress:
- [ ] Step 0: Create flow-start todos
- [ ] Step 1: Select Quick Flow or Full Flow
- [ ] Step 2: Write the upfront execution plan
- [ ] Step 3: Run the selected flow
- [ ] Step 4: Close validation and review gates
- [ ] Step 5: Declare Fine and produce QA comment draft (Cursor-only)
```

### Step 0 - Start with todos

- Create todos at the start of the selected flow.
- In Quick Flow, create one todo per orchestration action.
- In Full Flow, create one todo per plan task, per review loop, per `[REUSE]` UI verification item, and per final gate.
- Consult the todo list before each action.
- Mark the matching todo complete immediately after the action finishes.
- If scope changes, update the execution plan first, then synchronize the todo list.

### Step 1 - Assess complexity and recommend a flow

Use the following decision rules before any delegation.

**Quick Flow is allowed only when every check below passes:**

| Check | Quick Flow pass condition |
| --- | --- |
| Scope width | Narrow, single-domain change with one clear implementation owner |
| Solution clarity | Solution path is obvious from the task, approved plan, or existing context |
| File impact | Likely to touch 3 files or fewer |
| Ambiguity | No major ambiguity, contradiction, or unresolved tradeoff |
| Planning readiness | No missing research gap and no missing plan gap for the work being attempted |
| UI/Figma involvement | No Figma reference, no `[REUSE]` UI verification task, and no UI-verification requirement |

**Full Flow is required when any check below is true:**

| Trigger | Full Flow condition |
| --- | --- |
| Cross-domain work | Work spans multiple domains, multiple agents, or architectural boundaries |
| Ambiguity | Requirements, constraints, or acceptance criteria are incomplete or unclear |
| Research gap | Required context is missing or no complete `*.research.md` exists |
| Plan gap | No actionable `*.plan.md` exists for the current task |
| Larger scope | Likely to touch more than 3 files or requires phased execution |
| UI/Figma involvement | Any Figma involvement or UI-verification involvement exists |

**Hard exclusion:** any Figma or UI-verification involvement immediately disqualifies Quick Flow.

Recommend Quick Flow or Full Flow in chat with a short reason, and allow the user to override the recommendation.

### Step 2 - Write the upfront execution plan

Write the full ordered agent + prompt call sequence before the first delegation.

- Do this immediately after flow selection.
- In Full Flow, do it again after plan approval and before execution starts.
- The sequence must cover every planned delegation, review, validation checkpoint, and UI verification item.
- Keep the execution plan synchronized with the todo list whenever order or scope changes.

## Quick Flow

Use Quick Flow only if Step 1 passed every Quick criterion and the user selected or accepted it.

1. **Delegate implementation** — Delegate to **Software Engineer** via [`eversis-implement-common-task.md`](../../../.cursor/prompts/internal/eversis-implement-common-task.md).
2. **Run validation checks** — After implementation, run the appropriate checks for the affected area (see `eversis-project-stack.mdc` / `eversis-testing-and-terminal.mdc`).
3. **Delegate code review** — Delegate to **Code Reviewer** via [`eversis-review.md`](../../../.cursor/prompts/public/eversis-review.md).
4. **Handle review results explicitly:**
   - If review passes with no required changes, proceed to Step 5 (Fine).
   - If review requests changes, ask for confirmation before changing the reviewed solution.
   - After confirmation, route fixes back to Software Engineer, run affected validation again, and re-run review when the fix is material.
5. **Abort Quick Flow if hidden complexity appears** — If ambiguity, cross-domain work, plan gaps, or any Figma/UI-verification need appears during execution, stop Quick Flow, rewrite the execution plan, and restart in Full Flow.

## Full Flow

### Planning readiness

Check the current state before creating or executing any plan.

| Artifact or signal | Treat as ready when | If not ready |
| --- | --- | --- |
| `*.research.md` | It exists for the current task and contains enough context to explain scope, constraints, requirements, and referenced inputs or links | Delegate to **Context Engineer** with [`eversis-research.md`](../../../.cursor/prompts/internal/eversis-research.md) |
| `*.plan.md` | It exists for the current task and contains ordered, actionable tasks that can be delegated | Delegate to **Architect** with [`eversis-plan.md`](../../../.cursor/prompts/internal/eversis-plan.md) |
| Technical Context | The plan has a populated **Technical Context** section with conventions, patterns, stack, and testing guidance relevant to implementation | Delegate to **Architect** with [`eversis-review-codebase.md`](../../../.cursor/prompts/public/eversis-review-codebase.md) to populate Technical Context in the plan |
| Plan approval state | `{task}.plan-review.md` has verdict `APPROVED` and the plan is unchanged since that review | Skip re-review |

### Planning sequence

1. **Check for existing research and plan files** — Inspect current `*.research.md` and `*.plan.md` state first.
2. **Fill missing context when needed** — If research is missing or incomplete, delegate to Context Engineer with `eversis-research.md`.
3. **Create or refresh the plan when needed** — If the plan is missing, stale, or not actionable, delegate to Architect with `eversis-plan.md`.
4. **Human plan review** — Ask the user to review scope, phases, and acceptance criteria before plan validation.
5. **Review the plan before execution** — Delegate to **Plan Reviewer** with [`eversis-review-plan.md`](../../../.cursor/prompts/internal/eversis-review-plan.md) unless an approved `.plan-review.md` exists and the plan is unchanged.
6. **Run the review loop with hard limits:**
   - `*.plan-review.md` remains the source of truth.
   - If the verdict is `REVISIONS NEEDED`, send the review back to Architect and re-run review.
   - Stop after a maximum of **3** plan-review iterations and escalate to the user if blockers remain.
7. **Create execution todos from the plan** — Create todos per plan task, not just per phase.
8. **Capture UI inventory early** — Find every `[REUSE]` UI task and every Figma URL in the plan and research files.
9. **Ask for the dev server URL when UI tasks exist** — If the UI inventory is non-empty, ask the user in chat for the dev server URL before execution starts. Do not guess from port scans.
10. **Apply the Technical Context rule** — If the plan already contains populated Technical Context, use it and skip rediscovery; otherwise delegate to Architect with `eversis-review-codebase.md`.
11. **Conditional confirmation before execution** — Ask for confirmation before moving from planning to execution when the plan was newly created, materially changed, escalated, or not yet approved for execution in the current thread.
12. **Rewrite the upfront execution plan after approval** — Expand the ordered agent + prompt call sequence from the approved plan before the first implementation task starts.

### Execution routing

Process tasks in plan order. Consult the todo list before each task and update the plan and todo list after each completed task.

| Task type or tag | Delegate to | Prompt to use | Notes |
| --- | --- | --- | --- |
| app code | Software Engineer | [`eversis-implement-common-task.md`](../../../.cursor/prompts/internal/eversis-implement-common-task.md) | Standard implementation work |
| UI with Figma | Software Engineer | [`eversis-implement-ui-common-task.md`](../../../.cursor/prompts/internal/eversis-implement-ui-common-task.md) | Figma-based UI implementation |
| E2E | E2E Engineer | [`eversis-implement-e2e.md`](../../../.cursor/prompts/internal/eversis-implement-e2e.md) | End-to-end test work |
| infra/Terraform | DevOps Engineer | [`eversis-implement-terraform.md`](../../../.cursor/prompts/internal/eversis-implement-terraform.md) | Terraform changes |
| Kubernetes/deploy | DevOps Engineer | [`eversis-deploy-kubernetes.md`](../../../.cursor/prompts/internal/eversis-deploy-kubernetes.md) | Deployment or Kubernetes work |
| CI/CD | DevOps Engineer | [`eversis-implement-pipeline.md`](../../../.cursor/prompts/internal/eversis-implement-pipeline.md) | Pipeline work |
| observability | DevOps Engineer | [`eversis-implement-observability.md`](../../../.cursor/prompts/internal/eversis-implement-observability.md) | Logging, metrics, or tracing |
| LLM prompts | Prompt Engineer | [`eversis-engineer-prompt.md`](../../../.cursor/prompts/internal/eversis-engineer-prompt.md) | Prompt-engineering tasks |
| repo documentation | Repo Docs Writer | [`eversis-repo-docs-writer.md`](../../../.cursor/prompts/public/eversis-repo-docs-writer.md) | README, CHANGELOG, `docs/`, `website/docs` only — not `.docx` |
| `[REUSE]` UI verification | UI Reviewer | [`eversis-review-ui.md`](../../../.cursor/prompts/public/eversis-review-ui.md) | Review each UI item individually; do not batch |
| `[REUSE]` other | per the task definition | — | Execute as defined; delegate to the matching implementer only when new product code is required |

### Execution rules and gates

1. **Stay inside the approved plan** — If execution requires a material deviation, stop and get confirmation before changing direction.
2. **Delegate by route, not by instinct** — Use the routing table; pass the plan section, Technical Context, and latest outputs.
3. **Update after every task** — After each task, update plan checkboxes, the matching todo, and run appropriate checks.
4. **Run checks after every task** — Lint, build, unit/integration tests, E2E, or infrastructure validation as appropriate for the changed area.
5. **Handle `[REUSE]` UI verification as a per-item loop:**
   - Process each `[REUSE]` UI verification task one item at a time in plan order.
   - Delegate each item to UI Reviewer with `eversis-review-ui.md`, passing Figma URL, dev server URL, and component or section name.
   - Use [`eversis-implement-ui.md`](../../../.cursor/prompts/internal/eversis-implement-ui.md) as the workflow reference for the verify-fix loop.
   - Mark each item **PASSED** or **ESCALATED**. Never batch multiple UI verification items into one review step.
6. **Enforce the UI verification gate** — Do not start code review until every `[REUSE]` UI verification item has been individually passed or escalated with explicit user approval.
7. **Run code review after the UI gate clears** — Delegate to Code Reviewer with `eversis-review.md` only after the UI verification gate passes or is explicitly escalated per item.
8. **Confirm before changing a reviewed solution** — If code review finds issues, ask for confirmation before changing the reviewed solution.
9. **Route review fixes back through the correct implementer** — After confirmation, delegate fixes through the routing table, run affected checks, and re-run review when needed.
10. **Treat direct implementation as a workflow violation** — If the orchestrator starts writing product code directly, stop and return to delegated execution.
11. **Record solution changes in the plan Changelog** — When the approved solution changes during implementation, document it in the plan file's Changelog with timestamps after confirmation.

### Step 5 - Declare Fine and produce QA comment draft (Cursor-only)

When all validation and review gates pass:

1. Declare **Fine** explicitly.
2. In the **same response**, produce the QA comment draft following **`eversis-fine-handoff`** (MCP `eversis_skills_get` or `.cursor/skills/eversis-fine-handoff/SKILL.md`).
3. Label: `**Draft QA comment — review before posting to Jira**`.
4. Do **not** post to Jira in this turn. Only use Atlassian MCP after explicit human approval.

## Connected Skills

- `eversis-technical-context-discovering` — when existing Technical Context is sufficient vs when discovery should be delegated
- `eversis-code-reviewing` — final review gate standards
- `eversis-ui-verifying` — verification standard behind the per-item UI review gate
- `eversis-fine-handoff` — mandatory QA comment draft on Fine (Cursor-only)
- `eversis-writing-repo-documentation` — repository documentation tasks delegated from the plan
- `eversis-task-analysing` — whether research context is complete before planning
- `eversis-creating-implementation-plans` — plan structure and planning readiness signals
