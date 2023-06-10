// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from 'forge-std/Script.sol';
import {ImpactETHtoken} from '../src/imETHtoken.sol';
import {Vault} from '../src/Vault.sol';
import {VaultFactory} from '../src/VaultFactory.sol';

contract Deployment is Script {
    Vault public vault;
    ImpactETHtoken public imETH;
    VaultFactory public vaultFactory;

    address public frxEthMinterAddress = 0xbAFA44EFE7901E04E39Dad13167D089C559c1138;
    address public sfrxEthAddress = 0xac3E018457B222d93114458476f3E3416Abbe38F;
    address public beneficiaryAddress = 0x717654f0E07450e47A53e6A33eE191852C47CaF8;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        vaultFactory = new VaultFactory(frxEthMinterAddress, sfrxEthAddress);
        vaultFactory.createVault(beneficiaryAddress);

        vm.stopBroadcast();
    }
}