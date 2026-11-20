---
name: bug-hunter-recon
description: Quick read-only recon before an audit — map the frontend and API surface, verify deployed code matches the source, list live contracts and trusted parties. Use before scope when the target is already deployed; never sends a transaction.
---

# Recon

Recon answers one question before the audit starts: what is actually
live, and does the deployed code match the source being reviewed? An
audit of source code that is not what is deployed audits the wrong
thing. Recon is read-only. No transactions, no wallet, no signing.

## 1. Find the public surface

- The app's frontend: what pages exist, what actions they expose
  (deposit, withdraw, claim, bridge, vote), and which contract calls
  each action triggers.
- The API the frontend talks to: list the endpoints from the network
  traffic or the app's own client code. Note which endpoints are
  public, which need a signature, and what each one returns.
- The docs: what the protocol claims it does, who the actors are,
  which parties are trusted (multisig, oracle, backend, relayer).
  Docs are claims, not facts — verify them against the code.

## 2. Verify deployed code against source

For every live contract address you find:

- Pull the verified source from the chain explorer and diff it
  against the audited repo at the pinned commit.
- Record the result in one line per contract: identical, differs only
  by a rename or whitespace (same logic), or differs in logic.
- If a contract is unverified or the source is not on the explorer,
  say so — it is not auditable from source, and the audit says that.
- Note the chain ID and the deployment addresses in the scope record.
  An address on the wrong chain is not the same contract.

## 3. Map what the live system trusts

- Which addresses hold admin, operator, or solver roles on-chain?
- Which oracle or price feed does the live deployment point at — and
  is it the same feed the docs name? A docs page naming one oracle
  while the deployment points at another is a finding in itself.
- Which backend or relayer submits transactions for users? What can
  it do that a user cannot?

## 4. Note the seams

Recon notes are leads for contract-vulns, not findings:

- A frontend action that calls a contract function the docs never
  mention.
- An API endpoint that returns data the contract does not validate.
- A contract the frontend uses that is not in the audit scope.
- A price or parameter the frontend fetches from an off-chain source
  the contract then trusts.

Write each one down with the URL or address where you saw it, and
hand it to scope as an open question.

## Rules

- Read-only. No transactions, no signatures, no wallet connections.
- Every claim about a live contract names the chain, the address, and
  the explorer link.
- A diff result of "identical" or "rename only" is recorded, not
  assumed — the diff is the evidence.
- Recon never promotes a note to a finding. That is foundry-poc's job.
