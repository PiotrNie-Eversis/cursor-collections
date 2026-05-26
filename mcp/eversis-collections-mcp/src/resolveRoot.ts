import fs from "node:fs";
import path from "node:path";

/**
 * Walk upward from `startDir` until `.cursor/skills` exists.
 * Falls back to env overrides when walk-up finds nothing:
 *   1. CURSOR_COLLECTIONS_HOME  (canonical)
 *   2. EVERSIS_COLLECTIONS_ROOT (legacy — deprecated, kept for backwards compat)
 */
export function findRepoRoot(startDir: string): string {
  let dir = path.resolve(startDir);
  for (;;) {
    const skillsPath = path.join(dir, ".cursor", "skills");
    if (fs.existsSync(skillsPath) && fs.statSync(skillsPath).isDirectory()) {
      return dir;
    }
    const parent = path.dirname(dir);
    if (parent === dir) {
      break;
    }
    dir = parent;
  }

  // Try env overrides in priority order.
  const candidates: Array<{ name: string; value: string | undefined }> = [
    { name: "CURSOR_COLLECTIONS_HOME", value: process.env["CURSOR_COLLECTIONS_HOME"] },
    { name: "EVERSIS_COLLECTIONS_ROOT", value: process.env["EVERSIS_COLLECTIONS_ROOT"] },
  ];

  for (const { name, value } of candidates) {
    if (!value) continue;
    const resolved = path.resolve(value);
    const skillsPath = path.join(resolved, ".cursor", "skills");
    if (fs.existsSync(skillsPath)) {
      return resolved;
    }
    throw new Error(
      `${name}=${value} does not contain .cursor/skills`,
    );
  }

  throw new Error(
    "Could not find repository root (directory with .cursor/skills). " +
    "Set CURSOR_COLLECTIONS_HOME to the cursor-collections checkout path.",
  );
}

export function assertUnderRoot(repoRoot: string, candidate: string): string {
  const resolved = path.resolve(candidate);
  const root = path.resolve(repoRoot);
  if (!resolved.startsWith(root + path.sep) && resolved !== root) {
    throw new Error(`Path escapes repository root: ${candidate}`);
  }
  return resolved;
}
