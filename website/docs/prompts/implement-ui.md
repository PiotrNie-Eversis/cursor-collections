---
sidebar_position: 5
title: /tsh-implement-ui
---

# /tsh-implement-ui

**Agent:** Software Engineer  
**File:** `.github/prompts/tsh-implement-ui.prompt.md`

Extends the base `/tsh-implement` workflow with iterative Figma verification for UI tasks.

## Usage

```text
/tsh-implement-ui <JIRA_ID or task description>
```

## What It Does

Everything from [`/tsh-implement`](./implement), plus:

1. **Locates Figma URLs** from the research and plan files.
2. **Ensures dev server is running** and the target page is accessible.
3. **Runs a verification loop** for each UI component:
   - Calls `/tsh-review-ui` to compare implementation against Figma.
   - If PASS → moves to next component.
   - If FAIL → fixes reported differences and re-runs `/tsh-review-ui`.
   - Maximum **5 iterations** per component, then escalates.
4. **Produces a UI Verification Summary** before handing off to code review.

## Verification Loop

```
BEFORE starting:
    0. Ensure Figma URL is available → if not, ASK user

REPEAT (max 5 iterations):
    1. Call /tsh-review-ui to verify current implementation
    2. If PASS → done, exit loop
    3. If FAIL → fix reported differences → go to step 1
```

### Confidence Levels

- **HIGH** — Fix code to match EXPECTED values exactly.
- **MEDIUM** — Fix obvious differences, manually verify unclear ones.
- **LOW** — Manually verify before making changes; tool data may be incomplete.

### Escalation (after 5 iterations)

Stops the loop and prepares an escalation report with:
- Summary of each iteration.
- Remaining mismatches.
- Suspected root causes.
- Recommended next steps.

## Additional Skills Loaded

- `tsh-implementing-frontend` — Accessibility, design system, component patterns.
- `tsh-ui-verifying` — Verification criteria, tolerances, PASS/FAIL definitions.
- `tsh-technical-context-discovering` — Project conventions before implementing.

## Output

Everything from `/tsh-implement`, plus:
- UI Verification Summary listing verified components, iterations per component, design gaps, and deviations with rationale.
