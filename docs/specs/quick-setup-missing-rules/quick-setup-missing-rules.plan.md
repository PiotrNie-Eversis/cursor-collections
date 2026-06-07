# Plan: quick setup — glob gitignore dla reguł frameworku

**Research:** [quick-setup-missing-rules.research.md](./quick-setup-missing-rules.research.md)  
**Wdrożenie** po akceptacji tego planu (bramka z `eversis-agent-core.mdc`).

**Decyzje produktowe (human gate):** 2026-06-05

| Pytanie | Decyzja |
| ------- | ------- |
| Opcja A vs B | **Opcja B** — `.cursor/rules/eversis-*.mdc` + `!.cursor/rules/eversis-project-stack.mdc` |
| Istniejące consumer repos | **Re-run** `setup-cursor-local.sh` — skrypt musi **zaktualizować** istniejący blok local (merge/migracja), nie tylko dokumentacja |
| Własne `eversis-*.mdc` w consumer | Tworzone **po** skonfigurowaniu reguł projektowych; glob B akceptowany — frameworkowe reguły z setupu są upstream; późniejsze reguły projektowe poza scope tego fixu |

---

## Task Details

| Field | Value |
| ----- | ----- |
| ID / folder | `quick-setup-missing-rules` |
| Title | Uzupełnienie local gitignore — wszystkie `eversis-*.mdc` oprócz stack |
| Priority | Średnia — spójność quick setup z modelem local |
| Scope | `gitignore.sh`, `.gitignore` frameworku, smoke test, docs, CHANGELOG |

---

## Proposed Solution

Zastąpić **czteroelementową listę** reguł w bloku `# cursor-collections local [begin]` wzorcem glob + wyjątek stack:

```gitignore
.cursor/mcp.json
.cursor/prompts/
.cursor/commands/
.cursor/skills/
.cursor/rules/eversis-*.mdc
!.cursor/rules/eversis-project-stack.mdc
```

### Re-run na istniejących consumer repos

Dziś `manage_gitignore()` przy istniejącym markerze **tylko** toggle’uje sub-blok `agent-artifacts` i **nie odświeża** linii reguł. Plan wymaga **`_refresh_local_gitignore_core_lines`**:

1. Jeśli marker istnieje — przepisać **rdzeń** bloku (linie między `[begin]` a sub-markerem artifacts lub `[end]`) do aktualnego kształtu z `_local_gitignore_lines`.
2. Usunąć **stare** jawne wpisy (4 reguły SDLC + ewentualne pojedyncze accessibility/ba-docs jeśli ktoś dodał ręcznie).
3. Zachować sub-marker `agent-artifacts` bez zmian (jak dziś).
4. Idempotentny re-run — jeden marker, jeden zestaw linii rdzenia.

**Instrukcja dla zespołów:** po merge tego fixu w `cursor-collections`, w consumer projekcie (local mode):

```bash
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --non-interactive
```

(opcjonalnie `--sync` jeśli copy mode i odświeżenie `.cursor/*`).

### Konwencja reguł projektowych (poza scope implementacji)

Glob ignoruje **wszystkie** `eversis-*.mdc` oprócz stack. Zatwierdzona decyzja: dodatkowe reguły `eversis-*` powstają **po** setupie w ramach konfiguracji projektu — zespół wie, że w local mode nie powinny być commitowane jako kopie upstream. Jeśli projekt potrzebuje **commitowalnej** własnej reguły `eversis-*`, używa vendor mode lub ręcznego wyjątku w `.gitignore` (dokumentacja w Part C — jedno zdanie).

---

## Current Implementation Analysis

### Pliki do modyfikacji

| Plik | Zmiana |
| ---- | ------ |
| `scripts/lib/setup-cursor-local/gitignore.sh` | Glob w `_local_gitignore_lines`; `_refresh_local_gitignore_core_lines`; wywołanie przy re-run w `manage_gitignore` |
| `.gitignore` (repo frameworku) | Zamiana 4 linii na glob + wyjątek stack |
| `scripts/setup-cursor-local.test.sh` | Scenariusz J: `git check-ignore` dla wszystkich framework rules; scenariusz K: re-run migracja ze starej listy |
| `scripts/lib/setup-cursor-local/gitignore.test.sh` | Case: refresh core lines zachowuje artifacts sub-block |
| `documentation/cursor-collection.md` | Part C — local gitignore = glob reguł |
| `website/docs/getting-started/installation.md` | Mirror jednego akapitu |
| `README.md` | § Quick setup — re-run po aktualizacji frameworku (jeśli brak) |
| `CHANGELOG.md` | Fix entry |
| `docs/specs/quick-setup-missing-rules/quick-setup-missing-rules.research.md` | § Decyzje produktowe — zamknięte pytania |

### Bez zmian

| Element | Powód |
| ------- | ----- |
| `link-framework.sh` | Już linkuje wszystkie `eversis-*.mdc` oprócz stack |
| Vendor mode | Local block usuwany — bez wpływu |
| `eversis-project-stack.mdc` | Nadal commitowany; wyjątek `!` w gitignore |

---

## Implementation Phases

### Phase 1 — Logika gitignore + migracja re-run

#### Task 1.1 - [MODIFY] `scripts/lib/setup-cursor-local/gitignore.sh`

**Description:**

1. **`_local_gitignore_lines`** — output:

   ```
   .cursor/mcp.json
   .cursor/prompts/
   .cursor/commands/
   .cursor/skills/
   .cursor/rules/eversis-*.mdc
   !.cursor/rules/eversis-project-stack.mdc
   ```

2. **`_refresh_local_gitignore_core_lines "$file"`** — gdy `_has_marker`:
   - Wyodrębnij zawartość sub-bloku artifacts (jeśli jest) do zmiennych / zachowaj przez awk.
   - Zastąp cały blok local nowym rdzeniem + opcjonalny artifacts + `[end]`.
   - Log: `log_ok "Refreshed cursor-collections local gitignore block"`.

3. **`manage_gitignore`** — gdy marker istnieje:
   - Wywołaj `_refresh_local_gitignore_core_lines` **przed** artifacts toggle.
   - Następnie dotychczasowa logika artifacts (ensure/remove).

**Definition of Done:**

- [ ] Nowy setup dostaje glob w bloku
- [ ] Re-run na bloku ze **starą** 4-liniową listą → migracja do glob (bez duplikacji markera)
- [ ] Re-run z `--gitignore-agent-artifacts` zachowuje sub-marker
- [ ] `eversis-project-stack.mdc` nigdy w gitignore (brak linii ignorującej; jest `!`)

#### Task 1.2 - [MODIFY] `.gitignore` (cursor-collections repo)

**Description:** Zaktualizować blok `cursor-collections local [begin]` do tego samego kształtu co `_local_gitignore_lines`.

**Definition of Done:**

- [ ] Spójność z `gitignore.sh`

---

### Phase 2 — Testy

#### Task 2.1 - [MODIFY] `scripts/setup-cursor-local.test.sh`

**Description:**

**Scenario J — framework rules gitignored (copy mode, local):**

- Po setup: dla każdego `eversis-*.mdc` w `REPO_ROOT/.cursor/rules/` **oprócz** `eversis-project-stack.mdc`:
  - `git -C "$TMP" check-ignore -q ".cursor/rules/$(basename)"` → pass
- Dla `eversis-project-stack.mdc`: `check-ignore` → **fail** (not ignored)
- `.gitignore` zawiera `eversis-*.mdc` i `!...eversis-project-stack.mdc`

**Scenario K — re-run migrates legacy block:**

- Ręcznie utwórz `.gitignore` ze **starą** listą 4 reguł + marker
- Re-run setup
- Assert: stara lista usunięta; glob obecny; pojedynczy marker

**Definition of Done:**

- [ ] `bash scripts/setup-cursor-local.test.sh` — wszystkie scenariusze PASS
- [ ] `bash scripts/lib/setup-cursor-local/gitignore.test.sh` — PASS (+ case refresh)

#### Task 2.2 - [MODIFY] `scripts/lib/setup-cursor-local/gitignore.test.sh`

**Description:** Case 4: plik ze starą listą 4 reguł + artifacts sub-block → `_refresh_local_gitignore_core_lines` → glob + artifacts zachowany.

---

### Phase 3 — Dokumentacja

#### Task 3.1 - [MODIFY] `documentation/cursor-collection.md` (Part C)

**Description:** W sekcji Quick setup / tabela local gitignore — doprecyzować:

- Local block ignoruje `.cursor/rules/eversis-*.mdc` z wyjątkiem `eversis-project-stack.mdc`.
- Po aktualizacji frameworku: re-run `setup-cursor-local.sh` w consumer repo odświeża blok.

#### Task 3.2 - [MODIFY] `website/docs/getting-started/installation.md`

**Description:** Mirror Part C (krótki akapit + re-run).

#### Task 3.3 - [MODIFY] `docs/specs/cursor-local-setup/cursor-local-setup-specs-context-gitignore.research.md`

**Description:** Zaktualizować przykładowy blok gitignore w § „Stan obecny” (odniesienie historyczne lub „zobacz quick-setup-missing-rules”).

---

### Phase 4 — CHANGELOG + research closure

#### Task 4.1 - [MODIFY] `CHANGELOG.md`

**Description:** Wpis **Fixed** — local gitignore obejmuje wszystkie framework rules (glob); re-run migruje legacy block.

#### Task 4.2 - [MODIFY] `quick-setup-missing-rules.research.md`

**Description:** Dodać sekcję **Decyzje produktowe (2026-06-05)** z odpowiedziami; link do tego planu.

---

## Acceptance Criteria

- [x] Po local setup **wszystkie** reguły frameworku (accessibility, ba-docs-*, core SDLC) są `git check-ignore` w consumer fixture.
- [x] `eversis-project-stack.mdc` **nie** jest ignorowany.
- [x] Re-run na consumer ze starym blokiem **migruje** do glob bez duplikacji markera.
- [x] Vendor mode bez zmian.
- [x] Smoke + gitignore unit tests green.
- [x] Dokumentacja Part C / installation wspomina re-run.

---

## Test plan (manual)

1. W pustym repo: `setup-cursor-local.sh --link-mode copy --non-interactive` → `git status .cursor/rules/` pokazuje tylko `eversis-project-stack.mdc` jako trackable (reszta ignored).
2. Symulacja legacy: stary blok 4 linii → re-run → glob w `.gitignore`.
3. `git check-ignore -v .cursor/rules/eversis-accessibility.mdc` → match na glob.

---

## Risks

| Ryzyko | Mitigacja |
| ------ | --------- |
| Git negacja `!` nie działa w starszym git | Smoke na CI (macOS/Linux); wzorzec standardowy |
| Re-run nadpisuje ręczne edycje w bloku local | Oczekiwane — blok zarządzany przez skrypt; dokumentacja |
| Późniejsze `eversis-custom.mdc` gitignored | Zaakceptowane; vendor / ręczny wyjątek dla commitowalnych reguł projektowych |

---

## Changelog (plan)

| Data | Zmiana |
| ---- | ------ |
| 2026-06-05 | Plan utworzony po human gate (Opcja B, re-run, reguły projektowe post-setup) |
| 2026-06-05 | Wdrożenie zakończone — gitignore glob, refresh na re-run, testy J–K, docs, CHANGELOG |
