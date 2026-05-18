# Plan implementacji: linki w `website/docs/agents/*.md`

**Research:** [cursor-md-link-refs-agents.research.md](./cursor-md-link-refs-agents.research.md)  
**Poprzednik (zamknięty / w toku):** [cursor-md-link-refs.plan.md](./cursor-md-link-refs.plan.md) — Phase 4 **nie** obejmuje agents (decyzja #3).  
**Normatywna konwencja (po wdrożeniu):** sekcja [Konwencja linków — agents](#konwencja-linków--agents-docs) poniżej.

**Wdrożenie** po akceptacji planu (bramka `eversis-agent-core.mdc`). **Zależność:** sensowne po merge / zamknięciu `cursor-md-link-refs` (prompty ↔ agenci w kanonie i sync).

**Decyzje produktowe zaakceptowane:** 2026-05-18 (implementacja w wątku `/eversis-implement`).

Zakres: wyłącznie `website/docs/agents/**/*.md`, rozszerzenie walidatora `--context=agents`, krótka aktualizacja `documentation/cursor-collection.md` — **bez** zmian w `.cursor/`, `sync-prompts`, MCP, zależnościach npm.

---

## Task Details

| Field            | Value                                                                                      |
| ---------------- | ------------------------------------------------------------------------------------------ |
| ID / folder      | `cursor-md-link-refs-agents` (artefakty w `docs/specs/cursor-md-link-refs/`)               |
| Title            | Linki z kart agentów do promptów / skills (Docusaurus)                                     |
| Priority         | Niska–średnia — UX docs; nie blokuje codziennej pracy w IDE                                 |
| Related Research | [cursor-md-link-refs-agents.research.md](./cursor-md-link-refs-agents.research.md)         |

## Proposed Solution

1. Ustalić **konwencję slugów** dla `website/docs/agents/` (spójną ze synced `website/docs/prompts/`).
2. Na każdej karcie roli dodać **markdown linki** do stron promptów (public/internal) i skills (wg mapy z `skills/overview.md`).
3. Zachować **backticki** dla `.cursor/rules/*.mdc` i `@eversis-*` (IDE); rules bez osobnych stron docs.
4. Rozszerzyć **`validate-cursor-markdown-links.mjs`** o `--context=agents` i wpiąć w **`validate-cursor-links`** (po `sync-prompts`).
5. Zweryfikować **`npm run build`** (Docusaurus `onBrokenLinks: "throw"`).

```mermaid
flowchart LR
  subgraph agents [website/docs/agents]
    A[role cards]
  end
  subgraph targets [Doc targets]
    P[../prompts/public|internal/slug]
    S[../skills/doc-id]
    F[../framework]
    R[./other-agent]
  end
  A --> P
  A --> S
  A --> F
  A --> R
  A --> V[validate --context=agents]
  V --> B[docusaurus build]
```

## Konwencja linków — agents (docs)

| Typ odwołania | W `website/docs/agents/*.md` | Przykład |
| ------------- | ---------------------------- | -------- |
| Inny agent | `./<doc-id>` | `[Architect](./architect)` |
| Public prompt | `../prompts/public/<slug>` | `[Implement](../prompts/public/implement)` |
| Internal prompt | `../prompts/internal/<slug>` | `[Plan](../prompts/internal/plan)` |
| Skill (strona docs) | `../skills/<doc-id>` | `[eversis-code-reviewing](../skills/code-review)` |
| Framework | `../framework` | `[Framework reference](../framework)` |
| Rule (brak strony docs) | backtick | `` `.cursor/rules/eversis-role-architect.mdc` `` |
| `@eversis-*` w tekście | backtick + opcjonalnie link przy **pierwszej** wzmiance w sekcji „Primary / Delegated prompt” | `` `@eversis-implement` `` + link do docs |
| Ścieżki `.cursor/...` w prose | backtick (IDE) | bez zmiany na `eversis-*.md` w href |

**Mapa skill package → doc id:** normatywnie [website/docs/skills/overview.md](../../../website/docs/skills/overview.md) — przy edycji agentów **nie wymyślać** nowych slugów; kopiować href z overview.

**Nie zmieniać:** treści procedur, tabel MCP, diagramów handoff — tylko `href` / nowe linki tam gdzie dziś są same backticki lub gołe nazwy skilli.

## Decyzje produktowe (do akceptacji przed implementacją)

| #   | Pytanie | Propozycja |
| --- | ------- | ---------- |
| 1   | Czy `--context=agents` ma być w `validate-cursor-links` (fail `prebuild`)? | **Tak** — spójnie z `cursor-md-link-refs` decyzją #2; kolejność: `sync-docs-assets` → `source` + `synced` + **`agents`** → build |
| 2   | Czy w `overview.md` dodawać osobną kolumnę „Docs”? | **Nie** — linki w kolumnie „Eversis packaging” (prompt jako `[analyze-materials](../prompts/public/analyze-materials)` obok backtick rule); unikamy szerokich tabel |
| 3   | Czy linkować rules do GitHub? | **Nie** w tej iteracji — backtick + [Framework reference](../framework); ewentualnie anchor w przyszłości |
| 4   | Role „via `@eversis-implement`” bez własnego public prompt | Linkować **[Implement](../prompts/public/implement)** przy pierwszej wzmiance + internal slugi tam gdzie są nazwane pliki |

---

## Implementation Plan

### Phase 0 — Konwencja i checklist mapowania

#### Task 0.1 - [CREATE] Checklist mapowania w komentarzu planu / research

**Description:** Utrzymać tabelę ról → slugi (poniżej) jako listę kontrolną Phase 2. Źródło skill doc ids: `skills/overview.md`.

**Definition of Done:**

- [ ] Implementer ma jedną tabelę slugów (ta sekcja planu) bez zgadywania z research

#### Mapowanie ról (lista kontrolna)

| Plik agenta | Public prompt(s) | Internal prompt(s) | Skills (doc ids) — linkować w „Skills Loaded” |
| ----------- | ---------------- | -------------------- | --------------------------------------------- |
| `business-analyst.md` | `analyze-materials` | — | transcript-processing, task-extraction, task-quality-review, jira-task-formatting, codebase-analysis |
| `context-engineer.md` | (link implement przy „via”) | `research` | task-analysis |
| `architect.md` | (implement) | `plan` | architecture-design, technical-context-discovery, implementation-gap-analysis, codebase-analysis, sql-and-database, engineering-prompts, multi-cloud-architecture, implementing-ci-cd, implementing-kubernetes, implementing-observability, implementing-terraform-modules, managing-secrets, optimizing-cloud-cost |
| `engineering-manager.md` | `implement` (już częściowo) | `research`, `plan`, `implement-ui` (+ wzmianki innych w prose jako linki) | qa-comment |
| `software-engineer.md` | (implement) | `implement-common-task`, `implement-ui-common-task` | technical-context-discovery, implementation-gap-analysis, codebase-analysis, frontend-implementation, implementing-forms, writing-hooks, ensuring-accessibility, optimizing-frontend, ui-verification, sql-and-database, engineering-prompts |
| `devops-engineer.md` | (implement) | `implement-pipeline`, `implement-terraform`, `implement-observability`, `deploy-kubernetes` | technical-context-discovery, codebase-analysis, ci-cd-implementation, kubernetes-implementation, terraform-modules, observability-implementation, secrets-management, cloud-cost-optimization, multi-cloud-architecture |
| `e2e-engineer.md` | (implement) | `implement-e2e` | e2e-testing, task-analysis, technical-context-discovery |
| `code-reviewer.md` | `review` | — | code-review, reviewing-frontend, implementation-gap-analysis, technical-context-discovery, sql-and-database, engineering-prompts |
| `ui-reviewer.md` | `review-ui` | — | ui-verification |
| `prompt-engineer.md` | (implement) | `engineer-prompt` | prompt-engineering |
| `cursor-customization-engineer.md` | `create-custom-agent`, `create-custom-prompt`, `create-custom-skill`, `create-custom-instructions` | — | creating-agents, creating-prompts, creating-skills, creating-instructions |
| `cursor-customization-orchestrator.md` | `create-custom-agent` (+ related w prose) | — | (minimal — handoff do workers) |
| workers (3 pliki) | — | — | opcjonalnie creating-* jeśli wymienione w tekście |

---

### Phase 1 — Walidator `--context=agents`

#### Task 1.1 - [MODIFY] `scripts/validate-cursor-markdown-links.mjs`

**Description:** Dodać tryb `--context=agents`:

- Skan: `website/docs/agents/**/*.{md}`
- Resolver:
  - `./<id>` → `website/docs/agents/<id>.md`
  - `../framework` → `website/docs/framework-reference.md`
  - `../prompts/public/<slug>` / `../prompts/internal/<slug>` → plik w `website/docs/prompts/{tier}/` przez `buildPromptSlugIndex(.cursor/prompts)` (jak synced)
  - `../skills/<docId>` → `website/docs/skills/<docId>.md`
- Pomijać: `http(s):`, `mailto:`, `#`, globy

**Definition of Done:**

- [ ] `node scripts/validate-cursor-markdown-links.mjs --context=agents` exit 0 na obecnym drzewie (przed Phase 2 może być 0 broken — tylko istniejące linki)
- [ ] Świadomie zły slug w agencie → exit 1 z czytelnym komunikatem

#### Task 1.2 - [MODIFY] `website/package.json`

**Description:** Rozszerzyć `validate-cursor-links`:

```text
... --context=synced && node ../scripts/validate-cursor-markdown-links.mjs --context=agents
```

**Definition of Done:**

- [ ] `prebuild` / `prestart` uruchamiają trzy konteksty po `sync-docs-assets`

---

### Phase 2 — Karty agentów (linki prompt + skill)

Wzorzec edycji (każdy plik):

1. Sekcja nagłówkowa **Primary / Delegated prompt:** zamienić listę backticków internal na linki `[Title](../prompts/internal/<slug>)`; public — `[Title](../prompts/public/<slug>)`.
2. Przy `@eversis-*`: zostawić backtick; dodać „(docs: […](../prompts/…))” **raz** w nagłówku lub sekcji How to Use.
3. **Skills Loaded:** każdy `` `eversis-…` `` → `[eversis-…](../skills/<doc-id>)` wg overview.
4. **Handoffs:** istniejące linki agentów — bez zmian; dodać linki promptów tylko jeśli brakuje.

#### Task 2.1 - [MODIFY] `business-analyst.md`

**Definition of Done:**

- [ ] Link do `../prompts/public/analyze-materials`
- [ ] Skills Loaded — 5 linków (wg tabeli Phase 0)
- [ ] `@eversis-analyze-materials` + docs link w nagłówku

#### Task 2.2 - [MODIFY] `context-engineer.md`, `architect.md`

**Definition of Done:**

- [ ] `research` / `plan` jako linki internal
- [ ] Wzmianka implement → link public `implement`
- [ ] Skills Loaded — linki wg tabeli

#### Task 2.3 - [MODIFY] `engineering-manager.md`

**Definition of Done:**

- [ ] Rozszerzyć istniejący link implement; dodać internal: research, plan, implement-ui
- [ ] `qa-comment` w prose (Fine handoff) → link skill
- [ ] Backtick internal w „How to Use” — opcjonalnie skrócić do linków docs (zachować jedną linię backtick „w IDE: `.cursor/prompts/...`”)

#### Task 2.4 - [MODIFY] `software-engineer.md`, `e2e-engineer.md`

**Definition of Done:**

- [ ] SE: 0 markdown links dziś → dodać delegated + skills (11+) + handoff do review
- [ ] E2E: `implement-e2e` + skills + link implement

#### Task 2.5 - [MODIFY] `devops-engineer.md`, `prompt-engineer.md`

**Definition of Done:**

- [ ] 4 internal delegated prompts jako linki
- [ ] Skills Loaded — pełna lista z overview

#### Task 2.6 - [MODIFY] `code-reviewer.md`, `ui-reviewer.md`

**Definition of Done:**

- [ ] `review` / `review-ui` public links
- [ ] Skills Loaded — linki

#### Task 2.7 - [MODIFY] Cluster customization (4 pliki)

**Pliki:** `cursor-customization-engineer.md`, `cursor-customization-orchestrator.md`, `cursor-customization-researcher.md`, `cursor-customization-artifact-creator.md`, `cursor-customization-artifact-reviewer.md`

**Definition of Done:**

- [ ] Engineer: linki do `create-custom-*` public prompts + skills creating-*
- [ ] Orchestrator: `create-custom-agent` + istniejące linki workerów OK
- [ ] Workers: bez nowych prompt links (brak public entry); ewentualnie link do orchestrator (już jest)

---

### Phase 3 — `overview.md`

#### Task 3.1 - [MODIFY] `website/docs/agents/overview.md`

**Description:**

- W tabelach „Role summary”: w kolumnie packaging dodać linki do primary public prompt (np. `[implement](../prompts/public/implement)`) obok `@eversis-*`.
- Dla ról „internal implement prompts” — link `[implement](../prompts/public/implement)` + tekst „internal delegates” (bez wypisywania wszystkich slugów w tabeli — szczegóły na kartach).
- Zachować `[Framework reference](../framework)` i linki `./<role>`.

**Definition of Done:**

- [ ] Każda wiersz tabeli z `@eversis-*` ma co najmniej jeden link docs do promptu
- [ ] Brak regresji diagramu ASCII / handoff

---

### Phase 4 — Dokumentacja

#### Task 4.1 - [MODIFY] `documentation/cursor-collection.md`

**Description:** Pod sekcją „Link conventions in `.cursor/`” dodać wiersz tabeli:

| `website/docs/agents/` | Slugi: `../prompts/...`, `../skills/...`, `./<agent>`, `../framework` | `validate-cursor-markdown-links.mjs --context=agents` |

**Definition of Done:**

- [ ] Deweloper rozróżnia trzy warstwy: source `.cursor/`, synced prompts, agents docs

---

### Phase 5 — Weryfikacja

#### Task 5.1 - [REUSE] Build i walidator

**Description:**

```bash
cd website && npm run sync-prompts
node ../scripts/validate-cursor-markdown-links.mjs --context=agents
cd website && npm run build
```

Opcjonalnie: `@eversis-review` na diffie (docs-only).

**Definition of Done:**

- [ ] Wszystkie trzy konteksty walidatora OK
- [ ] `npm run build` OK
- [ ] Ręcznie: 2–3 karty agentów w dev server — klik prompt + skill

#### Task 5.2 - [REUSE] Przegląd spójności z promptami

**Description:** Sample: otworzyć synced `eversis-implement.md` → link do EM; z `engineering-manager.md` → link do implement (dwukierunkowość docs).

**Definition of Done:**

- [ ] Prompt → agent i agent → prompt działają w preview docs

---

## Security Considerations

- Brak — wyłącznie markdown i skrypt walidacji lokalny; bez sekretów i nowych zależności.

## Quality Assurance

Acceptance criteria (całość zadania):

- [ ] Każda karta roli (12 + 3 workers z entry w overview) linkuje do co najmniej jednego `../prompts/...` lub wyraźnie do `implement` gdy rola jest delegowana
- [ ] Sekcje „Skills Loaded” używają `../skills/<doc-id>` zgodnie z `skills/overview.md`
- [ ] `validate-cursor-markdown-links.mjs --context=agents` = 0 errors
- [ ] `npm run build` przechodzi
- [ ] Brak zmian w `.cursor/prompts/` kanonie (tylko `website/docs/agents/`)
- [ ] Rules pozostają backtick (decyzja #3)

**Komenda weryfikacji (repo root):**

```bash
cd website && npm run sync-docs-assets
node ../scripts/validate-cursor-markdown-links.mjs --context=source
node ../scripts/validate-cursor-markdown-links.mjs --context=synced
node ../scripts/validate-cursor-markdown-links.mjs --context=agents
cd website && npm run build
```

## Improvements (Out of Scope)

- Generowanie sekcji „Skills Loaded” z `skills/overview.md` (skrypt)
- Osobne strony `website/docs/rules/` dla kart `.mdc`
- Linki GitHub do plików `.cursor/rules/` z kart agentów

## Szacunek nakładu

| Faza | Szacunek |
| ---- | -------- |
| 0 | ~15 min |
| 1 (walidator) | ~1 h |
| 2 (karty) | ~1.5 h |
| 3 (overview) | ~30 min |
| 4–5 (docs + QA) | ~45 min |
| **Razem** | **~3–4 h** |

## Kolejność wdrożenia (rekomendowana)

1. Akceptacja [Decyzji produktowych](#decyzje-produktowe-do-akceptacji-przed-implementacją)
2. Phase 1 (walidator + package.json)
3. Phase 2.1 → 2.7 (karty)
4. Phase 3 → 4 → 5

## Changelog

| Date       | Change Description        |
| ---------- | ------------------------- |
| 2026-05-18 | Initial plan created      |
| 2026-05-18 | Implementacja zakończona — agents links + walidator `--context=agents` + build OK |
