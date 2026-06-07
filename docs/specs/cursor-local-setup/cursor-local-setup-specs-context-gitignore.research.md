# Research: gitignore `docs/specs/*/` i `docs/context/*/` w trybie local

**Data:** 2026-05-27  
**Kontekst:** Pytanie produktowe — czy przy instalacji jedną komendą (`setup-cursor-local.sh`, tryb **local**, bez vendoringu frameworku) zasadne jest dopisywanie do `.gitignore` wzorców `docs/specs/*/` i `docs/context/*/`.  
**Powiązane:** [cursor-local-setup.research.md](./cursor-local-setup.research.md), [cursor-local-setup.plan.md](./cursor-local-setup.plan.md), `scripts/lib/setup-cursor-local/gitignore.sh`.

## Pytanie

Czy w trybie **local** (framework poza repo, `.cursor/mcp.json` i vendored `.cursor/*` w gitignore) należy **domyślnie** ignorować w git zawartość podkatalogów `docs/specs/` i `docs/context/`?

## Werdykt (skrót)

| Opcja | Rekomendacja |
| ----- | ------------ |
| **Domyślny gitignore `docs/specs/*/` + `docs/context/*/` w trybie local** | **Nie** — niezgodne z modelem frameworku i wcześniejszą decyzją produktową |
| **Opcjonalna flaga** (np. `--gitignore-agent-artifacts`) | **Tak, opcjonalnie** — dla zespołów/ solo devów, którzy świadomie traktują artefakty agenta jako lokalne |
| **`.cursorignore` zamiast `.gitignore`** | **Rozważyć osobno** — gdy problemem jest indeks Cursor, nie wersjonowanie |

**Wniosek:** Gitignore tych ścieżek **nie wynika** z tego, że instalacja jest „lokalna”. Tryb local dotyczy **infrastruktury frameworku** (ścieżki maszynowe, duplikaty upstream), nie **wiedzy projektowej**. Domyślne ignorowanie specs/context **osłabiłoby** workflow Implement / Review i sync wiki opisany w dokumentacji.

---

## Stan obecny (as-is)

### Co robi skrypt dziś

Plik `scripts/lib/setup-cursor-local/gitignore.sh` w trybie local dopisuje blok:

```gitignore
# cursor-collections local [begin]
.cursor/mcp.json
.cursor/prompts/
.cursor/commands/
.cursor/skills/
.cursor/rules/eversis-*.mdc
!.cursor/rules/eversis-project-stack.mdc
# cursor-collections local [end]
```

*(Od 2026-06-05 — glob zamiast jawnej listy czterech reguł; patrz [quick-setup-missing-rules.plan.md](../quick-setup-missing-rules/quick-setup-missing-rules.plan.md).)*

**Nie** obejmuje `docs/specs/` ani `docs/context/`.

Scaffolding (`scaffolding.sh`) tworzy `docs/specs/` + README, **nie** tworzy `docs/context/` (pozostaje manual / opcjonalnie `.gitkeep` w planie).

### Decyzja z pierwotnego researchu (2026-05-21)

[cursor-local-setup.research.md](./cursor-local-setup.research.md) § „`.gitignore` — zależność od trybu instalacji”:

| Tryb local | W `.gitignore` | W repo (commit) |
| ---------- | -------------- | ---------------- |
| Local | `mcp.json`, prompts, commands, skills, framework rules | **`eversis-project-stack.mdc`**, **`AGENTS.md`**, **`docs/specs/`** |

Osobno: re-run setup **nie powinien** nadpisywać `docs/context/` (idempotencja względem lokalnej wiedzy).

### Rola katalogów w workflow Eversis

| Katalog | Przeznaczenie | Odniesienia |
| ------- | ------------- | ----------- |
| `docs/specs/` | Specyfikacje feature, `*.research.md`, `*.plan.md`, acceptance criteria | `eversis-implement`, `docs/specs/README.md`, Engineering Manager |
| `docs/context/` | Architektura, ADR, eksport wiki, onboarding | `@docs/context/` w promptach, Code Reviewer, Part D sync w `documentation/cursor-collection.md` |

Oba są **projektowe**, nie pochodzą z `cursor-collections` upstream.

---

## Analiza: czy gitignore ma sens w trybie local?

### 1. Semantyka trybu „local”

Tryb **local** rozwiązuje trzy konkretne problemy:

1. **Absolutne ścieżki** w `.cursor/mcp.json` — różne per developer / OS.
2. **Duplikat frameworku** — prompts/skills/rules to kopia/symlink do `$CURSOR_COLLECTIONS_HOME`, nie źródło prawdy projektu.
3. **Szum w diffie** — aktualizacja upstream frameworku nie powinna zanieczyszczać historii aplikacji.

`docs/specs/<feature>/` i `docs/context/*.md` **nie** mają tych cech:

- Nie zawierają ścieżek maszynowych do MCP.
- Nie są kopią cursor-collections (chyba że team świadomie trzyma tam spec frameworku — wtedy **powinny** być w git).
- Są **intencjonalnym outputem** workflow (research → plan → implement → review).

**Analogia:** gitignore `.cursor/prompts/` ≠ gitignore `docs/specs/` — pierwsze to „silnik”, drugie to „dokumentacja delivery”.

### 2. Współpraca zespołowa (nawet przy local framework)

Przy local setup **każdy dev** ma własny `$CURSOR_COLLECTIONS_HOME`, ale **wspólne repo aplikacji**. Jeśli `docs/specs/my-feature/` jest w gitignore:

- Plan zatwierdzony przez human gate **nie trafia** do MR / nie jest widoczny dla reviewera.
- Kolejna sesja agenta na innym komputerze **nie widzi** `@docs/specs/...` bez lokalnych plików.
- QA / Code Reviewer (reguły: czytaj `docs/specs/` / `docs/context/`) traci spójność z repo.

Tryb local **nie oznacza** „solo developer only” — README opisuje go jako domyślny dla personal/per-machine setup, ale repo nadal może być zespołowe.

### 3. Sync wiki / CI (Part D)

`documentation/cursor-collection.md` Part D opisuje **commit i push** plików do `docs/context/` (bot CI, Confluence → Markdown). Wzorzec:

```bash
git add docs/context/
git commit -m "docs: sync internal knowledge from wiki [skip ci]"
```

Gitignore `docs/context/*/` **uniemożliwia** ten model bez wyjątków (`git add -f`) i jest sprzeczny z dokumentacją bootstrap.

### 4. Wzorzec `docs/specs/*/` / `docs/context/*/`

Propozycja ignorowania **tylko podkatalogów**:

- Zachowuje `docs/specs/README.md` w repo, ale **cała treść feature** (`docs/specs/<issue-kebab>/`) znika z gita.
- README bez folderów to pusty kontrakt — mylące dla nowych devów.
- Nie rozróżnia speców „normatywnych” (commitowane w tym monorepo: `business-docs-workflow/`, `cursor-local-setup/`) od artefaktów sesji — w consumer repo **ta sama ścieżka** służy obu rolom.

### 5. Argumenty „za” gitignore (kiedy team tego *może* chcieć)

| Argument | Ocena |
| -------- | ----- |
| Artefakty agenta to „szum”, Jira = source of truth | **Polityka zespołu**, nie wymóg trybu local; lepiej flaga opt-in |
| Solo dev, brak potrzeby współdzielenia planów | Możliwe, ale **domyślne** gitignore karze zespoły |
| Mniejszy repo / mniej plików markdown w MR | Koszt niski vs utrata audytu planu i review |
| Prywatność / NDA w research | `.cursorignore` lub osobny katalog poza repo; gitignore nie szyfruje |

Żaden z powyższych **nie wynika** z samego wyboru local vs vendor — dotyczy **polityki artefaktów AI**.

---

## Porównanie z innymi mechanizmami

| Mechanizm | Cel | Czy zastępuje gitignore specs/context? |
| --------- | ----- | ------------------------------------- |
| `.gitignore` (local block) | Nie commitować frameworku + MCP paths | Nie — specs/context to nie framework |
| `.cursorignore` | Wyłączyć z indeksu Cursor (secrets, generated) | Tak, jeśli chodzi o **indeks**, nie git |
| `--vendor` | Commitować framework w repo | Nie zmienia roli specs/context |
| Jira-only workflow | Ticket jako jedyny artefakt | Wymaga jawnej decyzji zespołu, nie domyślku skryptu |

---

## Rekomendacje produktowe

### Domyślnie (bez zmian)

- **Nie dodawać** `docs/specs/*/` ani `docs/context/*/` do bloku gitignore w trybie local.
- Zachować zgodność z [cursor-local-setup.research.md](./cursor-local-setup.research.md) i checklistą w `documentation/cursor-collection.md` Part C.

### Opcjonalne rozszerzenie skryptu (jeśli product chce elastyczność)

| Flaga (propozycja) | Zachowanie |
| ------------------ | ---------- |
| `--gitignore-agent-artifacts` | Dopisuje `docs/specs/*/` i `docs/context/*/` do bloku local; drukuje ostrzeżenie o utracie współdzielenia planów / CI sync |
| `--no-scaffold-specs` | Nie tworzy `docs/specs/` (rzadki edge case) |

Vendor mode: flaga **ignorowana** lub **usuwa** te wpisy (jak reszta bloku local).

### Alternatywy zamiast gitignore

1. **Konwencja nazw** — np. `*.local.md` gitignored globalnie w projekcie (team decyduje w root `.gitignore`).
2. **Osobny katalog** — `docs/scratch/` gitignored; specs/context pozostają commitowane (wymaga edukacji).
3. **`.cursorignore`** — gdy pliki mają być w git, ale nie w indeksie agenta (rzadkie).

---

## Ryzyka wdrożenia domyślnego gitignore

| Ryzyko | Severity |
| ------ | -------- |
| Rozjazd z dokumentacją (README, installation.md, cursor-collection.md) | **Wysokie** |
| Utrata artefaktów research/plan między sesjami / maszynami | **Wysokie** |
| Code review bez `@docs/specs/` w MR | **Średnie–wysokie** |
| Zepsucie wzorca CI sync do `docs/context/` | **Wysokie** (jeśli team używa Part D) |
| Fałszywe poczucie spójności („local = wszystko agentowe poza gitem”) | **Średnie** |

---

## Otwarte pytania (do human gate przed planem)

1. Czy pytanie dotyczy **domyślnego** zachowania skryptu, czy **polityki** konkretnego consumer repo (EOP / inny)?
2. Czy zespół chce **Jira-only** bez commitowania `*.plan.md` — i czy to ma być flaga, nie default?
3. Czy `docs/context/` ma być scaffoldowany przez skrypt (obecnie brak), skoro rola jest równie ważna jak specs?

---

## Następny krok

**Plan:** [cursor-local-setup-gitignore-agent-artifacts.plan.md](./cursor-local-setup-gitignore-agent-artifacts.plan.md) — **zaimplementowany** 2026-05-27 (`--gitignore-agent-artifacts`).
