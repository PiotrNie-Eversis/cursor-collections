# Eversis Docs MCP

> **Production in cursor-collections:** The same **tool names** and contract are implemented inside [`eversis-collections-mcp`](../eversis-collections-mcp/) (`registerDocxTools`). This workspace’s [`.cursor/mcp.json`](../../.cursor/mcp.json) enables **`eversis-collections`** only. Use this Python package for a **standalone** `python-docx` process or comparison with collections’ OOXML path.

Local **Model Context Protocol** server for **`.docx`** using **`python-docx`**. Used by the **Business Manager Docs** workflow (`@eversis-ba-docs-writer`).

## Requirements

- Python **3.11+**
- Dependencies: `pip install -r requirements.txt`

## Tools

| Tool | Purpose |
| ---- | ------- |
| `generate_summary_map` | Writes a `*.summary.md` table of `chapter_id` (`sec-0` …) mapped to headings. |
| `read_chapter` | Returns body text for a `chapter_id`. |
| `update_chapter` | Replaces section body and saves the `.docx` (optional graphics placeholder paragraph). |
| `upload_to_sharepoint` | **Stub** — implement with your tenant; do not embed secrets in this repo. |

## `chapter_id` contract

Sections are numbered **`sec-N`** in document order: optional **Preamble** (`sec-0`) before the first Heading style, then each **Heading** starts a new section. Heading detection uses paragraph style names containing `Heading`.

## Run (Cursor / CI)

Preferred: **uv** (Python 3.11+):

```bash
cd mcp/eversis-docs-mcp
uv sync --group dev
uv run pytest tests/ -q
```

The workspace [`.cursor/mcp.json`](../../.cursor/mcp.json) in this repository uses **`eversis-collections`** for `.docx` tools. For a **Python-only** stdio server, run locally:

`uv run --directory mcp/eversis-docs-mcp python server.py`

Run `uv sync` in `mcp/eversis-docs-mcp` once so the lockfile / `.venv` exist. If you do not use `uv`, create a 3.11+ venv, `pip install mcp python-docx pytest`, and point Cursor at `python path/to/server.py` locally.

## Run (dev, direct)

```bash
cd mcp/eversis-docs-mcp && uv run python server.py
```

## Alternative: Node.js server

Reference: [`mcp/eversis-docs-mcp-node/`](../eversis-docs-mcp-node/). Prefer **`eversis-collections`** in this repo; enable a separate Node/Python server only if you need a dedicated process (avoid duplicate tool names in one client).
