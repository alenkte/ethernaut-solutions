//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "interfaces/ILevel10.sol";
import {Test} from "forge-std/Test.sol";
import {Hack} from "../src/level10.sol";
import {console} from "forge-std/console.sol";

contract level9Test is Test {
    ILevel10 target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address payable instanceAddress = payable(vm.envAddress("INSTANCE_AD"));
        target = ILevel10(payable(instanceAddress));
    }

    function testSolvesLeve10() public {
        address hacker = makeAddr("hacker");
        vm.deal(hacker, 0.001 ether);
        vm.startPrank(hacker);
        Hack hackContract = new Hack(payable(address(target)));
        hackContract.hack{value: 0.001 ether}();
        vm.stopPrank();
        assertTrue(address(target).balance == 0);
    }
}
//INSTANCE_AD=0xB10a55A81Bcd33115Ec0167e6721808AddB251d9 forge test --mt testSolvesLeve10 -vvv
