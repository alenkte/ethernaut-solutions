// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {AlertBot, DoubleEntryPoint, IForta} from "../src/level26.sol";

contract Level26Script is Script {
    function run(address instanceAddress, address sender) external {
        DoubleEntryPoint target = DoubleEntryPoint(instanceAddress);
        address player = target.player();
        address vault = target.cryptoVault();
        IForta forta = target.forta();

        console.log("Instance address:", instanceAddress);
        console.log("Player address:", player);
        console.log("Sender address:", sender);
        console.log("Vault address:", vault);
        console.log("Forta address:", address(forta));

        vm.startBroadcast();
        AlertBot bot = new AlertBot(vault);
        vm.stopBroadcast();

        require(sender == player, "Sender must be player");

        vm.startBroadcast(sender);
        forta.setDetectionBot(address(bot));
        vm.stopBroadcast();

        address detectionBot = address(forta.usersDetectionBots(player));
        console.log("Bot deployed at:", address(bot));
        console.log("Bot set for player:", detectionBot);
        console.log("Attack successful:", detectionBot == address(bot));
    }
}
//forge script script/level26.s.sol:Level26Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address,address)" your instance address your wallet address
