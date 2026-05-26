#!/usr/bin/env bash
# lib/setup-cursor-local/gitignore.sh — manage .gitignore and .cursorignore.
# Sourced after common.sh.

readonly _GITIGNORE_MARKER_START="# cursor-collections local [begin]"
readonly _GITIGNORE_MARKER_END="# cursor-collections local [end]"

# Lines added in local (non-vendor) mode.
_local_gitignore_lines() {
  cat <<'LINES'
.cursor/mcp.json
.cursor/prompts/
.cursor/commands/
.cursor/skills/
.cursor/rules/eversis-agent-core.mdc
.cursor/rules/eversis-testing-and-terminal.mdc
.cursor/rules/eversis-engineering-manager.mdc
.cursor/rules/eversis-code-reviewer.mdc
LINES
}

_has_marker() {
  grep -qF "$_GITIGNORE_MARKER_START" "${1}" 2>/dev/null
}

_remove_marker_block() {
  local file="$1"
  if _has_marker "$file"; then
    # Remove everything between (inclusive) the two marker lines.
    local tmp
    tmp="$(mktemp)"
    awk "/${_GITIGNORE_MARKER_START//\//\\/}/{skip=1} !skip{print} /${_GITIGNORE_MARKER_END//\//\\/}/{skip=0}" \
      "$file" > "$tmp" && mv "$tmp" "$file"
    log_info "Removed local gitignore block from ${file}"
  fi
}

manage_gitignore() {
  # VENDOR_MODE="" → add local block.
  # VENDOR_MODE=submodule|copy → remove local block (if present).
  local gi="${TARGET_DIR}/.gitignore"

  if [[ "${VENDOR_MODE:-}" == "submodule" ]] || [[ "${VENDOR_MODE:-}" == "copy" ]]; then
    _remove_marker_block "$gi"
    return 0
  fi

  # Local mode: add block if not already present.
  if _has_marker "$gi"; then
    log_info ".gitignore already has cursor-collections block — not duplicating."
    return 0
  fi

  {
    echo ""
    echo "$_GITIGNORE_MARKER_START"
    _local_gitignore_lines
    echo "$_GITIGNORE_MARKER_END"
  } >> "$gi"
  log_ok "Added cursor-collections local entries to ${gi}"
}

manage_cursorignore() {
  # Create .cursorignore stub only when the file is absent.
  local ci="${TARGET_DIR}/.cursorignore"
  if [[ -f "$ci" ]]; then
    return 0
  fi

  local template_src="${COLLECTIONS_HOME}/scripts/setup-cursor-local/templates/cursorignore.stub"
  if [[ -f "$template_src" ]]; then
    cp "$template_src" "$ci"
  else
    cat > "$ci" <<'EOF'
# .cursorignore — patterns excluded from Cursor's indexing.
# Add project-specific secrets, generated artefacts, or large dirs here.
node_modules/
dist/
.env
.env.local
*.secret
EOF
  fi
  log_ok "Created .cursorignore stub at ${ci}"
}
