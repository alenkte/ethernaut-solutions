//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Hack} from "../src/level19.sol";

interface IAlienCodex {
    function owner() external view returns (address);

    function contact() external view returns (bool);

    function makeContact() external;

    function retract() external;

    function revise(uint256 i, bytes32 _content) external;
}

contract level19Test is Test {
    IAlienCodex target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = IAlienCodex(instanceAddress);
    }

    function testSolvesLeve19() public {
        address hacker = makeAddr("hacker");
        address ownerBefore = target.owner();
        console.log("Owner before: ", ownerBefore);

        vm.startPrank(hacker, hacker);
        Hack hackContract = new Hack(address(target));
        hackContract.hack();
        vm.stopPrank();

        address ownerAfter = target.owner();
        console.log("Owner after: ", ownerAfter);
        assertEq(target.owner(), hacker);
    }
}
//INSTANCE_AD=0x77589e7EAEf016A48225D99d1aec26D69444a0Ad forge test --mt testSolvesLeve19 -vvv
