#!/usr/bin/env bash
# lib/setup-cursor-local/scaffolding.sh — scaffold AGENTS.md + docs/specs/ in target.
# Sourced after common.sh.

scaffold_project() {
  local target="$TARGET_DIR"
  local agents_dst="${target}/AGENTS.md"
  local specs_dir="${target}/docs/specs"
  local specs_readme="${specs_dir}/README.md"

  # AGENTS.md — only if absent.
  if [[ ! -f "$agents_dst" ]]; then
    local agents_src="${COLLECTIONS_HOME}/scripts/setup-cursor-local/templates/AGENTS.stub.md"
    if [[ -f "$agents_src" ]]; then
      cp "$agents_src" "$agents_dst"
    else
      cat > "$agents_dst" <<'AGENTS_EOF'
# Agent instructions (Cursor)

This project uses the [Eversis Cursor Collections](https://github.com/PiotrNie-Eversis/cursor-collections) framework.

- **Framework docs:** see `vendor/cursor-collections/documentation/cursor-collection.md` (vendor) or the upstream repo.
- **Rules:** `.cursor/rules/` — start with `eversis-agent-core.mdc`; customise **`eversis-project-stack.mdc`** for this repo.
- **Prompts:** attach with `@eversis-*` in Cursor Chat/Agent.
- **MCP:** enable `eversis-collections` entry in `.cursor/mcp.json` and restart Cursor.
AGENTS_EOF
    fi
    log_ok "Created AGENTS.md — review and customise for your project."
  else
    log_info "AGENTS.md already exists — not overwritten."
  fi

  # docs/specs/ directory.
  if [[ ! -d "$specs_dir" ]]; then
    mkdir -p "$specs_dir"
    cat > "$specs_readme" <<'README_EOF'
# specs

Feature research and implementation plan artifacts for this project.

Naming convention: `docs/specs/<issue-kebab>/`

```
docs/specs/my-feature/
  my-feature.research.md
  my-feature.plan.md
```
README_EOF
    log_ok "Created docs/specs/ directory."
  fi
}
