//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Hack, IGoodSamaritan, GoodSamaritan, Coin, Wallet} from "../src/level27.sol";

contract level27Test is Test {
    IGoodSamaritan target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = IGoodSamaritan(instanceAddress);
    }

    function testSolvesLeve27() public {
        address hacker = makeAddr("hacker");

        GoodSamaritan goodSamaritan = GoodSamaritan(address(target));
        Wallet wallet = goodSamaritan.wallet();
        Coin coin = goodSamaritan.coin();

        uint256 walletBalanceBefore = coin.balances(address(wallet));
        console.log("Wallet balance before:", walletBalanceBefore);

        vm.startPrank(hacker, hacker);
        Hack hackContract = new Hack(address(target));
        hackContract.hack();
        vm.stopPrank();

        uint256 walletBalanceAfter = coin.balances(address(wallet));
        uint256 hackBalanceAfter = coin.balances(address(hackContract));
        console.log("Wallet balance after:", walletBalanceAfter);
        console.log("Hack balance after:", hackBalanceAfter);

        assertEq(walletBalanceAfter, 0, "Wallet balance should be 0");
        assertEq(
            hackBalanceAfter,
            walletBalanceBefore,
            "Hack should have all coins"
        );
    }
}
//INSTANCE_AD=0x6b93e29A620E86e3F1876dd230fe0734312607cb forge test --mt testSolvesLeve27 -vvv
