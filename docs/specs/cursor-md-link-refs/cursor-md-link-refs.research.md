# Research: poprawność odwołań `.md` w `.cursor/`

**Data:** 2026-05-18  
**Kontekst:** Audyt żądany w wątku Implement (`@.cursor/`, weryfikacja linków markdown).

## Cel

Upewnić się, że linki i ścieżki w `.cursor/commands/`, `.cursor/rules/`, `.cursor/prompts/`, `.cursor/skills/` wskazują na istniejące pliki — zarówno przy nawigacji w repozytorium (IDE, GitHub), jak i po `sync-prompts` na stronie Docusaurus.

## Metoda

- Przeskanowano `.cursor/` pod kątem `[tekst](ścieżka)` oraz ścieżek `.md` / `.mdc`.
- Zweryfikowano rozwiązanie względne względem pliku źródłowego i względem roota repo.
- Porównano z docelową lokalizacją po `scripts/sync-prompts.mjs` (`website/docs/prompts/{public,internal}/`).

## Kluczowe ustalenie: dwa konteksty rozwiązywania

| Kontekst | Przykład ścieżki | `../../agents/engineering-manager` | `../../../website/docs/agents/engineering-manager.md` |
| -------- | ---------------- | ------------------------------------ | ----------------------------------------------------- |
| **Źródło** `.cursor/prompts/internal/` | Kanon w repo | ❌ → `.cursor/agents/` (brak) | ✅ |
| **Po sync** `website/docs/prompts/internal/` | Kopia Docusaurus | ✅ → `website/docs/agents/` | ❌ → poza `website/` |

`sync-prompts.mjs` dziś **kopiuje pliki 1:1** — bez przepisywania linków. Linki w promptach są zoptymalizowane pod **Docusaurus**, nie pod drzewo `.cursor/`.

## Co jest poprawne

- **Commands → prompty:** `.cursor/prompts/public/eversis-*.md` — wszystkie 6 commands OK.
- **Backtick ścieżki od roota:** np. `.cursor/skills/eversis-qa-comment/SKILL.md` — OK.
- **Slugi promptów** (`../public/implement`, `./review-ui`): po sync mapują na `eversis-*.md` przez Docusaurus `slug`; w `.cursor/` nie są ścieżkami plików — **zamierzone dla docs**.
- **Skills — szablony lokalne:** `./jira-task.example.md`, `./references/*.md` w pakietach — OK.
- **`eversis-architecture-designing`:** pełne ścieżki `../../../.cursor/prompts/public/eversis-review.md` — OK.

## Błędy wymagające naprawy

### Wysoki priorytet (źródło + always-on)

| Obszar | Problem | Liczba |
| ------ | ------- | ------ |
| `.cursor/rules/` | Linki względne bez `../../` (np. `AGENTS.md`, `documentation/...`, podwójne `.cursor/rules/.cursor/rules/`) | ~6 w 2 plikach |
| `.cursor/commands/` | `website/...`, `documentation/...` bez `../../` | 3 pliki |
| Skills multi-cloud | Stare nazwy `terraform-module-library`, `cost-optimization` | 4 linki |

### Średni priorytet (prompty + sync)

| Obszar | Problem | Liczba |
| ------ | ------- | ------ |
| Prompty | `../../agents/*` działa po sync, nie w `.cursor/` | ~26 |
| Prompty | Slugi bez `eversis-` — słaba nawigacja w IDE | wiele |

### Niski priorytet

| Obszar | Problem |
| ------ | ------- |
| `eversis-creating-prompts/prompt.template.md` | `./dependency-prompt.prompt.md` — plik nie istnieje (legacy) |

## Ryzyka

1. **Naprawa linków tylko w `.cursor/`** bez aktualizacji `sync-prompts` może **zepsuć** linki na stronie docs.
2. **Ujednolicenie na pełne ścieżki repo** w promptach bez rewrite przy sync — ten sam problem odwrotny.
3. **Globy i placeholdery** (`*.mdc`, `eversis-*/`) — nie traktować jako broken links w validatorze.

## Rekomendacja strategiczna

- **Rules + commands:** poprawić względne ścieżki plikowe (`../../...`) — jeden kontekst, brak sync.
- **Prompty:** kanon w `.cursor/` = ścieżki działające w IDE; **`sync-prompts.mjs`** = rewrite do formy Docusaurus (`../../agents/`, **slugi** `./implement` w kopii sync).
- **Walidacja:** skrypt z trybami `source` + `synced`; **fail `npm run build`** przy błędach (decyzja produktowa 2026-05-18).
- **`website/docs/agents/`:** osobny task — poza zakresem `cursor-md-link-refs`.

## Powiązane pliki

- [documentation/cursor-collection.md](../../../documentation/cursor-collection.md) — `sync-prompts`, `.cursorignore`
- [scripts/sync-prompts.mjs](../../../scripts/sync-prompts.mjs)
- [.cursor/rules/eversis-project-stack.mdc](../../../.cursor/rules/eversis-project-stack.mdc)
