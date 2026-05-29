#!/usr/bin/env node
/**
 * Smoke tests for validate-cursor-markdown-links.mjs (--paths support).
 *
 * Usage (from repo root):
 *   node scripts/validate-cursor-markdown-links.test.mjs
 */
import { spawnSync } from "node:child_process";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");
const script = path.join(__dirname, "validate-cursor-markdown-links.mjs");
const templatePath =
  "scripts/setup-cursor-local/templates/eversis-project-stack.example.mdc";

function run(args) {
  return spawnSync(process.execPath, [script, ...args], {
    cwd: root,
    encoding: "utf8",
  });
}

let pass = 0;
let fail = 0;

function ok(name, cond) {
  if (cond) {
    console.log(`  ✓ ${name}`);
    pass += 1;
  } else {
    console.log(`  ✗ ${name}`);
    fail += 1;
  }
}

console.log("validate-cursor-markdown-links.test.mjs\n");

const t1 = run(["--context=source"]);
ok("T1 source without --paths exits 0", t1.status === 0);

const t2 = run(["--context=source", `--paths=${templatePath}`]);
ok("T2 source with consumer template --paths exits 0", t2.status === 0);

const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "validate-links-test-"));
const badFile = path.join(tmpDir, "broken.mdc");
fs.writeFileSync(badFile, "[missing](does-not-exist.md)\n", "utf8");
const relBad = path.relative(root, badFile);
const t3 = run(["--context=source", `--paths=${relBad}`]);
ok("T3 --paths with broken link exits non-zero", t3.status !== 0);
fs.rmSync(tmpDir, { recursive: true, force: true });

const t4 = run(["--context=source", "--paths=definitely/missing-file.mdc"]);
ok("T4 --paths missing file exits non-zero", t4.status !== 0);

console.log(`\n${fail === 0 ? "✅" : "❌"} ${pass} passed, ${fail} failed`);
process.exit(fail === 0 ? 0 : 1);
