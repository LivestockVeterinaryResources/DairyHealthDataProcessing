# Contributing

> **Status: DRAFT for community review.** `<TODO>` items need confirmation.

Welcome — and thank you for helping improve cattle health and welfare through
open, reproducible tooling. This project is built by a community of
veterinarians, researchers, producers, analysts, educators, and students.
**You do not need to be a programmer to contribute.**

Please read the [Charter](../community/charter.md) for our mission and values, and the
[Code of Conduct](code_of_conduct.md), which governs all participation.

## Ways to contribute (all are valued equally)

Code is only one path. The following all count as real contributions and are
recognized:

- **Domain expertise** — review methods for clinical/scientific soundness,
  propose metrics, sanity-check results against field experience.
- **Documentation & teaching** — improve guides, write examples, contribute to
  course materials.
- **Data** — contribute example datasets or test fixtures for open use
  (only data you have the right to share openly).
- **Issue triage & testing** — report bugs, reproduce issues, test changes.
- **Code** — features, fixes, tests, refactors, infrastructure.

If you are new, look for issues labeled **`good first issue`**
`<TODO: set up this label>`, or open an issue describing what you'd like to work
on so we can help you get started.

## How changes get made

1. **Discuss first for anything non-trivial.** Open an issue describing the
   problem or idea before large changes, so we can agree on direction.
2. **Branch** from the integration branch `<TODO: confirm — e.g., develop>` and
   make your change.
3. **Open a pull request.** Describe what changed and why. Link any related
   issue.
4. **Review.** A maintainer reviews for correctness, clarity, fit with the
   values, and (for any change to how data is computed or interpreted)
   **independent methodology review** per [governance.md](../community/governance.md).
5. **Merge** once approved.

Keep pull requests focused and reasonably small — they are easier to review and
get merged faster.

## Sign your commits (Developer Certificate of Origin)

We use the **Developer Certificate of Origin (DCO)** instead of a corporate
contributor agreement. This keeps copyright distributed among contributors, so
the project can never be unilaterally closed or relicensed.

By signing off, you certify you wrote the contribution or otherwise have the
right to submit it under the project's license (full text:
<https://developercertificate.org/>). Add a sign-off line to each commit:

```
Signed-off-by: Your Name <your.email@example.com>
```

You can add it automatically with:

```
git commit -s -m "Your message"
```

## Crediting organizational support (the `Supported by:` trailer)

If an organization paid for the time you spent on a contribution, record it as a
**factual** trailer in the commit message. This gives supporters transparent
credit for providing *capacity* — with no implication of influence over content.

```
Add per-clinic Excel ingest example

Supported by: <Organization Name>
Signed-off-by: Your Name <your.email@example.com>
```

If you have a financial relationship relevant to the change (e.g., you are paid
by a company affected by a methodology change), disclose it in the PR and see the
conflict-of-interest expectations in [governance.md](../community/governance.md).

## Review standards

Contributions are evaluated on:

- **Correctness and reproducibility** — does it work, and can others verify it?
- **Scientific soundness** — for anything touching methods, metrics, or
  interpretation.
- **Clarity** — readable code and documentation; this is a teaching project, so
  approachability matters.
- **Fit with the [values](../community/charter.md)** — especially vendor/data-source
  neutrality.

A contribution is judged on its merits and soundness — **never on who funded it.**

## Recognition

Contributions are credited in a few complementary ways:

- **Code** — everyone who commits is credited automatically on the project's
  [GitHub contributors graph](https://github.com/LivestockVeterinaryResources/DairyHealthDataProcessing/graphs/contributors)
  (no list to maintain).
- **Expertise, data, teaching, or funding** — the contributions that commits
  don't capture are recognized in [Supporters](../community/supporters.md).
- **Citable authorship** — for releases, a curated author list is maintained in
  [citation.cff](../CITATION.cff).

We deliberately recognize non-code contributions alongside code.

## Questions

Open an issue or reach out at `<TODO: community contact / discussion channel>`.
