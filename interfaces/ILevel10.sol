// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ILevel10 {
    function balances(address _who) external view returns (uint256);

    function donate(address _to) external payable;

    function balanceOf(address _who) external view returns (uint256);

    function withdraw(uint256 _amount) external;
}
