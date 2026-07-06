# Data Flow: step0 → Milestone 5

How data moves from the **entry point (`step0_master_processing.R`)**, through the processing
pipeline, into the artifacts that the **course milestones (weeks 1–5)** consume.

There are **three layers**:

0. **Entry & configuration** — `step0_master_processing.R` sets options and orchestrates the run.
1. **The processing pipeline** — `step1` → `step2` → `step3` turn raw CSVs into parquet artifacts in `data/intermediate_files/`.
2. **The milestones** — course exercises that each read one of those artifacts and rebuild/extend a slice of the work.

> **Teaching arc:** the milestones are *not* in pipeline order. **M5 reaches all the way back to the
> raw CSVs** (and re-derives what step1 does), while **M1 reads the most-processed table**
> (`animals.parquet`). Students learn the pipeline by rebuilding pieces of it.

---

## Layer 0 — Entry & configuration (`step0`)

You run **`step0_master_processing.R`**. It:

1. Sources **`functions/setup_default_processing_options.R`** for the default toggles, which you can override at the top of step0.
2. Sources package management (`fxn_pacman.R`) and, if `clean_up_old_files == TRUE`, wipes prior raw + processed data (`fxn_delete_files_clean_slate.R`).
3. Sources **`functions/fxn_process_files.R`**, which pulls denominator parameters from **`functions/setup_denominators.R`** and orchestrates the acquire → step1 → step2 → step3 sequence.
4. After processing, if `run_reports == TRUE`, renders the `qmd_reports/*` reports.

### Config toggles (`setup_default_processing_options.R`)

| Toggle | Default | Effect |
|---|---|---|
| `clean_up_old_files` | `TRUE` | Delete previously processed files **and** raw event files before running. Set `FALSE` when using your own data. |
| `get_EXAMPLE_herds` | `1` (0–8) | How many Parnell example herds to download. `0` = use your own data in `data/event_files/`. |
| `milk_data_exists` | `FALSE` | Process milk/production files in `data/milk_files/` (runs `step1a`). |
| `auto_de_duplicate` | `TRUE` | De-duplicate event rows. Set `FALSE` to keep treatments that recur within a day. |
| `run_reports` | `TRUE` | Render the Quarto reports after processing. |

### Denominator parameters (`setup_denominators.R`)

`set_cut_by_days = 60`, `set_top_cut = 400` (cow DIM), `set_top_cut_hfr = 700` (heifer days of age),
`denominator_time_periods = c(365)` (yearly is required; calendar periods month/season/year are always built).

### Optional branches (toggled in step0)

- **`get_EXAMPLE_herds > 0`** → `functions/step00_get_example_data_from_google_drive.R` downloads example herds into `data/event_files/*.csv`.
- **`milk_data_exists`** → `scripts/step1a_read_in_production_data.R` reads `data/milk_files/*.csv` → `production_all_columns.parquet`, `production_formatted.parquet`. *(Separate from the milestone flow — milestones 1–5 don't use it.)*
- **`run_reports`** → renders `qmd_reports/*` after step3.

---

## Layer 1 — The processing pipeline

Run once, orchestrated by `fxn_process_files.R`:

| Step | Script | Reads | Writes (in `data/intermediate_files/` unless noted) |
|---|---|---|---|
| **step1** | `scripts/step1_read_in_event_data.R` | `data/event_files/*.csv` (raw, all columns as character) | `events_all_columns.parquet`, `events_formatted.parquet`; plus `data/qc_files/*` and `data/template_files/*` |
| **step2** | `scripts/step2_create_intermediate_files.R` | `events_all_columns.parquet` | `animals.parquet`, `animal_lactations.parquet` |
| **step3** | `qmd_reports/step3_denominators_by_calendar_time.qmd` (Quarto, rendered by `fxn_process_files.R`; also a time-period loop) | `animals.parquet`, `animal_lactations.parquet`, `events_all_columns.parquet` | `denominator_by_calendar_time_period.parquet` (+ `calendar_from_calender_time_periods.parquet`) |

### Artifacts and their grain

| Artifact | Grain (one row = …) | Notes |
|---|---|---|
| `events_all_columns.parquet` | one event | full column set; debugging / re-derivation source |
| `events_formatted.parquet` | one event | trimmed, standardized columns; the main analysis table |
| `animals.parquet` | one animal | birth/enroll/sold/died dates, breed, sex, location history, `age_left` |
| `animal_lactations.parquet` | one animal-lactation | fresh/dry/archive dates, DIM milestones |
| `denominator_by_calendar_time_period.parquet` | one (location × lactation-group × period [× day-of-phase]) | animals-at-risk counts: `ct_animal_time_periods`, `ct_animals`, `ct_animal_lactations`, `ct_animal_days_elig`; sliced by `calendar_time_period_type` (month/season/year) and `deno_type` |
| `production_formatted.parquet` | one milk test | only if `milk_data_exists`; not used by milestones 1–5 |

---

## Layer 2 — The milestones (weeks 1–5)

| # | File / Title | Reads | Helper fns | Skills practiced | Produces (in-env) |
|---|---|---|---|---|---|
| **M1** | `milestone_week_01_import_inspect_visualize.qmd` — *Import, Inspect, Visualize* | `animals.parquet` | — | `read_parquet`, `nrow`, `count`, `filter`, `summary`/`skim`, `ggplot` (boxplot + points) | `number_of_rows`, `counts`, `animals_common_breed`, `skim_animals`; age_left-by-breed boxplot |
| **M2** | `milestone_week_02_summarize_beautify.qmd` — *Read & Visualize / Summarize* | `events_formatted.parquet` | `add_new_variables()` (`data_milestones/fxn_floor_dates.R`) → adds `floordate_month` + event counts | `group_by`, `summarize`, `quantile`, `geom_smooth` | `dim_at_bred` — DIM at first breeding (**BRED1**) by `lact_group` × `location_event` × `floordate_month`, last 3 yrs |
| **M3** | `milestone_week_03_new_variables.qmd` — *New Variables* | `events_formatted.parquet` filtered to `event_type == 'health'` | `fxn_add_event_counts.R`, `fxn_floor_dates.R` | `mutate`, `floor_date`, `case_when`, `distinct` | `event_counts_by_month`; student-defined `Disease` / `Treatment` |
| **M4** | `milestone_week_04_quarto_tidy_and_join.qmd` — *Denominators (Tidy & Join)* | `denominator_by_calendar_time_period.parquet` **+** `events_formatted.parquet` | `fxn_add_event_counts.R` | `filter`, summarize numerator, `left_join`, compute rate | disease **rate** over time (worked example: `MAST`); numerator ÷ denominator |
| **M5** | `milestone_week_05_strings_dates.qmd` — *Dates & Strings* | `data/event_files/*.csv` (raw → `events_original`) **+** `events_formatted.parquet` (as the "solution" to match) | — | `lubridate::mdy`, `floor_date`, `str_*` parsing | re-derives `date_event`, `floordate_month/season/year`, and the `remark_*` columns — i.e. **reconstructs what step1 does** |

---

## Notes & maintenance caveats

- **Solution-file numbering is offset.** The `waldo::compare` answer keys in
  `milestones_dairy/data_milestones/` lag the milestone's week number by one in several files:
  M2 reads `solutions_week_03_*`, M3 reads `solutions_week4_*`, M4 reads `solutions_week_05_pivotlonger`.
  Artifact of course renumbering — match by **content**, not by the week number in the filename.
- **M5 reads raw directly.** Unlike the others it bypasses the parquet artifacts and re-reads
  `data/event_files/*.csv` (all columns as character), using `events_formatted.parquet` only as the
  target to compare against.
- **Prereq for all milestones:** the pipeline must have been run (`step0_master_processing.R`) so the
  parquet artifacts exist. M1's intro tells students to re-run step0 if `animals.parquet` is missing.
- There is a separate combined **pharma** track
  (`milestone_week_04_and_05_PHARMA_quarto_tidy_and_join_strings_and_dates.qmd`) that uses external
  CSVs (`week4_pharma_company_data.csv`, `fda_facilities.rds`) instead of the dairy artifacts — out of
  scope for this dairy data-flow doc.

_The companion diagram (rendered in-session) is the visual version of this flow, starting at step0._
