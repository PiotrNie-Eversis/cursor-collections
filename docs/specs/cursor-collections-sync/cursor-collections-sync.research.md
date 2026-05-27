# Research: aktualizacja plików `.cursor` w projekcie konsumenckim (wyrównanie z paczką cursor-collections)

**Data:** 2026-05-27 (aktualizacja: earth-explorers-3d — wzorzec `sync:collections` wycofany, alignacja wyłącznie przez Part C `cursor-collection.md`)  
**Faza:** Research (`@eversis-implement`)  
**Język zadania:** polski; artefakt po polsku, odwołania do ścieżek repo po angielsku (konwencja frameworku).

---

## Cel

Odpowiedzieć na pytanie: **jak utrzymywać i aktualizować** katalog `.cursor/` (oraz powiązane `mcp.json`, MCP build) w **projekcie aplikacyjnym**, żeby pozostał zgodny z upstream **`cursor-collections`**, bez utraty lokalnych dostosowań (np. `eversis-project-stack.mdc`, własne reguły, merge MCP).

Research obejmuje **ten monorepo** (źródło frameworku) oraz **repozytoria konsumenckie** (np. **earth-explorers-3d**), które utrzymują `.cursor/` zgodnie z [`documentation/cursor-collection.md`](../../../documentation/cursor-collection.md) Part C — **`setup-cursor-local.sh`**, bez osobnego lokalnego skryptu sync.

---

## Podsumowanie werdyktu

| Aspekt | Werdykt |
| ------ | ------- |
| Jedna oficjalna ścieżka aktualizacji | **Tak** — `scripts/setup-cursor-local.sh` z flagą **`--sync`** (oraz pull upstream frameworku) |
| Automatyczne nadpisanie wszystkiego | **Nie** — `eversis-project-stack.mdc` i istniejące katalogi w trybie copy/symlink są chronione domyślnie |
| Tryb zespołowy (wersja w git) | **Tak** — `--vendor submodule` + `git submodule update` + ponowny setup/`--sync` |
| Walidacja po aktualizacji promptów | **Opcjonalnie** — `node scripts/validate-cursor-markdown-links.mjs --context=source` w checkout frameworku |
| Osobny skrypt `sync-cursor-collections.mjs` w consumer | **Nieaktualny / wycofany** — earth-explorers-3d i nowe projekty używają wyłącznie **`setup-cursor-local.sh`** (Part C); skryptu **nie ma** w upstream cursor-collections |

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

### 5. Consumer referencyjny: earth-explorers-3d (model kanoniczny)

**Stan (2026-05-27):** **earth-explorers-3d** nie używa już wzorca `third-party/cursor-collections` + `npm run sync:collections` / `sync-cursor-collections.mjs`. Projekt jest w **100% zgodny** z [`documentation/cursor-collection.md`](../../../documentation/cursor-collection.md) Part C — ta sama procedura co §1–§4 powyżej:

- bootstrap i aktualizacja: **`scripts/setup-cursor-local.sh`** (`--sync`, `--build-mcp`, opcjonalnie `--vendor submodule|copy`, `--gitignore-agent-artifacts`);
- checkout frameworku: **`$CURSOR_COLLECTIONS_HOME`** (lub vendor submodule/copy w repo aplikacji);
- **materialised** [`eversis-project-stack.mdc`](../../../.cursor/rules/eversis-project-stack.mdc) w consumer opisuje stack aplikacji (visuals-portal itd.) — **nie** jest kopiowany z upstream.

**Upstream cursor-collections:** [`eversis-project-stack.mdc`](../../../.cursor/rules/eversis-project-stack.mdc) opisuje **ten** monorepo (Docusaurus, `website/`, MCP). Szablon profilu aplikacyjnego: sekcja **„Reference: Eversis stack example”** w Part C + seed przy pierwszym setup (tylko gdy plik nie istnieje).

**Nie traktować earth-explorers jako osobnego „§5 wzorca”** — to consumer na **jednej z czterech ścieżek** Part C, bez lokalnego wrapper-skryptu sync.

**Historycznie (nieaktualne):** wcześniejsze wersje earth-explorers mogły vendorować submodule pod `third-party/cursor-collections` i utrzymywać `sync-cursor-collections.mjs` w `scripts/` — wzorzec **poza** upstream, **usunięty** z projektu.

---

## Checklist aktualizacji (uniwersalny)

### Przed pull

- [ ] Ustal tryb: local symlink | local copy | vendor submodule | vendor copy (Part C — **jedyna** ścieżka; bez `sync:collections`)
- [ ] Zrób backup / branch jeśli masz **lokalne zmiany** w plikach frameworku pod `.cursor/` (np. forkowane `eversis-*.mdc`) — `--sync` je **nadpisze** w trybie copy
- [ ] Sprawdź **CHANGELOG** upstream (`CHANGELOG.md`) pod kątem breaking changes (env MCP, nowe commands, usunięte prompty)

### Pull frameworku

- [ ] Local: `git pull` w `$CURSOR_COLLECTIONS_HOME`
- [ ] Vendor: `git submodule update` (+ commit SHA w consumer)
- [ ] Vendor / local: zgodnie z Part C [`documentation/cursor-collection.md`](../../../documentation/cursor-collection.md) (setup + `--sync` gdzie wymagane)

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
| Legacy `sync-cursor-collections.mjs` w starym consumer | **Nie kopiować** — migracja na `setup-cursor-local.sh` (wzór: earth-explorers-3d, 2026-05-27) |

---

## Źródła w repozytorium (SSOT)

| Temat | Ścieżka |
| ----- | ------- |
| Bootstrap + quick setup | [`documentation/cursor-collection.md`](../../../documentation/cursor-collection.md) Part C |
| Instalacja / tryby | [`website/docs/getting-started/installation.md`](../../../website/docs/getting-started/installation.md) |
| Skrypt setup (`--sync`, flagi) | [`scripts/setup-cursor-local.sh`](../../../scripts/setup-cursor-local.sh) |
| Logika link/copy | [`scripts/lib/setup-cursor-local/link-framework.sh`](../../../scripts/lib/setup-cursor-local/link-framework.sh) |
| Ochrona stack rule | `_handle_stack_rule` w `link-framework.sh` |
| Stack rule upstream vs consumer | Upstream: [`eversis-project-stack.mdc`](../../../.cursor/rules/eversis-project-stack.mdc) (profil frameworku); consumer: materialised plik per projekt — [`documentation/cursor-collection.md`](../../../documentation/cursor-collection.md) § Reference |
| Vendor | [`scripts/lib/setup-cursor-local/vendor.sh`](../../../scripts/lib/setup-cursor-local/vendor.sh) |
| Research setup (historyczny) | [`docs/specs/cursor-local-setup/cursor-local-setup.research.md`](../cursor-local-setup/cursor-local-setup.research.md) |
| MCP env | [`mcp/eversis-collections-mcp/README.md`](../../../mcp/eversis-collections-mcp/README.md) |
| Ostatnie zmiany frameworku | [`CHANGELOG.md`](../../../CHANGELOG.md) |

---

## Otwarte pytania (do planu / decyzji zespołu)

1. ~~**Czy consumer ma dostać oficjalny `sync-cursor-collections.mjs`**~~ — **Zamknięte:** wystarczy **`setup-cursor-local.sh`** (Part C); earth-explorers-3d zmigrowany.
2. **Czy CI consumer ma check-only** (porównanie wersji vendor/submodule vs `.cursor/` copy)?
3. **Polityka forków:** czy zespół może commitować zmiany w `vendor/cursor-collections`, czy tylko pin SHA upstream?

---

## Następny krok (bramka Implement)

Po **akceptacji** tego researchu:

- Opcjonalny **plan** (`cursor-collections-sync.plan.md`) — np. runbook PL w `docs/context/`, CI check-only dla vendor mode.
- **Bez** oficjalnego `sync-cursor-collections.mjs` w upstream — SSOT pozostaje Part C.

**Status:** Research zaktualizowany — earth-explorers-3d na modelu kanonicznym; §5 nie opisuje osobnego wzorca sync.
