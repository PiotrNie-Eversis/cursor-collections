#!/usr/bin/env node
/**
 * Copies canonical prompt bodies from .cursor/prompts/ into website/docs/prompts/
 * for Docusaurus. Rewrites link targets for the docs site (see prompt-link-rewrite.mjs).
 *
 * Source (.cursor/prompts/):  ../../../website/docs/agents/foo.md, eversis-*.md paths
 * Synced (website/docs/prompts/): ../../agents/foo, slug paths (./implement, ../public/review)
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import {
  buildPromptSlugIndex,
  rewritePromptLinksForDocusaurus,
} from "./lib/prompt-link-rewrite.mjs";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");
const promptsRoot = path.join(root, ".cursor/prompts");
const slugIndex = buildPromptSlugIndex(promptsRoot);

const pairs = [
  [path.join(promptsRoot, "public"), path.join(root, "website/docs/prompts/public")],
  [path.join(promptsRoot, "internal"), path.join(root, "website/docs/prompts/internal")],
];

let totalReplacements = 0;
let fileCount = 0;

for (const [srcDir, destDir] of pairs) {
  if (!fs.existsSync(srcDir)) {
    console.error(`sync-prompts: missing source directory ${srcDir}`);
    process.exit(1);
  }
  fs.mkdirSync(destDir, { recursive: true });
  for (const name of fs.readdirSync(srcDir)) {
    if (!name.startsWith("eversis-") || !name.endsWith(".md")) continue;
    const raw = fs.readFileSync(path.join(srcDir, name), "utf8");
    const { body, replacements } = rewritePromptLinksForDocusaurus(raw, slugIndex);
    fs.writeFileSync(path.join(destDir, name), body, "utf8");
    totalReplacements += replacements;
    fileCount += 1;
  }
}

console.log(
  `sync-prompts: copied ${fileCount} eversis-*.md to website/docs/prompts/{public,internal}/ (${totalReplacements} link rewrite(s))`,
);
