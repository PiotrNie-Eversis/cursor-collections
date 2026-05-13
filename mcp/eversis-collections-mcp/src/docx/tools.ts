import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import * as z from "zod";
import { mkdir, writeFile } from "node:fs/promises";
import path from "node:path";
import {
  buildSections,
  readSectionText,
  renderSummaryMd,
  updateSectionBody,
  type Section,
} from "./chapters.js";
import { loadDocx, saveDocx } from "./docx-io.js";

const GRAPHICS_PLACEHOLDER =
  ">>> DO WERYFIKACJI BA: SPRAWDŹ I ZAKTUALIZUJ DIAGRAM ZGODNIE Z RELEASE <<<";

function textResult(text: string) {
  return { content: [{ type: "text" as const, text }] };
}

function findSection(sections: Section[], chapterId: string): Section {
  const cid = chapterId.trim().toLowerCase();
  const s = sections.find((x) => x.section_id.toLowerCase() === cid);
  if (!s) {
    throw new Error(
      `Unknown chapter_id ${JSON.stringify(chapterId)}. Valid: ${sections.map((x) => x.section_id).join(", ")}`
    );
  }
  return s;
}

/** Register .docx chapter tools (same names as legacy eversis-docs MCP servers). */
export function registerDocxTools(server: McpServer): void {
  server.registerTool(
    "generate_summary_map",
    {
      description:
        "Build a markdown table of sections (chapter_id sec-N). Writes *.summary.md next to the doc unless output_md_path is set.",
      inputSchema: {
        docx_path: z.string(),
        output_md_path: z.string().optional(),
      },
    },
    async ({ docx_path, output_md_path }) => {
      try {
        const loaded = await loadDocx(docx_path);
        const sections = buildSections(loaded.paragraphs);
        const md = renderSummaryMd(sections, path.basename(loaded.abs));
        const out = output_md_path
          ? path.resolve(output_md_path)
          : loaded.abs.replace(/\.docx$/i, ".summary.md");
        await mkdir(path.dirname(out), { recursive: true });
        await writeFile(out, md, "utf8");
        return textResult(`Wrote summary map to ${out} (${sections.length} sections).`);
      } catch (e) {
        return textResult(JSON.stringify({ error: String(e) }, null, 2));
      }
    }
  );

  server.registerTool(
    "read_chapter",
    {
      description: "Return body text for chapter_id (e.g. sec-0, sec-1) from the .docx.",
      inputSchema: {
        docx_path: z.string(),
        chapter_id: z.string(),
      },
    },
    async ({ docx_path, chapter_id }) => {
      try {
        const loaded = await loadDocx(docx_path);
        const sections = buildSections(loaded.paragraphs);
        const sec = findSection(sections, chapter_id);
        return textResult(readSectionText(loaded.paragraphs, sec));
      } catch (e) {
        return textResult(JSON.stringify({ error: String(e) }, null, 2));
      }
    }
  );

  server.registerTool(
    "update_chapter",
    {
      description:
        "Replace section body (excluding heading line) with new_content and save the .docx.",
      inputSchema: {
        docx_path: z.string(),
        chapter_id: z.string(),
        new_content: z.string(),
        requires_graphics_review: z.boolean().optional(),
      },
    },
    async ({
      docx_path,
      chapter_id,
      new_content,
      requires_graphics_review,
    }) => {
      try {
        const loaded = await loadDocx(docx_path);
        const sections = buildSections(loaded.paragraphs);
        const sec = findSection(sections, chapter_id);
        const ph = requires_graphics_review ? GRAPHICS_PLACEHOLDER : null;
        updateSectionBody(loaded.doc, loaded.paragraphs, sec, new_content, ph);
        await saveDocx(loaded);
        return textResult(`Updated ${chapter_id} in ${loaded.abs} and saved.`);
      } catch (e) {
        return textResult(JSON.stringify({ error: String(e) }, null, 2));
      }
    }
  );

  server.registerTool(
    "upload_to_sharepoint",
    {
      description:
        "Stub — organisation-specific auth required. Validates docx path exists.",
      inputSchema: { docx_path: z.string() },
    },
    async ({ docx_path }) => {
      try {
        await loadDocx(docx_path);
        return textResult(
          "upload_to_sharepoint is not implemented in this repo. " +
            "Publish manually or extend this MCP with tenant-specific integration."
        );
      } catch (e) {
        return textResult(JSON.stringify({ error: String(e) }, null, 2));
      }
    }
  );
}
