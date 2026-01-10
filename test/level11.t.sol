//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Hack, Elevator} from "../src/level11.sol";

contract level11Test is Test {
    Elevator target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = Elevator(instanceAddress);
    }

    function testSolvesLeve11() public {
        address hacker = makeAddr("hacker");
        vm.startPrank(hacker);
        Hack hackContract = new Hack(address(target));
        hackContract.hack();
        vm.stopPrank();

        assertTrue(target.top());
    }
}
//INSTANCE_AD=0xEfBB0544d900b0eFF66ef6932C977cC27704721B forge test --mt testSolvesLeve11 -vvv
