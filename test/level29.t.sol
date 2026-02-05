//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {SwitchAttack, Switch} from "../src/level29.sol";

contract level29Test is Test {
    Switch target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = Switch(instanceAddress);
    }

    function testSolvesLeve29() public {
        address hacker = makeAddr("hacker");

        bool switchOnBefore = target.switchOn();
        console.log("Switch on before:", switchOnBefore);

        vm.startPrank(hacker, hacker);
        SwitchAttack attackContract = new SwitchAttack();
        attackContract.attack(address(target));
        vm.stopPrank();

        bool switchOnAfter = target.switchOn();
        console.log("Switch on after:", switchOnAfter);

        assertTrue(switchOnAfter, "Switch should be on");
    }
}
//INSTANCE_AD=0x4755e2BE7ba965e0d008C74164910253C94b756F forge test --mt testSolvesLeve29 -vvv
