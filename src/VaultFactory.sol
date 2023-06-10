// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// Uncomment this line to use console.log
import "forge-std/console.sol";
import {Vault} from "./Vault.sol";
import {ImpactETHtoken} from './imETHtoken.sol';
import {frxETHMinter} from 'frxETH-public/frxETHMinter.sol';
import {sfrxETH} from 'frxETH-public/sfrxETH.sol';


contract VaultFactory {

    ImpactETHtoken public imEth;
    sfrxETH public sfrxETHcontract;
    frxETHMinter public frxEthMinter;

    address[] public vaults;
    address public imEthAddress;

    constructor(address _frxEthMinterAddress, address _sfrxEthAddress){
        frxEthMinter = frxETHMinter(payable (_frxEthMinterAddress));
        sfrxETHcontract = sfrxETH(_sfrxEthAddress);
        imEth = new ImpactETHtoken();
        imEthAddress = address(imEth);
    }

    function createVault(address _beneficiary) external {
        Vault newVault = new Vault(address(frxEthMinter), address(sfrxETHcontract), _beneficiary, address(imEth));
        imEth.grantRole(imEth.MINTER_ROLE(), address(newVault));
        vaults.push(address(newVault));
    }

    function vaultsNumber() external view returns(uint){
        return vaults.length;
    }

}