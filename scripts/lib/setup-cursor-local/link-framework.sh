#!/usr/bin/env bash
# lib/setup-cursor-local/link-framework.sh — link or copy .cursor/* into target.
# Sourced after common.sh.

# Directories inside .cursor/ that are managed by the framework.
readonly FRAMEWORK_CURSOR_DIRS=(rules prompts commands skills)
readonly STACK_RULE_BASENAME="eversis-project-stack.mdc"

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

_copy_rules_dir_excluding_stack() {
  local src="$1" dst="$2"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete \
      --exclude=node_modules/ \
      --exclude=.git/ \
      --exclude="${STACK_RULE_BASENAME}" \
      "$src/" "$dst/"
  else
    mkdir -p "$dst"
    local f base
    shopt -s nullglob
    for f in "${src}"/*; do
      base="$(basename "$f")"
      [[ "$base" == "${STACK_RULE_BASENAME}" ]] && continue
      if [[ -d "$f" ]]; then
        rm -rf "${dst}/${base}"
        cp -R "$f" "${dst}/${base}"
      else
        cp "$f" "${dst}/${base}"
      fi
    done
    shopt -u nullglob
  fi
}

_stack_template_path() {
  local primary="${COLLECTIONS_HOME}/scripts/setup-cursor-local/templates/eversis-project-stack.example.mdc"
  if [[ -f "$primary" ]]; then
    echo "$primary"
    return 0
  fi
  local fallback="${SETUP_SCRIPT_DIR:-}/setup-cursor-local/templates/eversis-project-stack.example.mdc"
  if [[ -f "$fallback" ]]; then
    echo "$fallback"
    return 0
  fi
  echo "$primary"
}

_file_inode() {
  local path="$1"
  if [[ "$OS_TYPE" == "macos" ]]; then
    stat -f '%i' "$path" 2>/dev/null || return 1
  else
    stat -c '%i' "$path" 2>/dev/null || return 1
  fi
}

_stack_points_to_home() {
  local stack_dst="$1"
  local home_stack="${COLLECTIONS_HOME}/.cursor/rules/${STACK_RULE_BASENAME}"

  [[ -f "$stack_dst" ]] || return 1
  [[ -f "$home_stack" ]] || return 1

  local dst_inode home_inode
  if dst_inode="$(_file_inode "$stack_dst")" && home_inode="$(_file_inode "$home_stack")"; then
    [[ "$dst_inode" == "$home_inode" ]]
    return
  fi

  # Fallback when inode comparison is unavailable.
  local dst_real home_real
  dst_real="$(realpath -m "$stack_dst" 2>/dev/null || readlink -f "$stack_dst" 2>/dev/null || echo "$stack_dst")"
  home_real="$(realpath -m "$home_stack" 2>/dev/null || readlink -f "$home_stack" 2>/dev/null || echo "$home_stack")"
  [[ "$dst_real" == "$home_real" ]]
}

_seed_or_preserve_stack_rule() {
  local preserved="${1:-}"
  local stack_dst="${TARGET_DIR}/.cursor/rules/${STACK_RULE_BASENAME}"
  local stack_template
  stack_template="$(_stack_template_path)"

  [[ -f "$stack_template" ]] || die "Stack rule template not found: ${stack_template}"

  if [[ -f "$stack_dst" ]] && ! _stack_points_to_home "$stack_dst"; then
    log_info "eversis-project-stack.mdc already exists — not overwritten."
    return 0
  fi

  mkdir -p "$(dirname "$stack_dst")"

  if [[ -n "$preserved" ]]; then
    printf '%s\n' "$preserved" > "$stack_dst"
    log_ok "eversis-project-stack.mdc materialised (preserved content from legacy layout)."
    return 0
  fi

  if [[ -f "$stack_dst" ]] && _stack_points_to_home "$stack_dst"; then
    preserved="$(cat "$stack_dst")"
    printf '%s\n' "$preserved" > "$stack_dst"
    log_ok "eversis-project-stack.mdc materialised (preserved content)."
    return 0
  fi

  if [[ ! -f "$stack_dst" ]]; then
    cp "$stack_template" "$stack_dst"
    log_ok "Created eversis-project-stack.mdc from template — customise for your project."
  fi
}

_link_framework_rule_files() {
  local src="${COLLECTIONS_HOME}/.cursor/rules"
  local dst="${TARGET_DIR}/.cursor/rules"
  local f base linked_any="false"

  mkdir -p "$dst"

  shopt -s nullglob
  for f in "${src}"/eversis-*.mdc; do
    base="$(basename "$f")"
    [[ "$base" == "${STACK_RULE_BASENAME}" ]] && continue
    rm -f "${dst}/${base}"
    if _make_symlink "$f" "${dst}/${base}"; then
      linked_any="true"
    else
      log_warn "Symlink failed for ${base} — copy fallback for rules/."
      shopt -u nullglob
      _copy_rules_dir_excluding_stack "$src" "$dst"
      return 1
    fi
  done
  shopt -u nullglob

  [[ "$linked_any" == "true" ]]
}

_link_rules_dir_symlink() {
  local src="${COLLECTIONS_HOME}/.cursor/rules"
  local dst="${TARGET_DIR}/.cursor/rules"
  local preserved=""

  if [[ -L "$dst" ]]; then
    if [[ -f "${dst}/${STACK_RULE_BASENAME}" ]]; then
      preserved="$(cat "${dst}/${STACK_RULE_BASENAME}")"
    fi
    rm -f "$dst"
  fi

  if ! _link_framework_rule_files; then
    _seed_or_preserve_stack_rule "$preserved"
    log_ok "Copied framework rules/ (stack rule excluded); stack seeded locally."
    return 0
  fi

  _seed_or_preserve_stack_rule "$preserved"
  log_ok "Linked framework rules/ (per-file symlinks); stack rule is local."
}

_link_rules_dir_copy() {
  local src="${COLLECTIONS_HOME}/.cursor/rules"
  local dst="${TARGET_DIR}/.cursor/rules"
  local preserved=""

  if [[ -L "$dst" ]]; then
    if [[ -f "${dst}/${STACK_RULE_BASENAME}" ]]; then
      preserved="$(cat "${dst}/${STACK_RULE_BASENAME}")"
    fi
    rm -f "$dst"
  fi

  if [[ -d "$dst" ]] && [[ "${ARG_SYNC:-false}" != "true" ]] && [[ "${ARG_FORCE:-false}" != "true" ]]; then
    _seed_or_preserve_stack_rule "$preserved"
    log_info "Directory exists: ${dst} — skipping rules sync (use --sync to refresh copy)."
    return 0
  fi

  mkdir -p "$dst"
  _copy_rules_dir_excluding_stack "$src" "$dst"
  _seed_or_preserve_stack_rule "$preserved"
  log_ok "Copied framework rules/ (stack rule excluded); stack rule is local."
}

link_framework_files() {
  # Link or copy framework .cursor/* directories into TARGET_DIR/.cursor/.
  # rules/: per-file symlinks (symlink mode) or copy excluding stack; stack seeded from template.
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

    if [[ "$subdir" == "rules" ]]; then
      if [[ "$link_mode" == "symlink" ]]; then
        _link_rules_dir_symlink
      else
        _link_rules_dir_copy
      fi
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
}
