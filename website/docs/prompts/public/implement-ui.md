---
sidebar_position: 5
title: /tsh-implement-ui
---

# /tsh-implement-ui

**Agent:** Engineering Manager  
**File:** `.github/prompts/tsh-implement-ui.prompt.md`

Orchestrates the implementation of UI features with iterative Figma verification, delegating to specialized agents.

## Usage

```text
/tsh-implement-ui <JIRA_ID or task description>
```

## What It Does

Everything from [`/tsh-implement`](./implement), plus:

1. **Extracts Figma URLs** from the research and plan files.
2. **Confirms dev server URL** with the user before the first verification.
3. **Delegates UI implementation** to the Software Engineer with Figma design context.
4. **Delegates UI verification** to the `tsh-ui-reviewer` subagent after each UI component:
   - If PASS → moves to next component.
   - If FAIL → delegates fix to Software Engineer, then re-runs verification.
   - Maximum **5 iterations** per component, then escalates.
5. **Produces a UI Verification Summary** before handing off to code review.

## Verification Loop

```
BEFORE starting:
    0. Ensure Figma URL is available → if not, ASK user

REPEAT (max 5 iterations):
    1. Run tsh-ui-reviewer subagent to verify current implementation
    2. If PASS → done, exit loop
    3. If FAIL → fix reported differences → go to step 1
```

:::warning
The Software Engineer never verifies UI itself. It delegates to the `tsh-ui-reviewer` subagent which uses Figma MCP and Playwright to extract and compare data. Mental comparison or code reading is not verification.
:::

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

- `tsh-implementing-frontend` — Component patterns, design system usage, composition.
- `tsh-ui-verifying` — Verification criteria, tolerances, PASS/FAIL definitions.
- `tsh-ensuring-accessibility` — WCAG 2.1 AA compliance, semantic HTML, ARIA.
- `tsh-technical-context-discovering` — Project conventions before implementing.

## Output

Everything from `/tsh-implement`, plus:

- UI Verification Summary listing verified components, iterations per component, design gaps, and deviations with rationale.
