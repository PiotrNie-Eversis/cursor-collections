#!/usr/bin/env node
/**
 * One-shot port helper for Phase H (upstream PR #50 → eversis-*).
 * Run: node scripts/port-qa-phase-h.mjs
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");
const SHA = "a25c94578339f1d1352aaf4eccab52afef6af15b";
const BASE = `https://raw.githubusercontent.com/TheSoftwareHouse/copilot-collections/${SHA}`;

const SKILL_MAP = {
  "tsh-verifying-acceptance-criteria": "eversis-verifying-acceptance-criteria",
  "tsh-functional-testing": "eversis-functional-testing",
  "tsh-analyzing-bugs": "eversis-analyzing-bugs",
  "tsh-analyzing-regression-risk": "eversis-analyzing-regression-risk",
  "tsh-accessibility-auditing": "eversis-accessibility-auditing",
  "tsh-planning-tests": "eversis-planning-tests",
};

const SKILL_FILES = [
  ".github/skills/tsh-verifying-acceptance-criteria/SKILL.md",
  ".github/skills/tsh-functional-testing/SKILL.md",
  ".github/skills/tsh-analyzing-bugs/SKILL.md",
  ".github/skills/tsh-analyzing-regression-risk/SKILL.md",
  ".github/skills/tsh-accessibility-auditing/SKILL.md",
  ".github/skills/tsh-planning-tests/SKILL.md",
  ".github/skills/tsh-functional-testing/examples/bug-report.example.md",
  ".github/skills/tsh-functional-testing/examples/regression-scope.example.md",
  ".github/skills/tsh-functional-testing/examples/regression-test-suite.example.md",
  ".github/skills/tsh-functional-testing/examples/test-cases.example.md",
  ".github/skills/tsh-functional-testing/examples/test-plan.example.md",
  ".github/skills/tsh-functional-testing/examples/test-report.example.md",
  ".github/skills/tsh-analyzing-regression-risk/examples/regression-scope.example.md",
  ".github/skills/tsh-analyzing-regression-risk/examples/regression-test-suite.example.md",
  ".github/skills/tsh-analyzing-regression-risk/examples/test-cases.example.md",
  ".github/skills/tsh-planning-tests/examples/bug-report.example.md",
  ".github/skills/tsh-planning-tests/examples/test-cases.example.md",
  ".github/skills/tsh-planning-tests/examples/test-plan.example.md",
  ".github/skills/tsh-accessibility-auditing/examples/audit-report.example.md",
  ".github/skills/tsh-accessibility-auditing/examples/business-summary.example.md",
  ".github/skills/tsh-accessibility-auditing/references/automated-tools.md",
  ".github/skills/tsh-accessibility-auditing/references/interactive-components.md",
  ".github/skills/tsh-accessibility-auditing/references/wcag22-new-criteria.md",
];

function transform(text) {
  let out = text;
  for (const [from, to] of Object.entries(SKILL_MAP)) {
    out = out.split(from).join(to);
  }
  out = out
    .replace(/`vscode\/askQuestions`/g, "chat")
    .replace(/vscode\/askQuestions/g, "ask the user in chat")
    .replace(/\/tsh-analyze-materials/g, "@eversis-analyze-materials")
    .replace(/`tsh-atlassian-mcp` instruction file/g, "Atlassian MCP tool patterns")
    .replace(/get_changed_files tool/g, "git diff or workspace search")
    .replace(/user-invocable: false\n/g, "user-invocable: false\n");
  if (!out.includes("user-invocable:") && out.startsWith("---\nname:")) {
    out = out.replace(/^(---\nname:[^\n]+\n)/, "$1user-invocable: false\n");
  }
  return out;
}

function destPath(upstreamPath) {
  const rel = upstreamPath.replace(/^\.github\/skills\//, "");
  const [skillDir, ...rest] = rel.split("/");
  const eversisDir = SKILL_MAP[skillDir];
  if (!eversisDir) throw new Error(`Unknown skill dir: ${skillDir}`);
  return path.join(root, ".cursor/skills", eversisDir, ...rest);
}

async function fetchText(url) {
  const res = await fetch(url);
  if (!res.ok) throw new Error(`Fetch failed ${url}: ${res.status}`);
  return res.text();
}

for (const upstream of SKILL_FILES) {
  const url = `${BASE}/${upstream}`;
  const dest = destPath(upstream);
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  const raw = await fetchText(url);
  fs.writeFileSync(dest, transform(raw), "utf8");
  console.log("wrote", path.relative(root, dest));
}

console.log("done");
