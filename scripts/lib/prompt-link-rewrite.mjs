/**
 * Rewrites markdown link targets in prompt bodies when copying
 * .cursor/prompts/ → website/docs/prompts/ for Docusaurus.
 *
 * Canonical source (.cursor/) uses repo paths and eversis-*.md filenames.
 * Synced copy uses Docusaurus slugs and ../../agents/ for role docs.
 */
import fs from "node:fs";
import path from "node:path";

/**
 * @param {string} promptsRoot - absolute path to .cursor/prompts
 * @returns {Map<string, string>} keys like "public/eversis-implement.md" → slug "implement"
 */
export function buildPromptSlugIndex(promptsRoot) {
  const index = new Map();
  for (const tier of ["public", "internal"]) {
    const dir = path.join(promptsRoot, tier);
    if (!fs.existsSync(dir)) continue;
    for (const name of fs.readdirSync(dir)) {
      if (!name.startsWith("eversis-") || !name.endsWith(".md")) continue;
      const content = fs.readFileSync(path.join(dir, name), "utf8");
      const slugMatch = content.match(/^slug:\s*["']?([^"'\n]+)["']?\s*$/m);
      const stem = name.replace(/^eversis-/, "").replace(/\.md$/, "");
      const slug = slugMatch?.[1]?.trim() || stem;
      index.set(`${tier}/${name}`, slug);
    }
  }
  return index;
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
