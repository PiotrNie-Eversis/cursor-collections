/**
 * Rewrites markdown link targets in prompt bodies when copying
 * .cursor/prompts/ → website/docs/prompts/ for Docusaurus.
 *
 * Canonical source (.cursor/) uses repo paths and eversis-*.md filenames.
 * Synced copy uses Docusaurus slugs and ../../agents/ for role docs.
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

/**
 * @param {string} content - prompt markdown with YAML frontmatter
 * @returns {string | null} slug from frontmatter, or null if absent
 */
export function parsePromptFrontmatterSlug(content) {
  const m = content.match(/^slug:\s*["']?([^"'\n]+)["']?\s*$/m);
  return m?.[1]?.trim() ?? null;
}

/**
 * Scans .cursor/prompts/{public,internal}/eversis-*.md and builds slug ↔ filename maps
 * from each file's `slug:` frontmatter (fallback: stem after `eversis-` prefix).
 *
 * @param {string} promptsRoot - absolute path to .cursor/prompts
 * @returns {{
 *   fileToSlug: Map<string, string>,
 *   slugToFile: Map<string, string>,
 *   collisions: Array<{ tier: string, slug: string, files: string[] }>,
 * }}
 */
export function buildPromptSlugMaps(promptsRoot) {
  /** @type {Map<string, string>} */
  const fileToSlug = new Map();
  /** @type {Map<string, string>} keys "public/implement" → "eversis-implement.md" */
  const slugToFile = new Map();
  /** @type {Array<{ tier: string, slug: string, files: string[] }>} */
  const collisions = [];

  for (const tier of ["public", "internal"]) {
    const dir = path.join(promptsRoot, tier);
    if (!fs.existsSync(dir)) continue;

    for (const name of fs.readdirSync(dir)) {
      if (!name.startsWith("eversis-") || !name.endsWith(".md")) continue;

      const content = fs.readFileSync(path.join(dir, name), "utf8");
      const stem = name.replace(/^eversis-/, "").replace(/\.md$/, "");
      const slug = parsePromptFrontmatterSlug(content) || stem;
      const fileKey = `${tier}/${name}`;
      const slugKey = `${tier}/${slug}`;

      fileToSlug.set(fileKey, slug);

      const existing = slugToFile.get(slugKey);
      if (existing && existing !== name) {
        collisions.push({ tier, slug, files: [existing, name] });
      } else {
        slugToFile.set(slugKey, name);
      }
    }
  }

  return { fileToSlug, slugToFile, collisions };
}

/**
 * @param {string} promptsRoot
 * @returns {Map<string, string>} keys like "public/eversis-implement.md" → slug "implement"
 */
export function buildPromptSlugIndex(promptsRoot) {
  const { fileToSlug, collisions } = buildPromptSlugMaps(promptsRoot);
  if (collisions.length > 0) {
    const details = collisions
      .map((c) => `${c.tier}/${c.slug}: ${c.files.join(" vs ")}`)
      .join("; ");
    throw new Error(`Duplicate prompt slug(s) in frontmatter: ${details}`);
  }
  return fileToSlug;
}

/**
 * @param {Map<string, string>} slugToFile
 * @param {"public"|"internal"} tier
 * @param {string} slug - Docusaurus slug (no .md)
 * @returns {string | null} eversis-*.md filename in that tier
 */
export function resolvePromptFilenameBySlug(slugToFile, tier, slug) {
  const normalized = slug.replace(/\.md$/, "");
  return slugToFile.get(`${tier}/${normalized}`) ?? null;
}

/**
 * @param {{ fileToSlug: Map<string, string>, slugToFile: Map<string, string> }} maps
 * @returns {Record<string, { slug: string } | Record<string, string>>}
 */
export function promptSlugMapsToJson({ fileToSlug, slugToFile }) {
  /** @type {Record<string, Record<string, string>>} */
  const byTier = { public: {}, internal: {} };

  for (const [slugKey, filename] of slugToFile.entries()) {
    const [tier, slug] = slugKey.split("/");
    if (tier === "public" || tier === "internal") {
      byTier[tier][slug] = filename;
    }
  }

  const files = {};
  for (const [fileKey, slug] of fileToSlug.entries()) {
    files[fileKey] = { slug };
  }

  return { generatedFrom: ".cursor/prompts frontmatter slug:", files, slugToFile: byTier };
}

/**
 * Writes slug ↔ filename JSON next to this module (for debugging / tooling).
 * @param {string} promptsRoot
 * @param {string} [outputPath]
 */
export function writePromptSlugMapFile(promptsRoot, outputPath) {
  const maps = buildPromptSlugMaps(promptsRoot);
  if (maps.collisions.length > 0) {
    throw new Error(
      `Cannot write slug map: duplicate slug(s): ${maps.collisions.map((c) => `${c.tier}/${c.slug}`).join(", ")}`,
    );
  }
  const out =
    outputPath ??
    path.join(path.dirname(fileURLToPath(import.meta.url)), "prompt-slug-map.generated.json");
  fs.writeFileSync(out, `${JSON.stringify(promptSlugMapsToJson(maps), null, 2)}\n`, "utf8");
  return out;
}

/**
 * @param {string} eversisFilename - e.g. "eversis-implement.md"
 * @param {Map<string, string>} slugIndex
 * @param {"public"|"internal"} tier
 */
function slugForFile(eversisFilename, slugIndex, tier) {
  return slugIndex.get(`${tier}/${eversisFilename}`) || eversisFilename.replace(/^eversis-/, "").replace(/\.md$/, "");
}

/**
 * @param {string} body
 * @param {Map<string, string>} slugIndex
 * @returns {{ body: string, replacements: number }}
 */
export function rewritePromptLinksForDocusaurus(body, slugIndex) {
  let replacements = 0;
  let out = body;

  const beforeAgents = out;
  out = out.replaceAll("../../../website/docs/agents/", "../../agents/");
  if (out !== beforeAgents) {
    replacements += (beforeAgents.match(/\.\.\/\.\.\/\.\.\/website\/docs\/agents\//g) || []).length;
  }

  // ../public/eversis-foo.md → ../public/<slug>
  out = out.replace(
    /\]\(\.\.\/public\/eversis-([a-z0-9-]+)\.md\)/gi,
    (_m, stem) => {
      replacements += 1;
      const slug = slugForFile(`eversis-${stem}.md`, slugIndex, "public");
      return `](../public/${slug})`;
    },
  );

  // ../internal/eversis-foo.md → ../internal/<slug>
  out = out.replace(
    /\]\(\.\.\/internal\/eversis-([a-z0-9-]+)\.md\)/gi,
    (_m, stem) => {
      replacements += 1;
      const slug = slugForFile(`eversis-${stem}.md`, slugIndex, "internal");
      return `](../internal/${slug})`;
    },
  );

  // ./eversis-foo.md → ./<slug> (internal cross-links)
  out = out.replace(/\]\(\.\/eversis-([a-z0-9-]+)\.md\)/gi, (_m, stem) => {
    replacements += 1;
    const slug = slugForFile(`eversis-${stem}.md`, slugIndex, "internal");
    return `](./${slug})`;
  });

  // ./eversis-foo.md in public tier (same-dir public links)
  out = out.replace(/\]\(\.\/eversis-([a-z0-9-]+)\.md([^)]*)\)/gi, (full, stem, rest) => {
    if (rest && !rest.startsWith("#")) return full;
    replacements += 1;
    const slug = slugForFile(`eversis-${stem}.md`, slugIndex, "public");
    return `](./${slug}${rest})`;
  });

  return { body: out, replacements };
}
