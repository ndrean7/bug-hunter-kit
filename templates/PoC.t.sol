// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

/// @title Bug Hunter Kit — PoC template
/// @notice A PoC ends with a MEASURED gain or loss in real units.
/// A PoC that only shows a revert or a strange return value is a lead,
/// not a finding. Fill in every section; delete nothing until the PoC
/// runs green with the numbers asserted.
///
/// HOW TO USE:
///  1. Deploy the target from a clean state and fund the actors.
///  2. Run the attack from an UNPRIVILEGED address.
///  3. Record balances before and after. Assert the gain or loss.
///  4. `forge test --match-contract PoC_Template -vvv`
contract PoC_Template is Test {
    // --- Actors -------------------------------------------------------
    // The attacker holds no role. If your finding needs a role,
    // say so in the report — the role is the precondition.
    address internal attacker = makeAddr("attacker");
    address internal victim = makeAddr("victim");

    // --- Balances recorded before the attack -------------------------
    uint256 internal attackerBefore;
    uint256 internal victimBefore;

    function setUp() public {
        // Deploy the target here from a clean state.
        // Fund the actors here. If the payout comes from a second
        // contract, fund THAT contract, not just the users.
        //
        // Example:
        //   target = new Target();
        //   deal(address(token), attacker, 1 ether);
        //   deal(address(token), victim, 100 ether);
    }

    function test_Attack() public {
        // --- Record "before" -----------------------------------------
        // attackerBefore = token.balanceOf(attacker);
        // victimBefore = token.balanceOf(victim);

        // --- Step 1: build the vulnerable state ----------------------
        // e.g. attacker takes the first position in a fresh pool.

        // --- Step 2: bend the number the protocol trusts ------------
        // e.g. attacker moves value in a way the accounting does not
        // record — a direct transfer, an unguarded credit, a price
        // the caller controls.

        // --- Step 3: the victim acts on the bent number --------------
        // e.g. victim deposits, claims, or withdraws against the
        // number the attacker bent.

        // --- Step 4: the attacker extracts ---------------------------
        // e.g. attacker redeems, sweeps, or claims the victim's share.

        // --- Record "after" and assert the measured impact -----------
        // uint256 attackerAfter = token.balanceOf(attacker);
        // uint256 victimAfter = token.balanceOf(victim);
        // assertGt(attackerAfter, attackerBefore, "attacker must gain");
        // assertLt(victimAfter, victimBefore, "victim must lose");
        // console.log("attacker gain:", attackerAfter - attackerBefore);
        // console.log("victim loss:", victimBefore - victimAfter);
    }
}
