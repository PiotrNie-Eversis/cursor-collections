#!/usr/bin/env bash
# lib/setup-cursor-local/summary.sh — print "Next steps" after successful setup.
# Sourced after common.sh.

print_summary() {
  local mode="local"
  [[ -n "${VENDOR_MODE:-}" ]] && mode="vendor (${VENDOR_MODE})"

  local effective_link="${ARG_LINK_MODE:-auto}"
  [[ "$OS_TYPE" == "windows" ]] && [[ "$effective_link" == "auto" ]] && effective_link="copy (auto-fallback on Windows)"

  local mcp_file="${TARGET_DIR}/.cursor/mcp.json"
  local configured="${MCP_CONFIGURED_SERVERS:-eversis-collections}"

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "${_BOLD}${_GREEN}cursor-collections setup complete${_RESET}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "  Mode:          ${mode}"
  echo "  Link mode:     ${effective_link}"
  echo "  Framework:     ${COLLECTIONS_HOME}"
  echo "  Target:        ${TARGET_DIR}"
  echo ""
  echo "${_BOLD}Next steps:${_RESET}"
  echo ""
  echo "  1. ${_BOLD}Customise your project stack rule:${_RESET}"
  echo "       ${TARGET_DIR}/.cursor/rules/eversis-project-stack.mdc"
  echo ""
  echo "  2. ${_BOLD}Enable MCP servers in Cursor:${_RESET}"
  echo "       • Open Cursor Settings → MCP"
  if [[ -f "$mcp_file" ]]; then
    echo "       • Configured in ${mcp_file}:"
    local id
    IFS=',' read -ra _mcp_summary_ids <<< "${configured// /}"
    for id in "${_mcp_summary_ids[@]}"; do
      [[ -n "$id" ]] && echo "         - ${id}"
    done
  else
    echo "       • Enable 'eversis-collections'"
  fi
  echo "       • Restart Cursor"
  local _oauth_hint=()
  local _oid
  for _oid in atlassian figma; do
    if echo ",${configured}," | grep -qF ",${_oid},"; then
      _oauth_hint+=("$_oid")
    fi
  done
  if ((${#_oauth_hint[@]} > 0)); then
    echo "       • Complete OAuth in Cursor for: $(IFS=', '; echo "${_oauth_hint[*]}")"
  fi
  if echo "${configured}" | grep -q 'awslabs.aws'; then
    echo "       • AWS MCP servers require uv / uvx (Python) on your PATH"
  fi
  echo ""
  echo "  3. ${_BOLD}Review AGENTS.md${_RESET} and docs/specs/ in your project root."
  echo ""

  if [[ "$mode" == "local" ]] && [[ "${ARG_GITIGNORE_AGENT_ARTIFACTS:-false}" == "true" ]]; then
    echo "  ${_YELLOW}Agent artifacts:${_RESET} docs/specs/*/ and docs/context/*/ are gitignored."
    echo "  Research and plan files will not be shared via git. Re-run without"
    echo "  --gitignore-agent-artifacts to commit them."
    echo ""
  fi

  if [[ "$mode" == "local" ]]; then
    echo "  4. ${_BOLD}(Required) Export CURSOR_COLLECTIONS_HOME${_RESET} where Cursor can see it:"
    echo "       export CURSOR_COLLECTIONS_HOME=\"${COLLECTIONS_HOME}\""
    echo "       Add to ~/.zshrc (or ~/.bashrc), then launch Cursor from terminal (cursor .)"
    echo "       or set the variable in your system/login environment."
    echo "       Local mcp.json uses \${env:CURSOR_COLLECTIONS_HOME} — Dock-only launch may miss it."
    echo ""
    echo "  5. ${_BOLD}Privacy / local-only files:${_RESET}"
    echo "       Do not commit .cursor/mcp.json or remove the managed .gitignore block."
    echo "       Re-run this script if you move the project or framework checkout."
    echo "       Shared teams: consider --vendor submodule instead of local mode."
    echo ""
  fi

  if [[ "$OS_TYPE" == "windows" ]]; then
    echo "  ${_YELLOW}Windows note:${_RESET} Use Git Bash or WSL to run this script."
    echo "  Files were copied (symlinks require Developer Mode / elevated prompt)."
    echo "  To use the Node.js launcher: node scripts/setup-cursor-local.mjs [same flags]"
    echo ""
  fi

  if [[ "${VENDOR_MODE:-}" == "submodule" ]]; then
    echo "  ${_CYAN}Submodule note:${_RESET} Run 'git submodule update --init' after cloning this repo."
    echo "  Commit the .gitmodules and vendor/cursor-collections/ entry."
    echo ""
  fi

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}
