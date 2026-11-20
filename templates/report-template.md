# Finding report — <one-line title>

> Attacker can <drain / steal / brick / bypass> <what> by <doing what>.
> One finding per report. Never two bugs in one submission.

## Severity

**<Critical / High / Medium / Low / Informational>** — <one sentence:
why this severity, impact first, then likelihood.>

CVSS vector: `<AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:H/A:N>` — <and the same
vector written in words: attack vector, complexity, privileges
required, user interaction, scope, and which of confidentiality /
integrity / availability breaks, and how much.>

Precondition (if any): <the role, config, or state the attack needs.
If none, write "None — any caller.">

## Location

- Repo: <url>
- Commit: <hash>
- File: <path, line numbers>
- Function: <name>

## Attack chain

Numbered, from an actor the attacker controls:

1. <step — what the attacker does, with the exact call>
2. <step>
3. <step>

## Description

<What the code does, and why it is wrong. Short. No adjectives doing
the work of evidence.>

## Impact

<Who loses what, with measured numbers from the PoC:>

- Attacker gain: <amount, token>
- Victim loss: <amount, token>
- Protocol loss: <amount, token — or "none">

## Proof of concept

- PoC file: <path, e.g. `test/PoC_<Name>.t.sol`>
- Run: `forge test --match-contract PoC_<Name> -vvv`
- Key assertion: <the assert that proves the gain/loss>
- Measured result: <paste the test output verbatim — the numbers, not
  a summary>

## Recommendation

<The smallest fix that closes the hole. One fix, not a redesign.>

## Fix verification

- PoC re-run against patched code: <must fail — paste the result>
- Protocol's own test suite: <must still pass — paste the result>

## Status

**Verified** (PoC passes) / **Unverified** (precondition noted above).

---

## Scope

- In scope: <files>
- Out of scope: <files, and why>
- Not covered: <areas the audit did not reach>

## Killed leads

- <lead: file:line, hypothesis — killed because: reason>

_This audit narrows risk; it does not certify the contracts as safe._
