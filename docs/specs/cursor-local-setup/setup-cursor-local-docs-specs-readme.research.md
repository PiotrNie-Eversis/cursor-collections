# Research: does `setup-cursor-local.sh --build-mcp --gitignore-agent-artifacts` add `docs/specs/README.md`?

**Date:** 2026-05-29  
**Context:** Confirm whether the one-command local setup (with optional agent-artifacts gitignore) scaffolds `docs/specs/README.md` in the **target consumer project**.  
**Related:** [cursor-local-setup-specs-context-gitignore.research.md](./cursor-local-setup-specs-context-gitignore.research.md), [cursor-local-setup-gitignore-agent-artifacts.plan.md](./cursor-local-setup-gitignore-agent-artifacts.plan.md).

## Question

Does running:

```bash
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --build-mcp --gitignore-agent-artifacts
```

add `README.md` under `docs/specs/` in the target project?

## Verdict (short)

| Aspect | Answer |
| ------ | ------ |
| **Does the command add `docs/specs/README.md`?** | **Yes**, when `docs/specs/` does not already exist in the target |
| **Is that caused by `--gitignore-agent-artifacts`?** | **No** — scaffolding is unconditional; the flag only affects `.gitignore` |
| **Is `README.md` gitignored when the flag is set?** | **No** — only `docs/specs/*/` (subdirectories) is gitignored; root `docs/specs/README.md` stays commitable |

---

## How the script works

### Main flow (`scripts/setup-cursor-local.sh`)

Relevant phases for this question:

| Phase | Module | Effect |
| ----- | ------ | ------ |
| D | `build-mcp.sh` | Builds MCP when `--build-mcp` (or when `dist/index.js` missing) |
| G | `gitignore.sh` | Manages `.gitignore`; `--gitignore-agent-artifacts` adds `docs/specs/*/` + `docs/context/*/` |
| H | `scaffolding.sh` | Creates `AGENTS.md` (if absent) and `docs/specs/` + `README.md` (if directory absent) |

`--build-mcp` and `--gitignore-agent-artifacts` are independent flags parsed separately; Phase H always runs.

### Scaffolding (`scripts/lib/setup-cursor-local/scaffolding.sh`)

```bash
scaffold_project() {
  # ...
  local specs_dir="${target}/docs/specs"
  local specs_readme="${specs_dir}/README.md"

  if [[ ! -d "$specs_dir" ]]; then
    mkdir -p "$specs_dir"
    cat > "$specs_readme" <<'README_EOF'
# specs
...
README_EOF
    log_ok "Created docs/specs/ directory."
  fi
}
```

**Conditions:**

- Creates `docs/specs/` and **`docs/specs/README.md`** only when **`docs/specs/` directory is missing**.
- Does **not** create README if `docs/specs/` exists but `README.md` is missing.
- Does **not** overwrite an existing `docs/specs/` tree.
- Content is **inline stub text** in the script — **not** copied from this repo’s richer `docs/specs/README.md`.

### Gitignore flag (`--gitignore-agent-artifacts`)

From `gitignore.sh`:

```gitignore
docs/specs/*/
docs/context/*/
```

The trailing `/*/` pattern ignores **subdirectories only**. Root files such as `docs/specs/README.md` remain trackable — intentional per [cursor-local-setup-gitignore-agent-artifacts.plan.md](./cursor-local-setup-gitignore-agent-artifacts.plan.md) § “Wzorce ignorują **tylko podkatalogi**”.

### Self-install guard

If the target directory is the cursor-collections source repo itself, setup **aborts** (Phase B guard). The command does not scaffold into the framework repo when run without `--target` pointing at a consumer project.

---

## Test coverage

`scripts/setup-cursor-local.test.sh`:

- **Scenario A** (default local): asserts `docs/specs/README.md` exists.
- **Scenario B** (`--gitignore-agent-artifacts`): same `assert_common_outputs` including `docs/specs/README.md`, plus gitignore lines for `docs/specs/*/`.

Both scenarios confirm README scaffolding is **not** suppressed by the agent-artifacts flag.

---

## Comparison: framework repo vs consumer scaffold

| | Framework repo (`cursor-collections`) | Consumer scaffold (`scaffolding.sh`) |
| --- | --- | --- |
| Path | `docs/specs/README.md` | `docs/specs/README.md` |
| Source | Hand-maintained; describes specs + implementation plans | Generated stub: naming convention + example tree |
| Created by setup script? | No (already in repo) | Yes, on first setup when dir missing |

---

## Edge cases

| Situation | `docs/specs/README.md` created? |
| --------- | ------------------------------- |
| Fresh consumer repo, first setup | **Yes** |
| Re-run setup (`--sync`), `docs/specs/` already exists | **No** (idempotent skip) |
| `docs/specs/` exists, README missing | **No** (gap — script checks directory only) |
| `--gitignore-agent-artifacts` | **Same as without flag** for scaffolding |
| `--vendor submodule\|copy` | Scaffolding unchanged; gitignore flag ignored for artifacts |
| Target = cursor-collections repo | **Aborted** — nothing scaffolded |

---

## Open questions (human gate)

1. Is the question about **expected behavior** (documentation) or a **bug report** (README appearing when unwanted)?
2. Should scaffolding copy the **framework** `docs/specs/README.md` template instead of the minimal inline stub?
3. Should re-run create README when `docs/specs/` exists but README is absent?

---

## Next step

No implementation plan required unless product wants to change scaffolding behavior (e.g. `--no-scaffold-specs`, template sync, or README backfill on re-run). **Await human approval** before any plan or code changes.
