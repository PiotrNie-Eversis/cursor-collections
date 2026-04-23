#!/usr/bin/env node
/**
 * Copies documentation/cursor-collection.md into website/docs/framework-reference.md
 * with Docusaurus-friendly link targets and a front matter block.
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");
const src = path.join(root, "documentation/cursor-collection.md");
const dest = path.join(root, "website/docs/framework-reference.md");

const GITHUB_BLOB =
  "https://github.com/PiotrNie-Eversis/cursor-collections/blob/main";
const GITHUB_TREE =
  "https://github.com/PiotrNie-Eversis/cursor-collections/tree/main";

if (!fs.existsSync(src)) {
  console.error(`sync-framework-doc: missing ${src}`);
  process.exit(1);
}

let body = fs.readFileSync(src, "utf8");

const replacements = [
  [
    "[website/docs/prompts/overview.md](../website/docs/prompts/overview.md)",
    "[Prompts overview](./prompts/overview)",
  ],
  [
    "[website/docs/agents/](../website/docs/agents/)",
    "[Agents](./agents/overview)",
  ],
  [
    "[CHANGELOG.md](../CHANGELOG.md)",
    `[CHANGELOG.md](${GITHUB_BLOB}/CHANGELOG.md)`,
  ],
  ["[AGENTS.md](../AGENTS.md)", `[AGENTS.md](${GITHUB_BLOB}/AGENTS.md)`],
  ["[README](../README.md)", `[README](${GITHUB_BLOB}/README.md)`],
  ["](../.cursor/mcp.json)", `](${GITHUB_BLOB}/.cursor/mcp.json)`],
  ["](../.cursor/skills/)", `](${GITHUB_TREE}/.cursor/skills)`],
  ["](../mcp/eversis-collections-mcp/)", `](${GITHUB_TREE}/mcp/eversis-collections-mcp)`],
  ["](../.cursor/rules/)", `](${GITHUB_TREE}/.cursor/rules)`],
];

for (const [from, to] of replacements) {
  body = body.split(from).join(to);
}

body = body.split("**`sync-prompts`**").join("**`sync-docs-assets`**");

const frontmatter = `---
id: framework-reference
title: Framework reference
sidebar_label: Framework reference
description: Authoritative packaging, workflow variants, and per-project bootstrap checklist for Cursor Collections.
slug: /framework
sidebar_position: 2
---

:::tip Source of truth
This page is generated from [\`documentation/cursor-collection.md\`](${GITHUB_BLOB}/documentation/cursor-collection.md) in the repository. Edit that file, then run \`npm run sync-docs-assets\` from \`website/\` (or use \`prestart\` / \`prebuild\`) to refresh.
:::

`;

fs.writeFileSync(dest, frontmatter + body, "utf8");
console.log("sync-framework-doc: wrote website/docs/framework-reference.md");
