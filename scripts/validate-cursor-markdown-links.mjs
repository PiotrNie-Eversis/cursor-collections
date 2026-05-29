#!/usr/bin/env node
/**
 * Validates markdown [text](href) links under .cursor/ (source) or
 * website/docs/prompts/ (synced, after sync-prompts).
 *
 * Slug links in synced/agents context resolve via frontmatter-derived maps
 * (see buildPromptSlugMaps in ./lib/prompt-link-rewrite.mjs).
 *
 * Usage:
 *   node scripts/validate-cursor-markdown-links.mjs [--context=source|synced|agents]
 *   node scripts/validate-cursor-markdown-links.mjs --context=source \
 *     --paths=scripts/setup-cursor-local/templates/eversis-project-stack.example.mdc
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import {
  buildPromptSlugMaps,
  resolvePromptFilenameBySlug,
} from "./lib/prompt-link-rewrite.mjs";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");

const contextArg = process.argv.find((a) => a.startsWith("--context="));
const context = contextArg?.split("=")[1] || "source";

const extraPathSpecs = process.argv
  .filter((a) => a.startsWith("--paths="))
  .flatMap((a) => a.slice("--paths=".length).split(","))
  .map((s) => s.trim())
  .filter(Boolean);

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

function collectExtraPaths(specs) {
  const out = [];
  for (const spec of specs) {
    const abs = path.resolve(root, spec);
    if (!fs.existsSync(abs)) {
      console.error(`validate-cursor-markdown-links: --paths not found: ${spec}`);
      process.exit(1);
    }
    const stat = fs.statSync(abs);
    if (stat.isDirectory()) {
      collectFiles(abs, [".md", ".mdc"], out);
    } else if ([".md", ".mdc"].some((ext) => abs.endsWith(ext))) {
      out.push(abs);
    } else {
      console.error(
        `validate-cursor-markdown-links: --paths must be .md/.mdc file or directory: ${spec}`,
      );
      process.exit(1);
    }
  }
  return out;
}

function dedupeFiles(fileList) {
  const seen = new Set();
  const unique = [];
  for (const file of fileList) {
    let key;
    try {
      key = fs.realpathSync(file);
    } catch {
      key = path.resolve(file);
    }
    if (seen.has(key)) continue;
    seen.add(key);
    unique.push(file);
  }
  return unique;
}

function promptTargetPath(promptsRoot, tier, slug, slugToFile) {
  const file = resolvePromptFilenameBySlug(slugToFile, tier, slug);
  return file ? path.join(promptsRoot, tier, file) : null;
}

function buildSyncedResolver(promptsSyncedRoot, slugToFile) {
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
      target = promptTargetPath(promptsSyncedRoot, "public", slug, slugToFile) ?? target;
    } else if (raw.startsWith("../internal/")) {
      const slug = raw.replace("../internal/", "").replace(/\.md$/, "");
      target = promptTargetPath(promptsSyncedRoot, "internal", slug, slugToFile) ?? target;
    } else if (raw.startsWith("./public/")) {
      const slug = raw.replace("./public/", "").replace(/\.md$/, "");
      target = promptTargetPath(promptsSyncedRoot, "public", slug, slugToFile) ?? target;
    } else if (raw.startsWith("./internal/")) {
      const slug = raw.replace("./internal/", "").replace(/\.md$/, "");
      target = promptTargetPath(promptsSyncedRoot, "internal", slug, slugToFile) ?? target;
    } else if (raw.startsWith("./")) {
      const slug = raw.slice(2).replace(/\.md$/, "");
      const tier = fromFile.includes(`${path.sep}internal${path.sep}`) ? "internal" : "public";
      target = promptTargetPath(promptsSyncedRoot, tier, slug, slugToFile) ?? path.join(fromDir, `${slug}.md`);
    }

    if (fs.existsSync(target)) return { ok: true, target };
    if (fs.existsSync(`${target}.md`)) return { ok: true, target: `${target}.md` };
    return { ok: false, target };
  };
}

function buildAgentsResolver(promptsSyncedRoot, slugToFile) {
  const agentsDir = path.join(root, "website/docs/agents");
  const skillsDir = path.join(root, "website/docs/skills");
  const frameworkDoc = path.join(root, "website/docs/framework-reference.md");

  return function resolveAgents(fromFile, href) {
    const raw = href.split("#")[0].trim();
    if (!raw || SKIP_HREF.test(raw) || isGlobOrPlaceholder(raw)) return { ok: true };

    const fromDir = path.dirname(fromFile);
    let target = path.resolve(fromDir, raw);

    if (raw === "../framework" || raw === "../framework-reference") {
      target = frameworkDoc;
    } else if (raw.startsWith("./")) {
      const agent = raw.slice(2).replace(/\.md$/, "");
      target = path.join(agentsDir, `${agent}.md`);
    } else if (raw.startsWith("../prompts/public/")) {
      const slug = raw.replace("../prompts/public/", "").replace(/\.md$/, "");
      target = promptTargetPath(promptsSyncedRoot, "public", slug, slugToFile) ?? target;
    } else if (raw.startsWith("../prompts/internal/")) {
      const slug = raw.replace("../prompts/internal/", "").replace(/\.md$/, "");
      target = promptTargetPath(promptsSyncedRoot, "internal", slug, slugToFile) ?? target;
    } else if (raw.startsWith("../skills/")) {
      const docId = raw.replace("../skills/", "").replace(/\.md$/, "");
      target = path.join(skillsDir, `${docId}.md`);
    }

    if (fs.existsSync(target)) return { ok: true, target };
    if (fs.existsSync(`${target}.md`)) return { ok: true, target: `${target}.md` };
    return { ok: false, target };
  };
}

function resolveSource(fromFile, href) {
  const raw = href.split("#")[0].trim();
  if (!raw || SKIP_HREF.test(raw) || isGlobOrPlaceholder(raw)) return { ok: true };

  let fromDir = path.dirname(fromFile);
  // Consumer stack template uses links as if deployed to .cursor/rules/
  if (fromDir.includes(`${path.sep}setup-cursor-local${path.sep}templates`)) {
    fromDir = path.join(root, ".cursor/rules");
  }

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

const { slugToFile, collisions } = buildPromptSlugMaps(path.join(root, ".cursor/prompts"));

if (collisions.length > 0) {
  console.error("validate-cursor-markdown-links: duplicate slug(s) in prompt frontmatter:\n");
  for (const c of collisions) {
    console.error(`  ${c.tier}/${c.slug}: ${c.files.join(" vs ")}\n`);
  }
  process.exit(1);
}

let files;
let resolver;

if (context === "synced") {
  const syncedRoot = path.join(root, "website/docs/prompts");
  files = collectFiles(syncedRoot, [".md"]);
  resolver = buildSyncedResolver(syncedRoot, slugToFile);
} else if (context === "agents") {
  const agentsRoot = path.join(root, "website/docs/agents");
  const syncedRoot = path.join(root, "website/docs/prompts");
  files = collectFiles(agentsRoot, [".md"]);
  resolver = buildAgentsResolver(syncedRoot, slugToFile);
} else if (context !== "source") {
  console.error(`Unknown --context=${context} (use source, synced, or agents)`);
  process.exit(1);
} else {
  const dirs = [
    path.join(root, ".cursor/commands"),
    path.join(root, ".cursor/rules"),
    path.join(root, ".cursor/prompts"),
    path.join(root, ".cursor/skills"),
  ];
  files = dedupeFiles([
    ...dirs.flatMap((d) => collectFiles(d, [".md", ".mdc"])),
    ...collectExtraPaths(extraPathSpecs),
  ]);
  resolver = resolveSource;
}

if (extraPathSpecs.length > 0 && context !== "source") {
  console.warn(
    `validate-cursor-markdown-links: --paths ignored (only supported with --context=source)`,
  );
}

const errors = validateFiles(files, resolver);

if (errors.length === 0) {
  console.log(
    `validate-cursor-markdown-links (${context}): OK (${files.length} files, ${slugToFile.size} slug(s) indexed)`,
  );
  process.exit(0);
}

console.error(`validate-cursor-markdown-links (${context}): ${errors.length} broken link(s)\n`);
for (const e of errors) {
  console.error(`  ${e.file}\n    href: ${e.href}\n    resolved: ${e.resolved}\n`);
}
process.exit(1);
