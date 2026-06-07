# Research: quick setup — brakujące reguły w bloku local gitignore

**Data:** 2026-06-05  
**Kontekst:** `/eversis-implement` — reguły frameworku nieobjęte blokiem „quick setup” (local `.gitignore`):

- `.cursor/rules/eversis-accessibility.mdc`
- `.cursor/rules/eversis-ba-docs-planner.mdc`
- `.cursor/rules/eversis-ba-docs-writer.mdc`

**Powiązane:** [cursor-local-setup.research.md](../cursor-local-setup/cursor-local-setup.research.md), [cursor-local-setup.plan.md](../cursor-local-setup/cursor-local-setup.plan.md) Task 1.9, `scripts/lib/setup-cursor-local/gitignore.sh`, `scripts/lib/setup-cursor-local/link-framework.sh`.

---

## Pytanie

Dlaczego powyższe trzy reguły **nie są** uwzględnione w konfiguracji quick setup (`setup-cursor-local.sh`, tryb **local**), skoro pozostałe reguły frameworku (`eversis-agent-core`, `eversis-testing-and-terminal`, `eversis-engineering-manager`, `eversis-code-reviewer`) są?

Czy to luka implementacyjna wymagająca naprawy?

---

## Werdykt (skrót)

| Aspekt | Werdykt |
| ------ | ------- |
| Skrypt **linkuje / kopiuje** wszystkie trzy reguły | **Tak** — są w `.cursor/rules/` po setup |
| Blok **local gitignore** je obejmuje | **Nie** — tylko 4 reguły na sztywno |
| Zgodność z **oryginalnym modelem** (wszystkie `eversis-*.mdc` oprócz stack) | **Nie** — rozjazd |
| Rekomendacja | **Naprawić** — uzupełnić gitignore (preferowany wzorzec glob + wyjątek stack) |

**Wniosek:** To **luka utrzymaniowa**, nie zamierzona separacja produktowa. Trzy reguły są częścią frameworku dostarczanego przez quick setup, ale w trybie local mogą trafić do gita konsumenta, podczas gdy reszta reguł frameworku jest ignorowana.

---

## Stan obecny (as-is)

### Pełna lista reguł w repozytorium frameworku

| Plik | `alwaysApply` / aktywacja | W `gitignore.sh` (local block) | W `.gitignore` repo frameworku |
| ---- | ------------------------- | ------------------------------ | ------------------------------ |
| `eversis-agent-core.mdc` | always-on | ✅ | ✅ |
| `eversis-testing-and-terminal.mdc` | always-on | ✅ | ✅ |
| `eversis-project-stack.mdc` | always-on, **per-project** | ❌ (commit) | ❌ (commit) |
| `eversis-engineering-manager.mdc` | attach-on-demand | ✅ | ✅ |
| `eversis-code-reviewer.mdc` | attach-on-demand | ✅ | ✅ |
| `eversis-accessibility.mdc` | globs (UI) | ❌ **brak** | ❌ **brak** |
| `eversis-ba-docs-planner.mdc` | attach-on-demand | ❌ **brak** | ❌ **brak** |
| `eversis-ba-docs-writer.mdc` | attach-on-demand | ❌ **brak** | ❌ **brak** |

### Co robi quick setup

**Phase E — `link-framework.sh`:**

- Iteruje po **wszystkich** `${COLLECTIONS_HOME}/.cursor/rules/eversis-*.mdc`.
- **Wyklucza wyłącznie** `eversis-project-stack.mdc` (seed z szablonu / preserve).
- Symlink (Unix) lub copy (Windows / fallback) — **w tym** accessibility i ba-docs-*.

**Phase G — `gitignore.sh` (`_local_gitignore_lines`):**

```gitignore
.cursor/mcp.json
.cursor/prompts/
.cursor/commands/
.cursor/skills/
.cursor/rules/eversis-agent-core.mdc
.cursor/rules/eversis-testing-and-terminal.mdc
.cursor/rules/eversis-engineering-manager.mdc
.cursor/rules/eversis-code-reviewer.mdc
```

**Brak** wpisów dla accessibility i ba-docs-*.

### Weryfikacja empiryczna (smoke, copy mode, local)

Po `setup-cursor-local.sh --link-mode copy --non-interactive` w pustym repo:

- **Wszystkie 8** plików `eversis-*.mdc` obecne w `.cursor/rules/` (7 framework + stack lokalny).
- W `.gitignore` — **tylko 4** reguły frameworkowe (jak w tabeli).

Oczekiwany efekt w git: `eversis-accessibility.mdc`, `eversis-ba-docs-planner.mdc`, `eversis-ba-docs-writer.mdc` są **śledzalne** (nie ignorowane), podczas gdy pozostałe 4 reguły frameworku są ignorowane. Stack rule — śledzalny (zgodnie z modelem).

---

## Intencja projektowa (to-be)

### Oryginalny research (`cursor-local-setup.research.md`)

§ „`.gitignore` — zależność od trybu instalacji”:

| Tryb local | W `.gitignore` | W repo (commit) |
| ---------- | -------------- | ---------------- |
| Local | `mcp.json`, prompts, commands, skills, **symlinkowane/kopiowane pliki rules framework (`eversis-*.mdc` oprócz stack)** | `eversis-project-stack.mdc`, `AGENTS.md`, `docs/specs/` |

Model: **cały silnik frameworku** poza gitem; **wyjątek** — stack rule per projekt.

### Plan implementacji Task 1.9

Plan zawiera 4 jawne wpisy + komentarz:

```gitignore
# … pozostałe vendored rules oprócz eversis-project-stack.mdc
```

**Implementacja** zatrzymała się na czterech plikach istniejących w momencie pisania skryptu — komentarz „pozostałe” **nie został** zautomatyzowany.

### Charakter brakujących reguł (nie uzasadnia wykluczenia z gitignore)

| Reguła | Rola | Dlaczego to nadal „framework upstream” |
| ------ | ---- | -------------------------------------- |
| `eversis-accessibility.mdc` | Scoped WCAG / UI (`globs` na `**/*.tsx` itd.) | Ogólna polityka frameworku; projekt doprecyzowuje w `eversis-project-stack.mdc` / `docs/context/` |
| `eversis-ba-docs-planner.mdc` | Rola BA — plan `.docx` | Para z promptem `eversis-ba-docs-planner`; attach-on-demand jak engineering-manager |
| `eversis-ba-docs-writer.mdc` | Rola BA — edycja `.docx` | Para z promptem `eversis-ba-docs-writer`; dokumentacja opisuje regułę jako **opcjonalną przy `@`**, nie jako plik do commitowania w local mode |

Dokumentacja [business-manager-docs.md](../../../website/docs/workflow/business-manager-docs.md) mówi o **opcjonalnym** dołączaniu reguły przy sesji — to dotyczy **kontekstu agenta**, nie polityki git w trybie local.

---

## Przyczyna root cause

1. **Hardcoded lista** w `gitignore.sh` zamiast wzorca `eversis-*.mdc` z wyjątkiem stack (jak w `link-framework.sh`).
2. **`eversis-accessibility.mdc`** — istniała przed / równolegle z Task 1.9; **oversight** przy tworzeniu listy (tylko „core SDLC” rules).
3. **`eversis-ba-docs-*`** — dodane w [business-docs-workflow.implementation-plan.md](../business-docs-workflow/business-docs-workflow.implementation-plan.md) (2026-05-13); **brak follow-up** w `gitignore.sh` i `.gitignore` frameworku przy dodawaniu nowych reguł.
4. **Brak guarda CI** — smoke test `setup-cursor-local.test.sh` weryfikuje obecność katalogu `rules/` i stack, **nie** spójność „linked rules ⊆ gitignored rules (local)”.

---

## Skutki (impact)

| Skutek | Severity |
| ------ | -------- |
| Przypadkowy commit kopii reguł frameworku w consumer repo (local) | **Średnie** — szum w MR, rozjazd wersji z `$CURSOR_COLLECTIONS_HOME` |
| Niespójność z dokumentacją Part C / research (wszystkie vendored rules gitignored) | **Średnie** |
| Deweloper myli „opcjonalne `@` w sesji” z „opcjonalne w repo” | **Niskie–średnie** |
| Vendor mode | **Brak wpływu** — local block usuwany; wszystkie reguły commitowane |

**Uwaga:** Reguły **działają w Cursor** po setup (są na dysku). Problem dotyczy **polityki wersjonowania**, nie braku plików.

---

## Opcje naprawy

### Opcja A — Dopisać 3 wpisy (minimalny diff)

W `scripts/lib/setup-cursor-local/gitignore.sh` → `_local_gitignore_lines` oraz w `.gitignore` repozytorium frameworku:

```gitignore
.cursor/rules/eversis-accessibility.mdc
.cursor/rules/eversis-ba-docs-planner.mdc
.cursor/rules/eversis-ba-docs-writer.mdc
```

| Za | Przeciw |
| -- | ------- |
| Proste, zgodne z obecnym stylem | Każda nowa reguła `eversis-*.mdc` wymaga ręcznej aktualizacji |

### Opcja B — Wzorzec glob + wyjątek stack (rekomendowane)

```gitignore
.cursor/rules/eversis-*.mdc
!.cursor/rules/eversis-project-stack.mdc
```

| Za | Przeciw |
| -- | ------- |
| Zgodne z `link-framework.sh`; odporność na nowe reguły | Wymaga testu `git check-ignore` na consumer fixture; dokumentacja musi podkreślić wyjątek stack |

**Rekomendacja:** **Opcja B** w `gitignore.sh` + `.gitignore` frameworku; Opcja A akceptowalna jeśli zespół woli jawne listy.

### Opcja C — Generowanie listy z `$COLLECTIONS_HOME` przy setup

Setup skanuje `eversis-*.mdc` i dopisuje do bloku (jak link phase).

| Za | Przeciw |
| -- | ------- |
| Zawsze aktualne | Bardziej złożona logika merge markera; re-run musi aktualizować listę |

---

## Zakres zmian (propozycja na plan)

| Obszar | Zmiana |
| ------ | ------ |
| `scripts/lib/setup-cursor-local/gitignore.sh` | Uzupełnić / zastąpić listę (A lub B) |
| `.gitignore` (repo frameworku) | Ten sam blok `cursor-collections local` |
| `scripts/setup-cursor-local.test.sh` | Assert: każda reguła z HOME (oprócz stack) jest `git check-ignore` po local setup |
| `documentation/cursor-collection.md` Part C | Jedno zdanie: local gitignore = wszystkie `eversis-*.mdc` oprócz stack (jeśli nie jest już wystarczająco jasne) |
| `CHANGELOG.md` | Fix entry |

**Poza zakresem:** zmiana semantyki vendor mode; zmiana `link-framework.sh` (już poprawne).

---

## Decyzje produktowe (human gate — 2026-06-05)

| # | Pytanie | Decyzja |
| - | ------- | ------- |
| 1 | Opcja A vs B | **Opcja B** — glob `eversis-*.mdc` + wyjątek `!eversis-project-stack.mdc` |
| 2 | Istniejące consumer repos | **Re-run** `setup-cursor-local.sh` — skrypt musi zmergować/odświeżyć blok local |
| 3 | Własne `eversis-*.mdc` w consumer | Tworzone **po** skonfigurowaniu reguł projektowych; glob B **akceptowany** dla tego fixu |

---

## Następny krok

**Plan:** [quick-setup-missing-rules.plan.md](./quick-setup-missing-rules.plan.md) — wdrożenie po akceptacji planu.
