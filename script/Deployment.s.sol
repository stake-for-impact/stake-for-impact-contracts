// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from 'forge-std/Script.sol';
import {StakeForImpactNFT} from '../src/imNFT.sol';
import {Vault} from '../src/Vault.sol';
import {VaultFactory} from '../src/VaultFactory.sol';
import "forge-std/console.sol";

contract Deployment is Script {
    Vault public vault;
    StakeForImpactNFT public imNFT;
    VaultFactory public vaultFactory;

    address public stEthAddress = 0x1643E812aE58766192Cf7D2Cf9567dF2C37e9B7F; // stETH on Ethereum
    address public beneficiaryAddress = 0x717654f0E07450e47A53e6A33eE191852C47CaF8; //

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        address vaultFactoryAddress = 0xf796e79C9C4CE508dEAe787bDC95F58f473B192d;
        vaultFactory = VaultFactory(vaultFactoryAddress);
        vaultFactory.createVault(beneficiaryAddress, "TestVault", "This is a test vault and factory of Stake for Impact system");
        //console.log("Vault address:", address(vaultFactory.vaults(0)));
        vm.stopBroadcast();
    }
}