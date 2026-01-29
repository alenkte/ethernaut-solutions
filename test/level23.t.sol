//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Hack, DexTwo} from "../src/level23.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract level23Test is Test {
    DexTwo target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = DexTwo(instanceAddress);
    }

    function testSolvesLeve23() public {
        address hacker = makeAddr("hacker");

        address t1 = target.token1();
        address t2 = target.token2();
        IERC20 token1 = IERC20(t1);
        IERC20 token2 = IERC20(t2);

        uint256 dexBal1Before = target.balanceOf(t1, address(target));
        uint256 dexBal2Before = target.balanceOf(t2, address(target));
        console.log("Dex token1 balance before:", dexBal1Before);
        console.log("Dex token2 balance before:", dexBal2Before);

        vm.startPrank(hacker, hacker);
        Hack hackContract = new Hack(address(target));
        hackContract.hack();
        vm.stopPrank();

        uint256 dexBal1After = target.balanceOf(t1, address(target));
        uint256 dexBal2After = target.balanceOf(t2, address(target));
        console.log("Dex token1 balance after:", dexBal1After);
        console.log("Dex token2 balance after:", dexBal2After);

        assertTrue(dexBal1After == 0 || dexBal2After == 0);
    }
}
//INSTANCE_AD=0x0A2f768FA0ab98c800A1dbe2b9B8E9A633503bB9 forge test --mt testSolvesLeve23 -vvv
