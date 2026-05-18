# Research: linki w `website/docs/agents/*.md`

**Data:** 2026-05-18  
**Kontekst:** Follow-up z [cursor-md-link-refs.plan.md](./cursor-md-link-refs.plan.md) — sekcja *Improvements (Out of Scope)*, decyzja produktowa #3.  
**Powiązane:** [cursor-md-link-refs.research.md](./cursor-md-link-refs.research.md), wdrożenie `.cursor/` (walidator `--context=source|synced` **bez** `website/docs/agents/`).

## Cel

Zaudytować linki na kartach agentów (Docusaurus) do promptów, rules, skills oraz innych ról; zaproponować konwencję spójną z `website/docs/prompts/` po `sync-prompts`; określić zakres osobnego tasku bez blokowania zamknięcia `cursor-md-link-refs`.

## Metoda

- Przegląd 16 plików `website/docs/agents/**/*.md`.
- Porównanie ze wzorcem `website/docs/skills/overview.md` (bogate linki slug).
- Weryfikacja rozwiązywania ścieżek: skrypt plikowy (resolve do `*.md` na dysku) vs `npm run build` (Docusaurus `onBrokenLinks: "throw"`).
- Mapowanie `slug` z frontmatter `.cursor/prompts/**/eversis-*.md` (indeks jak w `scripts/lib/prompt-link-rewrite.mjs`).

## Ustalenie: dwa konteksty (jak w `.cursor/`)

| Kontekst | Gdzie | Link do promptu | Link do agenta | Link do skill (docs) |
| -------- | ----- | ---------------- | -------------- | -------------------- |
| **IDE / repo** | `.cursor/prompts/` (kanon) | `../public/eversis-implement.md` | `../../../website/docs/agents/engineering-manager.md` | backtick `.cursor/skills/.../SKILL.md` |
| **Docs site** | `website/docs/agents/` | `../prompts/public/implement` (slug) | `./engineering-manager` (doc id) | `../skills/code-review` (doc id) |
| **Docs site (synced prompts)** | `website/docs/prompts/` | `./implement`, `../public/review` | `../../agents/engineering-manager` | (brak w promptach — skills tylko backtick) |

Karty agentów żyją **wyłącznie** w kontekście docs — nie są kopiowane przez `sync-prompts`. Nie potrzebują rewrite dwukierunkowego; wystarczy jedna konwencja **slugów Docusaurus**, analogiczna do synced prompts.

## Stan obecny — linki markdown

### Co działa (build OK)

`cd website && npm run build` przechodzi (`onBrokenLinks: "throw"`). Istniejące linki markdown są poprawne **dla Docusaurus**:

| Href | Przykład | Mechanizm |
| ---- | -------- | --------- |
| `./<agent-slug>` | `[Architect](./architect)` | Doc id = nazwa pliku bez `.md` |
| `../framework` | overview → Framework reference | `framework-reference.md` ma `slug: /framework` |
| `../prompts/public/<slug>` | EM → `[Implement](../prompts/public/implement)` | Frontmatter `slug: implement` w `eversis-implement.md` |

**Uwaga:** Prosty resolve plików na dysku **fałszywie** zgłasza broken dla `../prompts/public/implement` i `../framework`, bo na dysku są `eversis-implement.md` i `framework-reference.md`. Walidator file-based musiałby znać mapę slug ↔ plik (jak `--context=synced` dla promptów).

### Rozkład linków (16 plików)

| Kategoria | Pliki | Liczba linków `[](...)` (szac.) |
| --------- | ----- | ------------------------------- |
| Tylko linki między agentami | software-engineer, e2e-engineer | **0** |
| Agenci + 1 prompt/framework | architect, context-engineer, prompt-engineer, code-reviewer, devops, ui-reviewer, business-analyst | 1–3 |
| Overview + tabele ról | overview.md | 17 (głównie `./<role>`) |
| Customization cluster | orchestrator + 3 workers + engineer | 5–9 (wzajemne `./cursor-customization-*`) |
| Jedyny link do prompt docs | engineering-manager.md | `../prompts/public/implement` |

### Luka: rules / prompts / skills nie są linkowane

Na kartach agentów dominują **backticki** (ścieżki repo, `@eversis-*`, nazwy skilli), nie markdown:

| Artifact | Jak jest dziś | Link do strony docs? |
| -------- | ------------- | -------------------- |
| **Public prompt** | `@eversis-implement`, backtick `.cursor/prompts/public/...` | Tylko EM → implement |
| **Internal prompt** | backtick `.cursor/prompts/internal/eversis-plan.md` | **Brak** |
| **Rule** | backtick `.cursor/rules/eversis-role-*.mdc` | **Brak** (brak `website/docs/rules/`) |
| **Skill** | lista `` `eversis-code-reviewing` `` w sekcji Skills Loaded | **Brak**; skills/overview ma `[eversis-code-reviewing](./code-review)` |

**Wzorzec do naśladowania:** `website/docs/skills/overview.md` — tabela z linkami `./<skill-doc-id>` (np. `./task-analysis` dla pakietu `eversis-task-analysing`).

### Asymetria prompt ↔ agent (po `cursor-md-link-refs`)

- **Prompty (kanon):** link do `[Engineering Manager](../../../website/docs/agents/engineering-manager.md)`.
- **Prompty (sync):** `[Engineering Manager](../../agents/engineering-manager)`.
- **Agenci:** większość **nie** linkuje z powrotem do `../prompts/public|internal/<slug>`.

Dwukierunkowa nawigacja docs jest dziś możliwa tylko: prompt → agent; agent → prompt (wyjątek: implement).

## Mapowanie ról → primary artifacts (do linkowania w docs)

| Agent (doc id) | Public prompt (slug) | Internal / delegated (slug) | Rule (repo only) | Skills (przykłady → docs id) |
| -------------- | -------------------- | ----------------------------- | ---------------- | ---------------------------- |
| business-analyst | `analyze-materials` | — | `eversis-role-business-analyst.mdc` | task-extraction, transcript-processing, jira-task-formatting |
| context-engineer | (via implement) | `research` | `eversis-role-context-engineer.mdc` | task-analysis |
| architect | (via implement) | `plan` | `eversis-role-architect.mdc` | architecture-design, technical-context-discovery |
| engineering-manager | `implement` | research, plan, implement-ui, … | `eversis-engineering-manager.mdc` | qa-comment (handoff) |
| software-engineer | (via implement) | implement-common-task, implement-ui-common-task | `eversis-role-software-engineer.mdc` | frontend-implementation, implementing-forms, … |
| devops-engineer | (via implement) | implement-pipeline, implement-terraform, implement-observability, deploy-kubernetes | `eversis-role-devops-engineer.mdc` | ci-cd-implementation, terraform-modules, … |
| e2e-engineer | (via implement) | `implement-e2e` | `eversis-role-e2e-engineer.mdc` | e2e-testing |
| code-reviewer | `review` | — | `eversis-code-reviewer.mdc` | code-review, reviewing-frontend |
| ui-reviewer | `review-ui` | — | `eversis-role-ui-reviewer.mdc` | ui-verification |
| prompt-engineer | (via implement) | `engineer-prompt` | `eversis-role-prompt-engineer.mdc` | prompt-engineering |
| cursor-customization-engineer | `create-custom-agent`, `create-custom-prompt`, … | — | `eversis-role-cursor-customization.mdc` | creating-agents, creating-prompts, creating-skills |
| cursor-customization-orchestrator | `create-custom-agent` | — | (composed) | — |
| workers (3) | — | — | — | creating-* (via orchestrator) |

Pełna lista skill doc ids: tabela w `website/docs/skills/overview.md` (33 wpisy).

## Proponowana konwencja (task follow-up)

### W `website/docs/agents/*.md` (jeden kontekst — Docusaurus)

1. **Prompty public:** `[Implement](../prompts/public/implement)` — slug z frontmatter, nie `eversis-implement.md`.
2. **Prompty internal:** `[Research](../prompts/internal/research)` — ten sam wzorzec co synced prompts.
3. **Skills:** jak overview — `[eversis-code-reviewing](../skills/code-review)` (doc id ≠ nazwa pakietu; utrzymać mapę w jednym miejscu).
4. **Rules:** bez osobnych stron docs — zostawić backtick **lub** link do sekcji [Framework reference](../framework) / anchor; opcjonalnie link GitHub do `.cursor/rules/...` (jak w `framework-reference.md`).
5. **Agenci:** zachować `./<slug>` (już OK).
6. **Overview:** w tabelach dodać kolumnę „Docs” z linkiem do prompt/skill tam gdzie istnieje strona.

**Nie** mieszać w agents ścieżek kanonicznych `.cursor/` (`eversis-*.md`) — to kontekst IDE, nie Docusaurus.

### Walidator (osobny scope)

Rozszerzenie `validate-cursor-markdown-links.mjs`:

- `--context=agents` → skan `website/docs/agents/**/*.md`
- Resolver: `../prompts/{public,internal}/<slug>` przez `buildPromptSlugIndex`; `../skills/<docId>` przez istnienie `website/docs/skills/<docId>.md`; `../framework` → `framework-reference.md`; `./<agent>` → `agents/<agent>.md`

**Nie** włączać do obecnego `prebuild` decyzji #2 dla `cursor-md-link-refs` (plan Phase 4 wyraźnie wyklucza agents).

### Dokumentacja

Krótka tabela w `documentation/cursor-collection.md` obok „Link conventions in `.cursor/`”:

| Layer | Link style |
| ----- | ---------- |
| `website/docs/agents/` | slug paths to `../prompts/...`, `../skills/...`, `./<agent>` |

## Ryzyka

1. **Duplikacja mapy skill package → doc id** — overview już ją ma; przy masowej edycji agentów warto wyekstrahować wspólny fragment lub skrypt generujący sekcję „Skills Loaded”.
2. **Linki do internal promptów** — strony są w gitignored/synced `website/docs/prompts/internal/`; build wymaga `sync-prompts` przed walidacją (już w `prebuild`).
3. **Regresja treści** — zmiana tylko `href`/linków, bez zmiany procedur (jak Phase 3 cursor-md-link-refs).

## Rekomendacja

| Priorytet | Działanie |
| --------- | --------- |
| P0 | Naprawić brak symetrii: dodać linki prompt docs na każdej karcie z `@eversis-*` / delegated prompt (wg tabeli mapowania). |
| P1 | Sekcje „Skills Loaded” — linki do `../skills/<doc-id>` jak w skills overview. |
| P2 | `--context=agents` w walidatorze + wpis w `website/package.json` (`validate-cursor-links` lub osobny skrypt). |
| P3 | Overview — opcjonalna kolumna linków; rules pozostają backtick + framework. |

**Zależność:** sensowne **po** zamknięciu `cursor-md-link-refs` (prompty ↔ agenci w kanonie/sync już ustalone). **Nie blokuje** zamknięcia — brak walidacji agents w Phase 4 jest zamierzony.

## Szacunek (osobny task)

| Obszar | Szacunek |
| ------ | -------- |
| Edycja 12 kart ról + overview | ~1.5–2 h |
| Walidator `--context=agents` | ~1 h |
| Docs + build | ~30 min |
| **Razem** | **~3 h** |

## Powiązane pliki

- [website/docs/agents/overview.md](../../../website/docs/agents/overview.md)
- [website/docs/skills/overview.md](../../../website/docs/skills/overview.md)
- [scripts/validate-cursor-markdown-links.mjs](../../../scripts/validate-cursor-markdown-links.mjs)
- [scripts/lib/prompt-link-rewrite.mjs](../../../scripts/lib/prompt-link-rewrite.mjs)
- [.cursor/commands/eversis-implement.md](../../../.cursor/commands/eversis-implement.md) — command ładuje prompt; linki w command używają `../../website/docs/...` (osobny kontekst `.cursor/commands/`)
