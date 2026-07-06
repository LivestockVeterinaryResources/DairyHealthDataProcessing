# CLAUDE.md

Orientation for AI assistants (and a quick reference for people) working in this
repository. Keep this file current as conventions change.

## What this project is

This project is open, community-owned R tooling to improve cattle health and welfare through 
better, data-driven decisions. It turns raw dairy data exports into 
analysis-ready parquet files, and doubles as the codebase for a Posit/R teaching 
course. The pipeline produces a few example reports, but only to demonstrate 
the workflow. Turning the processed data into real, actionable insights remains 
the responsibility of those with enough context about the data to appropriately
interpret it.

See `README.md` for the data-processing walkthrough and
the `community/` folder for how the project is governed.  

## Repository conventions

- **File/dir naming: lowercase.** Name new files and folders in lowercase
  (e.g., `charter.md`, `governance.md`). Exceptions that MUST stay uppercase for
  tooling: `CLAUDE.md`, `LICENSE`, `CITATION.cff`, and GitHub-detected files.
- **Commits:** sign off with the Developer Certificate of Origin
  (`git commit -s` → `Signed-off-by:`). When an organization funded the work, add
  a `Supported by: <org>` trailer. See `.github/contributing.md`.
- **Markdown is tracked.** A previous blanket `*.md` rule in `.gitignore` was
  removed because it silently hid authored docs; only rendered intermediates
  (`*.knit.md`, `*.utf8.md`) are ignored. Do NOT re-add a blanket `*.md` ignore.
- **Paths & packages:** scripts use the `{here}` package for project-root-relative
  paths and are run from the project root. Package loading is centralized in
  `functions/fxn_pacman.R` (`pacman::p_load(...)`) — add new dependencies there.
- **Entry point:** `step0_master_processing.R` runs the processing pipeline.

## Branching

- `develop` — integration trunk (most active); features branch from and merge here.
- `main` — release/stable; updated from `develop` via PR.
- Feature branches (e.g., `nora_updates_for_course`) → PR into `develop`.
- `community-governance` — branch adding the `community/` governance docs
  (in review as of this writing).
- The `{here}`-package removal is intentionally **deferred**; it lives on the
  `design/gold-pipeline-notes` branch, not on `develop`.

## Governance & community

How the project is run — decision-making, contribution, sponsorship, conflict of
interest — is documented in `community/`. Start with `community/charter.md` and
`community/community_summary.md`. For the history and rationale behind the current
setup, read `community/decision_log.md`.

## Key principle for edits

This is a scientific, vendor-neutral project. Changes to how data is computed or
interpreted (metrics, denominators, classifications) get independent review and
must not favor any commercial interest. Support (time or funding) adds capacity
but never controls direction or analysis.
