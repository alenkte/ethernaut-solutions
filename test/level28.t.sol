//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {GatekeeperAttack, GatekeeperThree} from "../src/level28.sol";

contract level28Test is Test {
    GatekeeperThree target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = GatekeeperThree(payable(instanceAddress));
    }

    function testSolvesLeve28() public {
        address hacker = makeAddr("hacker");
        vm.deal(hacker, 1 ether);

        address ownerBefore = target.owner();
        address entrantBefore = target.entrant();
        bool allowEntranceBefore = target.allowEntrance();
        console.log("Owner before:", ownerBefore);
        console.log("Entrant before:", entrantBefore);
        console.log("Allow entrance before:", allowEntranceBefore);

        vm.startPrank(hacker, hacker);
        GatekeeperAttack attackContract = new GatekeeperAttack{
            value: 0.002 ether
        }(payable(address(target)));
        attackContract.attack();
        vm.stopPrank();

        address ownerAfter = target.owner();
        address entrantAfter = target.entrant();
        bool allowEntranceAfter = target.allowEntrance();
        console.log("Owner after:", ownerAfter);
        console.log("Entrant after:", entrantAfter);
        console.log("Allow entrance after:", allowEntranceAfter);

        assertEq(entrantAfter, hacker, "Entrant should be hacker");
        assertTrue(allowEntranceAfter, "Allow entrance should be true");
    }
}
//INSTANCE_AD=0x4b360145fa82B4784a70de54c5e6Fa6fE1b32E54 forge test --mt testSolvesLeve28 -vvv
