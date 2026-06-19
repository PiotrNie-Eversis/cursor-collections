# Research: porównanie Cursor Collections z upstream Copilot Collections (TSH)

**Data:** 2026-06-12 (pierwsza wersja) · **Aktualizacja delta:** 2026-06-12 (ponowny przegląd upstream) · **Nazewnictwo Fine handoff:** 2026-06-12 (`eversis-qa-comment` → `eversis-fine-handoff` — decyzja human, implementacja rename w osobnym PR)  
**Faza:** Research (`@eversis-implement`)  
**Język zadania:** polski; artefakt po polsku, ścieżki repo po angielsku.

**Upstream:** [TheSoftwareHouse/copilot-collections](https://github.com/TheSoftwareHouse/copilot-collections) — dokumentacja: [copilot-collections.tsh.io](https://copilot-collections.tsh.io/)  
**Baseline upstream (bez zmian):** `30251c6` — merge PR **#65** `feat/architect-as-advisor` (2026-06-09)  
**Ten fork:** Cursor Collections — agent **Cursor** (`.cursor/`, MCP `eversis-collections`, `setup-cursor-local.sh`).

---

## Aktualizacja delta (ponowny przegląd upstream)

**Werdykt:** na gałęzi **`main`** upstream **nie doszły nowe commity** od pierwszego researchu. Baseline `30251c6` nadal opisuje stan `main`.

**Co się zmieniło od 2026-06-12:**

| Obszar | Zmiana |
| ------ | ------ |
| **`main` upstream** | Bez zmian — HEAD nadal `30251c6` (weryfikacja: pełny clone + [GitHub API](https://api.github.com/repos/TheSoftwareHouse/copilot-collections/commits/main)) |
| **Otwarte PR upstream** | **9** otwartych PR-ów (stan 2026-06-12) — istotna praca **poza `main`**, głównie Implement / plan contract (patrz tabela poniżej) |
| **Cursor Collections (lokalnie)** | Commit `4ad714a` — `website/docs/integrations/eversis-collections.md` (dokumentacja MCP); **nie** pochodzi z upstream Copilot |

**Wniosek:** rekomendacje P0–P2 z pierwszej wersji **pozostają aktualne** względem `main`. Plan portu warto **rozszerzyć** o elementy z otwartych PR **#63, #66, #67, #68** (self-contained plans + orchestration skill) — to ewolucja tego samego kierunku, nie sprzeczna zmiana.

### Otwarte PR upstream (niezmergowane — stan 2026-06-12)

| PR | Tytuł (skrót) | Istotność dla Cursor | Port? |
| -- | ------------- | -------------------- | ----- |
| [**#66**](https://github.com/TheSoftwareHouse/copilot-collections/pull/66) | Skill `tsh-orchestrating-implementation` — kanoniczny workflow EM zamiast duplikacji w agencie + `tsh-implement` | **Wysoka** — lepszy wzorzec dla Cursor niż kopiowanie długiego executable promptu | Tak → `eversis-orchestrating-implementation` + odchudzenie `eversis-implement.md` |
| [**#67**](https://github.com/TheSoftwareHouse/copilot-collections/pull/67) | Kontrakt architect ↔ plan-reviewer; split skill `tsh-creating-implementation-plans` | **Wysoka** — uzupełnia P0 Plan Reviewer | Tak, razem z fazą A |
| [**#63**](https://github.com/TheSoftwareHouse/copilot-collections/pull/63) | Self-contained plans: glossary, traps, bogatsze task guidance | **Wysoka** — rozszerza P0 Technical Context | Tak, w fazie plan template |
| [**#68**](https://github.com/TheSoftwareHouse/copilot-collections/pull/68) | `Files:` per task, runnable command w DoD, WIG w planie | **Wysoka** — mechaniczna egzekucja planu przez słabsze modele | Tak, po #63/#67 |
| [**#69**](https://github.com/TheSoftwareHouse/copilot-collections/pull/69) | Agent **Technical Writer** + `tsh-writing-documentation` | Średnia — nowy playbook, brak w Cursor | Rozważyć (P2) jeśli zespół potrzebuje |
| [**#50**](https://github.com/TheSoftwareHouse/copilot-collections/pull/50) | QA Engineer + skille (a11y audit, regression, Jira admin, bug analysis) | Średnia — **brak kolizji** z `eversis-fine-handoff` (inna warstwa SDLC) | Cherry-pick wybranych skilli → `eversis-qa-workflow` / `eversis-*-testing`; nie zastępować Fine handoff |
| [**#51**](https://github.com/TheSoftwareHouse/copilot-collections/pull/51) | Skill **`implementing-filters`** (URL sync + kontrakt TSH DataGrid) | Niska — domenowa (listy/filtry w URL); overlap API z [`eversis-implementing-backend`](../../../.cursor/skills/eversis-implementing-backend/SKILL.md) | Port jako `eversis-implementing-filters` tylko gdy consumer stack wymaga DataGrid + shareable URL |
| **#48, #37** | Knowledge agents, Copilot marketplace plugin | Niska dla Cursor | Nie portować (Copilot-only) |

**Kolejność zależności upstream (PR):** #66 (orchestration skill) ← #67 (plan contract) ← #63/#68 (plan shape). Przy portowaniu do Cursor **nie** cherry-pickować pojedynczych plików z PR — lepiej zsynchronizować **pakiet plan+orchestration** po merge do `main` TSH albo portować z gałęzi PR jako jedna faza.

---

## Cel

Odpowiedzieć: **czy zmiany w upstream Copilot Collections po rozgałęzieniu są wartościowe do przeniesienia do Cursor Collections**, przy założeniu:

- oba frameworki działają na **różnych agentach** (GitHub Copilot vs Cursor) — **brak portu 1:1**;
- porty mogą **tylko ulepszać** działającą paczkę — **nie psuć** istniejących kontraktów (Fine → handoff draft via `eversis-fine-handoff`, MCP skills, setup consumer, `eversis-project-stack.mdc`).

---

## Metodologia

1. Shallow clone upstream (`main`, commit `30251c6`, 2026-06-09 — merge PR **#65 feat/architect-as-advisor**).
2. Porównanie struktury, promptów, skilli, workflow docs i CHANGELOG.
3. Heurystyka podobieństwa treści skilli (normalizacja prefiksu `tsh-` → `eversis-`).
4. Odniesienie do wcześniejszego researchu w tym repo ([`readme-workflows-section.research.md`](../readme-workflows-section/readme-workflows-section.research.md), [`cursor-collections-sync.research.md`](../cursor-collections-sync/cursor-collections-sync.research.md)).

**Uwaga historyczna:** `main` upstream to nadal **jeden duży merge** PR #65 (~46k LOC) jako baza. Po nim TSH rozwija framework w **otwartych PR** (#63–#69), jeszcze nie na `main`.

**Metoda ponownego przeglądu (2026-06-12):** pełny clone `main`, GitHub API `commits/main`, lista `pulls?state=open`, lokalny fetch gałęzi PR #63/#66/#67/#68/#69 do porównania diffów.

---

## Werdykt w skrócie

| Kategoria | Ocena |
| --------- | ----- |
| Warto portować (wysoki ROI, niskie ryzyko) | **Plan Reviewer**, **Technical Context + self-contained plan** (PR #63/#68), **skill `eversis-orchestrating-implementation`** (PR #66), **Quick vs Full flow**, **odbudowa `eversis-task-quality-reviewing`**, **Gate 0 / intent-brief** |
| Warto rozważyć (średni ROI) | **`eversis-creating-implementation-plans`** (split z architecture-designing, PR #67), **`eversis-explore-materials`**, **task-baseline + post-push verification**, **Technical Writer** (PR #69), **wybrane QA skille** (PR #50) |
| Opcjonalnie / domenowe (niski ROI) | **`eversis-implementing-filters`** (PR #51) — listy z filtrami w URL (React/Next); kontrakt API już częściowo w `eversis-implementing-backend` |
| Nie portować / Copilot-only | **BA worker subagents**, **`.github/agents` + handoffs + model YAML**, **user settings `chat.*`**, **usuwanie rozszerzeń Cursor-only** |
| Cursor już **przed** upstreamem | **MCP skills**, **setup-cursor-local**, **Fine handoff** (`eversis-fine-handoff`), **BA Docs (.docx)**, **STRICT FORBIDDEN w code review**, **ochrona stack rule**, **walidacja linków** |

**Rekomendacja:** plan implementacji fazowy — najpierw **Implement + Plan Review** (największy wpływ na jakość delivery), potem **Ideate (BA + task-quality-reviewing)**, na końcu docs/website. **Nie** scalać struktury katalogów z upstream (`.github/` vs `.cursor/`).

---

## Kontekst rozjazdu architektury

| Aspekt | Copilot Collections (upstream) | Cursor Collections (ten repo) |
| ------ | -------------------------------- | ----------------------------- |
| Artefakty agenta | `.github/agents/*.agent.md`, `.github/prompts/*.prompt.md`, `.github/skills/` | `.cursor/rules/*.mdc`, `.cursor/prompts/{public,internal}/`, `.cursor/skills/`, `.cursor/commands/` |
| Delegacja | Copilot subagents, `runSubagent`, `handoffs`, `vscode/askQuestions` | `@` prompty, role rules, jedna sesja Agent / osobne tury |
| Skills w runtime | `chat.agentSkillsLocations` + folder `.github/skills` | MCP `eversis_skills_*` (nie rejestrować folderu jako Cursor Agent Skills) |
| Instalacja | User Settings JSON + skopiuj `.vscode/mcp.json` | `scripts/setup-cursor-local.sh`, vendor/submodule, merge MCP |
| Prompty publiczne | 14 (`tsh-*`, + `tsh-explore-materials`) | 14 (`eversis-*`, + **BA Docs** planner/writer, **bez** explore-materials) |
| Skille | 32 pakiety `tsh-*` | 35 pakietów `eversis-*` (+ **fine-handoff**, **ba-docs-***) |
| Agenty dokumentowane | 18 (w tym **plan-reviewer**, 5× BA workers) | 17 stron agents ( **brak plan-reviewer**; **cursor-customization-*** zamiast copilot-*) |

Prefiks: mapowanie **`tsh-*` → `eversis-*`** jest stabilne ([`documentation/cursor-collection.md`](../../../documentation/cursor-collection.md) Part A).

---

## Co Cursor Collections ma **ponad** upstream

Te elementy **nie należy** degradować przy porcie:

1. **`mcp/eversis-collections-mcp/`** — list/read/validate skills, `.docx` tools, allowlisted scripts.
2. **`scripts/setup-cursor-local.sh`** — symlink/copy/vendor, `--sync`, `--build-mcp`, ochrona `eversis-project-stack.mdc`.
3. **Kontrakt Fine → handoff draft** — [`eversis-fine-handoff`](../../../.cursor/skills/eversis-fine-handoff/SKILL.md), [`eversis-implement`](../../../.cursor/prompts/public/eversis-implement.md) krok 10. Treść outputu pozostaje **QA comment** dla działu QA; nazwa skilla kotwiczy **moment** (Fine), nie rolę QA Engineer.
4. **Business Manager Docs** — `eversis-ba-docs-planner` / `eversis-ba-docs-writer` (brak w upstream).
5. **Code review — STRICT FORBIDDEN** w [`eversis-code-reviewing`](../../../.cursor/skills/eversis-code-reviewing/SKILL.md) + [`eversis-code-reviewer.mdc`](../../../.cursor/rules/eversis-code-reviewer.mdc) (upstream tego nie ma w skillu).
6. **Walidacja linków** — `validate-cursor-markdown-links.mjs`, CI, `sync-prompts`.
7. **Instalacja consumer** — rozbudowany [`website/docs/getting-started/installation.md`](../../../website/docs/getting-started/installation.md) vs krótki upstream.
8. **Dokumentacja MCP na docs site** — [`website/docs/integrations/eversis-collections.md`](../../../website/docs/integrations/eversis-collections.md) (lokalny commit `4ad714a`; upstream Copilot **nie** ma odpowiednika — to rozszerzenie Cursor-only).

---

## Zmiany upstream **warto** przenieść (priorytet)

### P0 — Implement / Plan (najwyższy wpływ, umiarkowane ryzyko)

#### 1. Plan Reviewer (`tsh-review-plan` → `eversis-review-plan`)

**Stan upstream:** osobny agent `tsh-plan-reviewer`, internal prompt `tsh-review-plan.prompt.md`, artefakt `{task}.plan-review.md`, werdykt `APPROVED` | `REVISIONS NEEDED`, max 3 iteracje z Architect, fazy: challenge domains, failure modes, hidden assumptions, codebase-reality, sequencing.

**Stan Cursor:** brak internal promptu, brak strony `website/docs/agents/plan-reviewer.md`, [`standard-flow.md`](../../../website/docs/workflow/standard-flow.md) **nie** wspomina plan validation.

**Port (Cursor):**

- Dodać `.cursor/prompts/internal/eversis-review-plan.md` (treść z upstream, prefiks skills, ścieżka `docs/specs/` zamiast tylko `specifications/`).
- Rozszerzyć executable prompt w `eversis-implement.md` — krok po planie: delegacja review-plan (jak upstream Full flow step 2).
- Opcjonalnie krótka reguła w `eversis-engineering-manager.mdc` lub doc agenta (Cursor nie ma `.agent.md`).
- Zaktualizować `website/docs/workflow/standard-flow.md` i `frontend-flow.md`.

**Ryzyko:** dodatkowy czas przed kodem; **mitigacja:** skip gdy plan już ma `.plan-review.md` z `APPROVED` i nie zmieniono planu (upstream ma ten warunek).

**Wartość:** redukcja kosztownego reworku — bezpośrednio adresuje wymaganie „nie psuć, tylko ulepszać”.

---

#### 2. Sekcja **Technical Context** + plan self-contained (PR #63, #68 — nad `main`)

**Stan upstream `main`:** `tsh-plan.prompt.md` kroki 4–5 + sekcja w `plan.example.md` — Architect **persistuje** konwencje repo w planie; EM **pomija** ponowną analizę codebase jeśli sekcja jest wypełniona (`tsh-implement` Full flow step 5).

**Stan upstream PR #63/#68 (otwarte):** dodatkowo **Glossary / Ubiquitous Language**, **Traps and Warnings**, **Wildly Important Goal**, **Files:** per task, **runnable command** w Definition of Done, fazy z **Verification** powiązane z Technical Context.

**Stan Cursor:** [`eversis-plan.md`](../../../.cursor/prompts/internal/eversis-plan.md) **bez** kroków persist; [`plan.example.md`](../../../.cursor/skills/eversis-architecture-designing/plan.example.md) **bez** sekcji Technical Context; EM zawsze „Delegate codebase analysis” ([`eversis-implement`](../../../.cursor/prompts/public/eversis-implement.md) krok 5).

**Port:** uzupełnić `eversis-plan.md`, `plan.example.md` (najlepiej wzorować na PR #68 po merge lub jako jeden pakiet z #63), logikę w `eversis-implement.md` / przyszłym orchestration skill (warunkowy skip analizy).

**Ryzyko:** niskie — additive; większy szablon planu = dłuższe tury Architect (akceptowalne).

---

#### 2b. Skill **`eversis-orchestrating-implementation`** (PR #66 — nad `main`)

**Stan upstream PR #66:** workflow Implement (Quick/Full, todos, plan review loop, UI gate, routing) wyciągnięty do skillu `tsh-orchestrating-implementation`; `tsh-implement.prompt.md` i `tsh-engineering-manager.agent.md` odchudzone do „trigger + WHO”.

**Stan Cursor:** cała mechanika w executable prompt [`eversis-implement.md`](../../../.cursor/prompts/public/eversis-implement.md) (~115 linii) + [`eversis-engineering-manager.mdc`](../../../.cursor/rules/eversis-engineering-manager.mdc).

**Port (Cursor):** nowy `.cursor/skills/eversis-orchestrating-implementation/SKILL.md`; `eversis-implement` deleguje do skillu przez MCP `eversis_skills_get` lub `@` w prompcie; **zachować** krok 10 Fine → `eversis-fine-handoff` (Cursor-only, nie w upstream).

**Wartość:** jeden SSOT orchestracji, łatwiejsze utrzymanie po portach #63–#68; Quick Flow z tabelą warunków (w tym **hard exclusion** dla Figma/UI).

**Ryzyko:** refaktor promptu EM — testować na 2–3 zadaniach przed rollout do consumerów.

---

#### 3. **Quick vs Full** Implementation Flow

**Stan upstream:** `tsh-implement` Step 0 — ocena złożoności, rekomendacja Quick (bugfix, mała zmiana) vs Full (research → plan → plan review → …).

**Stan Cursor:** tylko Full flow (bez brancha Quick).

**Port:** dodać Step 0 do executable prompt `eversis-implement.md`; Quick flow: implement → quality checks → `@eversis-review` (bez pełnego research/plan gdy user potwierdzi).

**Ryzyko:** użytkownik może nadużywać Quick na dużych zadaniach — **mitigacja:** jasne kryteria w prompcie + EM pyta w czacie.

**Wartość:** lepsze UX dla małych fixów bez obchodzenia frameworku.

---

### P1 — Ideate / BA (duży gap treści skilli)

#### 4. **`eversis-task-quality-reviewing` — stub vs pełny skill**

**Fakt:** Cursor ma **18 linii** proceduralnych; upstream **344 linie** (Lite/Full mode, domain model, Jira board enrichment, klasyfikacja sugestii, `quality-review.example.md` workflow).

**To najpoważniejszy regres vs upstream w warstwie Ideate.** Publiczny prompt [`eversis-analyze-materials`](../../../.cursor/prompts/public/eversis-analyze-materials.md) **zakłada** pełny quality review — skill tego nie dostarcza.

**Port:** przenieść treść upstream → `eversis-task-quality-reviewing/SKILL.md` (prefiks, ścieżki `docs/specs/`), zachować przykłady w folderze skillu.

**Ryzyko:** dłuższe tury BA — akceptowalne (jakość > skrót).

---

#### 5. Gate 0 + **`intent-brief.md`**

**Stan upstream:** przed ekstrakcją — `intent-brief.md`, Gate 0, rozszerzony [`tsh-task-extracting`](https://github.com/TheSoftwareHouse/copilot-collections/blob/main/.github/skills/tsh-task-extracting/SKILL.md) (source traceability, scenario-based AC).

**Stan Cursor:** Gates 1, 1.5, 2 only ([`business-analyst.md`](../../../website/docs/agents/business-analyst.md)); [`eversis-task-extracting`](../../../.cursor/skills/eversis-task-extracting/SKILL.md) krótszy o ~32 linie procedury.

**Port (fazowo):**

- Rozszerzyć `eversis-task-extracting` + `eversis-analyze-materials` executable (kroki intent brief + Gate 0).
- Zaktualizować docs (4-gate → opcjonalnie Gate 0 przed Gate 1).

**Opcjonalnie:** publiczny `eversis-explore-materials.md` (upstream ma osobny prompt) — wcześniejszy research zalecał **nie** dodawać bez potrzeby ([`readme-workflows-section.research.md`](../readme-workflows-section/readme-workflows-section.research.md)); teraz upstream ma to jako first-class — **warto rozważyć** jako osobny `@` prompt, nie wymagany domyślnie.

**Ryzyko:** więcej bramek = więcej tarcia; Gate 0 można **pominąć** gdy materiały są już jasne (upstream też to implikuje).

---

#### 6. **Task baseline + post-push verification**

**Stan upstream:** `specifications/projects/<project>/task-baseline.md`, kroki 13–14 w analyze-materials (read-back Jira, archive, baseline refresh).

**Stan Cursor:** brak w prompcie BA; częściowo pokryte **Protected Status** w [`jira-task-formatting`](../../../website/docs/skills/jira-task-formatting.md) docs.

**Port:** rozszerzyć `eversis-jira-task-formatting` SKILL + executable analyze-materials.

**Ryzyko:** niskie; ścieżki baseline ujednolicić z `docs/specs/` vs `specifications/` (Cursor preferuje `docs/specs/` w nowych artefaktach).

---

### P2 — Drobne ulepszenia / docs

| # | Zmiana upstream | Port Cursor | Uwagi |
| - | --------------- | ----------- | ----- |
| 7 | Architect: terminal **read-only** (no build/test) | Wskazówki w skillu architecture-designing lub doc architect | Zapobiega „Architect implementuje” w Cursor |
| 8 | `tsh-code-reviewing`: mocniejszy nacisk na integration tests | **Merge selektywny** — Cursor ma już STRICT FORBIDDEN; dodać akapit o integration coverage **bez** usuwania scope/dep checks | |
| 9 | Standard flow: „plan validation” w diagramie | Docs only | Spójność z P0 |
| 10 | README: „Ask Copilot to configure itself” | **Adaptacja:** „Ask Cursor Agent to run `setup-cursor-local.sh`” w installation | Nie kopiować JSON Copilot settings |
| 11 | `for-ctos.md` z metrykami TSH (300+ eng, 30% lead time) | Cursor ma wersję bez liczb TSH — **opcjonalnie** dodać disclaimer + metryki jeśli Eversis ma approval | Marketing, nie runtime |
| 12 | **Technical Writer** (PR #69) | **`eversis-repo-docs-writer`** + **`eversis-writing-repo-documentation`** (nie `ba-docs`, nie samo „technical writer”) | Repo markdown po Implement; patrz § Konwencja nazewnictwa |
| 13 | **QA skille** (PR #50) | Np. `eversis-qa-workflow`, regression-risk, a11y-auditing — **osobna warstwa** od `eversis-fine-handoff` | Pełna praktyka QA; Fine handoff tylko szkic Jira po Implement |
| 14 | **`implementing-filters`** (PR #51) | `eversis-implementing-filters` + `references/react-patterns.md`, `nextjs-patterns.md` | **Nie** scalać z backend skill — cross-link; patrz § PR #51 poniżej |

#### PR #51 — `tsh-implementing-filters` (nie „backend filters”)

**Stan upstream PR #51:** skill `tsh-implementing-filters` (~330 linii) + referencje React Router / Next.js App Router. **Software Engineer** ładuje go przy zadaniach filtrowalnych list (obok `implementing-frontend`, `implementing-forms`, `writing-hooks`).

**Zakres (~70% frontend, ~30% kontrakt API):**

| Warstwa | Co definiuje skill |
| ------- | ------------------ |
| URL / UI | Schema TS, bracket notation, hook `useFilters`, push vs replace, path-vs-query, anti-patterny (`useState` zamiast URL) |
| API | Domyślny kontrakt TSH (`filter[field]`, OR/AND, `meta` echo) + adaptacja pod zewnętrzne API |

**Overlap z Cursor:** sekcja **DataGrid: Filtering, Sorting & Pagination** w [`eversis-implementing-backend`](../../../.cursor/skills/eversis-implementing-backend/SKILL.md) pokrywa **kontrakt query/response** (często bogatszy — operatory `eq`, `in`, …). **Brakuje** w Cursor dedykowanego playbooku URL-sync / hooków — `eversis-implementing-frontend` tego nie ma.

**Port:** osobny skill `eversis-implementing-filters`; w backend skill ewentualnie jednolinijkowy pointer: *kontrakt API → backend; URL/hooki → implementing-filters*. Tylko dla consumerów z DataGrid + shareable URL w React/Next.

---

## Zmiany upstream **nie** portować (lub tylko jako inspiracja docs)

| Element upstream | Dlaczego nie 1:1 |
| ---------------- | ---------------- |
| **5× BA worker agents** (`tsh-ba-transcript-worker`, …) + multi-model strategy | Copilot subagents + przypisanie modeli; Cursor nie ma tego samego API; koszt utrzymania 5 plików rules bez subagent routing |
| **`.github/agents/*.agent.md`** (tools, handoffs, model) | Zastąpione przez `.cursor/rules` + `@` prompty; duplikacja zwiększy drift |
| **`user-invocable: false`** na skillach | Metadane Copilot Skills |
| **`vscode/askQuestions`** | W Cursor: pytania w czacie / `AskQuestion` — nie ten sam kontrakt |
| **User Settings** (`chat.promptFilesLocations`, …) | Copilot-only; Cursor używa workspace + setup script |
| **Handoff buttons** (Architect → EM) | UX Copilot; w Cursor: human gate + `@eversis-implement` |
| **Usunięcie / osłabienie code review checks** | Regresja względem Cursor STRICT FORBIDDEN |

---

## Porównanie skilli (podobieństwo treści)

Skille z **istotną różnicą** (<0.92 similarity po normalizacji prefiksu):

| Skill | Uwaga |
| ----- | ----- |
| `eversis-task-quality-reviewing` | **Krytyczny stub w Cursor** — port P1 |
| `eversis-task-extracting` | Gate 0, intent brief, baseline — port P1 |
| `eversis-creating-agents/instructions/prompts/skills` | **Oczekiwany drift** — Cursor docs opisują `.cursor/rules`, nie `.github/agents` — **nie** ślepo nadpisywać upstreamem |
| `eversis-code-reviewing` | Cursor **bogatszy** (STRICT FORBIDDEN) — tylko cherry-pick integration-test guidance |
| `eversis-technical-context-discovering` | Lekki drift — porównać przy P0 Technical Context |
| `eversis-implementing-filters` *(brak w Cursor)* | Upstream PR #51 — **nowy** skill; overlap API z `eversis-implementing-backend` (DataGrid); unikalna wartość: URL-sync / hooki |

Skille **tylko w Cursor** (utrzymać): `eversis-fine-handoff`, `eversis-ba-docs-planner`, `eversis-ba-docs-writer`.

---

## Ryzyka portu (globalne)

| Ryzyko | Mitigacja |
| ------ | --------- |
| Regresja kontraktu Fine → handoff | Nie edytować kroku 10 `eversis-implement` przy merge upstream implement; przy rename `qa-comment` → `fine-handoff` — osobny PR + migration note dla consumerów |
| Podwójna analiza codebase (plan + EM) | Technical Context + conditional skip |
| Zbyt długi Plan Review na małych taskach | Quick flow + skip approved plan-review |
| Drift docs vs `.cursor/` | `sync-prompts`, `validate-cursor-links`, aktualizacja `website/docs/workflow/*` w tym samym PR co prompty |
| Ścieżki `specifications/` vs `docs/specs/` | W portach preferować **`docs/specs/<kebab>/`** (konwencja tego repo); wspomnieć alias w promptach |
| Brakujące `eversis-role-*.mdc` (docs linkują, pliki nie istnieją) | Osobny cleanup — **nie** blokera portu P0, ale docs drift do naprawy |

---

## Proponowana kolejność planu (po akceptacji research)

| Faza | Zakres | Akceptacja |
| ---- | ------ | ---------- |
| **0** | Rename `eversis-qa-comment` → `eversis-fine-handoff` (skill, docs, rules, MCP refs, CHANGELOG migration note) | Wszystkie normatywne linki wskazują nowy stem; `eversis_skills_get` zwraca nowy ID |
| **A** | `eversis-review-plan` + split `eversis-creating-implementation-plans` (PR #67) + `plan.example` (Technical Context + PR #63/#68 pola) + workflow docs | Plan review + self-contained plan; `.plan-review.md` z werdyktem |
| **A′** | `eversis-orchestrating-implementation` (PR #66) + integracja w `eversis-implement` / EM rule | Orchestracja w skillu; Fine → `eversis-fine-handoff` bez regresji |
| **B** | Quick/Full (w orchestration skill) | User może wybrać Quick; Figma/UI wymusza Full |
| **C** | Odbudowa `eversis-task-quality-reviewing` + sync analyze-materials | Gate 1.5 produkuje pełny `quality-review.md` jak w upstream |
| **D** | Gate 0 / intent-brief / task-extracting / opcjonalnie explore-materials | BA docs + gates spójne |
| **E** | Baseline + post-push verification | Import/push cycle z read-back |
| **F** | Docs/marketing (plan-reviewer page, architect read-only) | Linki przechodzą `validate-cursor-links` |

Każda faza: osobny PR, testy skryptów gdzie dotyczy, **brak** zmian w MCP API bez potrzeby.

---

## Konwencja nazewnictwa — Fine handoff vs QA practice (bez kolizji)

**Decyzja (2026-06-12):** skill `eversis-qa-comment` → **`eversis-fine-handoff`**. Powód: nazwa `qa-comment` sugerowała pełną praktykę QA (plan testów, regresja, Jira admin), podczas gdy skill to **wyłącznie** obowiązkowy szkic komentarza Jira w **tym samym turnie** co status **Fine** na końcu Implement.

| Warstwa | Etykieta | Skill / prompt | Moment SDLC | Output |
| ------- | -------- | -------------- | ----------- | ------ |
| **Fine handoff** | Implement handoff (dla QA) | `eversis-fine-handoff` | Koniec `@eversis-implement` — **Fine** | `Draft QA comment — review before posting to Jira` (treść nadal QA-oriented) |
| **QA practice** *(port PR #50)* | QA workflow | `eversis-qa-workflow` + skille (`eversis-planning-tests`, `eversis-analyzing-regression-risk`, …) | Osobny `@` — przed/po/w trakcie testów | Plan testów, regresja, AC table, bug report, a11y audit |

**Zasady:**

1. **Nie** scalać `eversis-fine-handoff` z `eversis-qa-workflow` — różne momenty i artefakty.
2. **Nagłówek draftu** i sekcje w treści (`QA Summary`, `Verification List`) **bez zmian** — odbiorca to dział QA; zmienia się tylko **ID skilla** i ścieżka folderu.
3. **Docs site:** `website/docs/skills/qa-comment.md` → `fine-handoff.md` (w PR rename); w research linkujemy docelową ścieżkę.
4. **MCP:** `eversis_skills_get` po rename zwraca `eversis-fine-handoff` — consumer repos muszą zaktualizować rules/commands wskazujące na stary stem.
5. **Pointer w skillu** (po rename): pełny plan testów → `@eversis-qa-workflow`; ten skill tylko handoff po Fine.

**Overlap z upstream PR #50 — werdykt:** wąski (Jira comment + luźna lista kroków manualnych). Upstream **nie** ma kontraktu Fine → draft; port QA **nie zastępuje** `eversis-fine-handoff`.

**Rename (osobny PR, przed lub równolegle z portem QA):**

| Było | Będzie |
| ---- | ------ |
| `.cursor/skills/eversis-qa-comment/` | `.cursor/skills/eversis-fine-handoff/` |
| `qa-comment.example.md` | `fine-handoff.example.md` |
| `website/docs/skills/qa-comment.md` | `website/docs/skills/fine-handoff.md` |
| `eversis_skills_get("eversis-qa-comment")` | `eversis_skills_get("eversis-fine-handoff")` |

---

## Konwencja nazewnictwa — dwa kanały dokumentacji (bez kolizji)

Dwa niezależne playbooki dokumentacyjne **nie powinny** dzielić etykiety „technical writer” bez kwalifikatora. Przyjęta konwencja (stemy `@` **stabilne** — bez breaking rename poza uzgodnionym `eversis-fine-handoff`):

| Kanał | Etykieta (UI / docs) | Prompty `@` | Skill(e) | Format | Narzędzia | Kiedy używać |
| ----- | -------------------- | ----------- | -------- | ------ | --------- | ------------ |
| **BA Docs (Word)** | Business Manager Docs — Word Planner / Word Writer | `eversis-ba-docs-planner`, `eversis-ba-docs-writer` | `eversis-ba-docs-planner`, `eversis-ba-docs-writer` | `.docx` (OOXML) | MCP `eversis-collections` (`.docx` tools) | Release Jira + reguły Confluence → `docs-update-plan.md` → edycja Word |
| **Repo Docs** *(planowany port upstream PR #69)* | Repo documentation writer | `eversis-repo-docs-writer` *(rezerwacja)* | `eversis-writing-repo-documentation` *(rezerwacja)* | README, CHANGELOG, `/docs`, `website/` | `read` / `edit` + `npm run build` / `validate-cursor-links` | Task z planu Implement: opis zmian w repo po dostarczeniu kodu |

**Zasady:**

1. **Nie używać** samodzielnie: „Technical Writer”, „documentation writer”, „Writer” — zawsze z kwalifikatorem **(Word)** lub **(Repo)**.
2. **Nie portować** upstream `tsh-technical-writer` / `tsh-writing-documentation` pod tymi samymi nazwami — mapowanie: `tsh-*` → `eversis-repo-docs-*` / `eversis-writing-repo-documentation`.
3. **`eversis-ba-docs-*` zostaje** — stem jest już rozróżniający; doprecyzowujemy tylko **tytuły**, **role w `.mdc`** i **playbook docs** (nie zmiana plików promptów).
4. **Wzajemne wykluczenie w regułach:** BA Docs Writer → *nie* README/website; Repo Docs Writer → *nie* `.docx` / MCP chapter tools.
5. **Playbook:** [Business Manager Docs](../../../website/docs/workflow/business-manager-docs.md) = wyłącznie kanał Word; Repo Docs = przyszły rozdział w workflow Implement / osobna strona agents.

**Upstream vs Cursor (nazwy):**

| Upstream (Copilot) | Cursor (docelowe) |
| ------------------ | ----------------- |
| `tsh-technical-writer` | Repo Docs writer (nie „BA Docs”) |
| `tsh-writing-documentation` | `eversis-writing-repo-documentation` |
| `tsh-write-documentation.prompt.md` | `eversis-repo-docs-writer` (public lub internal) |
| *(brak)* | `eversis-ba-docs-planner` / `eversis-ba-docs-writer` |

---

## Otwarte pytania (decyzja human)

1. **Gate 0 obowiązkowy czy opcjonalny** dla wszystkich workshopów, czy tylko gdy EM/BA wykryje niejednoznaczność?
2. **Plan Review zawsze w Full flow**, czy wyłączalny flagą / adnotacją w planie dla zespołów z krótkim SLA?
3. **Metryki TSH w `for-ctos.md`** — publikować w Cursor Collections czy zostawić neutralny wording Eversis?
4. **Czy tworzyć brakujące `eversis-role-*.mdc`** vs poprawić tylko docs agents (linki do istniejących rules)?
5. **Czy czekać na merge PR #63–#68 do upstream `main`** przed fazą A, czy portować z gałęzi PR teraz?
6. **Faza 0 (rename fine-handoff)** — przed portem QA (PR #50) czy może równolegle z fazą A?

---

## Źródła

| Temat | Ścieżka |
| ----- | ------- |
| Mapowanie tsh → eversis | [`documentation/cursor-collection.md`](../../../documentation/cursor-collection.md) |
| Upstream implement (Full + Quick + plan review) | `copilot-collections/.github/prompts/tsh-implement.prompt.md` |
| Upstream plan review | `copilot-collections/.github/internal-prompts/tsh-review-plan.prompt.md` |
| Cursor implement (obecny) | [`.cursor/prompts/public/eversis-implement.md`](../../../.cursor/prompts/public/eversis-implement.md) |
| Wcześniejsza decyzja vs explore-materials | [`readme-workflows-section.research.md`](../readme-workflows-section/readme-workflows-section.research.md) |
| Sync consumer | [`cursor-collections-sync.research.md`](../cursor-collections-sync/cursor-collections-sync.research.md) |
| Upstream open PRs (stan 2026-06-12) | [#66](https://github.com/TheSoftwareHouse/copilot-collections/pull/66), [#67](https://github.com/TheSoftwareHouse/copilot-collections/pull/67), [#63](https://github.com/TheSoftwareHouse/copilot-collections/pull/63), [#68](https://github.com/TheSoftwareHouse/copilot-collections/pull/68), [#69](https://github.com/TheSoftwareHouse/copilot-collections/pull/69), [#51](https://github.com/TheSoftwareHouse/copilot-collections/pull/51) (`implementing-filters`) |
| Cursor MCP integration doc (lokalnie) | [`website/docs/integrations/eversis-collections.md`](../../../website/docs/integrations/eversis-collections.md) |

---

## Następny krok (bramka Implement)

Po **akceptacji** researchu:

- **Plan:** [`copilot-upstream-porting.plan.md`](./copilot-upstream-porting.plan.md) — fazy 0, A, A′, B–I, acceptance checks, decyzje domyślne.
- **Nie** rozpoczynać szerokich edycji `.cursor/` przed zatwierdzeniem planu.
- Kolejność: **Faza 0** (rename fine-handoff) → **Faza A** (plan review + template) — osobne PR.

**Status:** Research zaakceptowany; plan przygotowany — oczekuje na akceptację planu przed implementacją.
