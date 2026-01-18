//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Privacy} from "../src/level12.sol";

contract level12Test is Test {
    Privacy target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = Privacy(instanceAddress);
    }

    function testSolvesLeve12() public {
        bytes32 data = vm.load(address(target), bytes32(uint256(5)));
        console.logBytes32(data);
        target.unlock(bytes16(data));
        assertTrue(target.locked() == false);
    }
}
//INSTANCE_AD=0x8c86e7B1d45eCB708B5D17908260EdC025325Ee8 forge test --mt testSolvesLeve12 -vvv
