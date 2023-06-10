
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "forge-std/console.sol";
import {Vault} from "./Vault.sol";
import {ImpactETHtoken} from './imETHtoken.sol';
import {IstETH} from './interfaces/IstETH.sol';


contract VaultFactory {

    ImpactETHtoken public imEth;
    IstETH public stETH;
    address[] public vaults;
    address public imEthAddress;

    constructor(address _stETH){
        stETH = IstETH(_stETH);
        imEth = new ImpactETHtoken();
        imEthAddress = address(imEth);
    }

    function createVault(address _beneficiary) external {
        Vault newVault = new Vault(address(stETH), _beneficiary, address(imEth));
        imEth.grantRole(imEth.MINTER_ROLE(), address(newVault));
        vaults.push(address(newVault));
    }

    function vaultsNumber() external view returns(uint){
        return vaults.length;
    }

}