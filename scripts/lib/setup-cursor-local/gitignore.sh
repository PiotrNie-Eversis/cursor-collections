#!/usr/bin/env bash
# lib/setup-cursor-local/gitignore.sh — manage .gitignore and .cursorignore.
# Sourced after common.sh.

readonly _GITIGNORE_MARKER_START="# cursor-collections local [begin]"
readonly _GITIGNORE_MARKER_END="# cursor-collections local [end]"
readonly _GITIGNORE_ARTIFACTS_START="# cursor-collections agent-artifacts [begin]"
readonly _GITIGNORE_ARTIFACTS_END="# cursor-collections agent-artifacts [end]"

# Lines added in local (non-vendor) mode.
# All framework eversis-*.mdc rules are gitignored; stack rule is the per-project exception.
_local_gitignore_lines() {
  cat <<'LINES'
.cursor/mcp.json
.cursor/prompts/
.cursor/commands/
.cursor/skills/
.cursor/rules/eversis-*.mdc
!.cursor/rules/eversis-project-stack.mdc
LINES
}

_artifact_gitignore_lines() {
  cat <<'LINES'
docs/specs/*/
docs/context/*/
LINES
}

_has_marker() {
  grep -qF "$_GITIGNORE_MARKER_START" "${1}" 2>/dev/null
}

_has_artifacts_subblock() {
  grep -qF "$_GITIGNORE_ARTIFACTS_START" "${1}" 2>/dev/null
}

_remove_marker_block() {
  local file="$1"
  if _has_marker "$file"; then
    local tmp
    tmp="$(mktemp)"
    awk -v start="${_GITIGNORE_MARKER_START}" -v end="${_GITIGNORE_MARKER_END}" '
      index($0, start) == 1 { skip=1; next }
      index($0, end) == 1 { skip=0; next }
      !skip { print }
    ' "$file" > "$tmp" && mv "$tmp" "$file"
    log_info "Removed local gitignore block from ${file}"
  fi
}

_remove_artifacts_subblock() {
  local file="$1"
  if [[ ! -f "$file" ]] || ! _has_artifacts_subblock "$file"; then
    return 0
  fi

  local tmp
  tmp="$(mktemp)"
  awk -v start="${_GITIGNORE_ARTIFACTS_START}" -v end="${_GITIGNORE_ARTIFACTS_END}" '
    index($0, start) == 1 { skip=1; next }
    index($0, end) == 1 { skip=0; next }
    !skip { print }
  ' "$file" > "$tmp" && mv "$tmp" "$file"
  log_info "Removed agent-artifacts sub-block from ${file}"
}

_ensure_artifacts_subblock() {
  local file="$1"
  if [[ ! -f "$file" ]] || ! _has_marker "$file"; then
    return 0
  fi
  if _has_artifacts_subblock "$file"; then
    return 0
  fi

  local tmp
  tmp="$(mktemp)"
  awk -v insert_start="${_GITIGNORE_ARTIFACTS_START}" \
      -v insert_end="${_GITIGNORE_ARTIFACTS_END}" \
      -v marker_end="${_GITIGNORE_MARKER_END}" \
      '
    $0 == marker_end {
      print insert_start
      print "docs/specs/*/"
      print "docs/context/*/"
      print insert_end
      print
      next
    }
    { print }
  ' "$file" > "$tmp" && mv "$tmp" "$file"
  log_ok "Added agent-artifacts entries to ${file}"
}

_append_local_block() {
  local file="$1"
  local with_artifacts="${2:-false}"

  {
    echo ""
    echo "$_GITIGNORE_MARKER_START"
    _local_gitignore_lines
    if [[ "$with_artifacts" == "true" ]]; then
      echo "$_GITIGNORE_ARTIFACTS_START"
      _artifact_gitignore_lines
      echo "$_GITIGNORE_ARTIFACTS_END"
    fi
    echo "$_GITIGNORE_MARKER_END"
  } >> "$file"
  log_ok "Added cursor-collections local entries to ${file}"
}

_refresh_local_gitignore_block() {
  # Rebuild the managed local block (core lines + optional artifacts).
  # Used on re-run to migrate legacy per-file rule entries to the glob pattern.
  local file="$1"
  local with_artifacts="${2:-false}"

  _remove_marker_block "$file"
  _append_local_block "$file" "$with_artifacts"
  log_ok "Refreshed cursor-collections local gitignore block"
}

_warn_agent_artifacts_gitignore() {
  log_warn "docs/specs/*/ and docs/context/*/ will be gitignored — research/plan artifacts will not be shared via git or MRs."
  log_warn "CI wiki sync to docs/context/ (see framework Part D) conflicts with this flag unless you change policy."
}

manage_gitignore() {
  # VENDOR_MODE="" → add/update local block.
  # VENDOR_MODE=submodule|copy → remove local block (if present).
  local gi="${TARGET_DIR}/.gitignore"
  local want_artifacts="false"
  [[ "${ARG_GITIGNORE_AGENT_ARTIFACTS:-false}" == "true" ]] && want_artifacts="true"

  if [[ "${VENDOR_MODE:-}" == "submodule" ]] || [[ "${VENDOR_MODE:-}" == "copy" ]]; then
    if [[ "$want_artifacts" == "true" ]]; then
      log_warn "--gitignore-agent-artifacts is ignored in vendor mode (framework and project docs are committed)."
    fi
    _remove_marker_block "$gi"
    return 0
  fi

  if [[ "$want_artifacts" == "true" ]]; then
    _warn_agent_artifacts_gitignore
  fi

  if _has_marker "$gi"; then
    _refresh_local_gitignore_block "$gi" "$want_artifacts"
    return 0
  fi

  touch "$gi"
  _append_local_block "$gi" "$want_artifacts"
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
