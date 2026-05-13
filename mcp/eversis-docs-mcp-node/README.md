# Eversis Docs MCP — Node.js (alternative)

> **Production in cursor-collections:** The OOXML implementation in this folder is **merged into** [`eversis-collections-mcp`](../eversis-collections-mcp/) (`src/docx/`). Enable **`eversis-collections`** in [`.cursor/mcp.json`](../../.cursor/mcp.json). Keep this package for a **standalone** Node stdio server or comparison.

Alternative implementation of the same **tool names** as [`../eversis-docs-mcp/`](../eversis-docs-mcp/) (Python + `python-docx`), using **JSZip** + **@xmldom/xmldom** on `word/document.xml`.

## When to use Node vs Python

| Aspect | Node (`eversis-docs-mcp-node`) | Python (`eversis-docs-mcp`) |
| ------ | ------------------------------ | ---------------------------- |
| Runtime | Node 18+, `npm install` + `npm run build` | Python 3.11+, `uv sync` |
| Fidelity | Good for body paragraphs / heading styles; complex OOXML (tables, text boxes) may diverge from Word | Usually closer to Word for rich layouts via `python-docx` |
| Cursor | Prefer **`eversis-collections`** in this repo; duplicate `generate_summary_map` / `read_chapter` / etc. from two servers will confuse clients |

## Tools (same contract as Python server)

- `generate_summary_map`
- `read_chapter`
- `update_chapter`
- `upload_to_sharepoint` (stub)

`chapter_id` numbering matches the Python server (`sec-N`, preamble / heading rules).

## Setup

```bash
cd mcp/eversis-docs-mcp-node
npm install
npm run build
```

## Tests

```bash
npm test
```

## Cursor `mcp.json`

This repository’s default config uses **`eversis-collections`** only. To run **this** Node server in another workspace, add a stdio entry (and disable overlapping `.docx` tools elsewhere):

```json
"eversis-docs-node": {
  "command": "node",
  "args": ["mcp/eversis-docs-mcp-node/dist/index.js"],
  "type": "stdio"
}
```

Reload MCP after building. Paths are relative to the workspace root.

## Run (stdio)

```bash
node mcp/eversis-docs-mcp-node/dist/index.js
```
