# bug-hunter-kit

A bug-hunting skill bundle for AI coding agents. Scope the code, hunt the
vuln, prove it with a local Foundry PoC, write the report triage can
actually reproduce. Nothing here finds bugs for you — it makes the agent
work the way a human auditor works, and stop it from calling a guess a
finding.

Built from real audit work, not from a course: the methodology behind
Audit Forge and Audit Forge Pro, and the lessons from a settlement-protocol
audit in November 2026 (one HIGH report sent with a passing PoC, five
MEDIUMs PoC-verified, six PoCs green).

Not affiliated with Claude-BugHunter or any other bug-hunting bundle.
This kit is original work by ndrean7, written from his own audit practice.

## Who this is for

- You run an AI coding agent (Claude Code, Cursor, Codex, or any agent
  that reads skill files) and want it to audit Solidity code properly.
- You hunt bug bounties and want reports that survive triage.
- You review your own protocol before launch and want a checklist that
  does not let you skip the proof step.

## Skills

| Skill | What it does |
| --- | --- |
| [scope](skills/scope/SKILL.md) | Freeze the scope before reading a line: repo, commit, in/out, actors, value flows, invariants. |
| [contract-vulns](skills/contract-vulns/SKILL.md) | The vulnerability classes to hunt, each as one question to ask of the code. |
| [foundry-poc](skills/foundry-poc/SKILL.md) | Prove the finding with a local Foundry PoC that ends in a measured number. No PoC, no finding. |
| [report](skills/report/SKILL.md) | Turn a proven finding into a bounty-ready report: severity, repro steps, fix. |
| [recon](skills/recon/SKILL.md) | Quick recon before the audit: frontend, API surface, deployed code vs source. Read-only. |

## Install

Skills follow the Agent Skills open standard: each skill is one folder
with a `SKILL.md` (frontmatter `name` + `description`, then instructions).

**Claude Code:**

```sh
# user-wide
cp -r skills/* ~/.claude/skills/

# or per-project
cp -r skills/* .claude/skills/
```

**Any other agent:** point it at the `skills/` folder, or paste a skill's
`SKILL.md` into the conversation. No build step, no dependencies, no
network calls. Foundry is only needed for the PoC skill.

## Usage example

One lead, all five skills, in order. Target: a vault contract.

**1. scope** — freeze it:

> Audit `vault-repo` at commit `abc123`. In scope: `src/Vault.sol`.
> Out of scope: tests, mocks, deployment scripts. Actors: depositor,
> attacker (no role, no deposit beyond 1 wei). Value flow: deposit
> token in, shares out, redeem shares for token. Invariant: "shares
> minted never exceed deposits minus withdrawals, measured in the
> underlying token."

**2. contract-vulns** — the lead:

> First depositor sets the share price. `deposit()` mints
> `amount * totalSupply / totalAssets`. A direct token donation raises
> `totalAssets` without minting shares. Question: can the first actor
> donate, then let the victim deposit into an inflated price?

**3. foundry-poc** — prove it:

> Copy `templates/PoC.t.sol`, deploy the vault clean, attacker deposits
> 1 wei, donates directly, victim deposits 100 tokens and receives 0
> shares, attacker redeems 1 share for the whole pool. Assert the
> numbers: victim shares == 0, attacker gain > 0. `forge test` green.

**4. report** — write it:

> One finding, `templates/report-template.md`. Title: "First depositor
> inflates share price by direct donation; next depositor receives zero
> shares." Severity High with the scoring rationale. Repro steps a
> triager can run in under 10 minutes. Fix: virtual shares, or a
> minimum first deposit, or price from an internal ledger instead of
> the raw token balance.

**5. recon** (when the target is already deployed) — check the live
code matches the source before trusting anything the audit says about
it. Explorer byte-compare, note the chain and the addresses, read the
docs for what is trusted.

A lead whose PoC fails is a killed lead. Write down why it died and
move on. A review that finds nothing is a valid result.

## Track record (honest)

- Audit Forge (free) and Audit Forge Pro ($10) — live on
  [Agensi](https://www.agensi.io/skills/audit-forge), built from this
  same methodology. TestForge, the testing companion skill, is live
  there too.
- November 2026 settlement-protocol audit, Foundry only, no chain
  transactions: 1 HIGH report sent to the program (ticket
  #158121334), 5 MEDIUMs verified with passing PoCs, 6 PoC files
  green, 91 tests passing. Relay Vaults were out of scope; the router
  residual-funds note was recorded as out of scope, not reported.
- Bug bounties in progress: Relay (PoC required, KYC before payout),
  Uniswap on Cantina.

No payouts are claimed here, because none have been confirmed. Bounties
pay only for valid, first-reported bugs. A clean review that finds
nothing is a normal outcome, and this kit will not dress it up as a
finding.

## Rules the skills enforce

- **No PoC with a measured impact, no confirmed finding.** A suspicion
  stays a lead until the PoC names the gain or loss in numbers.
- **Local only.** All PoCs run in Foundry. Never a mainnet or testnet
  transaction, never a private key, seed phrase, or wallet connection.
- **Never guarantee safety or a bounty.** An audit narrows risk; it
  never certifies a contract as safe.
- **Scope is frozen.** Nothing outside the frozen scope is reported,
  and the commit is never silently moved.
- **Findings come from reading this codebase.** Not from another audit,
  another entry, or a public report.

## Requirements

- Foundry (`forge`, `cast`) for the PoC skill.
- Slither / Aderyn for static analysis (optional, recommended).
- A local copy of the target repo at a pinned commit.

## License

MIT — see [LICENSE](LICENSE). © 2026 ndrean7.
