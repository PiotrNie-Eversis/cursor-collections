#!/usr/bin/env bash
# setup-cursor-local.sh — one-command setup of cursor-collections in a consumer project.
#
# Usage:
#   bash scripts/setup-cursor-local.sh [OPTIONS]
#
# Options:
#   --build-mcp               Build the MCP server (npm install + npm run build).
#                             Auto-triggered when dist/index.js is missing.
#   --collections-home DIR    Path to cursor-collections checkout.
#                             Overrides CURSOR_COLLECTIONS_HOME env var and OS default.
#   --target DIR              Target project directory.
#                             Default: interactive (git root vs cwd) or git root.
#   --vendor submodule|copy   Vendor the framework into this repository.
#                             Default: local (framework lives outside repo).
#   --link-mode auto|symlink|copy
#                             How to expose .cursor/* in the target project.
#                             auto = symlink on Unix, copy on Windows (default).
#   --sync                    Re-run and refresh files (safe on copy-mode targets).
#   --non-interactive         Skip all prompts; use defaults.
#   --force                   Allow setup even when COLLECTIONS_HOME exists but
#                             looks incomplete.
#   --minimal                 (stub) — not yet implemented.
#   --gitignore-agent-artifacts
#                             Local mode only: gitignore docs/specs/*/ and
#                             docs/context/*/ (agent research/plan output).
#   --help                    Show this help and exit.
#
# Environment variables:
#   CURSOR_COLLECTIONS_HOME      Canonical path to cursor-collections checkout.
#   CURSOR_COLLECTIONS_REPO_URL  Git URL to clone from (default: upstream GitHub repo).
#
# Examples:
#   # Minimal local setup (auto-clones if needed):
#   bash scripts/setup-cursor-local.sh --build-mcp
#
#   # Vendor as Git submodule:
#   bash scripts/setup-cursor-local.sh --vendor submodule --build-mcp
#
#   # Vendor as copy (good for monorepos without submodule support):
#   bash scripts/setup-cursor-local.sh --vendor copy --build-mcp
#
#   # Point to an existing checkout, non-interactively:
#   CURSOR_COLLECTIONS_HOME=~/src/cursor-collections \
#     bash scripts/setup-cursor-local.sh --build-mcp --non-interactive
#
#   # Refresh a copy-mode local install:
#   bash scripts/setup-cursor-local.sh --link-mode copy --sync
#
#   # Keep agent research/plan folders out of git (solo / Jira-only):
#   bash scripts/setup-cursor-local.sh --build-mcp --gitignore-agent-artifacts

set -euo pipefail

# ─── locate this script + lib dir ─────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/lib/setup-cursor-local"

# ─── parse arguments ──────────────────────────────────────────────────────────

ARG_BUILD_MCP="false"
ARG_COLLECTIONS_HOME=""
ARG_TARGET=""
ARG_VENDOR=""
ARG_LINK_MODE="auto"
ARG_SYNC="false"
ARG_NON_INTERACTIVE="false"
ARG_FORCE="false"
ARG_MINIMAL="false"
ARG_GITIGNORE_AGENT_ARTIFACTS="false"

export ARG_BUILD_MCP ARG_COLLECTIONS_HOME ARG_TARGET ARG_VENDOR ARG_LINK_MODE \
       ARG_SYNC ARG_NON_INTERACTIVE ARG_FORCE ARG_MINIMAL ARG_GITIGNORE_AGENT_ARTIFACTS

while [[ $# -gt 0 ]]; do
  case "$1" in
    --build-mcp)
      ARG_BUILD_MCP="true"; shift ;;
    --collections-home)
      [[ $# -lt 2 ]] && { echo "ERROR: --collections-home requires a value" >&2; exit 1; }
      ARG_COLLECTIONS_HOME="$2"; shift 2 ;;
    --collections-home=*)
      ARG_COLLECTIONS_HOME="${1#*=}"; shift ;;
    --target)
      [[ $# -lt 2 ]] && { echo "ERROR: --target requires a value" >&2; exit 1; }
      ARG_TARGET="$2"; shift 2 ;;
    --target=*)
      ARG_TARGET="${1#*=}"; shift ;;
    --vendor)
      if [[ $# -ge 2 ]] && [[ "$2" != --* ]]; then
        ARG_VENDOR="$2"; shift 2
      else
        ARG_VENDOR="true"; shift   # bare --vendor → interactive
      fi ;;
    --vendor=*)
      ARG_VENDOR="${1#*=}"; shift ;;
    --link-mode)
      [[ $# -lt 2 ]] && { echo "ERROR: --link-mode requires a value" >&2; exit 1; }
      ARG_LINK_MODE="$2"; shift 2 ;;
    --link-mode=*)
      ARG_LINK_MODE="${1#*=}"; shift ;;
    --sync)
      ARG_SYNC="true"; shift ;;
    --non-interactive)
      ARG_NON_INTERACTIVE="true"; shift ;;
    --force)
      ARG_FORCE="true"; shift ;;
    --minimal)
      ARG_MINIMAL="true"; shift ;;
    --gitignore-agent-artifacts)
      ARG_GITIGNORE_AGENT_ARTIFACTS="true"; shift ;;
    --help|-h)
      # awk: portable on macOS (BSD sed) and Linux (GNU sed).
      awk '/^# setup-cursor-local.sh/,/^[^#]/ { if ($0 ~ /^#/) { sub(/^# ?/, ""); print } }' "$0"
      exit 0 ;;
    *)
      echo "ERROR: Unknown option: $1" >&2
      echo "Run with --help for usage." >&2
      exit 1 ;;
  esac
done

# Validate --link-mode value.
case "$ARG_LINK_MODE" in
  auto|symlink|copy) : ;;
  *) echo "ERROR: --link-mode must be auto, symlink, or copy (got: '${ARG_LINK_MODE}')" >&2; exit 1 ;;
esac

# Validate --vendor value if set to something other than "true" (bare flag).
if [[ -n "$ARG_VENDOR" ]] && [[ "$ARG_VENDOR" != "true" ]]; then
  case "$ARG_VENDOR" in
    submodule|copy) : ;;
    *) echo "ERROR: --vendor must be 'submodule' or 'copy' (got: '${ARG_VENDOR}')" >&2; exit 1 ;;
  esac
fi

# Warn about --minimal stub.
if [[ "$ARG_MINIMAL" == "true" ]]; then
  echo "WARNING: --minimal is not yet implemented; proceeding with full setup." >&2
fi

# ─── source modules ───────────────────────────────────────────────────────────

# shellcheck source=lib/setup-cursor-local/common.sh
source "${LIB_DIR}/common.sh"
# shellcheck source=lib/setup-cursor-local/paths.sh
source "${LIB_DIR}/paths.sh"
# shellcheck source=lib/setup-cursor-local/git-target.sh
source "${LIB_DIR}/git-target.sh"
# shellcheck source=lib/setup-cursor-local/build-mcp.sh
source "${LIB_DIR}/build-mcp.sh"
# shellcheck source=lib/setup-cursor-local/vendor.sh
source "${LIB_DIR}/vendor.sh"
# shellcheck source=lib/setup-cursor-local/link-framework.sh
source "${LIB_DIR}/link-framework.sh"
# shellcheck source=lib/setup-cursor-local/mcp-merge.sh
source "${LIB_DIR}/mcp-merge.sh"
# shellcheck source=lib/setup-cursor-local/gitignore.sh
source "${LIB_DIR}/gitignore.sh"
# shellcheck source=lib/setup-cursor-local/scaffolding.sh
source "${LIB_DIR}/scaffolding.sh"
# shellcheck source=lib/setup-cursor-local/summary.sh
source "${LIB_DIR}/summary.sh"

# ─── main ─────────────────────────────────────────────────────────────────────

log_info "Starting cursor-collections setup …"

detect_os

# Phase A: resolve + clone framework.
resolve_collections_home
ensure_framework_checkout

# Phase B: resolve target directory.
resolve_target_dir

# Guard: abort when TARGET_DIR is the cursor-collections source repo (self-install).
# Detect by comparing TARGET_DIR to the parent of SCRIPT_DIR (where this script lives).
_script_repo_root="$(realpath -m "${SCRIPT_DIR}/.." 2>/dev/null || cd "${SCRIPT_DIR}/.." && pwd)"
_resolved_target="$(realpath -m "${TARGET_DIR}" 2>/dev/null || echo "${TARGET_DIR}")"
if [[ "$_resolved_target" == "$_script_repo_root" ]]; then
  die "Target directory is the cursor-collections source repo (${_script_repo_root}).
  Running setup against the framework repo itself is not supported.

  Run from your consumer project instead:
    cd ~/your-project
    bash \"${BASH_SOURCE[0]}\" --build-mcp

  Or specify the target explicitly:
    bash \"${BASH_SOURCE[0]}\" --target ~/your-project --build-mcp"
fi
unset _script_repo_root _resolved_target

# Phase C: vendor setup (may update COLLECTIONS_HOME to vendor path).
run_vendor_setup

# Phase D: build MCP server.
maybe_build_mcp "$COLLECTIONS_HOME"

# Phase E: link / copy .cursor/* into target.
# Local: COLLECTIONS_HOME is the shared checkout; vendor: COLLECTIONS_HOME is vendor/cursor-collections/.
link_framework_files

# Phase F: merge mcp.json.
merge_mcp_json

# Phase G: gitignore + cursorignore.
manage_gitignore
manage_cursorignore

# Phase H: scaffold project structure.
scaffold_project

# Phase I: print summary / next steps.
print_summary

log_ok "Done."
