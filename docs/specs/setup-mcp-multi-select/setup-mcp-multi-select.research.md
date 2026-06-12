# Research: interaktywna konfiguracja MCP przy setup (`--build-mcp`)

**Data:** 2026-06-12 (aktualizacja: flow Y/N + multi-select)  
**Kontekst:** `/eversis-implement` — rozszerzenie `setup-cursor-local.sh` o opcjonalną konfigurację `.cursor/mcp.json` po fladze `--build-mcp`.

```bash
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --build-mcp
```

**Powiązane:** [cursor-local-setup.research.md](../cursor-local-setup/cursor-local-setup.research.md), [cursor-local-setup.plan.md](../cursor-local-setup/cursor-local-setup.plan.md) Task 1.8, `scripts/lib/setup-cursor-local/mcp-merge.sh`, [integrations overview](../../../website/docs/integrations/overview.md).

---

## Pytanie badawcze

Czy przy `--build-mcp` setup powinien:

1. Zapytać: **„Do you want to configure MCPs?”** (Y/n),
2. Po **yes** — pokazać **pole wielokrotnego wyboru** (checkboxy) serwerów,
3. Na podstawie zaznaczeń — **utworzyć / zaktualizować** `.cursor/mcp.json` z wpisami ze szablonu frameworku, z **poprawną ścieżką** dla `eversis-collections`?

---

## Werdykt (skrót)

| Aspekt | Werdykt |
| ------ | ------- |
| Zasadność produktowa | **Tak** — świadomy wybór integracji + automatyczna ścieżka do `cursor-collections` |
| Powiązanie z `--build-mcp` | **Tak** — sensowne: flaga oznacza „chcę MCP”; prompt tylko gdy TTY i brak `--non-interactive` |
| Multi-select w czystym bash | **Możliwe, ale słabe UX** — lepiej Node (już wymagany) lub `gum`/`fzf` opcjonalnie |
| Transformacja ścieżek | **Tylko `eversis-collections`** — reszta kopiowana 1:1 z szablonu |
| Złożoność | **Średnia** — nowy moduł prompt + rozszerzenie merge |
| Priorytet | **Średni–wysoki** — domyka lukę setupu bez ręcznego kopiowania `mcp.json` |

**Wniosek:** Implementacja **uzasadniona**. Flow zatwierdzony przez użytkownika (poniżej). Rekomendacja techniczna: **Node** (`@inquirer/prompts` przez `npx -y` lub mały helper w repo) dla checkboxów; merge w `mcp-merge.sh`.

---

## Wymagany flow UX (spec użytkownika)

### Krok 1 — gate (tylko z `--build-mcp`)

```
Do you want to configure MCPs? [Y/n]
```

| Odpowiedź | Zachowanie |
| --------- | ---------- |
| **Y** (domyślnie Enter) | Przejdź do kroku 2 |
| **n** | **Opcja B** — merge **tylko** `eversis-collections` (minimalny zestaw mimo `--build-mcp`) |
| `--non-interactive` | **Bez pytań** — flaga `--mcp-servers=…` lub domyślny zestaw |

### Krok 2 — multi-select (checkboxy)

```
Select MCP servers to add to .cursor/mcp.json (Space toggle, Enter confirm):

[ ] context7
[ ] sequential-thinking
[ ] figma
[ ] atlassian
[ ] pdf-reader
[ ] awslabs.aws-api-mcp-server
[ ] awslabs.aws-documentation-mcp-server
[ ] gcp-gcloud
[ ] gcp-observability
[ ] gcp-storage
[ ] eversis-collections
[ ] playwright
```

**Uwagi do listy:**

- **`playwright`** — **12. pozycja** (decyzja 2026-06-12).
- **`eversis-collections`** — pre-check domyślnie; wymaga `--build-mcp` / `dist/index.js` (faza D).
- Domyślne zaznaczenia — **tylko** `eversis-collections` pre-checked (reszta pusta).

### Krok 3 — generowanie `mcp.json`

1. Wczytać szablon: `$COLLECTIONS_HOME/.cursor/mcp.json` → `mcpServers`.
2. Dla każdego **zaznaczonego** klucza skopiować wpis ze szablonu.
3. Dla `eversis-collections` — **podmienić** `args[0]` i opcjonalnie `env` (logika z dzisiejszego `mcp-merge.sh`):
   - **local:** absolutna ścieżka do `dist/index.js` + `env.CURSOR_COLLECTIONS_HOME`
   - **vendor:** ścieżka względna od `TARGET_DIR`
4. Scalić z istniejącym `.cursor/mcp.json`: zachować serwery **spoza** listy wyboru / szablonu; **nadpisać** tylko wybrane klucze.
5. Zapisać `inputs: []` z szablonu jeśli brak.
6. **Nie** kopiować top-level artefaktów (np. duplikat `"eversis-collections"` poza `mcpServers` w root frameworkowym `mcp.json`).

---

## Stan obecny (as-is)

`merge_mcp_json` zawsze merguje **tylko** `eversis-collections` — bez pytania, bez wyboru integracji.

Faza `--build-mcp` buduje pakiet MCP, ale nie angażuje użytkownika w wybór serwerów zewnętrznych.

---

## Mapowanie serwerów → szablon

Źródło prawdy: `$COLLECTIONS_HOME/.cursor/mcp.json` (sekcja `mcpServers`).

| ID (checkbox) | Typ | Wymaga transformacji ścieżki |
| ------------- | --- | ---------------------------- |
| `context7` | stdio / npx | Nie |
| `sequential-thinking` | stdio / npx | Nie |
| `figma` | HTTP | Nie |
| `atlassian` | HTTP | Nie |
| `pdf-reader` | stdio / npx | Nie |
| `awslabs.aws-api-mcp-server` | stdio / uvx | Nie |
| `awslabs.aws-documentation-mcp-server` | stdio / uvx | Nie |
| `gcp-gcloud` | stdio / npx | Nie |
| `gcp-observability` | stdio / npx | Nie |
| `gcp-storage` | stdio / npx | Nie |
| `eversis-collections` | stdio / node | **Tak** |
| `playwright` | stdio / npx | Nie |

---

## Propozycja implementacji

### Nowe / zmienione pliki

| Plik | Zmiana |
| ---- | ------ |
| `scripts/lib/setup-cursor-local/mcp-prompt.sh` | Gate Y/n + wywołanie promptu multi-select; ustawia `MCP_SELECTED_SERVERS` (CSV lub JSON) |
| `scripts/lib/setup-cursor-local/mcp-merge.sh` | Merge tylko wybranych kluczy; refactor transformacji `eversis-collections` |
| `scripts/lib/setup-cursor-local/mcp-prompt.mjs` (opcjonalnie) | Checkbox UI przez `@inquirer/prompts` (`npx -y` bez dodawania dep do repo) |
| `scripts/setup-cursor-local.sh` | Flagi: `--mcp-servers=id1,id2` (non-interactive), ewent. `--skip-mcp-config` |
| `scripts/setup-cursor-local.test.sh` | Scenariusz: `--mcp-servers=context7,eversis-collections` |
| `scripts/lib/setup-cursor-local/summary.sh` | Wypisać zaznaczone serwery + OAuth / uvx |

### Kiedy uruchamiać prompt

| Warunek | Prompt |
| ------- | ------ |
| `--build-mcp` + TTY + **brak** `--non-interactive` | Tak — gate + multi-select |
| `--build-mcp` + `--non-interactive` + `--mcp-servers=…` | Merge bez promptu |
| `--build-mcp` + `--non-interactive` + brak `--mcp-servers` | Domyślnie: tylko `eversis-collections` (brak regresji CI) |
| Brak `--build-mcp` | Bez promptu MCP; merge minimalny jak dziś (jeśli w ogóle) |

### Mechanizm checkboxów (rekomendacja)

| Opcja | Plusy | Minusy |
| ----- | ----- | ------ |
| **Node + `npx -y @inquirer/prompts`** | Prawdziwe checkboxy; Node już required | Pierwsze uruchomienie pobiera pakiet |
| **`gum choose --no-limit`** | Ładny UX | Opcjonalna zależność; fallback potrzebny |
| **Bash toggle loop** | Zero deps | Gorszy UX; ręczna implementacja |

**Rekomendacja:** `mcp-prompt.mjs` z `@inquirer/prompts` przez `npx -y`; fallback bash (numerowana lista „1,3,5”) gdy `npx` / TTY niedostępne.

---

## Zachowanie przy „No” na gate

**Decyzja (2026-06-12): Opcja B** — merge **tylko** `eversis-collections`. Gate dotyczy **dodatkowych** integracji; `--build-mcp` i tak zapewnia lokalny pakiet skills.

---

## `--non-interactive` i CI

```bash
bash setup-cursor-local.sh --build-mcp --non-interactive \
  --mcp-servers=context7,sequential-thinking,eversis-collections
```

Bez `--mcp-servers` w non-interactive: merge **tylko** `eversis-collections` (obecne zachowanie).

---

## Ryzyka

| Ryzyko | Mitigacja |
| ------ | --------- |
| Pusty wybór (zero checkboxów) | Walidacja: wymagaj ≥1 serwera lub przerwij z komunikatem |
| `eversis-collections` bez build | Faza D przed merge; `die` jeśli brak `dist/index.js` |
| Re-run nadpisuje wybrane serwery | Merge add/overwrite tylko wybrane klucze; nie usuwać innych |
| Dryf listy vs szablon | Lista checkboxów w jednym pliku konfiguracyjnym (`mcp-server-list.json`) lub generowana z szablonu |
| OAuth nadal ręczne | `summary.sh` — przypomnienie dla `atlassian`, `figma` |

---

## Kryteria akceptacji

1. `--build-mcp` w TTY: pojawia się pytanie „Do you want to configure MCPs?”.
2. Po **Y**: checkboxy dokładnie z listy spec (**12 pozycji**, w tym `playwright`).
3. Po wyborze `context7` + `eversis-collections`: `mcp.json` zawiera **tylko** te dwa (+ zachowane obce klucze).
4. `eversis-collections` ma poprawną ścieżkę (local / vendor).
5. Po **n**: tylko `eversis-collections` (Opcja B).
6. `--non-interactive --mcp-servers=figma,atlassian` — merge bez promptu.
7. Smoke test w `setup-cursor-local.test.sh`.

---

## Podjęte decyzje (2026-06-12)

| Pytanie | Decyzja |
| ------- | ------- |
| Gate „No” | **Opcja B** — tylko `eversis-collections` |
| Domyślne zaznaczenia | **Pre-check** `eversis-collections`; reszta pusta |
| `playwright` | **Tak** — 12. pozycja na liście |
| Re-run setup | **Tylko przy pierwszym setupie** — prompt gdy **brak** `.cursor/mcp.json`; re-run bez pytania (merge według flag / minimalny) |

---

## Rekomendacja

| Decyzja | Rekomendacja |
| ------- | ------------ |
| Implementować? | **Tak** |
| Flow | Dokładnie jak spec użytkownika (Y/n → checkboxy) |
| Checkbox UI | Node `@inquirer/prompts` via `npx` + bash fallback |
| Źródło wpisów | `$COLLECTIONS_HOME/.cursor/mcp.json` |
| `--non-interactive` | `--mcp-servers=csv`; default minimal |

---

## Następne kroki

1. ~~Akceptacja researchu~~ — decyzje zamknięte 2026-06-12.
2. Plan: [setup-mcp-multi-select.plan.md](./setup-mcp-multi-select.plan.md) — **bramka przed implementacją**.
3. Implementacja + testy + docs (`installation.md`, `summary.sh`).
