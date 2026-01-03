//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Test, console} from "forge-std/Test.sol";
import {Hack, Telephone} from "../src/level4.sol";

contract level3Test is Test {
    Telephone target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = Telephone(instanceAddress);
    }

    function testSolvesLeve4() public {
        address hacker = makeAddr("hacker");
        vm.startPrank(hacker);
        Hack hackContract = new Hack(target);
        vm.stopPrank();
        assertTrue(target.owner() == hacker);
    }
}
//INSTANCE_AD=0x6818850c981b4A1e9b478D7bf73802ca5C31F78f forge test --mt testSolvesLeve4 -vvv
