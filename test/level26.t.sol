//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {AlertBot, DoubleEntryPoint, IForta} from "../src/level26.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract level26Test is Test {
    DoubleEntryPoint target;

    function setUp() public {
        vm.createSelectFork("SEPOLIA");
        address instanceAddress = vm.envAddress("INSTANCE_AD");
        target = DoubleEntryPoint(instanceAddress);
    }

    function testSolvesLeve26() public {
        address player = target.player();
        address vault = target.cryptoVault();
        IForta forta = target.forta();

        vm.startPrank(player, player);
        AlertBot bot = new AlertBot(vault);
        forta.setDetectionBot(address(bot));
        vm.stopPrank();

        address detectionBot = address(forta.usersDetectionBots(player));
        assertEq(detectionBot, address(bot), "Bot should be set for player");

        uint256 alertsBefore = forta.botRaisedAlerts(address(bot));
        console.log("Alerts before:", alertsBefore);

        bytes memory msgData = abi.encodeWithSelector(
            target.delegateTransfer.selector,
            address(0x123),
            100,
            vault
        );

        forta.notify(player, msgData);

        uint256 alertsAfter = forta.botRaisedAlerts(address(bot));
        console.log("Alerts after:", alertsAfter);
        assertTrue(alertsAfter > alertsBefore, "Alert should be raised");
    }
}
//INSTANCE_AD=0xdBE0895bb66F99d76dc11f4dA00952477496EE1c forge test --mt testSolvesLeve26 -vvv
