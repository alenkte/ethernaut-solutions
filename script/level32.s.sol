// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Hack, ECLocker} from "../src/level32.sol";

contract Level32Script is Script {
    function run(address instanceAddress, address sender) external {
        ECLocker target = ECLocker(instanceAddress);

        address controllerBefore = target.controller();
        console.log("Controller before:", controllerBefore);
        console.log("Sender address:", sender);

        vm.startBroadcast(sender);
        Hack attackContract = new Hack(instanceAddress);
        attackContract.hack();
        vm.stopBroadcast();

        address controllerAfter = target.controller();
        console.log("Controller after:", controllerAfter);
        console.log("Attack successful:", controllerAfter == address(0));
    }
}
//forge script script/level32.s.sol:Level32Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address,address)" your instanse your wallet address
