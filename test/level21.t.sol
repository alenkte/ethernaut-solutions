//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Shop, Hack} from "../src/level21.sol";

contract level21Test is Test {
    Shop target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = Shop(instanceAddress);
    }

    function testSolvesLeve21() public {
        address hacker = makeAddr("hacker");
        uint256 priceBefore = target.price();
        bool isSoldBefore = target.isSold();
        console.log("price before: ", priceBefore);
        console.log("isSold before: ", isSoldBefore);

        vm.startPrank(hacker, hacker);
        Hack hackContract = new Hack(address(target));
        hackContract.hack();
        vm.stopPrank();

        uint256 priceAfter = target.price();
        bool isSoldAfter = target.isSold();
        console.log("price after: ", priceAfter);
        console.log("isSold after: ", isSoldAfter);

        assertTrue(isSoldAfter);
        assertTrue(priceAfter < 100);
    }
}
//INSTANCE_AD=0xA017059008850BE63328FfDBE670e521c594B19c forge test --mt testSolvesLeve21 -vvv
