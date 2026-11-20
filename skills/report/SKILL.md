---
name: bug-hunter-report
description: Turn a proven finding into a bounty-ready report — title, severity with reasoning, impact in numbers, copy-paste repro steps, PoC evidence, fix. Use after foundry-poc; never writes a report for an unproven lead.
---

# Report

A bug that pays is a bug a triager can reproduce in minutes. This skill
takes a finding already proven — a Foundry PoC that runs, a measured
gain or loss, a concrete exploit path — and turns it into a report in
the shape triage teams use: what breaks, where, how bad, prove it, how
to fix it.

It never invents a finding. If the PoC does not reproduce, the lead is
unverified and the skill stops — no padded report, no guessed severity.

## Before writing

Freeze the program's rules alongside the scope: repo, commit, files in
scope, out-of-scope list, whether a PoC is required, whether KYC is
required before payout. A report without a pinned commit is not
submittable. One finding per report — never two bugs in one submission.

## The report format

Use `templates/report-template.md`. One finding per section, in order:

1. **Title** — what breaks, in one line. "Attacker can drain X by
   doing Y." If it does not fit one line, the finding is not
   understood yet.
2. **Severity** — Critical / High / Medium / Low / Informational,
   with the scoring rationale and the CVSS vector where it applies.
3. **Location** — file and function, with the commit hash.
4. **Attack chain** — the reachable path, step by step, from an actor
   the attacker controls.
5. **Description** — what the code does and why it is wrong.
6. **Impact** — who loses what, with measured numbers from the PoC
   (attacker gain, victim loss, protocol loss).
7. **Proof of concept** — the PoC test file, the exact commands, the
   key assertion, and the measured result. Paste test output verbatim
   where it proves the number.
8. **Recommendation** — the smallest fix that closes the hole.
9. **Fix verification** — the PoC re-run against patched code (must
   fail) and the protocol's own tests (must still pass).
10. **Status** — verified (PoC passes) or unverified (precondition
    noted).

Close with: scope (repo, commit, in/out), areas not covered, the
killed leads, and the sentence: "This audit narrows risk; it does not
certify the contracts as safe."

## Severity — impact first, then likelihood

| Severity | Meaning |
| --- | --- |
| Critical | Direct loss of user funds, or full protocol compromise, reachable by an unprivileged caller, with a measured gain |
| High | Loss of funds or a broken core invariant, with a realistic path to reach it, and a measured gain or loss |
| Medium | Loss under a precondition (a role, a config, a second bug) or a partial loss |
| Low | Minor loss, griefing, or a broken assumption with limited impact |
| Informational | No direct loss, but worth fixing (stale data, missing expiry, unclear code) |

A dramatic bug that needs an impossible precondition is Medium at most
— and its precondition is written in the finding. A bug whose impact
cannot be measured in numbers is not scored High. When unsure, rate
down and explain why — overclaiming burns credibility with triage. If
two findings share one root cause, score the root cause once and list
the instances; do not inflate the report with duplicates.

Record a CVSS-style vector alongside the severity so triage can score
without re-reading the whole finding — and write it in words too:
attack vector, complexity, privileges required, user interaction,
scope, and which of confidentiality / integrity / availability
actually breaks, and how much.

## Repro steps a triager can run

Numbered, copy-pasteable, no adjectives. The triager should reproduce
the finding in under 10 minutes from the steps alone. If they cannot,
rewrite the steps, not the adjectives. Include: repo + commit, how to
set up the local workspace, the exact `forge test` command, and the
expected output with the numbers.

## Program rules that change a report

- **PoC required** — no PoC, no submission. Some programs require a
  PoC for higher severities specifically; check the program's scale
  before rating.
- **KYC before payout** — a valid finding still pays only after the
  program's KYC. Say so when the user asks about payout.
- **Out of scope** — a finding in an excluded file or module is not
  reportable. Disclose the overlap instead of reporting it as new.
- **First reported wins** — check prior audits and public reports for
  the same finding before submitting. A duplicate pays nothing.

## What this skill does not do

- It does not find bugs — that is contract-vulns + foundry-poc. It
  writes up bugs already proved.
- It never promises a payout. Bounties pay only for valid,
  first-reported bugs; a clean report on a duplicate or an out-of-scope
  target pays nothing.
- It never submits anything for the user, and never discloses an
  un-triaged finding publicly. Reports go to the program first, with
  the user's approval.

## Self-check before submit

Read the report as a triager:

- Can I reproduce it in under 10 minutes from the steps alone?
- Is the severity justified by the PoC's numbers, not by adjectives?
- Is the precondition written in the finding, not hidden in a
  footnote?
- Is there exactly one finding in this report?

If any answer is no, fix the report before it goes anywhere.
