---
name: bug-hunter-vulns
description: Hunt smart-contract vulnerabilities by class — each class as one question to ask of the code, with the reachable path it needs. Use after scope; every suspicion becomes a lead, never a finding until foundry-poc proves it.
---

# Contract Vulns

Read every in-scope file end to end, in dependency order — entry points
first, then the contracts they call. For each function, ask the questions
below. A class is only a lead until the PoC proves it; a class with no
reachable path from an attacker-controlled actor is not a lead at all.

## How to use this skill

For each function, ask: who can call this, and what stops anyone else?
What state changes before any external call, and what changes after?
Which values come from a caller, a signature, or an oracle — and what
happens if they are stale, extreme, or attacker-chosen? What happens on
the second call, the reverted call, the call with no funds left?

Record every suspicion as a lead: file, line, one-line hypothesis of
who gains what. Do not promote a lead to a finding until the PoC runs.

## The classes

### Reentrancy

- Does any external call happen before state is updated
  (checks-effects-interactions broken)?
- Can the same call be re-entered through a token hook, a fallback, or
  a callback the protocol itself triggers?

### Access control

- Is there a function with no caller check that moves funds, changes a
  role, or sweeps a balance?
- Does a role check exist but check the wrong thing — a role that any
  holder can claim, or a check on the caller instead of the actor the
  action is for?
- Can a privileged function be called through an unguarded path
  (a public router, a multicall that does not restrict targets)?

### Oracle manipulation

- Spot price or TWAP — and can a caller move the spot inside the
  update window for less than the profit?
- How stale can the price be before it is used? Is there a maximum
  age anywhere, on every path including fallbacks?
- What happens when the price feed itself costs money (a LINK fee, a
  verification fee)? Can the adapter even pay it, or does the whole
  path brick?

### Rounding and precision

- Who gains if this arithmetic rounds down, and who gains if it rounds
  up? Who chooses the direction?
- Can the first actor in a fresh pool set the exchange rate? What
  happens to the second actor?
- Does a fee-on-transfer, rebasing, or hook-bearing token break the
  assumption that amount sent equals amount received?

### Signature replay

- Does the signed message bind chain, contract, nonce, amount, and
  recipient — or can one signature be replayed somewhere else?
- Do authorizations expire? An authorization that never expires is an
  authorization forever. Where is the expiry, and who can revoke it?

### Proxy and upgradeability

- Which storage slots does the implementation use, and which does the
  proxy reserve? Do they overlap anywhere?
- Can the implementation be initialized twice, by the wrong caller, or
  never at all?
- Who can upgrade, through how many keys, and what stops one
  compromised key from swapping the logic?
- Do any function selectors collide between proxy and implementation?

### Unchecked external calls

- Is a call's return value ignored where failure should revert?
- Can a call target be chosen by the caller (multicall, resolver,
  executor) with no allowlist on what it may call?

### Denial of service and griefing

- Can one caller brick a path for everyone (a reverting source, an
  unbounded loop, a nonce that burns on revert)?
- Is there a fee, a gas gate, or a minimum anywhere a parameter is
  unbounded?

### Front-running and ordering

- Is the executor permissionless while the caller chooses the resolver
  or the call data the signed request does not cover?
- Is the signed minimum output the receiver's only guarantee — and can
  someone else front-run the request, return exactly the minimum, and
  keep the spread?

### Economic and business logic

- Is the same value recorded in two places that can disagree — a
  credit ledger vs a token balance, a payment record vs the spender
  who uses it?
- Can a right be used twice — a claim, a refund, a withdrawal, a gas
  payment — because the record of use does not bind who used it?
- Can a credit be granted without checking who funded it? Always ask:
  does this credit check that the credited account earned it?
- Does a payment record say who paid, or only that something was paid?
- Is any parameter unbounded (a fee, a discount, a bonus) with no
  minimum, no maximum, and no gas gate?

## Static analysis is a lead source, not a verdict

Run Slither and Aderyn if available and triage their output. A
static-analysis warning is a lead, never a finding on its own. A clean
static run proves nothing — most economic bugs never trigger a detector.

## Rules

- No reachable path from an attacker-controlled actor, no lead.
- A lead is file + line + one-line hypothesis. Nothing more until the
  PoC.
- Never inflate a class into a finding to fill a report.
