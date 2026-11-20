---
name: bug-hunter-scope
description: Freeze the audit scope before reading any code — repo, commit, in/out files, actors, value flows, invariants, trusted assumptions. Use first in every audit; nothing outside the frozen scope gets reported.
---

# Scope

Scope first. No code is read until the scope is frozen and written down.
An audit without a frozen scope drifts: it reports files nobody asked
about, tests a commit that moved mid-review, and argues about findings
that were never in scope.

## Freeze the scope

Write a scope record before the first file is opened:

```md
## Scope record
- Repo: <url>
- Commit: <hash> — pinned, never moved silently
- In scope: <files/dirs>
- Out of scope: <files/dirs, and why>
- Economic surface: <which functions move value, in which token, to whom>
```

If the code changes mid-audit, re-freeze and say so in the report. A
finding against a commit that no longer exists is not a finding.

## The questions to answer first

Ask the user. If an answer is missing, ask — do not guess.

- What does the protocol do, in one paragraph, in the user's own words?
- Which repository and commit? Which files are in, which are out?
- Who are the actors (user, keeper, admin, oracle, solver, liquidator)
  and what can each one do?
- Where does value enter and leave? Which functions move funds, in
  which token, to which address?
- What is explicitly trusted (multisig, oracle, backend, bridge
  relayer) — and what breaks if that trust is abused?

## Map the value flows

Before reading code line by line, draw the flows: deposits,
withdrawals, borrowing, rewards, fees, cross-chain settlement. For each
flow, write the accounting invariant in one sentence. Examples:

- "Total shares minted never exceed deposits minus withdrawals,
  measured in the underlying token."
- "A credit is only granted to an account that funded the shortfall
  it is credited for."
- "A payment record is only spendable by the spender who paid it."

If the invariant cannot be written in one sentence, the flow is not
understood yet. Go back to the docs and the entry points until it can.

## Trusted assumptions are not findings

Admin keys, oracles, keepers, and backends the protocol explicitly
trusts are assumptions. Record them. A trusted party doing its job is
not a bug. A trusted party abusing its position is a centralization
note — worth writing down, not worth scoring as an exploit. The line
between the two is whether the code itself gives an unprivileged
caller the same power.

## Out of scope means out

Common out-of-scope items — record them, do not report them:

- Test files, mocks, deployment scripts.
- Vaults or modules the program explicitly excludes.
- Residual balances the program documents as expected (note the
  reference, e.g. a PRECON id, and move on).
- Prior audit findings already disclosed — read them to avoid
  duplicates; an overlap is a known issue, not a new finding.

## When the user says

- **"Audit this repo."** — Freeze the scope first (repo + commit +
  in/out + economic surface), then hand off to contract-vulns. Do not
  skip scoping.
- **"Just check this one function."** — Still write the scope record:
  the function, its callers, and what it is allowed to move. A
  function without its callers has no threat model.
- **"The code changed."** — Re-freeze at the new commit, note the
  old commit in the report, and re-check any finding whose code moved.

## Rules

- No review starts without a scope record.
- No finding is reported outside the frozen scope.
- No assumption is presented as a finding.
- The commit hash is written in every finding.
