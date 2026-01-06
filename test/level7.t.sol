//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Test, console} from "forge-std/Test.sol";
import {Hack, Force} from "../src/level7.sol";

contract level7Test is Test {
    Force target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = Force(instanceAddress);
    }

    function testSolvesLeve7() public {
        address hacker = makeAddr("hacker");
        vm.deal(hacker, 0.0001 ether);
        vm.startPrank(hacker);
        new Hack{value: 0.0001 ether}(payable(address(target)));
        vm.stopPrank();
        assertEq(address(target).balance, 0.0001 ether);
    }
}
//INSTANCE_AD=0x95E0Addb3710c77141A5419E41aDBbEF58F2D2b3 forge test --mt testSolvesLeve7 -vvv
