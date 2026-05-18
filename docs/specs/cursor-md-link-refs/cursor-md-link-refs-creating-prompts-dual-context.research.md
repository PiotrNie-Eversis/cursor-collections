# Research: `eversis-creating-prompts` — sekcja dual-context links

**Data:** 2026-05-18  
**Zadanie nadrzędne:** [cursor-md-link-refs.plan.md](./cursor-md-link-refs.plan.md) (Improvements / Phase 5 backlog)  
**Research bazowy:** [cursor-md-link-refs.research.md](./cursor-md-link-refs.research.md)  
**Stan infrastruktury:** walidator + `sync-prompts` rewrite + slug map — **wdrożone** (Changelog planu 2026-05-18).

## Cel

Ocenić, czy i jak rozszerzyć skill **`eversis-creating-prompts`** o normatywną sekcję **dual-context links** (źródło `.cursor/` vs kopia Docusaurus po sync), oraz zweryfikować **zalety i wady** tego podejścia względem alternatyw.

**Poza zakresem tego researchu:** implementacja edycji `SKILL.md` / `prompt.template.md` (wymaga osobnej akceptacji i tasku `[MODIFY]`).

## Problem użytkownika

Autorzy nowych promptów muszą pisać linki markdown, które:

1. **Działają w Cursor IDE** — kliknięcie / Go to Definition z pliku w `.cursor/prompts/`.
2. **Działają na stronie docs** — po `sync-prompts` i `npm run build` w `website/`.

Jeden zestaw `href` **nie może** jednocześnie spełniać obu kontekstów bez warstwy transformacji — to ustalenie z audytu [cursor-md-link-refs.research.md](./cursor-md-link-refs.research.md).

## Co już istnieje (nie duplikować w skillu)

| Warstwa | Gdzie | Rola |
| ------- | ----- | ---- |
| Konwencja produktowa | [cursor-md-link-refs.plan.md](./cursor-md-link-refs.plan.md) § Konwencja kanoniczna | Tabela rewrite source → synced |
| Dokumentacja frameworku | [documentation/cursor-collection.md](../../../documentation/cursor-collection.md) § Link conventions | Deweloperzy + consumer repos |
| Automatyzacja | `scripts/lib/prompt-link-rewrite.mjs`, `scripts/sync-prompts.mjs` | Rewrite przy kopiowaniu |
| Brama jakości | `scripts/validate-cursor-markdown-links.mjs` (`--context=source\|synced\|agents`) | Fail `website` prebuild/prestart |
| Skill tworzenia promptów | `.cursor/skills/eversis-creating-prompts/SKILL.md` | **Brak** sekcji dual-context; Step 8 nie wspomina walidatora |

Skill powinien być **proceduralnym skrótem** dla agenta tworzącego prompt — z odwołaniem do powyższych, nie kopią całej tabeli z planu.

## Propozycja treści sekcji w `SKILL.md`

**Umiejscowienie:** nowa podsekcja po **Step 7** (assemble) lub w **Step 8** (validate) — rekomendacja: **osobna sekcja `## Dual-context markdown links`** przed Step 8, plus 3–4 punkty w checklist Step 8.

**Szkic treści (do implementacji):**

1. **Dwa konteksty** — tabela skrócona (source vs synced), jak w researchu bazowym.
2. **Kanon w `.cursor/prompts/`** (tylko ten monorepo z `website/`):
   - Role docs: `../../../website/docs/agents/<slug>.md`
   - Cross-prompt public: `../public/eversis-<stem>.md`
   - Cross-prompt internal: `../internal/eversis-<stem>.md` lub `./eversis-<stem>.md`
   - **Nie** używać w źródle: `../../agents/…`, `./implement` (slug bez `eversis-`) — to forma **po sync**.
3. **`slug` w frontmatter** — musi być unikalny w tierze; kolizje blokują `buildPromptSlugMaps` / sync.
4. **Po zapisaniu pliku** — uruchomić z roota repo:
   ```bash
   node scripts/validate-cursor-markdown-links.mjs --context=source
   cd website && npm run sync-prompts
   node ../scripts/validate-cursor-markdown-links.mjs --context=synced
   ```
5. **Consumer repo bez `website/`** — linki `eversis-*.md` względem pliku; `@eversis-*` w tekście; brak obowiązku sync (jak w `cursor-collection.md`).
6. **Rules / commands / skills** — jeden kontekst (brak sync); `../../` do roota lub względne w tym samym katalogu — **nie** mieszać z regułami promptów.

**Aktualizacja `prompt.template.md`:** w komentarzu `<prerequisites>` zamienić przykład na kanoniczne ścieżki (`../public/eversis-implement.md`, nie legacy `../../prompts/...`).

## Zalety (weryfikacja)

| # | Zaleta | Uzasadnienie |
| - | ------ | ------------ |
| Z1 | **Mniej regresji przy tworzeniu promptów** | Główna przyczyna błędów w audycie (~26× `../../agents/` w źródle) — autorzy kopiowali wzorzec z kopii sync lub ze strony docs. |
| Z2 | **Spójność z automatyzacją** | Skill uczy tego samego, co `rewritePromptLinksForDocusaurus` — mniejsze ryzyko „ręcznego” slug w `.cursor/`. |
| Z3 | **Wczesne wykrywanie błędów** | Step 8 + walidator = feedback przed merge, bez czekania na CI Docusaurus. |
| Z4 | **Jeden punkt dla Prompt Engineera** | `eversis-creating-prompts` jest naturalnym miejscem procedury; `cursor-collection.md` zostaje dla architektury frameworku. |
| Z5 | **Niski koszt utrzymania** | Sekcja ~40–60 linii + 4 punkty checklist; tabela rewrite żyje w skryptach, skill tylko odwołuje. |
| Z6 | **Kompatybilność z `@eversis-*`** | Skill może wyraźnie rozdzielić: link markdown = nawigacja plikowa; `@` = attachment Cursor — bez zmiany istniejącej praktyki. |

## Wady i ryzyka (weryfikacja)

| # | Wada / ryzyko | Dotkliwość | Mitigacja |
| - | ------------- | ---------- | --------- |
| W1 | **Duplikacja wiedzy** (skill vs plan vs `cursor-collection.md`) | Średnia | Skill: skrót + linki; pełna tabela tylko w planie / docs; data „last aligned with” w komentarzu skillu opcjonalnie. |
| W2 | **Obciążenie poznawcze** nowych autorów | Średnia | Jedna tabela decyzyjna „jeśli linkujesz X → użyj Y”; przykłady copy-paste; `@` jako preferowany sposób w Executable gdy wystarczy attachment. |
| W3 | **Dryf skill ↔ skrypt** | Wysoka przy zmianie rewrite | W Step 8: „jeśli build failuje synced — sprawdź `prompt-link-rewrite.mjs`, nie zmieniaj ręcznie kopii w `website/docs/prompts/`”. Testy w `prompt-link-rewrite.test.mjs` jako źródło prawdy reguł. |
| W4 | **Fałszywe poczucie bezpieczeństwa** | Niska | Walidator nie skanuje wszystkiego (np. `website/docs/agents/` w osobnym tasku); skill musi wymienić wyjątki: globy, `http:`, placeholdery. |
| W5 | **Consumer repos bez sync** | Niska | Jawna adnotacja: sekcja dual-context **tylko** gdy jest `website/` + `sync-prompts`; inaczej jeden kontekst. |
| W6 | **Konflikt z Docusaurus sidebar slug** | Średnia | Podkreślić: `slug:` w YAML ≠ ścieżka pliku; rewrite używa frontmatter (`buildPromptSlugMaps`). |
| W7 | **Koszt dla agenta** (dłuższy skill) | Niska | Progressive disclosure: sekcja linków bez XML; szczegóły w `references/dual-context-links.md` **opcjonalnie** tylko jeśli skill > ~500 linii (obecnie ~190 — **nie wymagane** na start). |

## Alternatywy rozważone

| Alternatywa | Ocena |
| ----------- | ----- |
| **A. Tylko `documentation/cursor-collection.md`** (bez skillu) | Odrzucona jako jedyna ścieżka — agenci tworzący prompty często ładują `eversis-creating-prompts`, nie cały framework doc. |
| **B. Jeden wspólny format linków (tylko slug wszędzie)** | Odrzucona — slugi w `.cursor/` łamią IDE; audyt to potwierdził. |
| **C. Tylko pełne ścieżki repo (bez rewrite)** | Odrzucona — łamie Docusaurus po sync. |
| **D. Generowanie dwóch plików źródłowych** (source + generated) | Odrzucona na tę iterację — wyższy koszt, drift między plikami; obecny rewrite przy sync jest tańszy. |
| **E. Sekcja w `prompt.template.md` zamiast `SKILL.md`** | Niewystarczająca — template jest kopiowany; procedura walidacji należy do skillu Step 8. |
| **F. Osobny skill `eversis-linking-prompts`** | Odrzucona — zbyt rozdrobnienie; dual-context dotyczy wyłącznie tworzenia promptów w tym frameworku. |

## Rekomendacja

**Wdrożyć** rozszerzoną sekcję dual-context w **`eversis-creating-prompts/SKILL.md`** oraz minimalną korektę przykładów w **`prompt.template.md`**.

| Aspekt | Decyzja |
| ------ | ------- |
| Zakres skillu | Sekcja + rozszerzenie Step 8 (walidator); **bez** duplikowania pełnej tabeli rewrite |
| Głębokość | Średnia (~50 linii + przykłady 2× public, 1× internal, 1× agent) |
| `references/` | **Nie** na pierwszej iteracji — skill wystarczająco krótki |
| Powiązanie z planem | Osobny mini-task w Phase 5 lub backlog Improvements — szac. **20–30 min** |
| Kolejność | Po zamknięciu głównego `cursor-md-link-refs` (już done) — unika konfliktów treści |

**Nie rekomendować:** uczenia autorów ręcznej edycji `website/docs/prompts/` (gitignored, nadpisywane przez sync).

## Proponowany task implementacyjny (po akceptacji researchu)

```
#### Task 5.3 - [MODIFY] eversis-creating-prompts — dual-context links

Pliki:
- .cursor/skills/eversis-creating-prompts/SKILL.md
- .cursor/skills/eversis-creating-prompts/prompt.template.md (przykład prerequisites)

DoD:
- [ ] Sekcja „Dual-context markdown links” z tabelą source/synced i regułami kanonu
- [ ] Step 8 checklist: validate source + synced (komendy)
- [ ] Odniesienie do documentation/cursor-collection.md § Link conventions
- [ ] Brak sprzeczności z prompt-link-rewrite.mjs (przegląd po edycji)
```

## Kryteria akceptacji (research → implementacja)

- [ ] Autor promptu po przeczytaniu skillu wie, **który href** wpisać w `.cursor/prompts/` bez czytania planu.
- [ ] Autor wie, że **nie commituje** ręcznych poprawek w `website/docs/prompts/`.
- [ ] Step 8 wymusza uruchomienie walidatora (lub `cd website && npm run build` jako skrót).
- [ ] Sekcja nie duplikuje > ~15 linii tabeli z planu (link zamiast copy-paste).

## Powiązane pliki

- [.cursor/skills/eversis-creating-prompts/SKILL.md](../../../.cursor/skills/eversis-creating-prompts/SKILL.md)
- [scripts/lib/prompt-link-rewrite.mjs](../../../scripts/lib/prompt-link-rewrite.mjs)
- [scripts/validate-cursor-markdown-links.mjs](../../../scripts/validate-cursor-markdown-links.mjs)
- [documentation/cursor-collection.md](../../../documentation/cursor-collection.md) (§ Link conventions)

## Werdykt researchu

Rozszerzenie skillu o **dual-context links** jest **uzasadnione**: zamyka lukę proceduralną między wdrożoną automatyzacją a codziennym tworzeniem promptów, przy akceptowalnym koszcie (W1–W2) i jasnych mitigacjach (W3, W5). **Zalety przeważają nad wadami** pod warunkiem krótkiej sekcji i odwołań do skryptów/docs zamiast drugiej normy równoległej.

---

**Bramka Implement:** Po akceptacji tego researchu można dodać Task 5.3 do planu i wdrożyć edycję skillu (bez zmian w MCP / zależnościach npm).
