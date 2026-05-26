#!/usr/bin/env bash
# lib/setup-cursor-local/link-framework.sh — link or copy .cursor/* into target.
# Sourced after common.sh.

# Directories inside .cursor/ that are managed by the framework.
readonly FRAMEWORK_CURSOR_DIRS=(rules prompts commands skills)

_make_symlink() {
  local src="$1" dst="$2"
  if [[ "$OS_TYPE" == "windows" ]]; then
    # Try junction (no elevation needed on modern Windows).
    cmd //c "mklink /J \"${dst}\" \"${src}\"" 2>/dev/null && return 0
    return 1
  fi
  ln -sfn "$src" "$dst"
}

_copy_dir() {
  local src="$1" dst="$2"
  # rsync preferred; fall back to cp -R.
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete --exclude=node_modules/ --exclude=.git/ "$src/" "$dst/"
  else
    rm -rf "$dst"
    cp -R "$src" "$dst"
  fi
}

link_framework_files() {
  # Link or copy framework .cursor/* directories into TARGET_DIR/.cursor/.
  # Rules: eversis-project-stack.mdc is copied from template only when absent.
  local src_cursor="${COLLECTIONS_HOME}/.cursor"
  local dst_cursor="${TARGET_DIR}/.cursor"
  local link_mode="${ARG_LINK_MODE:-auto}"

  # Resolve effective link mode.
  if [[ "$link_mode" == "auto" ]]; then
    if [[ "$OS_TYPE" == "windows" ]]; then
      link_mode="copy"
    else
      link_mode="symlink"
    fi
  fi

  mkdir -p "$dst_cursor"

  for subdir in "${FRAMEWORK_CURSOR_DIRS[@]}"; do
    local src="${src_cursor}/${subdir}"
    local dst="${dst_cursor}/${subdir}"

    if [[ ! -d "$src" ]]; then
      log_warn "Source directory not found, skipping: ${src}"
      continue
    fi

    if [[ "$link_mode" == "symlink" ]]; then
      if [[ -L "$dst" ]]; then
        log_info "Symlink already exists: ${dst} — refreshing."
        rm -f "$dst"
      elif [[ -d "$dst" ]]; then
        log_warn "Directory already exists at ${dst}. It will be left in place (run --sync to overwrite)."
        [[ "${ARG_SYNC:-false}" == "true" ]] || continue
        rm -rf "$dst"
      fi
      _make_symlink "$src" "$dst" \
        && log_ok "Linked ${dst} → ${src}" \
        || { log_warn "Symlink failed for ${subdir}/ — falling back to copy."; _copy_dir "$src" "$dst" && log_ok "Copied ${subdir}/ → ${dst}"; }
    else
      # copy mode
      if [[ -d "$dst" ]] && [[ "${ARG_SYNC:-false}" != "true" ]] && [[ "${ARG_FORCE:-false}" != "true" ]]; then
        log_info "Directory exists: ${dst} — skipping (use --sync to refresh copy)."
        continue
      fi
      _copy_dir "$src" "$dst" && log_ok "Copied ${subdir}/ → ${dst}"
    fi
  done

  _handle_stack_rule "$link_mode"
}

_handle_stack_rule() {
  local link_mode="$1"
  local stack_src="${COLLECTIONS_HOME}/.cursor/rules/eversis-project-stack.mdc"
  local stack_dst="${TARGET_DIR}/.cursor/rules/eversis-project-stack.mdc"

  # When link mode is symlink, the whole rules/ dir is already symlinked — so the stack
  # rule inside is also symlinked. We need to replace it with a real file so the user can
  # edit it in the target repo without touching the framework source.
  if [[ "$link_mode" == "symlink" ]]; then
    if [[ -L "$stack_dst" ]]; then
      log_info "Converting eversis-project-stack.mdc from symlink to file copy …"
      local content
      content="$(cat "$stack_dst")"
      rm -f "$stack_dst"
      echo "$content" > "$stack_dst"
      log_ok "eversis-project-stack.mdc materialised (edit this file for your project)."
    fi
    return 0
  fi

  # copy mode — copy from source only if absent in target.
  if [[ ! -f "$stack_dst" ]]; then
    cp "$stack_src" "$stack_dst" && log_ok "Created eversis-project-stack.mdc (project-specific, please customise)."
  else
    log_info "eversis-project-stack.mdc already exists — not overwritten."
  fi
}
