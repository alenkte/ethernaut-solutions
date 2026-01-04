//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Test, console} from "forge-std/Test.sol";
import {Hack, IToken} from "../src/level5.sol";

contract level5Test is Test {
    IToken target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = IToken(instanceAddress);
    }

    function testSolvesLeve5() public {
        address hacker = makeAddr("hacker");
        vm.startPrank(hacker);
        Hack hackContract = new Hack(hacker, address(target));
        hackContract.hack();
        vm.stopPrank();
        assertTrue(target.balanceOf(hacker) >= 1e18);
    }
}
//INSTANCE_AD=0xC25bbC754359E3a9E51bE8d169E3FfA726B03000 forge test --mt testSolvesLeve5 -vvv
