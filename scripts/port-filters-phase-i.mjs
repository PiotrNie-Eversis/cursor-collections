#!/usr/bin/env node
/**
 * Port helper for Phase I (upstream PR #51 → eversis-implementing-filters).
 * Run: node scripts/port-filters-phase-i.mjs
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");
const PR = "refs/pull/51/head";
const BASE = `https://raw.githubusercontent.com/TheSoftwareHouse/copilot-collections/${PR}`;

const FILES = [
  ".github/skills/tsh-implementing-filters/SKILL.md",
  ".github/skills/tsh-implementing-filters/references/nextjs-patterns.md",
  ".github/skills/tsh-implementing-filters/references/react-patterns.md",
];

const DEST = ".cursor/skills/eversis-implementing-filters";

function transform(text, isSkill) {
  let out = text
    .replace(/tsh-implementing-filters/g, "eversis-implementing-filters")
    .replace(/tsh-implementing-frontend/g, "eversis-implementing-frontend")
    .replace(/tsh-implementing-forms/g, "eversis-implementing-forms")
    .replace(/tsh-writing-hooks/g, "eversis-writing-hooks")
    .replace(/tsh-optimizing-frontend/g, "eversis-optimizing-frontend")
    .replace(/tsh-ensuring-accessibility/g, "eversis-ensuring-accessibility")
    .replace(/tsh-sql-and-database-understanding/g, "eversis-sql-and-database-understanding")
    .replace(/tsh-implementing-backend/g, "eversis-implementing-backend");

  if (isSkill && !out.includes("user-invocable:")) {
    out = out.replace(/^(---\nname:[^\n]+\n)/, "$1user-invocable: false\n");
  }

  if (!isSkill) {
    out = out.replace(/for the tsh-implementing-filters skill/g, "for the eversis-implementing-filters skill");
  }

  return out;
}

async function fetchText(url) {
  const res = await fetch(url);
  if (!res.ok) throw new Error(`Fetch failed ${url}: ${res.status}`);
  return res.text();
}

for (const rel of FILES) {
  const url = `${BASE}/${rel}`;
  const text = transform(await fetchText(url), rel.endsWith("SKILL.md"));
  const sub = rel.replace(/^\.github\/skills\/tsh-implementing-filters\//, "");
  const dest = path.join(root, DEST, sub);
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  fs.writeFileSync(dest, text);
  console.log("wrote", path.relative(root, dest));
}
