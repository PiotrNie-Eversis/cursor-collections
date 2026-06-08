#!/usr/bin/env node
/**
 * Guard against README ↔ site terminology drift (A+ parity gate).
 * Skips synced/generated docs (prompts/, framework-reference.md).
 */
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative } from "node:path";

const ROOT = new URL("..", import.meta.url).pathname;

const SCAN_ROOTS = [
  join(ROOT, "README.md"),
  join(ROOT, "website/docs"),
  join(ROOT, "website/src/components"),
];

const SKIP_PATH_PARTS = [
  `${join("website", "docs", "prompts")}${join("", "")}`, // website/docs/prompts
  join("website", "docs", "framework-reference.md"),
];

function shouldSkip(file) {
  const rel = relative(ROOT, file);
  if (rel.includes("website/docs/prompts/")) return true;
  if (rel === "website/docs/framework-reference.md") return true;
  if (rel.includes("website/src/pages/changelog.md")) return true;
  return false;
}

function collectFiles(path) {
  const st = statSync(path);
  if (st.isFile()) {
    return path.endsWith(".md") || path.endsWith(".tsx") || path.endsWith(".ts")
      ? [path]
      : [];
  }
  const out = [];
  for (const name of readdirSync(path)) {
    if (name.startsWith(".")) continue;
    out.push(...collectFiles(join(path, name)));
  }
  return out;
}

function checkFile(file) {
  const rel = relative(ROOT, file);
  const lines = readFileSync(file, "utf8").split("\n");
  const violations = [];

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const loc = `${rel}:${i + 1}`;

    if (/Product Ideation/.test(line)) {
      violations.push({ loc, label: "Product Ideation (use Ideate)" });
    }

    if (/not built-in/i.test(line) && /slash command/i.test(line)) {
      violations.push({ loc, label: "not built-in slash commands" });
    }

    if (/\/tsh-/.test(line)) {
      const negated =
        /not used|are not used|Legacy|no legacy|not used in Cursor/i.test(line);
      if (!negated) {
        violations.push({ loc, label: "/tsh- legacy commands (undocumented)" });
      }
    }
  }

  return violations;
}

const files = SCAN_ROOTS.flatMap(collectFiles).filter((f) => !shouldSkip(f));
const violations = files.flatMap(checkFile);

if (violations.length > 0) {
  console.error("README/site parity check failed:\n");
  for (const v of violations) {
    console.error(`  - ${v.loc}: ${v.label}`);
  }
  process.exit(1);
}

console.log("README/site parity check passed.");
