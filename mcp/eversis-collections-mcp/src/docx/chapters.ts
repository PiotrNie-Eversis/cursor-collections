/**
 * Section model for .docx (OOXML). Body-level w:p in word/document.xml only.
 * Aligned with mcp/eversis-docs-mcp/chapters.py (python-docx) and docs-mcp-node.
 */

import type { Document as XmlDocument, Element as XmlElement } from "@xmldom/xmldom";

export const W_NS = "http://schemas.openxmlformats.org/wordprocessingml/2006/main";
const XML_NS = "http://www.w3.org/XML/1998/namespace";

export interface Section {
  section_id: string;
  level: number;
  title: string;
  start: number;
  end: number;
}

export function listBodyParagraphs(body: XmlElement): XmlElement[] {
  const out: XmlElement[] = [];
  for (let n = body.firstChild; n; n = n.nextSibling) {
    if (n.nodeType !== 1) continue;
    const el = n as XmlElement;
    if (el.namespaceURI === W_NS && el.localName === "p") out.push(el);
  }
  return out;
}

export function getBody(doc: XmlDocument): XmlElement {
  const docEl = doc.documentElement;
  if (!docEl) throw new Error("Empty XML document");
  const bodies = docEl.getElementsByTagNameNS(W_NS, "body");
  if (!bodies.length) throw new Error("No w:body");
  return bodies[0] as XmlElement;
}

function getPStyleVal(p: XmlElement): string | null {
  const pPrs = p.getElementsByTagNameNS(W_NS, "pPr");
  if (!pPrs.length) return null;
  const styles = pPrs[0].getElementsByTagNameNS(W_NS, "pStyle");
  if (!styles.length) return null;
  const st = styles[0];
  return st.getAttribute("w:val") ?? st.getAttributeNS(W_NS, "val");
}

export function isHeadingPara(p: XmlElement): boolean {
  const val = getPStyleVal(p);
  if (!val) return false;
  const lower = val.toLowerCase();
  return lower.includes("heading") || lower.startsWith("toc");
}

export function headingLevel(p: XmlElement): number {
  const val = getPStyleVal(p) ?? "";
  const parts = val.replace(/heading/gi, "").trim().split(/\s+/);
  for (const part of parts) {
    if (/^\d+$/.test(part)) return Math.max(1, Math.min(9, parseInt(part, 10)));
  }
  return 1;
}

export function paragraphText(p: XmlElement): string {
  const texts = p.getElementsByTagNameNS(W_NS, "t");
  let s = "";
  for (let i = 0; i < texts.length; i++) {
    s += texts[i].textContent ?? "";
  }
  return s.trim();
}

export function buildSections(paragraphEls: XmlElement[]): Section[] {
  const headingIndices: { idx: number; level: number; title: string }[] = [];
  for (let i = 0; i < paragraphEls.length; i++) {
    const p = paragraphEls[i];
    if (isHeadingPara(p)) {
      const t = paragraphText(p) || "(untitled)";
      headingIndices.push({ idx: i, level: headingLevel(p), title: t });
    }
  }

  if (!headingIndices.length) {
    return [
      {
        section_id: "sec-0",
        level: 1,
        title: "Document",
        start: 0,
        end: paragraphEls.length,
      },
    ];
  }

  const sections: Section[] = [];
  const firstHeadingIdx = headingIndices[0].idx;
  if (firstHeadingIdx > 0) {
    sections.push({
      section_id: "sec-0",
      level: 1,
      title: "Preamble",
      start: 0,
      end: firstHeadingIdx,
    });
  }

  for (let j = 0; j < headingIndices.length; j++) {
    const { idx, level, title } = headingIndices[j];
    const start = idx;
    const end =
      j + 1 < headingIndices.length ? headingIndices[j + 1].idx : paragraphEls.length;
    const secNum = sections.length;
    sections.push({
      section_id: `sec-${secNum}`,
      level,
      title,
      start,
      end,
    });
  }

  return sections;
}

export function readSectionText(paragraphEls: XmlElement[], section: Section): string {
  const lines: string[] = [];
  for (let i = section.start; i < Math.min(section.end, paragraphEls.length); i++) {
    if (i === section.start && isHeadingPara(paragraphEls[i])) continue;
    const t = paragraphText(paragraphEls[i]);
    if (t) lines.push(t);
  }
  return lines.join("\n\n");
}

export function renderSummaryMd(sections: Section[], docBaseName: string): string {
  const lines = [
    `<!-- Generated map for \`${docBaseName}\` — do not edit structure by hand unless needed. -->`,
    "",
    "| chapter_id | level | title |",
    "| --- | --- | --- |",
  ];
  for (const s of sections) {
    const title = s.title.replace(/\|/g, "\\|");
    lines.push(`| \`${s.section_id}\` | ${s.level} | ${title} |`);
  }
  return lines.join("\n");
}

export function createTextParagraph(ownerDoc: XmlDocument, text: string): XmlElement {
  const p = ownerDoc.createElementNS(W_NS, "w:p");
  const r = ownerDoc.createElementNS(W_NS, "w:r");
  const t = ownerDoc.createElementNS(W_NS, "w:t");
  if (/^\s|\s$/.test(text)) {
    t.setAttributeNS(XML_NS, "xml:space", "preserve");
  }
  t.appendChild(ownerDoc.createTextNode(text));
  r.appendChild(t);
  p.appendChild(r);
  return p;
}

export function insertAfter(parent: XmlElement, newEl: XmlElement, after: XmlElement): void {
  const next = after.nextSibling;
  if (next) parent.insertBefore(newEl, next);
  else parent.appendChild(newEl);
}

export function updateSectionBody(
  ownerDoc: XmlDocument,
  paragraphEls: XmlElement[],
  section: Section,
  newContent: string,
  placeholderGraphics?: string | null
): void {
  if (section.start >= paragraphEls.length) return;
  const anchorPara = paragraphEls[section.start];
  const startBody = isHeadingPara(anchorPara) ? section.start + 1 : section.start;
  const end = Math.min(section.end, paragraphEls.length);

  const toRemove: XmlElement[] = [];
  for (let i = startBody; i < end; i++) {
    toRemove.push(paragraphEls[i]);
  }
  const parent = anchorPara.parentNode as XmlElement;
  for (const el of toRemove) {
    el.parentNode?.removeChild(el);
  }

  let body = newContent.trimEnd();
  if (placeholderGraphics) body = `${body}\n\n${placeholderGraphics.trim()}`;

  let ref: XmlElement = anchorPara;
  for (const block of body.split(/\n\n+/)) {
    const line = block.trim();
    if (!line) continue;
    const newP = createTextParagraph(ownerDoc, line);
    insertAfter(parent, newP, ref);
    ref = newP;
  }
}
