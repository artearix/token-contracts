// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {TOKENv1} from "../src/TOKENv1.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        address proxy = Upgrades.deployUUPSProxy(
            "TOKENv1.sol",
            abi.encodeCall(TOKENv1.initialize, address(this))
        );
    }
}
