#!/usr/bin/env bash
# lib/setup-cursor-local/paths.sh — resolve CURSOR_COLLECTIONS_HOME + clone.
# Sourced after common.sh.

# Default clone URL (override with env CURSOR_COLLECTIONS_REPO_URL).
readonly DEFAULT_REPO_URL="https://github.com/PiotrNie-Eversis/cursor-collections.git"

resolve_collections_home() {
  # Priority: --collections-home CLI > CURSOR_COLLECTIONS_HOME env > default per OS.
  # Sets global COLLECTIONS_HOME (absolute, no trailing slash).
  local cli_home="${ARG_COLLECTIONS_HOME:-}"

  if [[ -n "$cli_home" ]]; then
    COLLECTIONS_HOME="$(realpath -m "$cli_home" 2>/dev/null || echo "$cli_home")"
  elif [[ -n "${CURSOR_COLLECTIONS_HOME:-}" ]]; then
    COLLECTIONS_HOME="$(realpath -m "${CURSOR_COLLECTIONS_HOME}" 2>/dev/null || echo "${CURSOR_COLLECTIONS_HOME}")"
  else
    COLLECTIONS_HOME="$(default_collections_home)"
  fi
  export COLLECTIONS_HOME
}

ensure_framework_checkout() {
  # Clone the framework if COLLECTIONS_HOME doesn't exist yet.
  # No-op if directory already contains .cursor/skills (already checked out).
  local home="$COLLECTIONS_HOME"
  local skills_marker="${home}/.cursor/skills"

  if [[ -d "$skills_marker" ]]; then
    log_ok "Framework found at: ${home}"
    return 0
  fi

  if [[ -d "$home" ]]; then
    # Directory exists but looks incomplete — warn and abort unless --force.
    if [[ "${ARG_FORCE:-false}" == "true" ]]; then
      log_warn "Directory exists but has no .cursor/skills — proceeding anyway (--force)."
      return 0
    fi
    die "Directory '${home}' exists but does not contain .cursor/skills. " \
        "Pass --collections-home to a different path or remove the directory and re-run."
  fi

  require_cmd git "Install Git from https://git-scm.com"

  local repo_url="${CURSOR_COLLECTIONS_REPO_URL:-${DEFAULT_REPO_URL}}"
  log_info "Cloning cursor-collections from ${repo_url} → ${home} …"
  git clone --depth 1 "$repo_url" "$home" || die "git clone failed."
  log_ok "Cloned to ${home}"
}
