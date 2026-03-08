---
sidebar_position: 12
title: Jira Task Formatting (sub-workflow)
---

# Jira Task Formatting

:::info Sub-workflow
Jira task formatting is **not a standalone prompt** — it is a sub-workflow within [`/tsh-analyze-materials`](./analyze-materials). The Business Analyst agent handles task formatting and Jira push as the final steps of the workshop analysis workflow.
:::

**Agent:** Business Analyst (within `/tsh-analyze-materials`)  
**Skill:** `tsh-jira-task-formatting`

## What It Does

### Formatting Mode (extracted-tasks.md provided)

1. Locates and reads the `extracted-tasks.md` file.
2. Loads the benchmark template from the `tsh-jira-task-formatting` skill.
3. Formats each epic and story according to the benchmark template fields and structure.
4. Validates completeness — flags any tasks where required fields cannot be confidently filled.
5. Presents formatted tasks for user review (Gate 2).
6. Creates issues in Jira with proper epic-to-story linking after approval.

### Import Mode (Jira project key provided)

1. Fetches existing tasks from Jira using the Atlassian tool.
2. Converts them into local `jira-tasks.md` format.
3. Presents imported tasks for user review.
4. After import, individual task changes trigger a "Push to Jira now?" prompt.

## Skills Loaded

- `tsh-jira-task-formatting` — Formatting process, benchmark template, Jira push guidelines, and Import Mode.

## Output

- `jira-tasks.md` in the `specifications/<workshop-name>/` directory.
- Created Jira issues with linked epics and stories (after approval).
