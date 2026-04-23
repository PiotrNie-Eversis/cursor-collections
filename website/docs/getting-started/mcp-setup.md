---
sidebar_position: 3
title: MCP Setup
---

# MCP Setup

To unlock the full workflow (Jira, Figma, code search, browser automation, cloud APIs), configure the **Model Context Protocol (MCP)** servers. This repository’s **source of truth** is **`.cursor/mcp.json`**: it defines every server (HTTP and stdio) under the **`mcpServers`** key, per [Cursor’s MCP documentation](https://cursor.com/docs/mcp).

## This repository (recommended)

1. **Clone** the repo and **open the folder in Cursor** (`File` → `Open Folder`).
2. **Cursor** detects **`.cursor/mcp.json`**. When prompted, **enable the workspace MCP configuration** (or use **Settings → Features → Model Context Protocol** to turn servers on or off).
3. Complete **OAuth** or **API keys** where a provider requires them (Atlassian, Figma, etc.).

You do not need to copy JSON by hand for this project unless you want the same set of servers in your **global** profile (see below).

## User profile (optional)

Use this to enable the same MCP tools in **all** of your projects.

1. **Command Palette**: `Cmd` + `Shift` + `P` (macOS) or `Ctrl` + `Shift` + `P` (Windows/Linux).
2. Run **"MCP: Open User Configuration"** to open `~/.cursor/mcp.json`.
3. **Merge** the `mcpServers` object (and any `inputs`) from this repo’s **`.cursor/mcp.json`** into that file, then restart Cursor if needed.

## Another project (vendor the template)

1. Copy **`.cursor/mcp.json`** from this repository.
2. Place it at **`<your-project>/.cursor/mcp.json`**, or merge only the `mcpServers` entries you need.
3. Open the project in Cursor and **enable** the workspace MCP when prompted.

## Canonical configuration

The **full, current** list of server IDs, commands, and endpoints lives in the repo file **`.cursor/mcp.json`**. A minimal shape (Cursor format) is:

```json
{
  "mcpServers": {
    "playwright": { "command": "npx", "args": ["@playwright/mcp@latest"], "type": "stdio" },
    "atlassian": { "url": "https://mcp.atlassian.com/v1/mcp", "type": "http" }
  }
}
```

For every server, see [Integrations overview](../integrations/overview.md) and the committed **`.cursor/mcp.json`**.

## MCP Server Reference

Each MCP server enables specific capabilities within the workflow:

| MCP Server                 | Purpose                                                                                    | Used By                                                       |
| -------------------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------- |
| 🧩 **Atlassian**           | Access Jira issues and Confluence pages for research, planning, implementation, and review | Business Analyst, Architect, Software Engineer, Code Reviewer |
| 🎨 **Figma MCP**           | Pull design details, components, and variables for design-driven work                      | Software Engineer (UI), UI Reviewer                           |
| 📚 **Context7**            | Semantic search in external documentation and knowledge bases                              | All agents                                                    |
| 🧪 **Playwright**          | Run browser interactions and end-to-end style checks from the agent                          | Software Engineer, E2E Engineer, UI Reviewer                  |
| 🧠 **Sequential Thinking** | Advanced reasoning for complex problem analysis, revision, and branching                   | All agents (for complex tasks)                                |

The template also includes **PDF Reader**, **AWS** (API + documentation), and **Google Cloud** MCP servers. See [Integrations overview](../integrations/overview.md) for IDs and details.

## Configuring Context7 API Key

To get higher rate limits and access to private repositories, you can provide a Context7 API key. Get your key at [context7.com/dashboard](https://context7.com/dashboard).

Cursor (and compatible hosts) can use the same `inputs` pattern in `mcp.json` to prompt for the API key. When the MCP tool runs, the host may ask for the key and store it per its settings.

To enable this, modify your `mcp.json` configuration (User or Workspace) to use the `--api-key` CLI argument with an input variable:

```json
{
  "mcpServers": {
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "@upstash/context7-mcp@latest",
        "--api-key",
        "${input:context7-api-key}"
      ]
    }
  },
  "inputs": [
    {
      "id": "context7-api-key",
      "description": "Context7 API Key (optional, for higher rate limits)",
      "type": "promptString",
      "password": true
    }
  ]
}
```

:::note
Server IDs in `mcp.json` are lowercase (e.g., `context7`, `figma`). If you copied an older template with different names, update your configuration to match the current **`.cursor/mcp.json`**.
:::

## Authentication Requirements

Some MCP servers require additional setup:

- **Atlassian** — Requires Atlassian account authentication. The HTTP MCP endpoint handles OAuth automatically via your browser.
- **Figma** — Requires Figma account access. The HTTP MCP endpoint handles authentication via your browser.
- **Context7** — Works without an API key (with rate limits). Optional API key for higher limits.
- **Playwright** — No authentication required. Runs locally via npx.
- **Sequential Thinking** — No authentication required. Runs locally via npx.

## Official Documentation

- [Atlassian MCP](https://support.atlassian.com/atlassian-rovo-mcp-server/docs/getting-started-with-the-atlassian-remote-mcp-server/)
- [Context7 MCP](https://github.com/upstash/context7)
- [Playwright MCP](https://github.com/microsoft/playwright-mcp)
- [Figma MCP](https://help.figma.com/hc/en-us/articles/32132100833559-Guide-to-the-Figma-MCP-server)
- [Sequential Thinking MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking)
