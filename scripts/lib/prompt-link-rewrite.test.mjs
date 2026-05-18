import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { fileURLToPath } from "node:url";
import {
  buildPromptSlugMaps,
  parsePromptFrontmatterSlug,
  promptSlugMapsToJson,
  resolvePromptFilenameBySlug,
} from "./prompt-link-rewrite.mjs";

describe("parsePromptFrontmatterSlug", () => {
  it("reads quoted and unquoted slug lines", () => {
    assert.equal(parsePromptFrontmatterSlug('slug: implement\n'), "implement");
    assert.equal(parsePromptFrontmatterSlug('slug: "review-ui"\n'), "review-ui");
  });

  it("returns null when slug is missing", () => {
    assert.equal(parsePromptFrontmatterSlug("title: foo\n"), null);
  });
});

describe("buildPromptSlugMaps", () => {
  it("indexes real prompts from frontmatter", () => {
    const root = fileURLToPath(new URL("../../.cursor/prompts", import.meta.url));
    const { fileToSlug, slugToFile, collisions } = buildPromptSlugMaps(root);

    assert.equal(collisions.length, 0);
    assert.equal(fileToSlug.get("public/eversis-implement.md"), "implement");
    assert.equal(
      resolvePromptFilenameBySlug(slugToFile, "public", "implement"),
      "eversis-implement.md",
    );
    assert.equal(
      resolvePromptFilenameBySlug(slugToFile, "internal", "research"),
      "eversis-research.md",
    );
  });

  it("serializes to JSON shape", () => {
    const root = fileURLToPath(new URL("../../.cursor/prompts", import.meta.url));
    const maps = buildPromptSlugMaps(root);
    const json = promptSlugMapsToJson(maps);
    assert.ok(json.slugToFile.public.implement);
    assert.equal(json.slugToFile.public.implement, "eversis-implement.md");
  });
});
