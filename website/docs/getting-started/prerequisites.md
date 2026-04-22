---
sidebar_position: 1
title: Prerequisites
---

# Prerequisites

## Cursor

**Use [Cursor](https://cursor.com/)** as the IDE for this framework. Prompts are **Markdown files** you attach with `@`; rules are **`.cursor/rules/*.mdc`**; automation and verification use the **Agent** and **terminal** as described in the rules.

Use a current Cursor release so Chat, Agent, rules, MCP, and Agent Skills behave as documented. Features evolve quickly — if something differs in your build, check Cursor’s own release notes.

## Git

You need **Git** to clone this repository and to work with the normal team workflow.

## MCP (for full workflow)

Jira, Figma, Playwright, Context7, and other MCP servers are **optional** but required for the full “integrated” experience described in the workflow docs. Configure them in Cursor per [MCP setup](./mcp-setup.md).

## Third-party accounts

Where your prompts call external APIs (Jira, Figma, AWS, GCP, etc.), you need the appropriate **accounts, tokens, and network access** per your organization’s policies.

---

**Not required:** GitHub Copilot, VS Code global `chat.*Locations` for prompts/agents, or `.github/prompts` / `.github/agents` — this repository is **Cursor-only** and does not ship those paths.
