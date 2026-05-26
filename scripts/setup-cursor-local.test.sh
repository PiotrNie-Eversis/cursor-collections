#!/usr/bin/env bash
# setup-cursor-local.test.sh — smoke test for setup-cursor-local.sh.
#
# Usage (from repo root):
#   bash scripts/setup-cursor-local.test.sh
#
# What it does:
#   1. Creates a temp directory as a fake consumer project (git init).
#   2. Uses CURSOR_COLLECTIONS_HOME=$PWD (this repo) as the framework source.
#   3. Runs setup in --non-interactive --link-mode copy mode (no symlinks needed in CI).
#   4. Asserts key outputs: .cursor dirs, mcp.json, .gitignore block, AGENTS.md, docs/specs/.
#   5. Cleans up the temp directory.
#
# The test does NOT build the MCP (--build-mcp is omitted) — CI regression for MCP build
# is covered separately in the package-level npm test.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SETUP_SCRIPT="${SCRIPT_DIR}/setup-cursor-local.sh"

PASS=0
FAIL=0
ERRORS=()

_pass() { echo "  ✓ $1"; PASS=$(( PASS + 1 )); }
_fail() { echo "  ✗ $1"; ERRORS+=("$1"); FAIL=$(( FAIL + 1 )); }

assert_exists() {
  local path="$1" desc="${2:-$1}"
  if [[ -e "$path" ]]; then
    _pass "$desc exists"
  else
    _fail "$desc missing: $path"
  fi
}

assert_file_contains() {
  local file="$1" pattern="$2" desc="${3:-}"
  local d="${desc:-file contains '$pattern'}"
  if grep -qF "$pattern" "$file" 2>/dev/null; then
    _pass "$d"
  else
    _fail "$d (in: $file)"
  fi
}

assert_not_contains() {
  local file="$1" pattern="$2" desc="${3:-}"
  local d="${desc:-file does NOT contain '$pattern'}"
  if grep -qF "$pattern" "$file" 2>/dev/null; then
    _fail "$d (found unexpectedly in: $file)"
  else
    _pass "$d"
  fi
}

# ─── setup temp project ───────────────────────────────────────────────────────

TMP_PROJECT="$(mktemp -d)"
trap 'rm -rf "$TMP_PROJECT"' EXIT

cd "$TMP_PROJECT"
git init -q
git config user.email "test@example.com"
git config user.name "Smoke Test"

echo "Smoke test project directory: ${TMP_PROJECT}"
echo ""
echo "Running setup-cursor-local.sh …"
echo "─────────────────────────────────────────────────────────────────"

# Run the script with this repo as the framework source.
CURSOR_COLLECTIONS_HOME="$REPO_ROOT" \
  bash "$SETUP_SCRIPT" \
    --non-interactive \
    --link-mode copy \
    --target "$TMP_PROJECT" \
  2>&1 | sed 's/^/  /'

echo "─────────────────────────────────────────────────────────────────"
echo ""
echo "Assertions:"

# ─── assertions ───────────────────────────────────────────────────────────────

# .cursor/ structure
assert_exists "${TMP_PROJECT}/.cursor/rules"            ".cursor/rules directory"
assert_exists "${TMP_PROJECT}/.cursor/prompts"          ".cursor/prompts directory"
assert_exists "${TMP_PROJECT}/.cursor/commands"         ".cursor/commands directory"
assert_exists "${TMP_PROJECT}/.cursor/skills"           ".cursor/skills directory"

# eversis-project-stack.mdc must be a real file (not a symlink) in copy mode.
assert_exists "${TMP_PROJECT}/.cursor/rules/eversis-project-stack.mdc" "eversis-project-stack.mdc"
if [[ -L "${TMP_PROJECT}/.cursor/rules/eversis-project-stack.mdc" ]]; then
  _fail "eversis-project-stack.mdc should not be a symlink in copy mode"
else
  _pass "eversis-project-stack.mdc is a regular file (not symlink)"
fi

# mcp.json
assert_exists "${TMP_PROJECT}/.cursor/mcp.json"                   ".cursor/mcp.json"
assert_file_contains "${TMP_PROJECT}/.cursor/mcp.json" "mcpServers"           "mcp.json has mcpServers key"
assert_file_contains "${TMP_PROJECT}/.cursor/mcp.json" "eversis-collections"  "mcp.json has eversis-collections entry"
assert_file_contains "${TMP_PROJECT}/.cursor/mcp.json" "CURSOR_COLLECTIONS_HOME" "mcp.json has CURSOR_COLLECTIONS_HOME env"

# mcp.json must be valid JSON
if node -e "JSON.parse(require('fs').readFileSync('${TMP_PROJECT}/.cursor/mcp.json','utf8'))" 2>/dev/null; then
  _pass "mcp.json is valid JSON"
else
  _fail "mcp.json is NOT valid JSON"
fi

# .gitignore local block
assert_exists "${TMP_PROJECT}/.gitignore"                         ".gitignore exists"
assert_file_contains "${TMP_PROJECT}/.gitignore" "cursor-collections local [begin]" ".gitignore has marker block"
assert_file_contains "${TMP_PROJECT}/.gitignore" ".cursor/mcp.json"                ".gitignore ignores .cursor/mcp.json"
assert_not_contains  "${TMP_PROJECT}/.gitignore" "eversis-project-stack.mdc"       ".gitignore does NOT ignore stack rule"

# AGENTS.md
assert_exists "${TMP_PROJECT}/AGENTS.md"          "AGENTS.md"
assert_file_contains "${TMP_PROJECT}/AGENTS.md" "eversis-collections" "AGENTS.md references framework"

# docs/specs/
assert_exists "${TMP_PROJECT}/docs/specs"         "docs/specs/ directory"
assert_exists "${TMP_PROJECT}/docs/specs/README.md" "docs/specs/README.md"

# .cursorignore
assert_exists "${TMP_PROJECT}/.cursorignore"      ".cursorignore stub"

# ─── results ──────────────────────────────────────────────────────────────────

echo ""
echo "─────────────────────────────────────────────────────────────────"
if [[ $FAIL -eq 0 ]]; then
  echo "  ✅  All ${PASS} assertions passed."
  echo "─────────────────────────────────────────────────────────────────"
  exit 0
else
  echo "  ❌  ${FAIL} assertion(s) FAILED (${PASS} passed):"
  for err in "${ERRORS[@]}"; do
    echo "      • $err"
  done
  echo "─────────────────────────────────────────────────────────────────"
  exit 1
fi
