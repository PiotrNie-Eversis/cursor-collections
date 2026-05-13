"""Eversis Docs MCP — safe .docx reads/writes via python-docx (stdio MCP)."""

from __future__ import annotations

import argparse
from pathlib import Path

from mcp.server.fastmcp import FastMCP

from chapters import (
    load_sections,
    read_section_text,
    render_summary_md,
    resolve_docx_path,
    update_section_body,
)

mcp = FastMCP("eversis-docs")

GRAPHICS_PLACEHOLDER = (
    ">>> DO WERYFIKACJI BA: SPRAWDŹ I ZAKTUALIZUJ DIAGRAM ZGODNIE Z RELEASE <<<"
)


def _find_section(sections, chapter_id: str):
    cid = chapter_id.strip().lower()
    for s in sections:
        if s.section_id.lower() == cid:
            return s
    raise ValueError(
        f"Unknown chapter_id {chapter_id!r}. Valid: {[s.section_id for s in sections]}"
    )


@mcp.tool()
def generate_summary_map(docx_path: str, output_md_path: str | None = None) -> str:
    """Build a markdown table of sections (chapter_id sec-N) for navigation.

    If ``output_md_path`` is set, writes the map there; otherwise uses ``<docx_stem>.summary.md`` next to the document.
    """
    path, _doc, sections = load_sections(docx_path)
    md = render_summary_md(sections, path)
    out = (
        Path(output_md_path).expanduser().resolve()
        if output_md_path
        else path.with_suffix(".summary.md")
    )
    out.write_text(md, encoding="utf-8")
    return f"Wrote summary map to {out} ({len(sections)} sections)."


@mcp.tool()
def read_chapter(docx_path: str, chapter_id: str) -> str:
    """Return body text for ``chapter_id`` (e.g. sec-0, sec-1) from the .docx."""
    _path, doc, sections = load_sections(docx_path)
    sec = _find_section(sections, chapter_id)
    return read_section_text(doc, sec)


@mcp.tool()
def update_chapter(
    docx_path: str,
    chapter_id: str,
    new_content: str,
    requires_graphics_review: bool = False,
) -> str:
    """Replace section body (excluding heading line) with ``new_content`` and save.

    If ``requires_graphics_review`` is True, appends the standard BA graphics placeholder
    paragraph (plain text — apply red styling manually or in a later tool revision).
    """
    path, doc, sections = load_sections(docx_path)
    sec = _find_section(sections, chapter_id)
    ph = GRAPHICS_PLACEHOLDER if requires_graphics_review else None
    update_section_body(doc, sec, new_content, placeholder_graphics=ph)
    doc.save(str(path))
    return f"Updated {chapter_id} in {path} and saved."


@mcp.tool()
def upload_to_sharepoint(docx_path: str) -> str:
    """Stub — organisation-specific auth and API required.

    Do not pass secrets via MCP. Implement Graph / SharePoint upload in your tenant and
    wire a real tool when approved by IT.
    """
    resolve_docx_path(docx_path)
    return (
        "upload_to_sharepoint is not implemented in this repo. "
        "Publish manually or extend this MCP with tenant-specific integration."
    )


def main() -> None:
    parser = argparse.ArgumentParser(description="Eversis Docs MCP (stdio)")
    parser.add_argument(
        "--transport",
        default="stdio",
        choices=("stdio",),
        help="MCP transport (stdio only for Cursor)",
    )
    args = parser.parse_args()
    if args.transport != "stdio":
        raise SystemExit("Only stdio transport is supported.")
    mcp.run(transport="stdio")


if __name__ == "__main__":
    main()
