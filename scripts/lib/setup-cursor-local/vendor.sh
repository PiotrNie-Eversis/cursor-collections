#!/usr/bin/env bash
# lib/setup-cursor-local/vendor.sh — --vendor submodule | copy.
# Sourced after common.sh.

readonly VENDOR_PATH="vendor/cursor-collections"

_resolve_vendor_mode() {
  # Sets VENDOR_MODE from --vendor arg or interactive prompt.
  # Possible values: submodule | copy | "" (off)
  VENDOR_MODE="${ARG_VENDOR:-}"

  if [[ -z "$VENDOR_MODE" ]]; then
    return 0
  fi

  if [[ "$VENDOR_MODE" == "true" ]]; then
    # bare --vendor without value → ask interactively (or default in non-interactive).
    if [[ "${ARG_NON_INTERACTIVE:-false}" == "true" ]]; then
      VENDOR_MODE="copy"
      log_info "--vendor without value in --non-interactive mode → defaulting to 'copy'."
    else
      echo ""
      echo "${_BOLD}Select vendor strategy:${_RESET}"
      echo "  1) submodule — adds cursor-collections as a Git submodule (versioned, best for teams)"
      echo "  2) copy      — copies framework files into vendor/ (simpler, no submodule overhead)"
      echo ""
      local choice=""
      read -r -p "Enter choice [1]: " choice
      case "${choice:-1}" in
        2) VENDOR_MODE="copy" ;;
        *) VENDOR_MODE="submodule" ;;
      esac
    fi
  fi

  if [[ "$VENDOR_MODE" != "submodule" ]] && [[ "$VENDOR_MODE" != "copy" ]]; then
    die "--vendor must be 'submodule' or 'copy', got: '${VENDOR_MODE}'"
  fi
  export VENDOR_MODE
}

setup_vendor_submodule() {
  require_cmd git "Install Git from https://git-scm.com"
  local vendor_dir="${TARGET_DIR}/${VENDOR_PATH}"
  local repo_url="${CURSOR_COLLECTIONS_REPO_URL:-${DEFAULT_REPO_URL:-}}"

  if [[ -z "$repo_url" ]]; then
    # Try to get the origin URL from COLLECTIONS_HOME if it's a git repo.
    repo_url="$(git -C "${COLLECTIONS_HOME}" remote get-url origin 2>/dev/null)" \
      || die "Cannot determine repository URL. Set CURSOR_COLLECTIONS_REPO_URL."
  fi

  if grep -q "path = ${VENDOR_PATH}" "${TARGET_DIR}/.gitmodules" 2>/dev/null; then
    log_ok "Submodule '${VENDOR_PATH}' already present — skipping add."
  else
    log_info "Adding submodule ${repo_url} → ${VENDOR_PATH} …"
    (cd "$TARGET_DIR" && git submodule add "$repo_url" "$VENDOR_PATH") \
      || die "git submodule add failed."
    log_ok "Submodule added: ${vendor_dir}"
  fi

  # Downstream steps (link .cursor/*, MCP build, mcp.json) use the vendored checkout.
  COLLECTIONS_HOME="$vendor_dir"
  export COLLECTIONS_HOME
}

setup_vendor_copy() {
  local vendor_dir="${TARGET_DIR}/${VENDOR_PATH}"
  local src_dirs=(
    ".cursor/rules"
    ".cursor/prompts"
    ".cursor/commands"
    ".cursor/skills"
    "mcp/eversis-collections-mcp"
    "scripts/setup-cursor-local/templates"
  )

  log_info "Copying framework into ${vendor_dir} …"
  mkdir -p "$vendor_dir"

  for rel in "${src_dirs[@]}"; do
    local src="${COLLECTIONS_HOME}/${rel}"
    local dst="${vendor_dir}/${rel}"
    if [[ ! -d "$src" ]]; then
      log_warn "Source not found, skipping: ${src}"
      continue
    fi
    mkdir -p "$(dirname "$dst")"
    if command -v rsync >/dev/null 2>&1; then
      rsync -a --delete --exclude=node_modules/ --exclude=.git/ --exclude=dist/ "$src/" "$dst/"
    else
      rm -rf "$dst"
      cp -R "$src" "$dst"
    fi
    log_ok "Copied ${rel}"
  done

  # Set COLLECTIONS_HOME to vendored path for downstream steps.
  COLLECTIONS_HOME="$vendor_dir"
  export COLLECTIONS_HOME
}

run_vendor_setup() {
  _resolve_vendor_mode

  case "${VENDOR_MODE:-}" in
    submodule) setup_vendor_submodule ;;
    copy)      setup_vendor_copy ;;
    "")        : ;; # local mode — no vendor
  esac
}
