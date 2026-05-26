# Research: jednokomendowa instalacja frameworka w projekcie konsumenckim

**Data:** 2026-05-21 (aktualizacja: decyzje produktowe + cross-platform)  
**Kontekst:** Weryfikacja pomysłu `bash scripts/setup-cursor-local.sh --build-mcp` — instalacja **cursor-collections** w istniejących repozytoriach / paczkach z domyślnym trybem **lokalnym** (framework poza gitem projektu) i opcjonalnym **vendoringiem** w repo.

## Cel

Ocenić, czy możliwa jest implementacja **jednej komendy**, która:

1. Podłącza framework do istniejącego projektu (monorepo, paczka npm, aplikacja).
2. Domyślnie trzyma **cursor-collections poza repozytorium projektu** (tylko lokalnie u dewelopera).
3. Pozwala deweloperowi **świadomie** zvendorować framework do repo (submodule / kopia).
4. Umożliwia **nakierowanie ścieżek** przez zmienną środowiskową.

Research **nie** obejmuje implementacji skryptu — tylko wykonalność, luki w obecnym stanie i rekomendacje.

---

## Podsumowanie werdyktu

| Aspekt | Werdykt |
| ------ | ------- |
| Jedna komenda setup | **Tak — wykonalne** (bash MVP; docelowo entry point cross-platform) |
| macOS (domyślny tryb local) | **Tak — pełne wsparcie** (bash + symlinki) |
| Windows (domyślny tryb local) | **Tak — z warunkami** (Git Bash/WSL + symlinki **lub** `--link-mode copy`) |
| Cross-platform MCP + Cursor | **Tak** (Node, `mcp.json`, `CURSOR_COLLECTIONS_HOME`) |
| Domyślny tryb lokalny (bez commitu frameworku) | **Tak — symlinki/copy + lokalny `mcp.json`** |
| Zmienna środowiskowa na ścieżki | **Decyzja:** jedna publiczna **`CURSOR_COLLECTIONS_HOME`** (setup script + `mcp.json` `env`); MCP dziś ma legacy **`EVERSIS_COLLECTIONS_ROOT`** — do migracji w implementacji |
| `--build-mcp` | **Tak — naturalne rozszerzenie** (`npm install && npm run build` w `mcp/eversis-collections-mcp/`) |
| Zero manualnych kroków w Cursor | **Nie w 100%** — nadal: włączenie MCP w UI, OAuth (Atlassian/Figma), ewentualnie merge user MCP |

**Wniosek:** Pomysł jest **sensowny i implementowalny** na **macOS i Windows**, ale MVP opisany jako bash + symlinki jest **Unix-first**. Pełna równość Windows wymaga **`--link-mode auto|copy`** i domyślnej ścieżki per OS — wpisane do planu implementacji, nie blokują researchu.

---

## Stan obecny (as-is)

### Instalacja w projekcie konsumenckim (dokumentacja)

Źródła: [documentation/cursor-collection.md](../../../documentation/cursor-collection.md) Part C, [README.md](../../../README.md) § „Using this framework in another repository”, [website/docs/getting-started/installation.md](../../../website/docs/getting-started/installation.md).

Dziś deweloper ręcznie:

1. Kopiuje / linkuje `.cursor/rules/`, `.cursor/prompts/`, opcjonalnie `.cursor/commands/`.
2. Dostosowuje `eversis-project-stack.mdc`.
3. Dodaje `AGENTS.md`, `docs/specs/`, `docs/context/`.
4. Kopiuje `.cursor/mcp.json`.
5. Buduje MCP: `cd mcp/eversis-collections-mcp && npm install && npm run build`.
6. Włącza serwery MCP w Cursor.

**Brak:** skryptu `setup-cursor-local.sh`, flag `--vendor` / `--build-mcp`, konwencji gitignore dla trybu lokalnego.

### MCP `eversis-collections`

| Element | Stan |
| ------- | ---- |
| Publikacja npm | **Nie dziś** — build z klonu; **tak w horyzoncie** (patrz § Decyzje — npm MCP) |
| Ścieżka w `.cursor/mcp.json` | Względna: `mcp/eversis-collections-mcp/dist/index.js` (działa **tylko** gdy `mcp/` jest w root workspace) |
| Rozwiązywanie roota skills | `findRepoRoot()` — walk-up do `.cursor/skills`; fallback dziś **`EVERSIS_COLLECTIONS_ROOT`** → docelowo **`CURSOR_COLLECTIONS_HOME`** ([resolveRoot.ts](../../../mcp/eversis-collections-mcp/src/resolveRoot.ts)) |
| `env` w `mcp.json` | **Obsługiwane** (np. AWS MCP w tym repo); docelowo przekazywać **`CURSOR_COLLECTIONS_HOME`** do procesu MCP |
| Substytucja `${VAR}` w `args` | **Nie** (ograniczenie Cursor) — ścieżka do `dist/index.js` musi być **absolutna** lub względna w workspace; skrypt powinien **generować** wpis |

### Rozmiary (orientacyjnie)

| Ścieżka | Rozmiar |
| ------- | ------- |
| `.cursor/skills/` | ~600 KB (33 pakiety `eversis-*`) |
| `.cursor/prompts/` | ~220 KB |
| `.cursor/rules/` | ~32 KB |
| `mcp/eversis-collections-mcp/` (z `node_modules`) | ~69 MB |

Build MCP **raz na checkout** frameworku, nie per projekt — argument za trybem lokalnym.

---

## Wymagania użytkownika vs możliwości techniczne

### 1. Domyślnie lokalnie (framework nie w repo projektu)

**Cursor wymaga**, aby w workspace były widoczne:

- `.cursor/rules/` — reguły (always-on / globs),
- `.cursor/prompts/` — attach `@eversis-*`,
- `.cursor/commands/` — komendy `/eversis-*`,
- opcjonalnie `.cursor/skills/` — bezpośrednie `@` do `SKILL.md` (MCP i tak czyta skills z roota wskazanego przez MCP).

Framework **poza** repozytorium projektu **nie jest indeksowany**, dopóki nie ma:

- **symlinków** w `.cursor/` projektu (zalecane dla trybu local), lub
- **multi-root workspace** w Cursor (projekt + cursor-collections) — mniej wygodne dla zespołu.

**Rekomendowany model local (default, `--link-mode auto`):**

Symlinki na macOS/Linux; na Windows — junction/symlink lub fallback copy (patrz § Cross-platform).

```text
$CURSOR_COLLECTIONS_HOME/           # jeden wspólny klon (domyślna ścieżka — patrz § Decyzje)
my-app/
  .cursor/
    rules/          → link/copy framework rules; eversis-project-stack.mdc = plik lokalny (commit)
    prompts/        → link/copy (gitignore w trybie local)
    commands/       → link/copy (gitignore w trybie local)
    skills/         → link/copy (gitignore w trybie local)
    mcp.json        → wygenerowany (gitignore w trybie local)
  .gitignore        → wpisy zależne od trybu instalacji (patrz § Decyzje — gitignore)
  AGENTS.md         → szablon w repo (commit)
  docs/specs/       → w repo (commit)
```

#### `.gitignore` — zależność od trybu instalacji (decyzja)

| Tryb | Co trafia do `.gitignore` | Co zostaje w repo (commit) |
| ---- | ------------------------- | --------------------------- |
| **Local** (default) | `.cursor/mcp.json`, `.cursor/prompts/`, `.cursor/commands/`, `.cursor/skills/`, symlinkowane/kopiowane pliki rules framework (`eversis-*.mdc` **oprócz** stack) | `eversis-project-stack.mdc`, `AGENTS.md`, `docs/specs/`, ewent. własne rule overrides |
| **`--link-mode copy`** (local) | Jak local — kopia prompts/commands/skills **nie** idzie do gita | **`eversis-project-stack.mdc`** zawsze commitowany |
| **`--vendor`** (in-repo) | **Brak** wpisów frameworkowych — całość vendored jest częścią repo | `.cursor/mcp.json` (względne ścieżki), vendored `.cursor/*`, `mcp/` lub submodule |

Skrypt **dopisuje** wpisy do `.gitignore` tylko w trybie local/copy; przy `--vendor` **usuwa** (lub nie tworzy) te wpisy, jeśli wcześniej istniały z local setup.

W repo można trzymać **`.cursor/mcp.json.example`** (bez absolutnych ścieżek) jako dokumentację — opcjonalnie, nie zamiennik commitowanego `mcp.json` w trybie vendor.

### 2. Opcja vendoring (świadomy wybór dewelopera)

**Domyślnie wyłączone** — bez `--vendor` instalacja jest **local** (framework poza gitem projektu).

Flaga **`--vendor`** umieszcza framework **w repozytorium** projektu. Skrypt nie wybiera jednej strategii — przyjmuje **`--vendor submodule`** lub **`--vendor copy`**. Samo `--vendor` bez argumentu → **interaktywne pytanie** (jak przy monorepo).

#### Submodule (`--vendor submodule`)

Framework jako **git submodule**, np. `vendor/cursor-collections/` lub `.cursor/vendor/cursor-collections/` (ścieżka do ustalenia w planie).

| | |
| --- | --- |
| **Jak działa** | `git submodule add <url> <path>`; w repo zapisany pin commita; `.gitmodules` wersjonowany |
| **Plusy** | Reprodukowalność — cały zespół na tym samym commicie frameworku; mniejszy „noise” w diffie projektu niż pełna kopia; jawny `git submodule update` przy upgrade |
| **Minusy** | Wymaga znajomości submodułów (`submodule update --init`, CI musi `--recurse-submodules`); nowi devs czasem pomijają init; na Windows historycznie więcej tarcia (dziś mniejsze z Git for Windows) |
| **Kiedy wybrać** | Zespół git-native, CI z submodułami, potrzeba **pinowanej wersji** frameworku w PR-ach (bump submodule = świadoma aktualizacja) |
| **MCP / mcp.json** | Względna ścieżka w workspace, np. `vendor/cursor-collections/mcp/eversis-collections-mcp/dist/index.js`; build MCP w submodule (skrypt lub `postinstall`) |

#### Copy (`--vendor copy`)

Rekurencyjna **kopia** katalogów frameworku do projektu (bez `.git` wewnątrz kopii).

| | |
| --- | --- |
| **Jak działa** | Skrypt kopiuje `.cursor/{rules,prompts,commands,skills}`, `mcp/eversis-collections-mcp/` (lub minimalny subset) do ustalonej ścieżki w repo |
| **Plusy** | Zero submodułów; działa w każdym VCS / mirrorze; prostsze onboarding („clone i masz”); **najlepsze na Windows** gdy zespół nie chce WSL ani submodule |
| **Minusy** | Duży diff przy aktualizacji frameworku; ryzyko **silent drift** (lokalne edycje w skopiowanych plikach); trudniej śledzić „która wersja upstream”; merge upstream = re-run `--vendor copy --sync` lub ręcznie |
| **Kiedy wybrać** | Małe zespoły, fork/stabilizacja wersji frameworku, polityka „no submodules”, offline/air-gapped kopie |
| **MCP / mcp.json** | Względne ścieżki w root projektu — **commitowane**; bez absolutnych ścieżek per developer |

#### Porównanie skrócone

| Kryterium | `--vendor submodule` | `--vendor copy` |
| --------- | -------------------- | --------------- |
| Wersjonowanie w git | pin commita | cały drzewo w diffie |
| Update frameworku | `git submodule update` + bump | re-run copy / `--sync` |
| CI | `--recurse-submodules` | brak extra kroków |
| Windows | OK z Git for Windows | **najprostsze** |
| Ryzyko drift | niskie | średnie/wysokie |
| Rozmiar repo | mniejszy (referencja) | większy (+ ~70 MB z `node_modules` MCP jeśli vendored build) |

#### Rekomendacja produktowa

- **Domyślny tryb:** local (bez `--vendor`).
- Gdy użytkownik wybierze vendor: **pytać** submodule vs copy (chyba że poda flagę explicite).
- W docs: **submodule** jako zalecane dla zespołów produktowych; **copy** jako escape hatch (Windows, brak submodułów).
- Przy `--vendor copy`: opcjonalnie **nie** vendorować `node_modules` MCP — tylko źródła + `npm run build` w CI lokalnym / dokumentowany krok.

Przy vendoringu `.cursor/mcp.json` z względną ścieżką do `dist/index.js` **działa** — skrypt parametruje prefix (`vendor/cursor-collections/` vs root).

### 3. Zmienna środowiskowa na ścieżki

#### Decyzja (2026-05-21): przedrostek `CURSOR_COLLECTIONS_*`

Publiczna konwencja dla **całego** flow (setup script, `mcp.json`, dokumentacja) — **nie** `EVERSIS_*`. Prefiks `CURSOR_COLLECTIONS` jest neutralny względem marki Eversis i opisuje produkt (`cursor-collections`), nie implementację MCP.

| Zmienna | Rola | Status |
| ------- | ---- | ------ |
| **`CURSOR_COLLECTIONS_HOME`** | **Jedyna kanoniczna** — absolutna ścieżka do checkoutu frameworku (katalog z `.cursor/skills/`, `mcp/`, `scripts/`) | Do wdrożenia (setup + MCP + docs) |
| **`EVERSIS_COLLECTIONS_ROOT`** | Legacy — to samo semantycznie co `HOME` powyżej | **Istnieje** w MCP; **deprecate** z fallbackiem w `resolveRoot.ts` |
| Substytucja `${VAR}` w `args` w `mcp.json` | — | **Nie** (ograniczenie Cursor); skrypt materializuje absolutną ścieżkę do `dist/index.js` |

**Priorytet rozwiązywania ścieżki (setup script i MCP):**

1. Flaga CLI (np. `--collections-home DIR`) — opcjonalnie w skrypcie.
2. **`CURSOR_COLLECTIONS_HOME`**
3. Legacy **`EVERSIS_COLLECTIONS_ROOT`** (MCP tylko, okres przejściowy)
4. Domyślny katalog — **zależny od OS** (patrz § Cross-platform):

| OS | Domyślny `CURSOR_COLLECTIONS_HOME` |
| ---- | ------------------------------------ |
| macOS / Linux | `$HOME/.local/share/cursor-collections` |
| Windows | `%LOCALAPPDATA%\cursor-collections` (w bash: `"${LOCALAPPDATA}/cursor-collections"`) |

**Przyszłe rozszerzenia** (ten sam prefiks, nie w scope MVP): np. `CURSOR_COLLECTIONS_REF` (pin tag/branch przy clone) — **nie** mieszać z `HOME`.

Przykład wygenerowanego fragmentu (tryb local):

```json
"eversis-collections": {
  "command": "node",
  "args": ["/Users/dev/src/cursor-collections/mcp/eversis-collections-mcp/dist/index.js"],
  "type": "stdio",
  "env": {
    "CURSOR_COLLECTIONS_HOME": "/Users/dev/src/cursor-collections"
  }
}
```

Gdy consumer **nie** ma `.cursor/skills` w swoim drzewie, MCP i tak znajdzie skills przez walk-up od `dist/` **lub** przez `env.CURSOR_COLLECTIONS_HOME` — oba działają.

**Uwaga:** Jeśli consumer ma **symlink** `.cursor/skills` → framework, walk-up z MCP (uruchomionego z zewnętrznego checkoutu) nadal wskazuje na **framework root** — poprawne. Gdyby kiedyś skopiowano tylko `mcp/` do projektu bez skills, **konieczne** `CURSOR_COLLECTIONS_HOME`.

**Migracja w implementacji:** `resolveRoot.ts` czyta `CURSOR_COLLECTIONS_HOME` pierwsze, potem `EVERSIS_COLLECTIONS_ROOT`; README MCP + CHANGELOG — jedna wzmianka o deprecacji.

---

## Cross-platform (macOS / Windows)

### Werdykt

Implementacja **działa na obu systemach**, ale **nie identycznie** w domyślnym trybie local:

| Warstwa | macOS | Windows |
| ------- | ----- | ------- |
| Cursor + `.cursor/mcp.json` | tak | tak |
| Build MCP (`node`, `npm`) | tak | tak |
| `CURSOR_COLLECTIONS_HOME` w `env` MCP | tak | tak |
| Absolutna ścieżka do `dist/index.js` w `args` | tak | tak (Node akceptuje `/` i `\`) |
| Tryb **`--vendor`** (submodule / copy w repo) | tak | tak — **najprostszy** wariant na Windows |
| Domyślny local: **bash + symlinki** | tak, out of the box | wymaga Git Bash/WSL + uprawnień do symlinków **lub** `--link-mode copy` |

### Co działa bez dodatkowej pracy (oba OS)

- **MCP `eversis-collections`** i integracja z Cursor — cross-platform (Node.js).
- **Generowany `mcp.json`** z absolutną ścieżką i blokiem `env` — cross-platform.
- **Klon / update** frameworku przez `git` — cross-platform.
- **Tryb vendor** — copy/submodule unika problemu symlinków na Windows.

### Różnice per OS (tryb local)

#### Bash jako entry point

```bash
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --target . --build-mcp
```

| OS | Uruchomienie |
| ---- | ------------ |
| **macOS** | Terminal / iTerm — natywnie |
| **Windows** | **Git Bash**, **MSYS2** lub **WSL** — natywny PowerShell nie uruchomi `.sh` bez wrappera |

**Decyzja (plan):** MVP = **bash** + dokumentacja Windows; **Faza 1b** = opcjonalny launcher Node (patrz § Decyzje — entry point Windows).

#### Symlinki vs copy

Domyślny model local zakłada symlinki `.cursor/{prompts,commands,skills,rules/*}` → `$CURSOR_COLLECTIONS_HOME`.

| OS | Symlinki katalogów | Bez uprawnień |
| ---- | ------------------ | ------------- |
| **macOS** | `ln -s` — bez dodatkowej konfiguracji | — |
| **Windows** | wymaga **Developer Mode** lub **Administrator** (`mklink /D`) | Git z `core.symlinks=false` może **skopiować** pliki zamiast linkować → utrata wspólnego źródła, drift przy `git pull` w frameworku |

**Decyzja (2026-05-21):** flaga **`--link-mode auto|symlink|copy`**:

| Wartość | Zachowanie |
| ------- | ---------- |
| **`auto`** (default) | macOS/Linux → symlink; Windows → próba symlink/junction, przy błędzie **fallback copy** + komunikat |
| **`symlink`** | wymuszony symlink (fail z podpowiedzią na Windows) |
| **`copy`** | rekurencyjna kopia `.cursor/*` z frameworku — aktualizacja przez re-run skryptu lub `--sync` |

Tryb **`copy`** na Windows jest akceptowalny dla MVP; aktualizacja frameworku = ponowne uruchomienie setup (idempotentne, bez nadpisywania `eversis-project-stack.mdc`).

#### Domyślna lokalizacja `CURSOR_COLLECTIONS_HOME`

Skrypt wykrywa OS i ustawia default, jeśli env nie jest ustawione:

```text
macOS / Linux:  $HOME/.local/share/cursor-collections
Windows:        %LOCALAPPDATA%\cursor-collections
```

Na Windows w Git Bash: `"${LOCALAPPDATA}/cursor-collections"`. W PowerShell (przy `.ps1`): `$env:LOCALAPPDATA\cursor-collections`.

### Macierz scenariuszy (akceptacja produktowa)

| Scenariusz | macOS | Windows |
| ---------- | ----- | ------- |
| Local + `--link-mode auto` (symlink) | zalecany | OK w Git Bash/WSL + Developer Mode |
| Local + `--link-mode copy` | OK | **zalecany fallback** |
| `--vendor` (framework w repo) | OK | **zalecany** dla zespołów bez WSL |
| Tylko MCP (`mcp.json` + env, bez linkowania `.cursor/*`) | częściowy | częściowy — brak `@eversis-*` / rules bez osobnego kroku |

### Dokumentacja dla użytkowników Windows (plan)

1. **WSL2** — zalecana ścieżka (bash + symlinki jak na macOS).
2. **Git Bash + Developer Mode** — symlinki natywne.
3. **`--link-mode copy`** lub **`--vendor`** — bez symlinków i bez WSL.

### CI / testy cross-platform (plan)

- Smoke test: temp dir, fake `CURSOR_COLLECTIONS_HOME`, dry-run setup.
- Runnery: **macOS** + **windows-latest** (Git Bash); osobny case `--link-mode copy` na Windows.

---

## Propozycja interfejsu skryptu (do planu)

```bash
# Domyślnie: tryb local, target = wykryty root repo (lub interaktywny wybór w monorepo)
bash scripts/setup-cursor-local.sh [--build-mcp] [--target DIR] [--vendor submodule|copy] [--link-mode auto|symlink|copy]

# macOS / Linux — domyślny HOME
export CURSOR_COLLECTIONS_HOME="${CURSOR_COLLECTIONS_HOME:-$HOME/.local/share/cursor-collections}"

# Windows (Git Bash) — skrypt ustawia sam, jeśli env puste:
# export CURSOR_COLLECTIONS_HOME="${CURSOR_COLLECTIONS_HOME:-${LOCALAPPDATA}/cursor-collections}"
```

| Flaga / env | Działanie |
| ----------- | --------- |
| *(default)* | Local: `--link-mode auto`; dopisuje wpisy **gitignore**; nie commituje frameworku |
| `--link-mode auto\|symlink\|copy` | Sposób podłączenia `.cursor/*` (patrz § Cross-platform) |
| `--vendor submodule\|copy` | Framework w repo; **bez** gitignore frameworkowych ścieżek; pyta jeśli sama flaga `--vendor` |
| `--build-mcp` | `npm install && npm run build` w `$CURSOR_COLLECTIONS_HOME/mcp/...` (local) lub w vendored `mcp/` |
| `--target DIR` | Jawny katalog projektu; pomija interaktywny wybór monorepo |
| `--collections-home DIR` | Nadpisanie `CURSOR_COLLECTIONS_HOME` (CLI > env > default OS) |
| `CURSOR_COLLECTIONS_HOME` | Lokalizacja klonu; brak klonu → `git clone` |
| `--minimal` (opcjonalnie) | Tylko rules + implement/review prompts, bez pełnego MCP stack |
| `--sync` (opcjonalnie) | Przy `--link-mode copy`: odśwież kopię z frameworku bez nadpisywania plików lokalnych |

**Lokalizacja skryptu:** logicznie w **cursor-collections** (`scripts/setup-cursor-local.sh`), wywoływany z projektu:

```bash
bash "$CURSOR_COLLECTIONS_HOME/scripts/setup-cursor-local.sh" --target . --build-mcp
```

Alternatywa: cienki bootstrap w projekcie (curl / copy 20 linii) — poza zakresem minimalnego MVP.

---

## Co skrypt musi zrobić (checklist implementacyjny)

1. **Rozwiązać** `$CURSOR_COLLECTIONS_HOME` (clone jeśli brak).
2. **`--build-mcp`:** build MCP w framework checkout.
3. **Utworzyć strukturę** w projekcie: `docs/specs/`, szablon `AGENTS.md` jeśli brak.
4. **Rules:** według `--link-mode` — link/copy plików framework **oprócz** `eversis-project-stack.mdc` (ten plik **kopiować z szablonu**, nie nadpisywać przy re-run).
5. **Prompts / commands / skills:** według `--link-mode` (symlink/junction/copy) w trybie local; copy/submodule w `--vendor`.
6. **`.cursor/mcp.json`:** merge `eversis-collections`; local → absolutna ścieżka + `env.CURSOR_COLLECTIONS_HOME` + **gitignore**; vendor → względne ścieżki, **commit**.
7. **`.cursorignore`:** szablon (secrets, `node_modules`, …).
8. **`.gitignore` projektu:** wpisy zależne od trybu (local/copy vs vendor) — patrz § Decyzje.
9. **Wykryć git root** — w monorepo **zapytać** użytkownika o `--target` (root vs podkatalog), chyba że `--target` podane.
10. **Wykryć OS** — default `CURSOR_COLLECTIONS_HOME`, `--link-mode auto`.
11. **Wypisać** next steps zależne od trybu i OS.

---

## Ryzyka i ograniczenia

| Ryzyko | Severity | Mitigacja |
| ------ | -------- | --------- |
| Linki w promptach do `website/docs/agents/` nie istnieją w consumer repo | **Średnie** | ~15 plików promptów; `@eversis-*` działa; linki IDE broken — [cursor-md-link-refs](../../cursor-md-link-refs/cursor-md-link-refs.research.md) |
| Windows: brak bash / PowerShell vs `.sh` | **Średnie** | Dokumentacja Git Bash/WSL; Faza 1b: launcher Node `.mjs` lub `.ps1` |
| Windows: symlinki bez uprawnień | **Średnie** | `--link-mode auto` → fallback **copy**; docs: Developer Mode / WSL; `--vendor` |
| Windows: `core.symlinks=false` w Git | **Średnie** | Wykryć kopię zamiast linku; ostrzeżenie + sugestia `--link-mode copy` explicite |
| macOS vs Windows: różne default HOME | **Niskie** | Detekcja OS w skrypcie; tabela w docs |
| Absolutne ścieżki w `mcp.json` | **Niskie (local)** | Local → gitignore; vendor → względne ścieżki commitowane; npm MCP w Fazie 3 |
| Drift wersji frameworku między devami (local) | **Średnie** | `git pull` w `$CURSOR_COLLECTIONS_HOME`; `--sync` przy copy mode |
| Re-run nadpisuje customizacje | **Wysokie** | Idempotencja: nie ruszać `eversis-project-stack.mdc`, `docs/context/`, lokalnych rule overrides |
| Monorepo (wiele paczek) | **Średnie** | Wykryj `.git` root; **interaktywne pytanie** o `--target`; domyślnie rekomenduj root repo |
| Pełny `.cursor/mcp.json` z AWS/GCP/… | **Niskie** | Skrypt merge tylko `eversis-collections` + opcjonalny template integracji |

---

## Luki produktowe (poza samym skryptem)

1. **Brak oficjalnego szablonu** `mcp.json.example` dla consumer (tylko pełny monorepo template).
2. **`CURSOR_COLLECTIONS_HOME`** — brak w kodzie/docs (legacy `EVERSIS_COLLECTIONS_ROOT` tylko w README MCP); ujednolicić w installation.md / Part C.
3. **Brak konwencji** `.gitignore` dla trybu local w dokumentacji frameworku.
4. **Validator linków** — consumer bez `website/` powinien używać `--context=source` na vendored `.cursor/`.
5. **Brak sekcji Windows** w installation.md — do uzupełnienia w Fazie 2 (WSL / Git Bash / `--link-mode copy`).

---

---

## Podjęte decyzje (2026-05-21)

Pytania z poprzedniej wersji researchu — **zamknięte**.

### 1. Domyślna ścieżka klonu — **TAK**

| OS | `CURSOR_COLLECTIONS_HOME` (gdy env puste) |
| ---- | ----------------------------------------- |
| macOS / Linux | `$HOME/.local/share/cursor-collections` |
| Windows | `%LOCALAPPDATA%\cursor-collections` |

Zgodne z XDG-like layout na Unix i standardem `%LOCALAPPDATA%` na Windows (per-user, bez uprawnień admina).

### 2. `--vendor`: submodule vs copy — **oba warianty, wybór explicite lub interaktywnie**

Szczegóły w § „Opcja vendoring”. Skrót:

- **`--vendor submodule`** — pin wersji, mniejszy drift, lepsze dla zespołów z CI i submodułami.
- **`--vendor copy`** — prostota, Windows-friendly, bez `.gitmodules`.
- **`--vendor` bez argumentu** → skrypt **pyta** (jak monorepo target).

Vendor **domyślnie off**; local pozostaje default.

### 3. `.cursor/mcp.json` a git — **zależy od trybu instalacji**

| Tryb | `mcp.json` |
| ---- | ---------- |
| **Local** (default) | Generowany z **absolutnymi** ścieżkami → **`.gitignore`** |
| **`--vendor`** | Względne ścieżki w repo → **commitowany** (jak dziś w monorepo frameworku) |

### 4. Monorepo — **wykryj repo i pytaj**

- Skrypt idzie w górę od `cwd` do roota git.
- Jeśli użytkownik uruchomił setup z podkatalogu (np. `apps/web/`), **interaktywnie** pyta: target = **root monorepo** czy **bieżący katalog**?
- Rekomendacja w promptcie: **root** (jeden `.cursor/` na workspace — zgodnie z modelem Cursor).
- `--target DIR` omija pytanie (automatyzacja CI / skrypty zespołowe).

### 5. Publikacja MCP na npm — **TAK (horyzont)**

Docelowo wpis w `mcp.json` consumer może wyglądać np.:

```json
"eversis-collections": {
  "command": "npx",
  "args": ["-y", "@eversis/cursor-collections-mcp@<semver>"],
  "env": { "CURSOR_COLLECTIONS_HOME": "..." }
}
```

| Korzyść | Opis |
| ------- | ---- |
| Brak absolutnych ścieżek | Ten sam commitowany `mcp.json` na macOS/Windows |
| Brak lokalnego build MCP | `npx` pobiera binarkę; nadal może być potrzebne `CURSOR_COLLECTIONS_HOME` dla `.cursor/skills` |
| CI | Prostsze — bez `npm run build` w submodule |

**Nie blokuje MVP skryptu** — Faza 2/3 roadmapy; do czasu publikacji setup generuje absolutną ścieżkę do lokalnego `dist/index.js`. Po npm: skrypt preferuje `npx` gdy pakiet dostępny (flaga `--use-npm-mcp` lub auto-detect).

### 6. Entry point Windows: bash vs `setup-cursor-local.mjs` — **MVP = bash; Node w Fazie 1b**

#### Opcja A: tylko bash + docs (MVP)

| Zalety | Wady |
| ------ | ---- |
| Jeden plik, spójność z początkową propozycją | Windows **wymaga** Git Bash lub WSL |
| Szybsze dowiezienie MVP | PowerShell / cmd **nie** uruchomi `.sh` natywnie |
| Mniej kodu do utrzymania na start | Logika path/symlink/copy w bash bywa krucha na Windows |
| Wystarczy przy `--link-mode auto` + copy fallback | Nowi devs na Windows bez Git for Windows — blokada |

**Wystarczy na MVP**, jeśli dokumentacja jasno wymaga Git Bash/WSL **albo** `--link-mode copy` / `--vendor copy`.

#### Opcja B: `setup-cursor-local.mjs` (Node) — Faza 1b

| Zalety | Wady |
| ------ | ---- |
| **Ten sam entry point** na macOS, Windows, Linux | Node **już wymagany** do MCP — ale to dodatkowy plik obok bash |
| `path.join`, `fs.symlink` / copy — przewidywalne na Windows | Trzeba wydzielić wspólną logikę (bash woła node **albo** duplikacja) |
| Możliwość `node setup-cursor-local.mjs` z PowerShell | Więcej pracy w pierwszej iteracji cross-platform |
| Łatwiejsze testy jednostkowe (Vitest/jest) | |

#### Rekomendacja

| Faza | Entry point |
| ---- | ----------- |
| **MVP (Faza 1)** | `setup-cursor-local.sh` + sekcja docs Windows |
| **Faza 1b** | `setup-cursor-local.mjs` jako **canonical** logika; bash = cienki wrapper `exec node ...` (opcjonalnie) |

**MVP nie musi** zawierać `.mjs`, o ile `--link-mode auto` + copy fallback i docs są kompletne. Dla zespołów Windows-only **Faza 1b** powinna być zaplanowana tuż po MVP, nie „kiedyś”.

### 7. `--link-mode copy` a gitignore — **TAK, gitignore (jak local)**

Przy copy w trybie **local** skopiowane `.cursor/prompts/`, `commands/`, `skills/` oraz wygenerowany `mcp.json` → **`.gitignore`**.

**Wyjątek (zawsze commitowany):** `eversis-project-stack.mdc` — jedyny plik rules frameworkowy, który **musi** być w repo i dostosowany per projekt.

Symlinki w trybie local — ta sama reguła gitignore (ścieżki docelowe linków, nie sam link jako „plik”).

---

## Otwarte pytania (pozostałe)

Brak — wszystkie punkty z poprzedniej listy zamknięte powyżej. Do planu ewentualnie:

- Dokładna ścieżka submodule (`vendor/cursor-collections` vs inna).
- Nazwa pakietu npm MCP (`@eversis/cursor-collections-mcp` — placeholder).

---

## Rekomendacja strategiczna

1. **Zatwierdzić kierunek** — jednokomendowy setup na macOS **i** Windows (z zastrzeżeniami cross-platform).
2. **Faza 1 (MVP):** bash, local default, `--link-mode auto`, `--vendor submodule|copy` (pytanie interaktywne), gitignore per tryb, monorepo → pytaj o target, `CURSOR_COLLECTIONS_HOME` per OS, migracja MCP env.
3. **Faza 1b:** `setup-cursor-local.mjs` (canonical logika); smoke CI macOS + Windows.
4. **Faza 2:** docs (installation + Windows), `mcp.json.example`, testy integracyjne.
5. **Faza 3 (horyzont):** publikacja **`eversis-collections-mcp` na npm** → `npx` w commitowanym `mcp.json` (vendor) i opcja w local setup.
6. **Nie blokuje:** epic `cursor-md-link-refs`.

---

## Powiązane pliki

- [documentation/cursor-collection.md](../../../documentation/cursor-collection.md) — Part B/C, layout consumer
- [mcp/eversis-collections-mcp/src/resolveRoot.ts](../../../mcp/eversis-collections-mcp/src/resolveRoot.ts) — docelowo `CURSOR_COLLECTIONS_HOME` (+ legacy fallback)
- [.cursor/mcp.json](../../../.cursor/mcp.json) — wzorcowa konfiguracja
- [docs/specs/cursor-md-link-refs/cursor-md-link-refs.research.md](../cursor-md-link-refs/cursor-md-link-refs.research.md) — linki w consumer

---

## Następny krok

**Plan:** [cursor-local-setup.plan.md](./cursor-local-setup.plan.md) — po akceptacji planu → implementacja Phase 0–2.
