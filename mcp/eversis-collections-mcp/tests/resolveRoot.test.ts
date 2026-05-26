import assert from "node:assert/strict";
import fs from "node:fs";
import { mkdtemp, mkdir, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import path from "node:path";
import { test, beforeEach, afterEach } from "node:test";
import { findRepoRoot } from "../src/resolveRoot.ts";

// ─── helpers ────────────────────────────────────────────────────────────────

async function makeFakeRoot(): Promise<string> {
  const dir = await mkdtemp(path.join(tmpdir(), "eversis-resolve-test-"));
  await mkdir(path.join(dir, ".cursor", "skills"), { recursive: true });
  return dir;
}

let savedEnv: Record<string, string | undefined> = {};

function setEnv(key: string, value: string | undefined): void {
  savedEnv[key] = process.env[key];
  if (value === undefined) {
    delete process.env[key];
  } else {
    process.env[key] = value;
  }
}

function restoreEnv(): void {
  for (const [key, value] of Object.entries(savedEnv)) {
    if (value === undefined) {
      delete process.env[key];
    } else {
      process.env[key] = value;
    }
  }
  savedEnv = {};
}

// ─── tests ───────────────────────────────────────────────────────────────────

test("findRepoRoot — walk-up finds .cursor/skills", async () => {
  const root = await makeFakeRoot();
  const nested = path.join(root, "a", "b", "c");
  await mkdir(nested, { recursive: true });
  try {
    const found = findRepoRoot(nested);
    assert.equal(found, root);
  } finally {
    await rm(root, { recursive: true, force: true });
  }
});

test("findRepoRoot — CURSOR_COLLECTIONS_HOME used when walk-up fails", async () => {
  const fakeHome = await makeFakeRoot();
  const unrelated = await mkdtemp(path.join(tmpdir(), "eversis-unrelated-"));
  setEnv("CURSOR_COLLECTIONS_HOME", fakeHome);
  setEnv("EVERSIS_COLLECTIONS_ROOT", undefined);
  try {
    const found = findRepoRoot(unrelated);
    assert.equal(found, fakeHome);
  } finally {
    restoreEnv();
    await rm(fakeHome, { recursive: true, force: true });
    await rm(unrelated, { recursive: true, force: true });
  }
});

test("findRepoRoot — CURSOR_COLLECTIONS_HOME takes priority over EVERSIS_COLLECTIONS_ROOT", async () => {
  const homeDir = await makeFakeRoot();
  const legacyDir = await makeFakeRoot();
  const unrelated = await mkdtemp(path.join(tmpdir(), "eversis-unrelated-"));
  setEnv("CURSOR_COLLECTIONS_HOME", homeDir);
  setEnv("EVERSIS_COLLECTIONS_ROOT", legacyDir);
  try {
    const found = findRepoRoot(unrelated);
    assert.equal(found, homeDir, "CURSOR_COLLECTIONS_HOME should win over EVERSIS_COLLECTIONS_ROOT");
  } finally {
    restoreEnv();
    await rm(homeDir, { recursive: true, force: true });
    await rm(legacyDir, { recursive: true, force: true });
    await rm(unrelated, { recursive: true, force: true });
  }
});

test("findRepoRoot — legacy EVERSIS_COLLECTIONS_ROOT still works (backwards compat)", async () => {
  const legacyDir = await makeFakeRoot();
  const unrelated = await mkdtemp(path.join(tmpdir(), "eversis-unrelated-"));
  setEnv("CURSOR_COLLECTIONS_HOME", undefined);
  setEnv("EVERSIS_COLLECTIONS_ROOT", legacyDir);
  try {
    const found = findRepoRoot(unrelated);
    assert.equal(found, legacyDir);
  } finally {
    restoreEnv();
    await rm(legacyDir, { recursive: true, force: true });
    await rm(unrelated, { recursive: true, force: true });
  }
});

test("findRepoRoot — CURSOR_COLLECTIONS_HOME pointing to bad path throws with var name", async () => {
  const unrelated = await mkdtemp(path.join(tmpdir(), "eversis-unrelated-"));
  setEnv("CURSOR_COLLECTIONS_HOME", "/nonexistent-path-xyz-12345");
  setEnv("EVERSIS_COLLECTIONS_ROOT", undefined);
  try {
    assert.throws(
      () => findRepoRoot(unrelated),
      (err: Error) => err.message.includes("CURSOR_COLLECTIONS_HOME"),
    );
  } finally {
    restoreEnv();
    await rm(unrelated, { recursive: true, force: true });
  }
});

test("findRepoRoot — no env, no .cursor/skills in walk-up throws mentioning CURSOR_COLLECTIONS_HOME", async () => {
  const unrelated = await mkdtemp(path.join(tmpdir(), "eversis-unrelated-"));
  setEnv("CURSOR_COLLECTIONS_HOME", undefined);
  setEnv("EVERSIS_COLLECTIONS_ROOT", undefined);
  try {
    assert.throws(
      () => findRepoRoot(unrelated),
      (err: Error) => err.message.includes("CURSOR_COLLECTIONS_HOME"),
    );
  } finally {
    restoreEnv();
    await rm(unrelated, { recursive: true, force: true });
  }
});
