// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Script, console2} from "forge-std/Script.sol";
import {MemesCoin} from "src/MemesCoin.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();
        MemesCoin memesCoin = new MemesCoin();
        console2.log("MemesCoin deployed at ", address(memesCoin));
        vm.stopBroadcast();
    }
}
