// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MagicNum {
    address public solver;

    constructor() {}

    function setSolver(address _solver) public {
        solver = _solver;
    }

    /*
    ____________/\\\_______/\\\\\\\\\_____        
     __________/\\\\\_____/\\\///////\\\___       
      ________/\\\/\\\____\///______\//\\\__      
       ______/\\\/\/\\\______________/\\\/___     
        ____/\\\/__\/\\\___________/\\\//_____    
         __/\\\\\\\\\\\\\\\\_____/\\\//________   
          _\///////////\\\//____/\\\/___________  
           ___________\/\\\_____/\\\\\\\\\\\\\\\_ 
            ___________\///_____\///////////////__
    */
}

interface IMagicNum {
    function setSolver(address _solver) external;
}

contract MagicNumSolver {
    function solve(address _target) public {
        bytes
            memory bytecode = hex"600a600c600039600a6000f3602a60005260206000f3"; //you need to calculate the return 42 value bytecode, use opcodes
        address solver;

        assembly {
            solver := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        require(solver != address(0), "Deployment failed");

        IMagicNum(_target).setSolver(solver);
    }
}
