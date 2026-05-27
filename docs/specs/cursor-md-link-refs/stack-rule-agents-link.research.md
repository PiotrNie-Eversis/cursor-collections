# Research: `validate-cursor-links` failure — broken `AGENTS.md` link in `eversis-project-stack.mdc`

**Data:** 2026-05-27  
**Faza:** Research (`@eversis-implement`) — **bez implementacji**  
**Trigger:** `website` `prebuild` / `validate-cursor-links` exit code 1 (terminal output, linie 58–75).

---

## Cel

Ustalić **źródło** błędu walidacji linków markdown i czy to regresja w frameworku, w pliku konsumenckim, czy w samym walidatorze.

---

## Werdykt (TL;DR)

| Pytanie | Odpowiedź |
| ------- | --------- |
| Co się psuje? | Jedyny broken link w `--context=source`: `[AGENTS.md](AGENTS.md)` w `.cursor/rules/eversis-project-stack.mdc` (linia 18) |
| Dlaczego? | Link względny bez `../../` — rozwiązuje się do `.cursor/rules/AGENTS.md`; plik jest w **root** repo (`AGENTS.md`) |
| Kto / kiedy wprowadził? | Commit **`6915c25`** (2026-05-27) — podmiana profilu stack rule na **earth-explorers-3d** w ramach commita o `--gitignore-agent-artifacts` |
| Czy walidator jest wadliwy? | **Nie** — zachowanie zgodne z [`scripts/validate-cursor-markdown-links.mjs`](../../../scripts/validate-cursor-markdown-links.mjs) (`resolveSource`: ścieżka względem katalogu pliku) |
| Czy `--context=synced` / `agents` też padają? | **Nie uruchamiają się** — pipeline kończy się na pierwszym broken link w `source` |

**Naprawa (znana konwencja):** `[AGENTS.md](AGENTS.md)` → `[AGENTS.md](../../AGENTS.md)` — patrz [cursor-md-link-refs.plan.md](./cursor-md-link-refs.plan.md) Task 1.1.

---

## Dowód z terminala

Komenda (z `website/package.json` → `validate-cursor-links`):

```text
node ../scripts/validate-cursor-markdown-links.mjs --context=source
```

Wynik:

```text
validate-cursor-markdown-links (source): 1 broken link(s)

  .cursor/rules/eversis-project-stack.mdc
    href: AGENTS.md
    resolved: .cursor/rules/AGENTS.md
```

Powtórzenie lokalne (2026-05-27): **identyczny wynik**, 1 błąd, exit code 1.

---

## Mechanizm walidatora

Plik: [`scripts/validate-cursor-markdown-links.mjs`](../../../scripts/validate-cursor-markdown-links.mjs)

- **`--context=source`** skanuje: `.cursor/commands/`, `.cursor/rules/`, `.cursor/prompts/`, `.cursor/skills/`.
- Dla href bez prefiksu `http:`, `mailto:`, `#`, `.cursor/`:
  - `target = path.resolve(dirname(pliku), href)` → dla `.cursor/rules/eversis-project-stack.mdc` i `AGENTS.md` → **`.cursor/rules/AGENTS.md`**.
- Kandydaci: plik, `*.md`, `*.mdc` — żaden nie istnieje.
- **`AGENTS.md`** istnieje tylko w **root** repozytorium (potwierdzone globem).

Wpięcie w CI docs: [`website/package.json`](../../../website/package.json) — `prebuild` / `prestart` → `validate-cursor-links` (source + synced + agents). Broken link w **source** blokuje **`npm run build`** w `website/`.

---

## Plik źródłowy problemu

```18:18:.cursor/rules/eversis-project-stack.mdc
| **Cursor framework** | Submodule **`third-party/cursor-collections`** — [`AGENTS.md`](AGENTS.md), rules **`/.cursor/rules/`**, prompts **`@eversis-*`**, **`eversis-collections`** MCP |
```

Linia 57 używa **`AGENTS.md`** tylko w backtickach (nie link markdown) — walidator **nie** flaguje.

---

## Historia git (regresja)

| Commit | Data | Zmiana `eversis-project-stack.mdc` |
| ------ | ---- | ----------------------------------- |
| `750cb27` | 2026-05-18 | **fix: fix markdown link validation** — profil **Cursor Collections** (Docusaurus); linki z `../../` do roota |
| `2aa01b8` | 2026-05-26 | Podmiana na profil **EOP** (consumer); bez linku `[AGENTS.md](AGENTS.md)` |
| **`6915c25`** | **2026-05-27** | Podmiana na profil **earth-explorers-3d**; **dodany** `[AGENTS.md](AGENTS.md)` bez `../../` |

Commit `6915c25` dotyczył głównie `--gitignore-agent-artifacts`; zmiana stack rule wygląda na **przypadkową materializację profilu konsumenckiego** w repo frameworku.

---

## Kontekst architektoniczny (poza samym linkiem)

`eversis-project-stack.mdc` jest **per-repo** — setup **nie nadpisuje** istniejącego pliku ([`link-framework.sh`](../../../scripts/lib/setup-cursor-local/link-framework.sh) `_handle_stack_rule`).

W **cursor-collections** (upstream framework) plik powinien opisywać **ten** monorepo (Docusaurus, `website/`, `sync-prompts`), nie earth-explorers-3d. Obecna zawartość to szablon **projektu konsumenckiego** (visuals-portal, submodule `third-party/cursor-collections`).

To **osobna decyzja produktowa** od naprawy linku:

| Opcja | Efekt |
| ----- | ----- |
| **A. Minimalna** | Tylko `../../AGENTS.md` — build przechodzi; profil earth-explorers zostaje w framework repo |
| **B. Przywrócenie profilu frameworku** | Przywrócić wersję Cursor Collections z `750cb27` (+ ewent. Fine→QA sekcja z późniejszych commitów) |
| **C. Szablon w `scripts/setup-cursor-local/templates/`** | Stack rule konsumenta w template; w repo frameworku trzymać profil Docusaurus |

Research **nie** wybiera opcji — wymaga akceptacji przed planem.

---

## Powiązane artefakty (już istniejące)

| Artefakt | Relevancja |
| -------- | ---------- |
| [cursor-md-link-refs.research.md](./cursor-md-link-refs.research.md) | Audyt 2026-05-18; rules bez `../../` |
| [cursor-md-link-refs.plan.md](./cursor-md-link-refs.plan.md) | Task 1.1/1.2 — mapowanie poprawek linków |
| [CHANGELOG.md](../../../CHANGELOG.md) | 2026-05-18 — walidator + fix linków w rules/commands |
| [cursor-collections-sync.research.md](../cursor-collections-sync/cursor-collections-sync.research.md) | Sync consumer; opcjonalna walidacja po update |

---

## Proponowany plan (po akceptacji researchu)

1. **[MODIFY]** `.cursor/rules/eversis-project-stack.mdc` — `[AGENTS.md](../../AGENTS.md)` (minimal fix).
2. **Opcjonalnie (decyzja):** przywrócić profil Cursor Collections lub przenieść earth-explorers do template setup.
3. **Verify:** `node scripts/validate-cursor-markdown-links.mjs --context=source` oraz `cd website && npm run validate-cursor-links` / `npm run build`.

---

## Decyzja (2026-05-27)

| Opcja | Status |
| ----- | ------ |
| **A** — tylko poprawka linku | Odrzucona |
| **B** — przywrócenie profilu Cursor Collections | **Zaakceptowana** |
| **C** — template setup dla konsumentów | Follow-up (out of scope) |

**Plan implementacji:** [stack-rule-restore-framework.plan.md](./stack-rule-restore-framework.plan.md)  
**Task 2.2** (aktualizacja `cursor-collections-sync.research.md`) — **Done** (2026-05-27).

## Status implementacji

- [x] Task 1.1 — przywrócono `.cursor/rules/eversis-project-stack.mdc` (profil frameworku)
- [x] Task 2.1 — decyzja w research (ten plik)
- [x] Task 2.2 — `cursor-collections-sync.research.md` (§5, werdykt, SSOT)
- [x] Task 3.1–3.2 — walidacja linków + build `website/` (OK)
