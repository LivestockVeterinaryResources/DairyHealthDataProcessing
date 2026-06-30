# Governance

> **Status: DRAFT for community review.** Proposed by the founding contributors,
> to be amended and ratified by the community. `<TODO>` items need confirmation.

This document defines how decisions are made, how people earn responsibility, and
the structural safeguards that keep the project open and independent. It
operationalizes the [Project Charter](charter.md).

## Guiding rule

Decisions are made **in the open**, on **merit**, in service of the
[mission and values](charter.md). No individual's employer and no project
supporter receives special authority over the project.

## Roles

### Contributors
Anyone who contributes — code, documentation, domain expertise, data, review,
teaching, issue triage. No application needed; open a pull request or issue.
Contributions in all forms are recognized (see [contributing.md](../.github/contributing.md)).

### Maintainers (Committers)
Contributors who have earned merge rights through sustained, high-quality
contribution and good judgment. Maintainers review and merge contributions,
mentor newcomers, and uphold the values and Code of Conduct.

- Maintainership is **earned by individual merit**, proposed by an existing
  maintainer, and confirmed by maintainer consensus.
- It is held by the **individual, not their employer**. A maintainer keeps their
  role if they change jobs. Roles cannot be assigned, transferred, or funded into
  existence by any organization.
- Maintainers who become inactive may move to emeritus status.

Current maintainers:
- Gerard Cramer
- Nora Schrag
- `<TODO: confirm additional maintainers — e.g., university contributors who take on review/merge duties>`

### Steering Committee
As the community grows, a Steering Committee provides overall direction,
ratifies changes to governance and the charter, stewards project assets, and
resolves disputes that maintainers cannot resolve by consensus.

- The committee is composed of individuals drawn from active maintainers and the
  broader community, chosen to reflect the community's breadth (practice,
  academia, production, students).
- **Single-organization cap (anti-capture):** **no single organization may hold
  more than one-third (⅓) of Steering Committee seats.** If employment changes
  push representation above the cap, it is rebalanced at the next opportunity.
- Committee membership, like maintainership, is held by individuals on merit —
  not purchased and not allocated to supporters.
- `<TODO: confirm initial committee size and members once the community agrees
  this structure is warranted. It is fine to defer forming the committee until
  the project is larger; until then, maintainers govern by consensus.>`

## How decisions are made

1. **Lazy consensus.** Most decisions happen through normal pull-request review.
   A proposal with no sustained objections, given reasonable time, is accepted.
2. **Seeking consensus.** For larger or contested changes, discussion happens in
   a public issue or proposal until maintainers reach consensus.
3. **Voting (fallback).** If consensus cannot be reached, maintainers (or, for
   governance/charter matters, the Steering Committee) decide by simple-majority
   vote, recorded publicly. The single-organization cap applies to any vote.
4. **Methodology and analytics changes** receive heightened review — see below.

All substantive decisions and their rationale are recorded in the open
(issues, pull requests, or meeting notes).

## Independence of analysis and mechanics

To protect scientific credibility, **any change to how the code computes,
standardizes, or interprets cattle-health data** (metrics, denominators,
classifications, statistical methods, default thresholds) must be reviewed by at
least one maintainer or qualified domain reviewer **who does not have a direct
commercial interest in that particular result**. Contributors may not be the sole
reviewer of methodology changes that affect a sponsor or client they are
financially tied to.

## Conflict of interest

Many of our contributors are professionally active in cattle health and have
legitimate commercial relationships. This is welcome and normal. Credibility is
protected by **disclosure and recusal**, not by exclusion.

- Maintainers and Steering Committee members **publicly disclose** relevant
  financial and organizational interests in [disclosures.md](disclosures.md).
- A decision-maker **recuses** from decisions in which they (or their
  employer/client) have a direct financial stake.
- Disclosed conflicts are acceptable; **undisclosed** conflicts are not.

## Supporters and sponsorship

Organizations may support the project with staff time, funding, or
infrastructure under the equal-terms policy in [sponsorship.md](sponsorship.md).
**Support never confers governance authority, merge rights, committee seats, or
control over methodology.** Supporters are acknowledged with equal weight in
[supporters.md](supporters.md).

## Project assets and the right to fork

- The project is released under an open license (see [LICENSE](../LICENSE)). Copyright is
  **distributed among contributors** via the Developer Certificate of Origin
  (see [contributing.md](../.github/contributing.md)); **no contributor agreement assigns
  copyright to any single company.** This guarantees the project can never be
  unilaterally closed or relicensed, and the community always retains the right
  to fork.
- As the project matures, the founders intend to move the project's name,
  domain, and any funds to a **neutral fiscal host or nonprofit**
  `<TODO: name a target, e.g., NumFOCUS / Open Collective / a dedicated
  nonprofit>` so that no single company owns the project's assets.

## Code of Conduct

All participation is governed by the [Code of Conduct](../.github/code_of_conduct.md).
Enforcement is handled by `<TODO: designated maintainers / committee>` at
`<TODO: conduct contact email>`.

## Changing this document

Changes to this governance document or the [Charter](charter.md) are proposed via
public pull request and adopted by Steering Committee consensus (or, before a
committee exists, by maintainer consensus), with reasonable time for community
comment.
