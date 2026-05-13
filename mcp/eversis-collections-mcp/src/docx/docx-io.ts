import { readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { DOMParser, XMLSerializer } from "@xmldom/xmldom";
import type { Document as XmlDocument, Element as XmlElement } from "@xmldom/xmldom";
import JSZip from "jszip";
import { getBody, listBodyParagraphs } from "./chapters.js";

export interface LoadedDocx {
  abs: string;
  zip: JSZip;
  doc: XmlDocument;
  body: XmlElement;
  paragraphs: XmlElement[];
}

export async function loadDocx(docxPath: string): Promise<LoadedDocx> {
  const abs = path.resolve(docxPath);
  let buf: Buffer;
  try {
    buf = await readFile(abs);
  } catch {
    throw new Error(`Not a file: ${abs}`);
  }
  const zip = await JSZip.loadAsync(buf);
  const f = zip.file("word/document.xml");
  if (!f) throw new Error("word/document.xml missing in docx");
  const xml = await f.async("string");
  const parser = new DOMParser();
  const doc = parser.parseFromString(xml, "application/xml") as XmlDocument;
  const docEl = doc.documentElement;
  if (!docEl) throw new Error("Empty document.xml");
  if (docEl.localName === "parsererror") {
    throw new Error("Failed to parse word/document.xml");
  }
  const body = getBody(doc);
  const paragraphs = listBodyParagraphs(body);
  return { abs, zip, doc, body, paragraphs };
}

export async function saveDocx(loaded: LoadedDocx): Promise<void> {
  const { zip, doc, abs } = loaded;
  const ser = new XMLSerializer();
  const root = doc.documentElement;
  if (!root) throw new Error("No document root");
  const out = ser.serializeToString(root);
  const decl = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>';
  zip.file("word/document.xml", `${decl}\n${out}`);
  const buf = await zip.generateAsync({ type: "nodebuffer" });
  await writeFile(abs, buf);
}
