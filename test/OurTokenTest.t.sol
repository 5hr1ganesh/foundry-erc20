// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ot;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    address charlie = makeAddr("charlie");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ot = deployer.run();

        vm.prank(address(msg.sender));
        ot.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, ot.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;

        // Bob approves alice to spend tokens on his behalf
        vm.prank(bob);
        ot.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ot.transferFrom(bob, alice, transferAmount);
        //The func transfer() sets the _From to msg.sender whereas the func transferFrom() sets the _From to the address that approved the transfer

        assertEq(ot.balanceOf(alice), transferAmount);
        assertEq(ot.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testTotalSupply() public view {
        uint256 totalSupply = ot.totalSupply();
        assertEq(totalSupply, 1000 ether);
    }

    function testMinting() public {
        uint256 mintAmount = 50 ether;

        // Mint tokens
        vm.prank(address(msg.sender));
        ot.mint(bob, mintAmount);

        // Check the new balance of Bob
        assertEq(ot.balanceOf(bob), STARTING_BALANCE + mintAmount);
    }

    function testBurning() public {
        uint256 burnAmount = 20 ether;

        // Burn tokens
        vm.prank(bob);
        ot.burn(bob, burnAmount);

        // Check the new balance of Bob
        assertEq(ot.balanceOf(bob), STARTING_BALANCE - burnAmount);
    }

    function testTransferBetweenUsers() public {
        uint256 transferAmount = 30 ether;

        // Bob transfers tokens to Charlie
        vm.prank(bob);
        ot.transfer(charlie, transferAmount);

        // Check balances
        assertEq(ot.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(ot.balanceOf(charlie), transferAmount);
    }
}
