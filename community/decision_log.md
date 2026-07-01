# decision log

A point-in-time record of the work and decisions made while establishing this
project's open-source community framework, written so a new contributor — or an
AI assistant — can pick up the context. This is a **snapshot, not living
documentation**; treat specifics as "true as of the date below."

- **Date:** 2026-06-30
- **Scope:** community/governance framework, repository tidy-up, and a `develop`
  history correction.
- **Status:** DRAFT — the community documents are proposed, not yet ratified.

## What was done

### 1. Community & governance framework (branch: `community-governance`)
Added founding documents defining an open, collaborative, vendor-neutral community
for improving cattle health and welfare:

- `community/`: `charter.md`, `governance.md`, `sponsorship.md`, `supporters.md`,
  `disclosures.md`, `community_summary.md`
- `.github/`: `contributing.md`, `code_of_conduct.md`
- root: `LICENSE`, `CITATION.cff`, plus a community intro paragraph and a
  "Supporters & contributors" section added to `README.md`
- `.gitignore`: removed a blanket `*.md` rule that was silently hiding authored
  markdown docs

This branch is pushed but **not yet merged**; it awaits community review and
ratification.

### 2. `develop` history correction
`develop` was reset to the June-4 state (the then-current `main`, commit
`a9061f5`) to **decouple an in-progress `{here}`-package removal** from other
work. That change set was not ready to ship, so it was taken off `develop` and
preserved on the `design/gold-pipeline-notes` branch for a future, deliberate
effort. New work (including course/excel examples merged via PR #123) was then
re-applied cleanly on top. Net effect: `develop` moved forward **without** the
premature `{here}` removal.

## Key decisions & rationale

- **Funding buys capacity, not control.** Organizations — including commercial
  ones — may fund contributor time on equal, public terms, with full disclosure
  and no governance rights or influence over methodology. This is the core
  credibility safeguard.
- **Distributed, merit-based governance:** a one-third cap on any single
  organization's steering-committee seats; maintainership earned by individuals
  (not assigned by employers); independent review of methodology changes; and
  conflict-of-interest disclosure with recusal.
- **Distributed copyright via the DCO** (no single-company CLA), preserving the
  permanent right to fork — the project can never be unilaterally closed or
  relicensed.
- **File organization:** bespoke governance docs live in `community/`;
  ecosystem-standard files sit where tools expect them (`LICENSE` and
  `CITATION.cff` at root, `contributing.md` and `code_of_conduct.md` in
  `.github/`).
- **Naming:** lowercase throughout, except tooling-mandated uppercase
  (`CLAUDE.md`, `LICENSE`, `CITATION.cff`).
- **Recognition model:** code contributors are credited automatically via
  GitHub's contributors graph; expertise/funding supporters in
  `community/supporters.md`; citable authorship in a curated `CITATION.cff`. No
  `AUTHORS` file (redundant with GitHub's graph and blind to non-code
  contributors).

## Sponsorship context (abstracted)

The framework was designed in anticipation of **industry/commercial sponsorship of
contributor time**, alongside the project's academic and clinical supporters. The
sensitivity: some potential sponsors have commercial interests in the domain, and
some maintainers have their own commercial relationships. The safeguards above —
equal terms, disclosure and recusal, capacity-not-control, distributed
governance, independent methodology review, and open/forkable code — exist
specifically so such support can be accepted **without biasing analysis or
capturing the project**. Specific sponsor names, amounts, and individuals'
commercial relationships are handled through `community/disclosures.md` and normal
disclosure processes, not recorded here.

## Open items / TODO

- Ratify the community documents and fill the `<TODO>` placeholders: enforcement
  contacts, steering-committee roster, the fourth course supporter, ORCIDs, the
  `LICENSE` SPDX id in `CITATION.cff`, and each person's self-confirmed
  `disclosures.md` entry.
- Open and merge the `community-governance` PR into `develop`.
- Decide the fate of the stray, untracked `functions/README.md` — an old,
  misplaced draft of an improved root README (it has a "Data flow at a glance"
  section and links written to resolve from the repo root). It has never been in
  git; it was only hidden by the old `*.md` ignore.
- Confirm the supporter list; add logos and individuals as appropriate.

## Working notes

- **Future sessions:** launch Claude Code rooted at
  `C:/GIT/DairyHealthDataProcessing` so repo context (`CLAUDE.md`, this file)
  loads correctly. Claude's private "memory" does not transfer between machines,
  users, or differently-rooted sessions — durable context belongs in the repo,
  like these files.
- New package dependencies go in `functions/fxn_pacman.R`; `readxl` was added
  there this session.
