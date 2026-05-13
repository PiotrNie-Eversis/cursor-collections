# eversis-collections-mcp

Local **Model Context Protocol** server for the [cursor-collections](https://github.com/PiotrNie-Eversis/cursor-collections) repository. It exposes:

- **`eversis_*` tools** — list, read, and validate `eversis-*` skill packages under `.cursor/skills/`, run allowlisted root scripts (`sync-prompts`, `sync-framework-doc`), and allowlisted per-skill scripts (`eversis_skill_run_script`).
- **`.docx` chapter tools** (Business Manager Docs) — same names as the legacy standalone docs MCPs: `generate_summary_map`, `read_chapter`, `update_chapter`, `upload_to_sharepoint` (stub). Implementation: `src/docx/` (JSZip + `@xmldom/xmldom`).

Use **only** the **`eversis-collections`** MCP entry in `.cursor/mcp.json` for skills and Word tools together.

## Not published to npm

This package is **not** published to the registry. Use it from a **clone of the repository**:

```bash
cd mcp/eversis-collections-mcp
npm install
npm run build
```

Then enable the **`eversis-collections`** entry in the repo’s `.cursor/mcp.json` (already present) and restart Cursor.

## Tests

```bash
npm test
```

## CLI: validate skills (CI)

```bash
npm run validate
# or
node dist/cli.js validate
```

- **`--strict`** — treat length warnings as failures (same as `EVERSIS_SKILLS_VALIDATE_STRICT=1`).

## Tools (MCP)

| Tool | Purpose |
| --- | --- |
| `eversis_skills_list` | List all `eversis-*` skills with `name` / `description` from `SKILL.md` frontmatter |
| `eversis_skills_get` | Read `SKILL.md` or a file under `references/` or `assets/` (optional line range) |
| `eversis_skills_validate` | Validate every skill (frontmatter, name vs directory, optional length warnings) |
| `eversis_repo_run_script` | Run `sync-prompts` or `sync-framework-doc` under the repo root |
| `eversis_skill_run_script` | Run an allowlisted script under `.cursor/skills/eversis-*/scripts/` (e.g. `eversis-creating-skills-skill-md-stats`) |
| `generate_summary_map` | Writes `*.summary.md` with `chapter_id` (`sec-0` …) mapped to headings |
| `read_chapter` | Returns body text for a `chapter_id` in a `.docx` |
| `update_chapter` | Replaces section body and saves the `.docx` (optional graphics placeholder) |
| `upload_to_sharepoint` | **Stub** — validate path only |

**Security:** `eversis_skill_run_script` and `eversis_repo_run_script` only run paths on a fixed allowlist in this package. New scripts require a PR that adds the file and the key in `src/skillScripts.ts` or `src/repoScripts.ts`. Tools that call external APIs (e.g. cloud cost APIs) are not bundled here by default; add them only with explicit env/credential requirements and review.

## Environment

- **`EVERSIS_COLLECTIONS_ROOT`** — absolute path to a checkout that contains `.cursor/skills` (optional; auto-detected by walking up from this package).

## Legacy standalone docs servers

[`mcp/eversis-docs-mcp/`](../eversis-docs-mcp/) (Python) and [`mcp/eversis-docs-mcp-node/`](../eversis-docs-mcp-node/) remain as optional reference or for workflows that want a separate process; **Cursor config in this repo uses only `eversis-collections`.**
