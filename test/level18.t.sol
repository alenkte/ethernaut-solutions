//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {MagicNum, MagicNumSolver} from "../src/level18.sol";

contract level18Test is Test {
    MagicNum target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = MagicNum(instanceAddress);
    }

    function testSolvesLeve18() public {
        address hacker = makeAddr("hacker");
        address solverBefore = target.solver();
        console.log("Solver before: ", solverBefore);

        vm.startPrank(hacker, hacker);
        MagicNumSolver solver = new MagicNumSolver();
        solver.solve(address(target));
        vm.stopPrank();

        address solverAfter = target.solver();
        console.log("Solver after: ", solverAfter);

        (bool success, bytes memory data) = solverAfter.call("");
        require(success, "Call failed");
        uint256 result = abi.decode(data, (uint256));
        console.log("Solver contract returns: ", result);

        assertTrue(result == 42);
        assertTrue(solverAfter != address(0));
    }
}
//INSTANCE_AD=0x35E523c78833349c4752EaB4c9f1506F0bEb1b5A forge test --mt testSolvesLeve18 -vvv
