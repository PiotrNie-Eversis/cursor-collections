#!/usr/bin/env bash
# lib/setup-cursor-local/summary.sh — print "Next steps" after successful setup.
# Sourced after common.sh.

print_summary() {
  local mode="local"
  [[ -n "${VENDOR_MODE:-}" ]] && mode="vendor (${VENDOR_MODE})"

  local effective_link="${ARG_LINK_MODE:-auto}"
  [[ "$OS_TYPE" == "windows" ]] && [[ "$effective_link" == "auto" ]] && effective_link="copy (auto-fallback on Windows)"

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
  echo "  2. ${_BOLD}Enable the MCP server in Cursor:${_RESET}"
  echo "       • Open Cursor Settings → MCP"
  echo "       • Enable 'eversis-collections'"
  echo "       • Restart Cursor"
  echo ""
  echo "  3. ${_BOLD}Review AGENTS.md${_RESET} and docs/specs/ in your project root."
  echo ""

  if [[ "$mode" == "local" ]]; then
    echo "  4. ${_BOLD}(Recommended) Export the env variable${_RESET} in your shell profile:"
    echo "       export CURSOR_COLLECTIONS_HOME=\"${COLLECTIONS_HOME}\""
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
