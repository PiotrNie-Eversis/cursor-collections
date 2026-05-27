# Plan: flaga `--gitignore-agent-artifacts` (setup-cursor-local)

**Research:** [cursor-local-setup-specs-context-gitignore.research.md](./cursor-local-setup-specs-context-gitignore.research.md)  
**Powiązany plan:** [cursor-local-setup.plan.md](./cursor-local-setup.plan.md) (Phase 1 — rozszerzenie Task 1.9, 1.12, Phase 2)  
**Wdrożenie** po akceptacji tego planu (bramka z `eversis-agent-core.mdc`).

**Decyzja produktowa:** 2026-05-27 — domyślnie **nie** gitignore specs/context; opt-in przez flagę CLI.

---

## Task Details

| Field | Value |
| ----- | ----- |
| ID / folder | `cursor-local-setup` (follow-up) |
| Title | `--gitignore-agent-artifacts` — opcjonalny gitignore podkatalogów `docs/specs/` i `docs/context/` |
| Priority | Niska–średnia — jakość życia dla solo dev / Jira-only; nie blokuje adopcji |
| Scope | Bash MVP (`setup-cursor-local.sh` + `gitignore.sh`); **nie** Phase 1b Node (nota w Task 4) |

## Proposed Solution

Dodać flagę **`--gitignore-agent-artifacts`**, która w trybie **local** (oraz `--link-mode copy` w local) dopisuje do istniejącego bloku `.gitignore`:

```gitignore
docs/specs/*/
docs/context/*/
```

Wzorce ignorują **tylko podkatalogi** — root `docs/specs/README.md` i ewentualne pliki bezpośrednio w `docs/context/` (np. `.gitkeep`) pozostają commitowalne.

### Semantyka flagi

| Warunek | Zachowanie |
| ------- | ---------- |
| Local + flaga | Blok local **zawiera** linie agent-artifacts (wewnętrzny sub-marker) |
| Local bez flagi | Blok local **bez** linii agent-artifacts (jak dziś) |
| `--vendor submodule\|copy` | Flaga **ignorowana** + `log_warn` (vendor = commit wszystkiego) |
| Re-run local, flaga wł./wył. | **Aktualizacja** sub-bloku (idempotentnie), bez duplikacji markera głównego |
| Scaffolding `docs/specs/` | **Bez zmian** — katalog nadal tworzony; gitignore dotyczy tylko git, nie filesystem |

### Struktura markera w `.gitignore`

Rozszerzyć `gitignore.sh` o **zagnieżdżony** sub-marker (łatwiejsze toggle niż przepisywanie całego bloku):

```gitignore
# cursor-collections local [begin]
.cursor/mcp.json
.cursor/prompts/
…
# cursor-collections agent-artifacts [begin]
docs/specs/*/
docs/context/*/
# cursor-collections agent-artifacts [end]
# cursor-collections local [end]
```

Sub-marker **obecny tylko** gdy `ARG_GITIGNORE_AGENT_ARTIFACTS=true`.

### Ostrzeżenie w stdout

Przy użyciu flagi — jedna linia `log_warn` + punkt w `print_summary()`:

- research/plan z `@eversis-implement` nie trafią do git / MR;
- CI sync wiki → `docs/context/` (Part D) wymaga wyjątków lub innej polityki.

---

## Current Implementation Analysis

### Pliki do modyfikacji

| Plik | Zmiana |
| ---- | ------ |
| `scripts/setup-cursor-local.sh` | Parse `--gitignore-agent-artifacts`; export `ARG_GITIGNORE_AGENT_ARTIFACTS`; help + przykład |
| `scripts/lib/setup-cursor-local/gitignore.sh` | Sub-marker; merge/update zamiast „skip if block exists”; usuwanie sub-bloku przy vendor |
| `scripts/lib/setup-cursor-local/summary.sh` | Opcjonalna sekcja „Agent artifacts gitignored” + warn |
| `scripts/setup-cursor-local.test.sh` | Nowe scenariusze (patrz Phase 1) |
| `documentation/cursor-collection.md` | Part C — tabela flag / when to use |
| `website/docs/getting-started/installation.md` | Sekcja flag + ostrzeżenie |
| `README.md` | § Quick setup — jedna linia + link |
| `CHANGELOG.md` | Wpis under Added |

### Bez zmian (świadomie)

| Element | Powód |
| ------- | ----- |
| `scaffolding.sh` | Nadal tworzy `docs/specs/`; flaga nie wyłącza scaffoldingu |
| `setup-cursor-local.mjs` (Phase 1b) | Poza scope — nota „port flagi przy migracji Node” |
| Domyślne zachowanie local | Bez flagi = commit specs/context (zgodnie z research) |

---

## Implementation Phases

### Phase 0 — Kontrakt flagi (parse + walidacja)

#### Task 0.1 - [MODIFY] `scripts/setup-cursor-local.sh`

**Description:**

- Dodać `ARG_GITIGNORE_AGENT_ARTIFACTS="false"`.
- Case `--gitignore-agent-artifacts` → `"true"` (boolean flag, bez wartości).
- Export razem z pozostałymi `ARG_*`.
- W `--help`: opis + przykład:

  ```bash
  bash scripts/setup-cursor-local.sh --build-mcp --gitignore-agent-artifacts
  ```

**Definition of Done:**

- [ ] `--help` zawiera flagę
- [ ] Nieznana flaga nadal kończy exit 1
- [ ] Flaga może łączyć się z `--non-interactive`, `--link-mode copy`, `--sync`

---

### Phase 1 — Logika gitignore + testy

#### Task 1.1 - [MODIFY] `scripts/lib/setup-cursor-local/gitignore.sh`

**Description:**

Stałe:

```bash
readonly _GITIGNORE_ARTIFACTS_START="# cursor-collections agent-artifacts [begin]"
readonly _GITIGNORE_ARTIFACTS_END="# cursor-collections agent-artifacts [end]"
```

Funkcje (propozycja):

| Funkcja | Rola |
| ------- | ---- |
| `_artifact_gitignore_lines` | Echo `docs/specs/*/` + `docs/context/*/` |
| `_remove_artifacts_subblock file` | Usuwa sub-marker z pliku (awk/sed jak główny blok) |
| `_ensure_artifacts_subblock file` | Wstawia sub-blok **przed** `_GITIGNORE_MARKER_END` |
| `_write_local_block file` | Tworzy pełny blok local (+ opcjonalnie sub-blok) |

**`manage_gitignore` — nowa logika:**

1. **Vendor mode** → `_remove_marker_block` (usuwa cały local block, w tym artifacts) — **bez zmian semantyki**.
2. **Local mode:**
   - Jeśli brak głównego markera → dopisz pełny blok (z/bez sub-bloku wg flagi).
   - Jeśli marker istnieje:
     - Flaga **on** → `_ensure_artifacts_subblock` (idempotentnie).
     - Flaga **off** → `_remove_artifacts_subblock` (nie ruszaj reszty bloku local).
   - Jeśli `ARG_GITIGNORE_AGENT_ARTIFACTS=true` → `log_warn` (tekst z research).

3. **Vendor + flaga** → przed return w vendor branch: `log_warn "--gitignore-agent-artifacts ignored in vendor mode"`.

**Definition of Done:**

- [ ] Ponowny run z tą samą flagą nie duplikuje linii
- [ ] Run **bez** flagi po run **z** flagą usuwa tylko sub-blok
- [ ] `eversis-project-stack.mdc` nadal poza gitignore
- [ ] Vendor usuwa cały blok local (w tym artifacts)

#### Task 1.2 - [MODIFY] `scripts/lib/setup-cursor-local/summary.sh`

**Description:** Gdy `ARG_GITIGNORE_AGENT_ARTIFACTS=true` i tryb local — dodać pod „Next steps”:

```text
Note: docs/specs/*/ and docs/context/*/ are gitignored (agent artifacts).
      Plans and research will not be shared via git. Remove the flag and re-run to commit them.
```

**Definition of Done:**

- [ ] Widoczne tylko przy fladze + local
- [ ] Nie wyświetla się w vendor mode

#### Task 1.3 - [MODIFY] `scripts/setup-cursor-local.test.sh`

**Description:** Rozszerzyć smoke test o **drugi przebieg** w osobnym temp dir (lub funkcje pomocnicze + 3 scenariusze). Minimalny zestaw:

| # | Scenariusz | Assert |
| - | ---------- | ------ |
| A | Local default (istniejący test) | `.gitignore` **nie** zawiera `docs/specs/*/` |
| B | Local + `--gitignore-agent-artifacts` | Zawiera sub-marker + oba wzorce |
| C | B → re-run B | Nadal jeden sub-marker (grep -c marker == 1) |
| D | B → re-run **bez** flagi | Sub-marker usunięty; główny local block zostaje |
| E | `--vendor copy` + flaga | Brak local block; opcjonalnie assert stderr zawiera „ignored” |

Implementacja: wyodrębnić funkcję `run_setup tmp_dir extra_args…` + `reset_gitignore_checks`.

**Definition of Done:**

- [ ] `bash scripts/setup-cursor-local.test.sh` exit 0 z repo root
- [ ] Scenariusze A–E pokryte (E może być assert na warn w output — opcjonalnie capture)
- [ ] Komentarz nagłówkowy testu zaktualizowany

#### Task 1.4 - [CREATE] `scripts/lib/setup-cursor-local/gitignore.test.sh` (opcjonalnie, zalecane)

**Description:** Lekki unit test **tylko** dla merge markera — bez pełnego setup (szybszy debug):

- Temp `.gitignore` z istniejącym blokiem local
- Source `gitignore.sh` + mock `TARGET_DIR`, `VENDOR_MODE`, `ARG_GITIGNORE_AGENT_ARTIFACTS`
- 3 case: add artifacts, remove artifacts, vendor removes all

Wywołanie z końca `setup-cursor-local.test.sh` lub osobno.

**Definition of Done:**

- [ ] ≥ 3 asercje merge
- [ ] Uruchamialny: `bash scripts/lib/setup-cursor-local/gitignore.test.sh`

*(Jeśli czas ograniczony — Task 1.4 można odłożyć; Task 1.3 jest obowiązkowy.)*

---

### Phase 2 — Dokumentacja

#### Task 2.1 - [MODIFY] `documentation/cursor-collection.md` Part C

**Description:** W sekcji Quick setup (script):

- Dodać flagę do listy przykładów.
- Tabela lub akapit **When to use** — solo / Jira-only vs zespół / CI wiki sync.
- Wyraźnie: **domyślnie off**.

**Definition of Done:**

- [ ] Part D (wiki sync) wspomina konflikt z flagą
- [ ] Manual bootstrap bez zmian merytorycznych

#### Task 2.2 - [MODIFY] `website/docs/getting-started/installation.md`

**Description:** W „Quick setup (script)” — bullet o fladze + ostrzeżenie (mirror Part C).

**Definition of Done:**

- [ ] Spójność z `cursor-collection.md`
- [ ] `npm run build` website przechodzi (linki)

#### Task 2.3 - [MODIFY] `README.md`

**Description:** W § Step 2 bootstrap — opcjonalny przykład z flagą + jedno zdanie „ephemeral agent artifacts”.

**Definition of Done:**

- [ ] Nie sugeruje flagi jako default

#### Task 2.4 - [MODIFY] `CHANGELOG.md`

**Description:** Wpis **Added** — `--gitignore-agent-artifacts` dla `setup-cursor-local.sh`.

**Definition of Done:**

- [ ] Wpis pod unreleased / najnowszą sekcją

#### Task 2.5 - [MODIFY] Research follow-up

**Description:** W [cursor-local-setup-specs-context-gitignore.research.md](./cursor-local-setup-specs-context-gitignore.research.md) § „Następny krok” — link do tego planu + status „plan approved”.

**Definition of Done:**

- [ ] Jedna linia cross-link

---

## Acceptance Criteria (całość)

- [x] Domyślny local setup **bez** gitignore `docs/specs/*/` / `docs/context/*/`.
- [x] Flaga `--gitignore-agent-artifacts` dodaje/usuwa sub-blok idempotentnie.
- [x] Vendor mode ignoruje flagę z ostrzeżeniem.
- [x] `bash scripts/setup-cursor-local.test.sh` green.
- [x] Docs (README, Part C, installation) opisują flagę i trade-offs.
- [x] CHANGELOG zaktualizowany.

---

## Ryzyka i mitigacje

| Ryzyko | Mitigacja |
| ------ | --------- |
| Dev włącza flagę nieświadomie | `log_warn` + summary note; docs „when not to use” |
| Toggle flagi zostawia śmieci w `.gitignore` | Sub-marker + `_remove_artifacts_subblock` |
| `docs/specs/*/` nie ignoruje plików w root specs | Zamierzone — README commitowany; udokumentować |
| Phase 1b Node launcher bez flagi | Nota w planie / issue follow-up |

---

## Test plan (manual QA po implementacji)

1. `mktemp -d && git init` → setup **bez** flagi → `git status` pokazuje `docs/specs/README.md` jako untracked.
2. Utworzyć `docs/specs/foo/foo.plan.md` → nadal untracked (bez flagi).
3. Re-run z `--gitignore-agent-artifacts` → `git check-ignore -v docs/specs/foo/foo.plan.md` zwraca match.
4. Re-run bez flagi → plik **nie** ignorowany.
5. `--vendor copy --gitignore-agent-artifacts` → brak local block; warn na stderr.

---

## Szacunek effort

| Phase | Effort |
| ----- | ------ |
| Phase 0 | ~30 min |
| Phase 1 (1.1–1.3) | ~2–3 h |
| Phase 1.4 (optional) | ~1 h |
| Phase 2 | ~1 h |
| **Razem** | **~4–5 h** |

---

## Changelog (plan)

| Data | Opis |
| ---- | ---- |
| 2026-05-27 | Plan utworzony po akceptacji researchu gitignore specs/context |
| 2026-05-27 | Zaimplementowano: flaga, testy, docs |
