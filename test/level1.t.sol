//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Fallback} from "../src/level1.sol";
import {Solver} from "../src/level1.sol";
import {Test} from "forge-std/Test.sol";

contract Level1Test is Test {
    Fallback target;
    Solver solver;

    function setUp() public {
        target = new Fallback();
        vm.deal(address(target), 10 ether);
        solver = new Solver(payable(address(target)));
    }

    function testSolve() public {
        solver.solve{value: 1 ether}();
        assertEq(target.owner(), address(solver));
        assertTrue(solver.checkIsSolved());
    }

    function testWithdrawSuccess() public {
        uint256 balanceBefore = address(solver).balance;
        solver.solve{value: 1 ether}();
        assertTrue(solver.checkIsSolved());
        assertEq(address(solver).balance, 11 ether);
        solver.withdrawforonwer();
        assertEq(address(solver).balance, 0);
    }

    receive() external payable {}
}

// forge test -vv -fork-url $SEPOLIA_RPC_URL
