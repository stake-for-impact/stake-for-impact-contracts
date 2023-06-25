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

    address public stEthAddress = 0x1643E812aE58766192Cf7D2Cf9567dF2C37e9B7F; // stETH on Ethereum
    address public beneficiaryAddress = 0x717654f0E07450e47A53e6A33eE191852C47CaF8; //

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        vaultFactory = new VaultFactory(stEthAddress);
        vaultFactory.createVault(beneficiaryAddress, "TestVault", "This is a test vault and factory of Stake for Impact system");

        vm.stopBroadcast();
    }
}