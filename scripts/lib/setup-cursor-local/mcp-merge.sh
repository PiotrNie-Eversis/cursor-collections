#!/usr/bin/env bash
# lib/setup-cursor-local/mcp-merge.sh — merge eversis-collections entry into .cursor/mcp.json.
# Sourced after common.sh.

merge_mcp_json() {
  # Requires: COLLECTIONS_HOME, TARGET_DIR, VENDOR_MODE (may be "").
  require_cmd node "Install Node.js ≥ 18 from https://nodejs.org"

  local cursor_dir="${TARGET_DIR}/.cursor"
  local mcp_file="${cursor_dir}/mcp.json"
  local mcp_pkg_dir="${COLLECTIONS_HOME}/mcp/eversis-collections-mcp"
  local dist_index="${mcp_pkg_dir}/dist/index.js"

  mkdir -p "$cursor_dir"

  # Determine path style: absolute (local) vs relative (vendor).
  local use_relative="false"
  if [[ "${VENDOR_MODE:-}" == "submodule" ]] || [[ "${VENDOR_MODE:-}" == "copy" ]]; then
    use_relative="true"
  fi

  # Read existing mcp.json (empty object if absent).
  local existing_json="{}"
  if [[ -f "$mcp_file" ]]; then
    existing_json="$(cat "$mcp_file")"
  fi

  # Merge via Node.js — all values passed through environment to avoid quoting issues.
  local merged
  merged="$(
    _MCP_TARGET_DIR="$TARGET_DIR" \
    _MCP_DIST_INDEX="$dist_index" \
    _MCP_COLLECTIONS_HOME="$COLLECTIONS_HOME" \
    _MCP_USE_RELATIVE="$use_relative" \
    _MCP_EXISTING_JSON="$existing_json" \
    node <<'NODE_EOF'
const path = require('path');

const targetDir   = process.env._MCP_TARGET_DIR.replace(/\\/g, '/');
const distIndex   = process.env._MCP_DIST_INDEX.replace(/\\/g, '/');
const collections = process.env._MCP_COLLECTIONS_HOME.replace(/\\/g, '/');
const useRelative = process.env._MCP_USE_RELATIVE === 'true';
const existing    = JSON.parse(process.env._MCP_EXISTING_JSON);

let cmdPath, envBlock;
if (useRelative) {
  cmdPath  = path.posix.relative(targetDir, distIndex);
  envBlock = {};
} else {
  cmdPath  = distIndex;
  envBlock = { CURSOR_COLLECTIONS_HOME: collections };
}

const entry = {
  command: 'node',
  args: [cmdPath],
  type: 'stdio',
  ...(Object.keys(envBlock).length ? { env: envBlock } : {}),
};

// Cursor requires servers nested under "mcpServers".
// Preserve any top-level keys already in the file (e.g. other config).
const existingServers = existing.mcpServers || {};
const mergedServers = Object.assign({}, existingServers, { 'eversis-collections': entry });
const result = Object.assign({}, existing, { mcpServers: mergedServers });
process.stdout.write(JSON.stringify(result, null, 2) + '\n');
NODE_EOF
  )" || die "Failed to build/merge mcp.json fragment."

  # Validate the result is parseable.
  echo "$merged" | node -e "JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'))" \
    || die "Merged mcp.json is not valid JSON — aborting."

  echo "$merged" > "$mcp_file"
  log_ok "Wrote ${mcp_file}"
}
