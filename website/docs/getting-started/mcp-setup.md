---
sidebar_position: 3
title: MCP Setup
---

# MCP Setup

## At a glance

To unlock the full workflow, configure **Model Context Protocol (MCP)** servers. Template: [`.cursor/mcp.json`](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/.cursor/mcp.json).

**Option 1 — User profile (recommended):** Command Palette → **MCP: Open User Configuration** → merge `mcpServers` from this repo (global across projects).

**Option 2 — Workspace:** Open this repo in Cursor and enable workspace MCP when prompted — or copy `.cursor/mcp.json` into your project.

**Build local server `eversis-collections`:**

```bash
cd mcp/eversis-collections-mcp && npm install && npm run build
```

Enable **`eversis-collections`** in **Settings → MCP** and restart Cursor. Details: [Cursor Collections MCP](../integrations/eversis-collections). Per-tool reference: [MCP package README](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/mcp/eversis-collections-mcp/README.md).

### What each MCP is used for

- **Atlassian** — Jira and Confluence for implement, review, and research.
- **Figma** — design context for UI implement and `@eversis-review-ui`.
- **Context7** — up-to-date library and framework documentation.
- **Playwright** — browser interactions and E2E-style checks.
- **Sequential Thinking** — structured reasoning for complex analysis ([details](../integrations/sequential-thinking)).
- **PDF Reader** — workshop PDFs for `@eversis-analyze-materials`.
- **AWS / GCP MCPs** — cloud APIs and docs for DevOps and cost prompts.
- **eversis-collections** — skills, Word `.docx` tools, repo scripts ([details](../integrations/eversis-collections)).

### Verify

After restart, open **Agent** and confirm tools appear (e.g. `eversis_skills_list` after building `eversis-collections`).

---

## Detailed setup

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

:::tip Do not hand-copy sample JSON
For this repository, **do not paste** ad-hoc `mcp.json` snippets from blog posts or older templates. The **authoritative** workspace list is the committed **[`.cursor/mcp.json`](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/.cursor/mcp.json)** at the repo root (the same path exists after you clone). It includes agentic tools such as **Sequential Thinking** (npm package **`@modelcontextprotocol/server-sequential-thinking`**), Context7, Playwright, PDF Reader, AWS and Google Cloud MCPs, and **`eversis-collections`**.

For the **annotated server list** and a **secondary** full JSON example that mirrors the repo, see [Integrations overview — Configuration](../integrations/overview.md#configuration).
:::

Build **`eversis-collections`** once so `dist/index.js` exists (see the table below). For details on each server, see [Integrations overview](../integrations/overview.md) and the committed **`.cursor/mcp.json`**.

## MCP Server Reference

### Local: `eversis-collections` (this repository)

**Required local server** — not an `npx` package. Build once so `dist/index.js` exists before Agent can call skill or Word tools. Unlike optional third-party MCPs, this server is **core to the framework** when you run `@eversis-implement`, `@eversis-review`, or BA Docs prompts.

| MCP Server | Type | Purpose | Used By | Build | Details |
| --- | --- | --- | --- | --- | --- |
| **eversis-collections** | stdio | Skills (`eversis_skills_*`), Word `.docx` chapter tools, allowlisted repo scripts | Engineering Manager, Code Reviewer, BA Docs prompts, all agents (skill discovery), contributors | `cd mcp/eversis-collections-mcp && npm install && npm run build` — **not on npm** | [Cursor Collections MCP](../integrations/eversis-collections) |

For the grouped **14-tool** inventory and **tool reference** (Focus / How to use / Outcome), see the integration page. Document compatibility and env vars: [MCP package README](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/mcp/eversis-collections-mcp/README.md).

### Third-party (external services)

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
- **eversis-collections** — No OAuth. Requires a **local build** (`npm install && npm run build` in `mcp/eversis-collections-mcp/`). Optional **`CURSOR_COLLECTIONS_HOME`** when the framework checkout lives outside your workspace — see [Cursor Collections MCP](../integrations/eversis-collections).

## Official Documentation

- [Cursor Collections MCP](../integrations/eversis-collections) — local skills + Word tools (build required)
- [MCP package README](https://github.com/PiotrNie-Eversis/cursor-collections/blob/main/mcp/eversis-collections-mcp/README.md) — per-tool reference
- [Atlassian MCP](https://support.atlassian.com/atlassian-rovo-mcp-server/docs/getting-started-with-the-atlassian-remote-mcp-server/)
- [Context7 MCP](https://github.com/upstash/context7)
- [Playwright MCP](https://github.com/microsoft/playwright-mcp)
- [Figma MCP](https://help.figma.com/hc/en-us/articles/32132100833559-Guide-to-the-Figma-MCP-server)
- [Sequential Thinking MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking)
