//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Hack, GatekeeperOne} from "../src/level13.sol";

contract level13Test is Test {
    GatekeeperOne target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = GatekeeperOne(instanceAddress);
    }

    function testSolvesLeve13() public {
        address hacker = makeAddr("hacker");
        vm.startPrank(hacker, hacker);
        Hack hackContract = new Hack(address(target));
        hackContract.hack();
        vm.stopPrank();

        assertTrue(target.entrant() == address(hacker));
    }
}
//INSTANCE_AD=0x60C752CaCCBf6d4E25713B3aDE73CD993a126A63 forge test --mt testSolvesLeve13 -vvv
