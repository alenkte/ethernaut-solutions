//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Hack, GatekeeperTwo} from "../src/level14.sol";

contract level14Test is Test {
    GatekeeperTwo target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = GatekeeperTwo(instanceAddress);
    }

    function testSolvesLeve14() public {
        address hacker = makeAddr("hacker");
        vm.startPrank(hacker, hacker);
        new Hack(address(target));
        vm.stopPrank();

        assertTrue(target.entrant() == hacker);
    }
}
//INSTANCE_AD=0x1C5d763ff749C270475756EBB31cbFe204B9B9fE forge test --mt testSolvesLeve14 -vvv
