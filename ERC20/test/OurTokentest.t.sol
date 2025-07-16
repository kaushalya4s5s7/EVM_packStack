// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

// Needed to test event emissions
interface IERC20Events {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract OurTokentest is Test, IERC20Events {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("Bob");
    address alice = makeAddr("Alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();
        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    // ✅ Basic balance check
    function test_balance() public {
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }

    // ✅ Successful allowance and transferFrom flow
    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.allowance(bob, alice), initialAllowance - transferAmount);
    }

    // ❌ Transfer more than balance should fail
    function test_cannotTransferMoreThanBalance() public {
        vm.prank(bob);
        vm.expectRevert();
        ourToken.transfer(alice, STARTING_BALANCE + 1);
    }

    // ❌ TransferFrom without approval should revert
    function test_transferFromWithoutApprovalReverts() public {
        vm.prank(alice);
        vm.expectRevert();
        ourToken.transferFrom(bob, alice, 1);
    }

    // ✅ Approve overwrites previous allowance
    function test_approveOverwritesPrevious() public {
        vm.prank(bob);
        ourToken.approve(alice, 100);

        vm.prank(bob);
        ourToken.approve(alice, 200);

        assertEq(ourToken.allowance(bob, alice), 200);
    }

    // ❌ TransferFrom after revoking allowance should fail
    function test_allowanceRevokeBlocksTransferFrom() public {
        vm.prank(bob);
        ourToken.approve(alice, 100);

        vm.prank(bob);
        ourToken.approve(alice, 0); // Revoke

        vm.prank(alice);
        vm.expectRevert();
        ourToken.transferFrom(bob, alice, 1);
    }

    // ❌ Transfer to zero address should revert
    function test_transferToZeroAddressReverts() public {
        vm.prank(bob);
        vm.expectRevert();
        ourToken.transfer(address(0), 1);
    }

    // ❌ Approve to zero address should revert
    function test_approveToZeroAddressReverts() public {
        vm.prank(bob);
        vm.expectRevert();
        ourToken.approve(address(0), 100);
    }

    // ✅ Emit Transfer event
    function test_transferEmitsEvent() public {
        vm.prank(bob);
        vm.expectEmit(true, true, false, true);
        emit Transfer(bob, alice, 100);

        ourToken.transfer(alice, 100);
    }

    // ✅ Emit Approval event
    function test_approveEmitsEvent() public {
        vm.prank(bob);
        vm.expectEmit(true, true, false, true);
        emit Approval(bob, alice, 100);

        ourToken.approve(alice, 100);
    }

    // ✅ Transfer zero tokens should succeed
    function test_transferZeroTokens() public {
        vm.prank(bob);
        bool result = ourToken.transfer(alice, 0);
        assertTrue(result);
    }

    // ✅ Self transfer keeps balance same
    function test_selfTransferShouldNotChangeBalance() public {
        vm.prank(bob);
        ourToken.transfer(bob, 100);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }
}
