---
name: bug-hunter-poc
description: Prove a finding with a local Foundry PoC that ends in a measured number — attacker gain or victim loss in real units. Use after contract-vulns; a PoC that cannot name the gain is not finished, and a lead whose PoC fails is a killed lead.
---

# Foundry PoC

A suspicion is a lead. A lead with a passing PoC that names the gain or
loss in numbers is a finding. Everything else stays a lead. This skill
is the gate between the two.

## Setup

Work in a local workspace that is a copy of the target repo at the
pinned commit. Never edit the original repository. PoCs live in the
workspace's `test/` directory and run with `forge test`.

Start from `templates/PoC.t.sol` in this repo. No mainnet fork unless
the user explicitly provides an RPC URL and the finding needs deployed
state. No mainnet or testnet transactions, ever. Never ask for a private
key, seed phrase, or wallet connection, and never sign or send a
transaction.

## A PoC must

- Deploy the target from a clean state. Fund the actors — and fund the
  paying contract, not just the users, if the payout comes from a
  second contract.
- Execute the attack from an **unprivileged** address where the finding
  claims an unprivileged attacker. If the attack needs a role, say so
  in the finding — the role is the precondition, not a detail.
- Record balances **before and after**: attacker, victim, protocol.
  Assert the gain or loss in real units. Log the numbers.
- Run green with `forge test` in the local workspace.

```sh
forge test --match-contract PoC_<Name> -vvv
```

## A PoC that is not finished

- It only shows a revert, a strange return value, or an odd state, with
  no number attached. That is a lead, not a finding.
- It runs from an admin or owner address while claiming an
  unprivileged attacker. Rebuild it from a fresh address, or rewrite
  the claim.
- It needs deployed state but has no fork and no RPC URL. Either the
  user provides one, or the lead stays unverified.

## Killed leads

If the PoC fails, the lead is dead or its precondition is missing.
Record it and move on — do not re-check it blindly later:

```md
- Lead: <file:line, one-line hypothesis>
- Killed because: <PoC failed — what the test showed>
- Precondition missing: <what would have to be true for it to work>
```

Real examples of killed leads: a nonce-burn grief that cannot happen
because a revert rolls back the nonce write; a "trusted backend" path
that the design explicitly grants to the operator role (a
centralization note, not an exploit).

## Fix verification

A fix is not verified by reading it. Re-run the PoC against the
patched code: the attack must fail. Then run the protocol's own test
suite: it must still pass. Both, or the fix is not verified.

## Invariants

Where an invariant can be stated precisely, write it as a Foundry
invariant test. Hard lessons, learned the expensive way:

- Pin the fuzz target. Fund the paying contract. Never sum a
  non-additive view. Assert against the contract's own ledger after
  the action, not against a recomputed expectation.

## When the user says

- **"Is this a bug?"** — Answer only after a PoC. Before that it is a
  lead, and say so.
- **"The PoC fails."** — Then the lead is dead or its precondition is
  missing. Record it as a killed lead with the reason.
- **"Can you check this fix?"** — Re-run the PoC on patched code (must
  fail) and the repo's own tests (must pass).

## Rules

- No PoC with a measured impact, no confirmed finding.
- No chain transactions. Local Foundry only.
- A PoC that cannot produce a number keeps the lead a lead.
