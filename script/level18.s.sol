// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {MagicNum, MagicNumSolver} from "../src/level18.sol";

contract Level18Script is Script {
    function run(address instanceAddress) external {
        MagicNum target = MagicNum(instanceAddress);
        address solverBefore = target.solver();
        console.log("Solver before: ", solverBefore);

        vm.startBroadcast();
        MagicNumSolver solver = new MagicNumSolver();
        solver.solve(instanceAddress);
        vm.stopBroadcast();

        address solverAfter = target.solver();
        console.log("Solver after: ", solverAfter);

        (bool success, bytes memory data) = solverAfter.call("");
        require(success, "Call failed");
        uint256 result = abi.decode(data, (uint256));
        console.log("Solver contract returns: ", result);

        console.log(
            "Attack successful: ",
            result == 42 && solverAfter != address(0)
        );
    }
}
//forge script script/level18.s.sol:Level18Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account yourkey --sig "run(address)" your instance address
