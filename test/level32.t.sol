//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Hack, ECLocker} from "../src/level32.sol";

contract level32Test is Test {
    ECLocker target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = ECLocker(instanceAddress);
    }

    function testSolvesLeve32() public {
        address hacker = makeAddr("hacker");

        address controllerBefore = target.controller();
        console.log("Controller before:", controllerBefore);

        vm.startPrank(hacker, hacker);
        Hack attackContract = new Hack(address(target));
        attackContract.hack();
        vm.stopPrank();

        address controllerAfter = target.controller();
        console.log("Controller after:", controllerAfter);

        assertEq(
            controllerAfter,
            address(0),
            "Controller should be address(0)"
        );
    }
}
//INSTANCE_AD=0x261BE9fE9F4f2643D0596132A6Af7DAC625580c9 forge test --mt testSolvesLeve32 -vvv
