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

    address public stEthAddress = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84; // stETH on Ethereum
    address public beneficiaryAddress = 0x717654f0E07450e47A53e6A33eE191852C47CaF8;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        vaultFactory = new VaultFactory(stEthAddress);
        vaultFactory.createVault(beneficiaryAddress);

        vm.stopBroadcast();
    }
}