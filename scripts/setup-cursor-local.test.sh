#!/usr/bin/env bash
# setup-cursor-local.test.sh — smoke test for setup-cursor-local.sh.
#
# Usage (from repo root):
#   bash scripts/setup-cursor-local.test.sh
#
# Scenarios:
#   A — local default: no docs/specs/*/ in .gitignore
#   B — local + --gitignore-agent-artifacts: sub-marker + patterns
#   C — re-run B: single sub-marker (no duplication)
#   D — B then re-run without flag: sub-marker removed, local block remains
#   E — vendor copy + flag: no local block; warn on stderr

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SETUP_SCRIPT="${SCRIPT_DIR}/setup-cursor-local.sh"
GITIGNORE_TEST="${SCRIPT_DIR}/lib/setup-cursor-local/gitignore.test.sh"

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

assert_count() {
  local file="$1" pattern="$2" expected="$3" desc="${4:-}"
  local count
  count="$(grep -cF "$pattern" "$file" 2>/dev/null || true)"
  local d="${desc:-'$pattern' appears ${expected} time(s)}"
  if [[ "$count" -eq "$expected" ]]; then
    _pass "$d"
  else
    _fail "$d (got: ${count}, in: $file)"
  fi
}

assert_common_outputs() {
  local project="$1"

  assert_exists "${project}/.cursor/rules"            ".cursor/rules directory"
  assert_exists "${project}/.cursor/prompts"          ".cursor/prompts directory"
  assert_exists "${project}/.cursor/commands"         ".cursor/commands directory"
  assert_exists "${project}/.cursor/skills"           ".cursor/skills directory"
  assert_exists "${project}/.cursor/rules/eversis-project-stack.mdc" "eversis-project-stack.mdc"
  assert_exists "${project}/.cursor/mcp.json"         ".cursor/mcp.json"
  assert_exists "${project}/.gitignore"               ".gitignore exists"
  assert_file_contains "${project}/.gitignore" "cursor-collections local [begin]" ".gitignore has marker block"
  assert_file_contains "${project}/.gitignore" ".cursor/mcp.json"                ".gitignore ignores .cursor/mcp.json"
  assert_not_contains  "${project}/.gitignore" "eversis-project-stack.mdc"       ".gitignore does NOT ignore stack rule"
  assert_exists "${project}/AGENTS.md"              "AGENTS.md"
  assert_exists "${project}/docs/specs"             "docs/specs/ directory"
  assert_exists "${project}/docs/specs/README.md"   "docs/specs/README.md"
}

new_temp_project() {
  local dir
  dir="$(mktemp -d)"
  (
    cd "$dir"
    git init -q
    git config user.email "test@example.com"
    git config user.name "Smoke Test"
  )
  echo "$dir"
}

run_setup() {
  local project="$1"
  shift
  CURSOR_COLLECTIONS_HOME="$REPO_ROOT" \
    bash "$SETUP_SCRIPT" \
      --non-interactive \
      --link-mode copy \
      --target "$project" \
      "$@" \
    2>&1 | sed 's/^/    /'
}

echo "setup-cursor-local smoke tests"
echo "Framework source: ${REPO_ROOT}"
echo ""

# ─── Scenario A: local default ────────────────────────────────────────────────

echo "Scenario A — local default (no agent-artifacts gitignore)"
echo "─────────────────────────────────────────────────────────────────"
TMP_A="$(new_temp_project)"
run_setup "$TMP_A"
echo ""
assert_common_outputs "$TMP_A"
assert_not_contains "${TMP_A}/.gitignore" "docs/specs/*/" "default .gitignore does NOT ignore docs/specs/*/"
assert_not_contains "${TMP_A}/.gitignore" "agent-artifacts [begin]" "default .gitignore has no agent-artifacts sub-block"
rm -rf "$TMP_A"
echo ""

# ─── Scenario B: local + flag ─────────────────────────────────────────────────

echo "Scenario B — local + --gitignore-agent-artifacts"
echo "─────────────────────────────────────────────────────────────────"
TMP_B="$(new_temp_project)"
run_setup "$TMP_B" --gitignore-agent-artifacts
echo ""
assert_common_outputs "$TMP_B"
assert_file_contains "${TMP_B}/.gitignore" "cursor-collections agent-artifacts [begin]" "agent-artifacts sub-block present"
assert_file_contains "${TMP_B}/.gitignore" "docs/specs/*/"                           ".gitignore ignores docs/specs/*/"
assert_file_contains "${TMP_B}/.gitignore" "docs/context/*/"                         ".gitignore ignores docs/context/*/"
echo ""

# ─── Scenario C: re-run with flag (idempotent) ────────────────────────────────

echo "Scenario C — re-run with flag (no duplication)"
echo "─────────────────────────────────────────────────────────────────"
run_setup "$TMP_B" --gitignore-agent-artifacts
echo ""
assert_count "${TMP_B}/.gitignore" "cursor-collections agent-artifacts [begin]" 1 "single agent-artifacts sub-block"
echo ""

# ─── Scenario D: remove flag on re-run ────────────────────────────────────────

echo "Scenario D — re-run without flag removes sub-block only"
echo "─────────────────────────────────────────────────────────────────"
run_setup "$TMP_B"
echo ""
assert_file_contains "${TMP_B}/.gitignore" "cursor-collections local [begin]" "local block still present"
assert_not_contains "${TMP_B}/.gitignore" "docs/specs/*/"                       "docs/specs/*/ removed from .gitignore"
assert_not_contains "${TMP_B}/.gitignore" "agent-artifacts [begin]"             "agent-artifacts sub-block removed"
rm -rf "$TMP_B"
echo ""

# ─── Scenario E: vendor + flag ────────────────────────────────────────────────

echo "Scenario E — vendor copy + flag ignored"
echo "─────────────────────────────────────────────────────────────────"
TMP_E="$(new_temp_project)"
OUTPUT_E="$(mktemp)"
run_setup "$TMP_E" --vendor copy --gitignore-agent-artifacts 2>&1 | tee "$OUTPUT_E" | sed 's/^/    /'
echo ""
assert_not_contains "${TMP_E}/.gitignore" "cursor-collections local [begin]" "vendor mode has no local gitignore block"
if grep -qF "gitignore-agent-artifacts is ignored in vendor mode" "$OUTPUT_E"; then
  _pass "vendor mode warns when flag is set"
else
  _fail "vendor mode should warn when --gitignore-agent-artifacts is set"
fi
rm -rf "$TMP_E" "$OUTPUT_E"
echo ""

# ─── gitignore unit tests ─────────────────────────────────────────────────────

if [[ -f "$GITIGNORE_TEST" ]]; then
  echo "gitignore unit tests"
  echo "─────────────────────────────────────────────────────────────────"
  bash "$GITIGNORE_TEST"
  echo ""
fi

# ─── results ──────────────────────────────────────────────────────────────────

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
