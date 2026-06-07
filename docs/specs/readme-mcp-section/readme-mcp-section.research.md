# Research: Align README MCP section with copilot-collections style

**Task:** Improve [`README.md`](../../../README.md) § **🔌 MCP server configuration** (from line ~259) to follow the structure and tone of [copilot-collections — MCP Server Configuration](https://github.com/TheSoftwareHouse/copilot-collections#-mcp-server-configuration).

**Related work:** MCP section was expanded in a prior edit (tables + verify); Agents section aligned in [`readme-agents-descriptions`](../readme-agents-descriptions/readme-agents-descriptions.plan.md).

**Status:** Approved — implementation complete (2026-06-07).

---

## Problem statement

The current README MCP block is **informative** (tables, local `eversis-collections` build, verify step) but **does not match the copilot-collections scan pattern** the stakeholder uses as the benchmark.

### Current structure (README ~259–315)

```text
1. Paragraph — what MCP is + source of truth
2. ### Local server: eversis-collections (build + table)
3. ### Third-party servers (table)
4. ### Where to configure (table — Workspace first)
5. ### Verify
```

### Copilot-collections structure (benchmark)

```text
1. One-liner — unlock full workflow + template path (.vscode/mcp.json)
2. ### Option 1: User Profile (Recommended) — numbered steps
3. ### Option 2: Workspace Configuration — numbered steps
4. ### Official Documentation — provider links
5. ### Configuring Context7 API Key — JSON snippet + dashboard link
6. Note — lowercase server IDs
7. ### What each MCP is used for — emoji bullets (not table)
8. Callout — API keys / local apps
9. ### Sequential Thinking MCP — dedicated mini-section (Revise / Branch / Track)
```

| Gap | Current README | Copilot benchmark |
| --- | -------------- | ----------------- |
| **Section title** | `MCP server configuration` (sentence case) | `MCP Server Configuration` (title case) |
| **Install narrative** | Table “Where to configure” | **Option 1 / Option 2** with Command Palette steps; User **recommended** first |
| **Official doc links** | Only `integrations overview` | Per-provider bullets (Atlassian, Context7, Playwright, Figma, Sequential Thinking) |
| **Context7 API key** | Absent in README | Full `inputs` JSON example |
| **Server usage** | Two tables | **Emoji bullet list** with workflow hooks (`/tsh-implement`) |
| **Sequential Thinking** | One table row | **Dedicated subsection** explaining revise / branch / track |
| **Local framework server** | Prominent (correct for Cursor) | N/A — **keep as Cursor-specific addition**, not in copilot |

---

## Scope boundary

| In scope | Out of scope |
| -------- | ------------ |
| Rewrite **MCP section only** in root [`README.md`](../../../README.md) | [`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md) (already progressive-disclosure) |
| Adapt copilot **section order and micro-templates** to **Cursor** (`.cursor/mcp.json`, Settings → MCP) | Changing committed [`.cursor/mcp.json`](../../../.cursor/mcp.json) |
| Preserve **eversis-collections build** requirement and consumer `CURSOR_COLLECTIONS_HOME` note | Duplicating full [`mcp-setup.md`](../../../website/docs/getting-started/mcp-setup.md) |
| Link to docs site for auth edge cases | Rewriting `website/docs/getting-started/mcp-setup.md` |

---

## Cursor-specific facts (must remain accurate)

### Config file

- **Path:** `.cursor/mcp.json` (not `.vscode/mcp.json`).
- **Key:** `mcpServers` (Cursor; copilot sample uses `servers` in Context7 snippet — use **`mcpServers`** in README JSON).

### Local server (required for skills + BA Docs)

```bash
cd mcp/eversis-collections-mcp && npm install && npm run build
```

- MCP id: **`eversis-collections`** (stdio, `node mcp/eversis-collections-mcp/dist/index.js`).
- Consumer projects: `setup-cursor-local.sh --build-mcp` + `CURSOR_COLLECTIONS_HOME`.

### Third-party servers in template

From [`.cursor/mcp.json`](../../../.cursor/mcp.json): Atlassian (HTTP), Figma (HTTP), Context7, Playwright, Sequential Thinking, PDF Reader, AWS (API + docs), GCP (gcloud, observability, storage).

### Enable flow (Cursor)

- Open folder → enable workspace MCP when prompted, **or** Settings → MCP per server.
- User global: Command Palette → **MCP: Open User Configuration** → merge `mcpServers`.

---

## Proposed information architecture (target README section)

Follow copilot order; insert **Cursor-only** blocks without breaking scan flow:

```text
## 🔌 MCP Server Configuration

Intro (1–2 sentences): unlock Ideate → Implement → Review; template in .cursor/mcp.json

### Option 1: User Profile (Recommended)
  4 numbered steps (Command Palette, merge mcpServers)

### Option 2: Workspace Configuration
  Open this repo OR copy .cursor/mcp.json to target project/.cursor/
  Enable when prompted

### Build local server: eversis-collections  ← Cursor-only (before or after options)
  npm install && npm run build
  Enable + restart
  3 emoji bullets: skills, BA Docs, repo scripts (replace wide table)
  Link: MCP README; consumer CURSOR_COLLECTIONS_HOME one-liner

### Official Documentation
  Bullets: Atlassian, Context7, Playwright, Figma, Sequential Thinking (+ optional PDF/AWS/GCP links or “see integrations overview”)

### Configuring Context7 API Key
  Dashboard link + condensed JSON (mcpServers + inputs) — mirror mcp-setup.md

> Note: lowercase server IDs (context7, figma, eversis-collections, …)

### What each MCP is used for
  Emoji bullets (not table) — map to @eversis-* not /tsh-*

> Callout: API keys / OAuth — configure per provider

### Sequential Thinking MCP
  Revise / Branch / Track bullets (from copilot)

### Verify
  eversis_skills_list smoke check; disable unused servers
```

**Length target:** ~75–95 lines (vs current ~56). Slight increase for copilot parity; remove redundant third-party **table** when bullets cover the same ground.

---

## Draft copy: “What each MCP is used for” (bullets)

Adapt copilot bullets to Cursor naming:

- 🧩 **Atlassian MCP** — Jira and Confluence for `@eversis-implement`, `@eversis-review`, and research/planning; optional QA comment post after Fine.
- 🎨 **Figma MCP** — design context, components, and screenshots for UI implement and `@eversis-review-ui`.
- 📚 **Context7 MCP** — up-to-date library and framework documentation search.
- 🧪 **Playwright MCP** — browser interactions and visual checks from Agent.
- 🧠 **Sequential Thinking MCP** — structured reasoning for complex analysis (see subsection below).
- 📄 **PDF Reader MCP** — workshop PDFs and attachments for `@eversis-analyze-materials`.
- ☁️ **AWS / GCP MCPs** — cloud APIs, docs, observability, and storage for DevOps and cost prompts.
- 🔌 **eversis-collections** (local) — `eversis_skills_*` for `.cursor/skills/` and Word `.docx` tools for BA Docs (**build required**).

---

## Draft copy: Official Documentation links

Mirror copilot (add PDF/AWS as optional second line or integrations link):

- [Atlassian MCP](https://support.atlassian.com/atlassian-rovo-mcp-server/docs/getting-started-with-the-atlassian-remote-mcp-server/)
- [Context7 MCP](https://github.com/upstash/context7)
- [Playwright MCP](https://github.com/microsoft/playwright-mcp)
- [Figma MCP](https://help.figma.com/hc/en-us/articles/32132100833559-Guide-to-the-Figma-MCP-server)
- [Sequential Thinking MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking)

Extended list: [integrations overview](website/docs/integrations/overview.md).

---

## Risks and constraints

| Risk | Mitigation |
| ---- | ---------- |
| README MCP section longer than copilot | Drop third-party table; use bullets only |
| Duplicate mcp-setup.md | README = onboarding copy; link “full setup” to mcp-setup.md |
| JSON key `servers` vs `mcpServers` | Use `mcpServers` in all README snippets |
| eversis-collections buried | Dedicated **Build local server** subsection immediately after Option 1/2 |
| Stale external URLs | Reuse URLs already in mcp-setup.md / copilot README |

---

## Acceptance criteria (research)

- [x] Benchmark structure documented vs current README
- [x] Cursor-specific requirements inventoried
- [x] Target IA and draft bullets prepared
- [x] Scope limited to README MCP section
- [x] **Human approval** to proceed to plan

---

## Open questions for human review

**Resolved (2026-06-07):**

1. **Option order:** User Profile recommended first.
2. **Context7 JSON:** Condensed snippet in README + link to mcp-setup.md for full auth.
3. **eversis-collections placement:** After Option 1/2.
4. **CHANGELOG:** Yes on implementation.

**Plan:** [`readme-mcp-section.plan.md`](./readme-mcp-section.plan.md)

---

## References

- Benchmark: [copilot-collections — MCP Server Configuration](https://github.com/TheSoftwareHouse/copilot-collections#-mcp-server-configuration)
- Current: [`README.md`](../../../README.md) § MCP (~259–315)
- Cursor setup: [`website/docs/getting-started/mcp-setup.md`](../../../website/docs/getting-started/mcp-setup.md)
- Local server: [`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md)
- Template: [`.cursor/mcp.json`](../../../.cursor/mcp.json)
