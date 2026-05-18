#!/usr/bin/env node
/**
 * Validates markdown [text](href) links under .cursor/ (source) or
 * website/docs/prompts/ (synced, after sync-prompts).
 *
 * Usage:
 *   node scripts/validate-cursor-markdown-links.mjs [--context=source|synced]
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { buildPromptSlugIndex } from "./lib/prompt-link-rewrite.mjs";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");

const contextArg = process.argv.find((a) => a.startsWith("--context="));
const context = contextArg?.split("=")[1] || "source";

const LINK_RE = /\[([^\]]*)\]\(([^)]+)\)/g;
const SKIP_HREF = /^(https?:|mailto:|#)/i;

function isGlobOrPlaceholder(href) {
  return /[*<>]/.test(href);
}

function collectFiles(dir, extensions, out = []) {
  if (!fs.existsSync(dir)) return out;
  for (const name of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, name.name);
    if (name.isDirectory()) collectFiles(full, extensions, out);
    else if (extensions.some((ext) => name.name.endsWith(ext))) out.push(full);
  }
  return out;
}

function parseFrontmatterSlug(content) {
  const m = content.match(/^slug:\s*["']?([^"'\n]+)["']?\s*$/m);
  return m?.[1]?.trim();
}

function buildSyncedResolver(promptsSyncedRoot, slugIndex) {
  const agentsDir = path.join(root, "website/docs/agents");

  return function resolveSynced(fromFile, href) {
    const raw = href.split("#")[0].trim();
    if (!raw || SKIP_HREF.test(raw) || isGlobOrPlaceholder(raw)) return { ok: true };

    const fromDir = path.dirname(fromFile);
    let target = path.resolve(fromDir, raw);

    if (raw.startsWith("../../agents/")) {
      const agent = raw.replace("../../agents/", "").replace(/\.md$/, "");
      target = path.join(agentsDir, `${agent}.md`);
    } else if (raw.startsWith("../public/")) {
      const slug = raw.replace("../public/", "").replace(/\.md$/, "");
      const file = findPromptBySlug(slugIndex, "public", slug);
      target = file ? path.join(promptsSyncedRoot, "public", file) : target;
    } else if (raw.startsWith("../internal/")) {
      const slug = raw.replace("../internal/", "").replace(/\.md$/, "");
      const file = findPromptBySlug(slugIndex, "internal", slug);
      target = file ? path.join(promptsSyncedRoot, "internal", file) : target;
    } else if (raw.startsWith("./public/")) {
      const slug = raw.replace("./public/", "").replace(/\.md$/, "");
      const file = findPromptBySlug(slugIndex, "public", slug);
      target = file ? path.join(promptsSyncedRoot, "public", file) : target;
    } else if (raw.startsWith("./internal/")) {
      const slug = raw.replace("./internal/", "").replace(/\.md$/, "");
      const file = findPromptBySlug(slugIndex, "internal", slug);
      target = file ? path.join(promptsSyncedRoot, "internal", file) : target;
    } else if (raw.startsWith("./")) {
      const slug = raw.slice(2).replace(/\.md$/, "");
      const tier = fromFile.includes(`${path.sep}internal${path.sep}`) ? "internal" : "public";
      const file = findPromptBySlug(slugIndex, tier, slug);
      target = file ? path.join(fromDir, file) : path.join(fromDir, `${slug}.md`);
    }

    if (fs.existsSync(target)) return { ok: true, target };
    if (fs.existsSync(`${target}.md`)) return { ok: true, target: `${target}.md` };
    return { ok: false, target };
  };
}

function findPromptBySlug(slugIndex, tier, slug) {
  for (const [key, value] of slugIndex.entries()) {
    if (key.startsWith(`${tier}/`) && value === slug) {
      return key.split("/")[1];
    }
  }
  const guess = `eversis-${slug}.md`;
  if (slugIndex.has(`${tier}/${guess}`)) return guess;
  return null;
}

function resolveSource(fromFile, href) {
  const raw = href.split("#")[0].trim();
  if (!raw || SKIP_HREF.test(raw) || isGlobOrPlaceholder(raw)) return { ok: true };

  const fromDir = path.dirname(fromFile);
  let target;

  if (raw.startsWith(".cursor/")) {
    target = path.join(root, raw);
  } else {
    target = path.resolve(fromDir, raw);
  }

  const candidates = [target];
  if (!path.extname(target)) {
    candidates.push(`${target}.md`, `${target}.mdc`);
  }

  for (const c of candidates) {
    if (fs.existsSync(c)) return { ok: true, target: c };
  }
  return { ok: false, target };
}

function validateFiles(files, resolver) {
  const errors = [];
  for (const file of files) {
    const content = fs.readFileSync(file, "utf8");
    let match;
    LINK_RE.lastIndex = 0;
    while ((match = LINK_RE.exec(content)) !== null) {
      const href = match[2];
      const result = resolver(file, href);
      if (!result.ok) {
        errors.push({
          file: path.relative(root, file),
          href,
          resolved: path.relative(root, result.target),
        });
      }
    }
  }
  return errors;
}

const slugIndex = buildPromptSlugIndex(path.join(root, ".cursor/prompts"));

let files;
let resolver;

if (context === "synced") {
  const syncedRoot = path.join(root, "website/docs/prompts");
  files = collectFiles(syncedRoot, [".md"]);
  resolver = buildSyncedResolver(syncedRoot, slugIndex);
} else {
  const dirs = [
    path.join(root, ".cursor/commands"),
    path.join(root, ".cursor/rules"),
    path.join(root, ".cursor/prompts"),
    path.join(root, ".cursor/skills"),
  ];
  files = dirs.flatMap((d) => collectFiles(d, [".md", ".mdc"]));
  resolver = resolveSource;
}

const errors = validateFiles(files, resolver);

if (errors.length === 0) {
  console.log(`validate-cursor-markdown-links (${context}): OK (${files.length} files)`);
  process.exit(0);
}

console.error(`validate-cursor-markdown-links (${context}): ${errors.length} broken link(s)\n`);
for (const e of errors) {
  console.error(`  ${e.file}\n    href: ${e.href}\n    resolved: ${e.resolved}\n`);
}
process.exit(1);
