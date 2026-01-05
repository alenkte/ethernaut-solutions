//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Test, console} from "forge-std/Test.sol";
import {Hack, Delegation} from "../src/level6.sol";

contract level6Test is Test {
    Delegation target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = Delegation(instanceAddress);
    }

    function testSolvesLeve6() public {
        address hacker = makeAddr("hacker");
        vm.startPrank(hacker);
        Hack hackContract = new Hack(address(target));
        hackContract.hack();
        vm.stopPrank();
        console.log("target.owner(): ", target.owner());
        console.log("hacker: ", address(hacker));
        assertTrue(target.owner() == address(hackContract));
    }
}
//INSTANCE_AD=0x755544a57002630fFd4C32AD6CefCbDf93fF8366 forge test --mt testSolvesLeve6 -vvv
