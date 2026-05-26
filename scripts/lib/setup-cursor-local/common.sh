#!/usr/bin/env bash
# lib/setup-cursor-local/common.sh — shared constants, colours, logging helpers.
# Sourced by every other module; do NOT execute directly.

set -euo pipefail

# ─── colours / logging ───────────────────────────────────────────────────────

if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
  _BOLD=$(tput bold)
  _GREEN=$(tput setaf 2)
  _YELLOW=$(tput setaf 3)
  _RED=$(tput setaf 1)
  _CYAN=$(tput setaf 6)
  _RESET=$(tput sgr0)
else
  _BOLD="" _GREEN="" _YELLOW="" _RED="" _CYAN="" _RESET=""
fi

log_info()    { echo "${_CYAN}[cursor-setup]${_RESET} $*"; }
log_ok()      { echo "${_GREEN}[cursor-setup]${_RESET} $*"; }
log_warn()    { echo "${_YELLOW}[cursor-setup WARN]${_RESET} $*" >&2; }
log_error()   { echo "${_RED}[cursor-setup ERROR]${_RESET} $*" >&2; }
die()         { log_error "$*"; exit 1; }

# ─── OS detection ─────────────────────────────────────────────────────────────

detect_os() {
  # Sets: OS_TYPE = macos | linux | windows
  case "${OSTYPE:-}" in
    darwin*) OS_TYPE="macos" ;;
    msys*|cygwin*|mingw*) OS_TYPE="windows" ;;
    *)
      if [[ "$(uname -s 2>/dev/null)" == MINGW* ]] || [[ "$(uname -s 2>/dev/null)" == CYGWIN* ]]; then
        OS_TYPE="windows"
      else
        OS_TYPE="linux"
      fi
      ;;
  esac
  readonly OS_TYPE
}

# ─── default HOME path per OS ─────────────────────────────────────────────────

default_collections_home() {
  # Prints the platform-appropriate default clone path.
  local os="${OS_TYPE:-}"
  case "$os" in
    macos|linux) echo "${HOME}/.local/share/cursor-collections" ;;
    windows)
      local appdata="${LOCALAPPDATA:-${APPDATA:-}}"
      if [[ -n "$appdata" ]]; then
        echo "${appdata}/cursor-collections"
      else
        echo "${HOME}/cursor-collections"
      fi
      ;;
    *) echo "${HOME}/.local/share/cursor-collections" ;;
  esac
}

# ─── misc ─────────────────────────────────────────────────────────────────────

require_cmd() {
  local cmd="$1" hint="${2:-}"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    if [[ -n "$hint" ]]; then
      die "Required command '${cmd}' not found. ${hint}"
    else
      die "Required command '${cmd}' not found."
    fi
  fi
}
