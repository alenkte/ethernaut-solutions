//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Test, console} from "forge-std/Test.sol";
import {HackCoinFlip, CoinFlip} from "../src/level3.sol";

contract level2Test is Test {
    CoinFlip target;

    function setUp() public {
        // vm.createSelectFork("SEPOLIA");
        target = CoinFlip(0xEdd15341D01cB5D24a62Cc8CEaDbF174114cEd46);
    }

    function testSolvesLevel() public {
        CoinFlip level = new CoinFlip();
        HackCoinFlip hackContract = new HackCoinFlip(address(level));

        for (uint256 i = 0; i < 10; i++) {
            //we need the cheatcode to change the block number and trigger the hack ten times in ten blocks
            vm.roll(block.number + 1);

            hackContract.hack();
        }

        assertTrue(level.consecutiveWins() == 10);
    }
}
