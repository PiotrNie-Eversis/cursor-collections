#!/usr/bin/env bash
# lib/setup-cursor-local/mcp-merge.sh — merge selected MCP servers into .cursor/mcp.json.
# Sourced after common.sh and mcp-prompt.sh.

merge_mcp_json() {
  # Requires: COLLECTIONS_HOME, TARGET_DIR, VENDOR_MODE, MCP_SELECTED_IDS (from resolve_mcp_selection).
  require_cmd node "Install Node.js ≥ 18 from https://nodejs.org"

  local cursor_dir="${TARGET_DIR}/.cursor"
  local mcp_file="${cursor_dir}/mcp.json"
  local mcp_pkg_dir="${COLLECTIONS_HOME}/mcp/eversis-collections-mcp"
  local dist_index="${mcp_pkg_dir}/dist/index.js"
  local template_path="${COLLECTIONS_HOME}/.cursor/mcp.json"
  # Vendor copy omits mcp.json; fall back to the checkout that hosts setup-cursor-local.sh.
  if [[ ! -f "$template_path" ]] && [[ -n "${SETUP_SCRIPT_DIR:-}" ]]; then
    local _fallback_template="${SETUP_SCRIPT_DIR}/../.cursor/mcp.json"
    if [[ -f "$_fallback_template" ]]; then
      template_path="$(cd "$(dirname "$_fallback_template")" && pwd)/$(basename "$_fallback_template")"
      log_info "Using MCP template from setup script checkout: ${template_path}"
    fi
  fi
  local server_list="${LIB_DIR}/mcp-server-list.json"
  local merge_mjs="${LIB_DIR}/mcp-merge.mjs"

  [[ -f "$template_path" ]] || die "Framework MCP template not found (checked COLLECTIONS_HOME and setup script checkout)."
  [[ -f "$server_list" ]]    || die "MCP server list not found: ${server_list}"
  [[ -f "$merge_mjs" ]]       || die "MCP merge script not found: ${merge_mjs}"

  mkdir -p "$cursor_dir"

  local use_relative="false"
  if [[ "${VENDOR_MODE:-}" == "submodule" ]] || [[ "${VENDOR_MODE:-}" == "copy" ]]; then
    use_relative="true"
  fi

  local existing_json="{}"
  if [[ -f "$mcp_file" ]]; then
    existing_json="$(cat "$mcp_file")"
  fi

  local merged
  merged="$(
    MCP_TARGET_DIR="$TARGET_DIR" \
    MCP_DIST_INDEX="$dist_index" \
    MCP_COLLECTIONS_HOME="$COLLECTIONS_HOME" \
    MCP_USE_RELATIVE="$use_relative" \
    MCP_EXISTING_JSON="$existing_json" \
    MCP_SELECTED_IDS="${MCP_SELECTED_IDS:-eversis-collections}" \
    MCP_TEMPLATE_PATH="$template_path" \
    MCP_SERVER_LIST_PATH="$server_list" \
    node "$merge_mjs"
  )" || die "Failed to build/merge mcp.json."

  echo "$merged" | node -e "JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'))" \
    || die "Merged mcp.json is not valid JSON — aborting."

  echo "$merged" > "$mcp_file"
  log_ok "Wrote ${mcp_file} (servers: ${MCP_SELECTED_IDS:-eversis-collections})"
}
