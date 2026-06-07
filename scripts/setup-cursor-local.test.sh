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
#   F — symlink mode: rules/ real dir, stack from template, inode ≠ HOME
#   G — legacy rules/ symlink migration preserves content
#   H — copy mode seeds stack from template (not HOME)
#   I — symlink re-run idempotent (stack unchanged)
#   J — all framework rules gitignored (glob); stack not ignored
#   K — re-run migrates legacy per-file rule list to glob

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

assert_not_symlink() {
  local path="$1" desc="${2:-$1 is not a symlink}"
  if [[ -L "$path" ]]; then
    _fail "$desc"
  else
    _pass "$desc"
  fi
}

assert_symlink() {
  local path="$1" desc="${2:-$1 is a symlink}"
  if [[ -L "$path" ]]; then
    _pass "$desc"
  else
    _fail "$desc"
  fi
}

_file_inode() {
  local path="$1"
  if [[ "$(uname -s)" == "Darwin" ]]; then
    stat -f '%i' "$path" 2>/dev/null || return 1
  else
    stat -c '%i' "$path" 2>/dev/null || return 1
  fi
}

assert_inode_diff() {
  local file_a="$1" file_b="$2" desc="${3:-inodes differ}"
  local inode_a inode_b
  inode_a="$(_file_inode "$file_a")" || { _fail "$desc (cannot stat: $file_a)"; return; }
  inode_b="$(_file_inode "$file_b")" || { _fail "$desc (cannot stat: $file_b)"; return; }
  if [[ "$inode_a" != "$inode_b" ]]; then
    _pass "$desc"
  else
    _fail "$desc (both inode ${inode_a})"
  fi
}

assert_git_ignores() {
  local project="$1" relpath="$2" desc="${3:-}"
  local d="${desc:-$relpath is gitignored}"
  if (cd "$project" && git check-ignore -q "$relpath" 2>/dev/null); then
    _pass "$d"
  else
    _fail "$d"
  fi
}

assert_git_not_ignores() {
  local project="$1" relpath="$2" desc="${3:-}"
  local d="${desc:-$relpath is not gitignored}"
  if (cd "$project" && git check-ignore -q "$relpath" 2>/dev/null); then
    _fail "$d"
  else
    _pass "$d"
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
  local link_mode="copy"
  local -a args=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --link-mode)
        link_mode="$2"; shift 2 ;;
      --link-mode=*)
        link_mode="${1#*=}"; shift ;;
      *)
        args+=("$1"); shift ;;
    esac
  done
  if ((${#args[@]} > 0)); then
    CURSOR_COLLECTIONS_HOME="$REPO_ROOT" \
      bash "$SETUP_SCRIPT" \
        --non-interactive \
        --link-mode "$link_mode" \
        --target "$project" \
        "${args[@]}" \
      2>&1 | sed 's/^/    /'
  else
    CURSOR_COLLECTIONS_HOME="$REPO_ROOT" \
      bash "$SETUP_SCRIPT" \
        --non-interactive \
        --link-mode "$link_mode" \
        --target "$project" \
      2>&1 | sed 's/^/    /'
  fi
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

# ─── Scenario F: symlink mode stack isolation ─────────────────────────────────

echo "Scenario F — symlink mode (local stack from template)"
echo "─────────────────────────────────────────────────────────────────"
TMP_F="$(new_temp_project)"
run_setup "$TMP_F" --link-mode symlink
echo ""
assert_common_outputs "$TMP_F"
assert_not_symlink "${TMP_F}/.cursor/rules" "rules/ is a real directory (not symlink)"
assert_symlink "${TMP_F}/.cursor/rules/eversis-agent-core.mdc" "framework rule is per-file symlink"
assert_file_contains "${TMP_F}/.cursor/rules/eversis-project-stack.mdc" "CUSTOMISE FOR THIS REPO" "stack seeded from template"
assert_inode_diff \
  "${TMP_F}/.cursor/rules/eversis-project-stack.mdc" \
  "${REPO_ROOT}/.cursor/rules/eversis-project-stack.mdc" \
  "consumer stack inode ≠ HOME stack inode"
rm -rf "$TMP_F"
echo ""

# ─── Scenario G: legacy rules/ symlink migration ─────────────────────────────

echo "Scenario G — legacy rules/ symlink migration preserves content"
echo "─────────────────────────────────────────────────────────────────"
TMP_G="$(new_temp_project)"
STACK_HOME="${REPO_ROOT}/.cursor/rules/eversis-project-stack.mdc"
STACK_BACKUP="$(mktemp)"
cp "$STACK_HOME" "$STACK_BACKUP"
MARKER="legacy-migration-marker-$$"
(
  mkdir -p "${TMP_G}/.cursor"
  ln -sfn "${REPO_ROOT}/.cursor/rules" "${TMP_G}/.cursor/rules"
  printf '%s\n' "$MARKER" > "${TMP_G}/.cursor/rules/eversis-project-stack.mdc"
)
run_setup "$TMP_G" --link-mode symlink
cp "$STACK_BACKUP" "$STACK_HOME"
rm -f "$STACK_BACKUP"
echo ""
assert_not_symlink "${TMP_G}/.cursor/rules" "legacy rules/ migrated to real directory"
assert_file_contains "${TMP_G}/.cursor/rules/eversis-project-stack.mdc" "$MARKER" "legacy stack content preserved"
assert_inode_diff \
  "${TMP_G}/.cursor/rules/eversis-project-stack.mdc" \
  "$STACK_HOME" \
  "migrated stack inode ≠ HOME stack inode"
rm -rf "$TMP_G"
echo ""

# ─── Scenario H: copy mode template seed ─────────────────────────────────────

echo "Scenario H — copy mode seeds stack from template"
echo "─────────────────────────────────────────────────────────────────"
TMP_H="$(new_temp_project)"
run_setup "$TMP_H" --link-mode copy
echo ""
assert_file_contains "${TMP_H}/.cursor/rules/eversis-project-stack.mdc" "CUSTOMISE FOR THIS REPO" "copy mode stack from template"
assert_inode_diff \
  "${TMP_H}/.cursor/rules/eversis-project-stack.mdc" \
  "${REPO_ROOT}/.cursor/rules/eversis-project-stack.mdc" \
  "copy mode stack inode ≠ HOME stack inode"
rm -rf "$TMP_H"
echo ""

# ─── Scenario I: symlink re-run idempotent ─────────────────────────────────────

echo "Scenario I — symlink re-run leaves local stack unchanged"
echo "─────────────────────────────────────────────────────────────────"
TMP_I="$(new_temp_project)"
run_setup "$TMP_I" --link-mode symlink
CHECKSUM_1="$(cksum "${TMP_I}/.cursor/rules/eversis-project-stack.mdc" | awk '{print $1}')"
run_setup "$TMP_I" --link-mode symlink
CHECKSUM_2="$(cksum "${TMP_I}/.cursor/rules/eversis-project-stack.mdc" | awk '{print $1}')"
if [[ "$CHECKSUM_1" == "$CHECKSUM_2" ]]; then
  _pass "stack rule unchanged after re-run"
else
  _fail "stack rule changed after re-run (checksum ${CHECKSUM_1} → ${CHECKSUM_2})"
fi
rm -rf "$TMP_I"
echo ""

# ─── Scenario J: framework rules gitignored (glob) ────────────────────────────

echo "Scenario J — framework rules gitignored; stack rule commitable"
echo "─────────────────────────────────────────────────────────────────"
TMP_J="$(new_temp_project)"
run_setup "$TMP_J" --link-mode copy
echo ""
assert_file_contains "${TMP_J}/.gitignore" ".cursor/rules/eversis-*.mdc"              "gitignore uses eversis-*.mdc glob"
assert_file_contains "${TMP_J}/.gitignore" "!.cursor/rules/eversis-project-stack.mdc" "gitignore negates stack rule"
assert_not_contains  "${TMP_J}/.gitignore" "eversis-agent-core.mdc"                   "legacy per-file agent-core entry absent"
for rule in "${REPO_ROOT}"/.cursor/rules/eversis-*.mdc; do
  base="$(basename "$rule")"
  [[ "$base" == "eversis-project-stack.mdc" ]] && continue
  assert_git_ignores "$TMP_J" ".cursor/rules/${base}" "framework rule ${base} gitignored"
done
assert_git_not_ignores "$TMP_J" ".cursor/rules/eversis-project-stack.mdc" "stack rule not gitignored"
rm -rf "$TMP_J"
echo ""

# ─── Scenario K: re-run migrates legacy gitignore block ─────────────────────

echo "Scenario K — re-run migrates legacy per-file rule list to glob"
echo "─────────────────────────────────────────────────────────────────"
TMP_K="$(new_temp_project)"
cat > "${TMP_K}/.gitignore" <<'EOF'
node_modules/

# cursor-collections local [begin]
.cursor/mcp.json
.cursor/prompts/
.cursor/commands/
.cursor/skills/
.cursor/rules/eversis-agent-core.mdc
.cursor/rules/eversis-testing-and-terminal.mdc
.cursor/rules/eversis-engineering-manager.mdc
.cursor/rules/eversis-code-reviewer.mdc
# cursor-collections agent-artifacts [begin]
docs/specs/*/
docs/context/*/
# cursor-collections agent-artifacts [end]
# cursor-collections local [end]
EOF
run_setup "$TMP_K" --link-mode copy --gitignore-agent-artifacts
echo ""
assert_count "${TMP_K}/.gitignore" "cursor-collections local [begin]" 1 "single local marker after migration"
assert_file_contains "${TMP_K}/.gitignore" ".cursor/rules/eversis-*.mdc"              "migrated block uses glob"
assert_not_contains  "${TMP_K}/.gitignore" "eversis-agent-core.mdc"                   "legacy agent-core line removed"
assert_file_contains "${TMP_K}/.gitignore" "cursor-collections agent-artifacts [begin]" "artifacts sub-block preserved"
assert_git_ignores "$TMP_K" ".cursor/rules/eversis-accessibility.mdc" "accessibility rule gitignored after migration"
rm -rf "$TMP_K"
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
