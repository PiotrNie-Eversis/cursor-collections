# Research: aktualizacja plików `.cursor` w projekcie konsumenckim (wyrównanie z paczką cursor-collections)

**Data:** 2026-05-27  
**Faza:** Research (`@eversis-implement`) — **bez implementacji**  
**Język zadania:** polski; artefakt po polsku, odwołania do ścieżek repo po angielsku (konwencja frameworku).

---

## Cel

Odpowiedzieć na pytanie: **jak utrzymywać i aktualizować** katalog `.cursor/` (oraz powiązane `mcp.json`, MCP build) w **projekcie aplikacyjnym**, żeby pozostał zgodny z upstream **`cursor-collections`**, bez utraty lokalnych dostosowań (np. `eversis-project-stack.mdc`, własne reguły, merge MCP).

Research obejmuje **ten monorepo** (źródło frameworku) oraz **repozytoria konsumenckie** (np. earth-explorers z submodule `third-party/cursor-collections` i skryptem `sync:collections` opisanym w szablonie `eversis-project-stack.mdc`).

---

## Podsumowanie werdyktu

| Aspekt | Werdykt |
| ------ | ------- |
| Jedna oficjalna ścieżka aktualizacji | **Tak** — `scripts/setup-cursor-local.sh` z flagą **`--sync`** (oraz pull upstream frameworku) |
| Automatyczne nadpisanie wszystkiego | **Nie** — `eversis-project-stack.mdc` i istniejące katalogi w trybie copy/symlink są chronione domyślnie |
| Tryb zespołowy (wersja w git) | **Tak** — `--vendor submodule` + `git submodule update` + ponowny setup/`--sync` |
| Walidacja po aktualizacji promptów | **Opcjonalnie** — `node scripts/validate-cursor-markdown-links.mjs --context=source` w checkout frameworku |
| Osobny skrypt `sync-cursor-collections.mjs` w consumer | **Wzorzec poza tym repo** — dokumentowany w stack rule dla earth-explorers; **nie ma go w cursor-collections** |

**Rekomendacja:** najpierw ustalić **tryb instalacji** projektu (local symlink / local copy / vendor submodule / vendor copy), potem stosować **jedną procedurę aktualizacji** z tabeli poniżej. Po każdej aktualizacji frameworku: **pull + `--sync` + rebuild MCP + restart Cursor**.

---

## Co wchodzi w skład „paczki” cursor-collections (dla `.cursor`)

Zarządzane przez setup (katalogi kopiowane/linkowane z `.cursor/` upstream):

| Ścieżka w projekcie | Zawartość | Nadpisywanie przy `--sync` |
| ------------------- | --------- | --------------------------- |
| `.cursor/rules/` | `eversis-*.mdc` (core, testing, role rules) | Copy: **tak** (`rsync --delete`); Symlink: **automatycznie** po `git pull` w `CURSOR_COLLECTIONS_HOME` |
| `.cursor/prompts/` | `public/` + `internal/` `eversis-*.md` | j.w. |
| `.cursor/commands/` | cienkie `/eversis-*` | j.w. |
| `.cursor/skills/` | `eversis-*/SKILL.md` | j.w. |
| `.cursor/rules/eversis-project-stack.mdc` | **Stack projektu** | **Nigdy** przy re-run (tylko seed jeśli brak pliku) |
| `.cursor/mcp.json` | merge wpisu `eversis-collections` | **Merge** (nie pełne nadpisanie pliku) — `mcp-merge.sh` |

**Poza `.cursor`, ale wymagane do skills MCP:**

- `mcp/eversis-collections-mcp/` — build: `npm install && npm run build` (flaga `--build-mcp` w setup).
- Zmienna **`CURSOR_COLLECTIONS_HOME`** — canonical path do checkoutu (MCP + setup).

**Nie synchronizowane przez setup** (lokalne w consumer, poza scope frameworku):

- `docs/specs/`, `docs/context/` — artefakty Implement; opcjonalnie gitignore (`--gitignore-agent-artifacts`).
- Własne reguły / prompty spoza prefiksu `eversis-*` — ręcznie lub osobny proces zespołu.
- `AGENTS.md` — stub tylko przy pierwszym setup (nie nadpisywany).

---

## Tryby instalacji a strategia aktualizacji

### 1. Local + **symlink** (domyślnie na macOS/Linux)

```text
$CURSOR_COLLECTIONS_HOME/.cursor/{rules,prompts,commands,skills}
        ↑ symlink
my-app/.cursor/{rules,prompts,commands,skills}
my-app/.cursor/rules/eversis-project-stack.mdc  → zwykły plik (materialised)
```

**Aktualizacja:**

1. `cd "$CURSOR_COLLECTIONS_HOME" && git pull`
2. Opcjonalnie: `cd mcp/eversis-collections-mcp && npm install && npm run build` (gdy zmienił się MCP).
3. **Restart Cursor** (MCP ładuje się przy starcie).
4. `--sync` **zwykle niepotrzebne** dla symlinków — nowa zawartość widoczna od razu po pullu w HOME.
5. Wyjątek: jeśli kiedyś `rules/` było katalogiem „gołym” zamiast symlinku, uruchomić setup z `--sync` aby przejść na link.

**`.cursor/mcp.json`:** w trybie local często **gitignored** — po zmianie ścieżek w upstream uruchomić ponownie setup (merge MCP), nie edytować ręcznie fragmentu `eversis-collections`.

---

### 2. Local + **copy** (Windows / polityka bez symlinków)

**Aktualizacja:**

1. `git pull` w `$CURSOR_COLLECTIONS_HOME`
2. Z katalogu frameworku lub z ustawionym `CURSOR_COLLECTIONS_HOME`:

```bash
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" \
  --target /path/to/my-app \
  --link-mode copy \
  --sync \
  --build-mcp \
  --non-interactive
```

**Semantyka `--sync`:** dla trybu copy wykonuje `rsync -a --delete` na `rules/`, `prompts/`, `commands/`, `skills/` — **usuwa pliki usunięte upstream**. Nadal **nie nadpisuje** istniejącego `eversis-project-stack.mdc`.

Bez `--sync`: istniejące katalogi są **pomijane** (stara wersja zostaje).

---

### 3. Vendor **submodule** (`vendor/cursor-collections/`)

**Aktualizacja wersji frameworku w repo:**

```bash
cd /path/to/my-app
git submodule update --remote vendor/cursor-collections   # lub pin commit + PR
bash vendor/cursor-collections/scripts/setup-cursor-local.sh \
  --vendor submodule \
  --target . \
  --sync \
  --build-mcp \
  --non-interactive
```

- Ścieżki MCP w `.cursor/mcp.json` są **względne** do `vendor/...` — **commitowane** w projekcie.
- Zespół widzi ten sam commit submodule w MR.
- Po `submodule update` konieczny **commit** w consumer na nowy SHA submodule.

**Uwaga:** `link-framework.sh` po vendor ustawia `COLLECTIONS_HOME` na `vendor/cursor-collections` — `.cursor/*` w root projektu nadal pochodzi z link/copy względem tego HOME.

---

### 4. Vendor **copy** (pełna kopia fragmentów frameworku do `vendor/`)

Setup kopiuje m.in. `.cursor/rules`, `prompts`, `commands`, `skills`, `mcp/eversis-collections-mcp` do `vendor/cursor-collections/`.

**Aktualizacja:** ponowny run z `--vendor copy` + `--sync` (lub ręczny pull upstream + re-run skryptu). Zespół commituje zaktualizowany `vendor/`.

---

### 5. Wzorzec consumer: submodule `third-party/cursor-collections` + `npm run sync:collections`

W **szablonie** [`eversis-project-stack.mdc`](../../../.cursor/rules/eversis-project-stack.mdc) (profil earth-explorers) opisano:

- Submodule: `third-party/cursor-collections`
- `cd scripts && npm run sync:collections` (skrypt `sync-cursor-collections.mjs`, flagi `--check-only`, build MCP)

**Stan w tym repozytorium (cursor-collections):** pliku `sync-cursor-collections.mjs` **tu nie ma** — to **narzędzie projektu konsumenckiego**, nie część upstream. Research zakłada, że robi ono to samo co setup: sync `.cursor/*` + opcjonalnie MCP, z ścieżką submodule ustawioną w skrypcie consumer.

**Dla zespołów z tym wzorcem:** aktualizacja = `git submodule update` w `third-party/cursor-collections` + `npm run sync:collections` (ew. `--check-only` w CI).

---

## Checklist aktualizacji (uniwersalny)

### Przed pull

- [ ] Ustal tryb: local symlink | local copy | vendor submodule | vendor copy | consumer `sync:collections`
- [ ] Zrób backup / branch jeśli masz **lokalne zmiany** w plikach frameworku pod `.cursor/` (np. forkowane `eversis-*.mdc`) — `--sync` je **nadpisze** w trybie copy
- [ ] Sprawdź **CHANGELOG** upstream (`CHANGELOG.md`) pod kątem breaking changes (env MCP, nowe commands, usunięte prompty)

### Pull frameworku

- [ ] Local: `git pull` w `$CURSOR_COLLECTIONS_HOME`
- [ ] Vendor: `git submodule update` (+ commit SHA w consumer)
- [ ] Consumer scripts: zgodnie z README projektu

### Zastosuj pliki `.cursor`

- [ ] Symlink local: zwykle wystarczy pull; w razie rozjazdu struktury — `setup-cursor-local.sh --sync`
- [ ] Copy / vendor copy: **`--sync`** (wymagane)
- [ ] Zweryfikuj, że **`eversis-project-stack.mdc`** nadal opisuje właściwy stack (nie został nadpisany)

### MCP

- [ ] `cd mcp/eversis-collections-mcp && npm install && npm run build` (lub `--build-mcp`)
- [ ] Jeśli zmienił się szablon MCP: re-run setup (merge `eversis-collections` w `.cursor/mcp.json`)
- [ ] Migracja env: preferuj **`CURSOR_COLLECTIONS_HOME`** zamiast deprecated `EVERSIS_COLLECTIONS_ROOT`

### Po aktualizacji

- [ ] Restart Cursor; włącz MCP `eversis-collections` jeśli wyłączone
- [ ] Opcjonalnie: `node scripts/validate-cursor-markdown-links.mjs --context=source` w checkout frameworku
- [ ] Przeczytaj diff `eversis-agent-core.mdc` / `eversis-implement` — zmiany workflow (np. Fine → QA draft) mogą wymagać zmiany procesu zespołu bez zmiany kodu aplikacji

---

## Co aktualizować ręcznie (poza skryptem)

| Element | Dlaczego ręcznie |
| ------- | ---------------- |
| `eversis-project-stack.mdc` | Jedyny plik rules celowo **per-repo** (komendy lint/build, ścieżki monorepo) |
| Własne `.cursor/rules/*.mdc` spoza `eversis-*` | Nie są częścią paczki |
| User-level MCP (Cursor Settings) | OAuth, klucze API — setup tylko merge workspace `mcp.json` |
| `.cursorignore` | Sekrety, `website/docs/prompts/` jeśli kiedyś syncujesz Docusaurus w consumer |
| Custom prompty / skille zespołu | Nie nadpisywane, chyba że leżą w zarządzanych katalogach i używasz `--sync` |

---

## Ryzyka i pułapki

| Ryzyko | Mitigacja |
| ------ | --------- |
| `--sync` + copy usuwa lokalne edycje w `eversis-*.md` promptów | Trzymaj customizacje w osobnym repo rule/prompt lub fork branch frameworku |
| Symlink + edycja pliku przez IDE w consumer | Edycja może trafiać do **HOME frameworku** — preferuj materialised `eversis-project-stack.mdc` only; reszta read-only przez symlink |
| Stary MCP `dist/` | Zawsze `--build-mcp` po bumpie submodule / pull |
| `mcp.json` w git (vendor) vs gitignore (local) | Zespół musi wiedzieć, czy commitujecie MCP config |
| Brak `sync-cursor-collections.mjs` w nowym consumer | Użyj `setup-cursor-local.sh` zamiast kopiować skrypt z earth-explorers bez adaptacji ścieżki submodule |

---

## Źródła w repozytorium (SSOT)

| Temat | Ścieżka |
| ----- | ------- |
| Bootstrap + quick setup | [`documentation/cursor-collection.md`](../../../documentation/cursor-collection.md) Part C |
| Instalacja / tryby | [`website/docs/getting-started/installation.md`](../../../website/docs/getting-started/installation.md) |
| Skrypt setup (`--sync`, flagi) | [`scripts/setup-cursor-local.sh`](../../../scripts/setup-cursor-local.sh) |
| Logika link/copy | [`scripts/lib/setup-cursor-local/link-framework.sh`](../../../scripts/lib/setup-cursor-local/link-framework.sh) |
| Ochrona stack rule | `_handle_stack_rule` w `link-framework.sh` |
| Vendor | [`scripts/lib/setup-cursor-local/vendor.sh`](../../../scripts/lib/setup-cursor-local/vendor.sh) |
| Research setup (historyczny) | [`docs/specs/cursor-local-setup/cursor-local-setup.research.md`](../cursor-local-setup/cursor-local-setup.research.md) |
| MCP env | [`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md) |
| Ostatnie zmiany frameworku | [`CHANGELOG.md`](../../../CHANGELOG.md) |

---

## Otwarte pytania (do planu / decyzji zespołu)

1. **Czy consumer ma dostać oficjalny `sync-cursor-collections.mjs` w cursor-collections** (obok `setup-cursor-local.sh`), czy wystarczy dokumentacja „używaj setup z `--target`”?
2. **Czy CI consumer ma `--check-only`** (porównanie wersji submodule vs `.cursor/` copy)?
3. **Polityka forków:** czy zespół może commitować zmiany w `vendor/cursor-collections`, czy tylko pin SHA upstream?

---

## Następny krok (bramka Implement)

Po **akceptacji** tego researchu:

- Opcjonalny **plan** (`cursor-collections-sync.plan.md`) — np. ujednolicenie docs PL, skrypt `sync-cursor-collections.mjs` w `scripts/` dla consumerów, CI check-only.
- **Brak kodu** w tej fazie — użytkownik pytał wyłącznie o Research.

**Prośba o akceptację:** Czy ten research pokrywa Twój kontekst (który projekt / tryb instalacji)? Po „OK” mogę przygotować plan lub krótką runbook PL w `docs/context/` — według preferencji.
