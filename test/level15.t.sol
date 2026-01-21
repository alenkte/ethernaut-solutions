//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {NaughtCoin, Hack} from "../src/level15.sol";

contract level15Test is Test {
    NaughtCoin target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = NaughtCoin(instanceAddress);
    }

    function testSolvesLeve15() public {
        address player = target.player();

        vm.startPrank(player, player);

        Hack hackContract = new Hack(address(target));
        uint256 balance = target.balanceOf(player);
        target.approve(address(hackContract), balance);

        hackContract.hack();
        vm.stopPrank();

        assertEq(target.balanceOf(player), 0);
    }
}
//INSTANCE_AD=0xc897D833567c56FF487afcBdB7056A228F664FF8 forge test --mt testSolvesLeve15 -vvv
