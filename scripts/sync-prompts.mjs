#!/usr/bin/env node
/**
 * Copies canonical prompt bodies from .cursor/prompts/ into website/docs/prompts/
 * so Docusaurus can build. Generated eversis-*.md files are gitignored.
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");

const pairs = [
  [path.join(root, ".cursor/prompts/public"), path.join(root, "website/docs/prompts/public")],
  [path.join(root, ".cursor/prompts/internal"), path.join(root, "website/docs/prompts/internal")],
];

for (const [srcDir, destDir] of pairs) {
  if (!fs.existsSync(srcDir)) {
    console.error(`sync-prompts: missing source directory ${srcDir}`);
    process.exit(1);
  }
  fs.mkdirSync(destDir, { recursive: true });
  for (const name of fs.readdirSync(srcDir)) {
    if (!name.startsWith("eversis-") || !name.endsWith(".md")) continue;
    fs.copyFileSync(path.join(srcDir, name), path.join(destDir, name));
  }
}

console.log("sync-prompts: copied eversis-*.md to website/docs/prompts/{public,internal}/");
