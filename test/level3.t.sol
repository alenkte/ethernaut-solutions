//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Test, console} from "forge-std/Test.sol";
import {HackCoinFlip, CoinFlip} from "../src/level3.sol";

contract level3Test is Test {
    CoinFlip target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = CoinFlip(instanceAddress);
    }

    function testSolvesLeve3() public {
        CoinFlip leve3 = new CoinFlip();
        HackCoinFlip hackContract = new HackCoinFlip(address(leve3));

        for (uint256 i = 0; i < 10; i++) {
            //we need the cheatcode to change the block number and trigger the hack ten times in ten blocks
            vm.roll(block.number + 1);

            hackContract.hack();
        }
        assertTrue(leve3.consecutiveWins() == 10);
    }
}
