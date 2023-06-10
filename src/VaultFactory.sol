// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// Uncomment this line to use console.log
import "forge-std/console.sol";
import {Vault} from "./Vault.sol";
import {ImpactETHtoken} from "./imETHtoken.sol";
import {IstETH} from "./interfaces/IstETH.sol";

struct VaultInfo {
    string name;
    string description;
    address beneficiary;
    address vaultAddress;
}

contract VaultFactory {
    ImpactETHtoken public imEth;
    IstETH public stETH;
    VaultInfo[] public vaults;
    address public imEthAddress;

    constructor(address _stETH) {
        stETH = IstETH(_stETH);
        imEth = new ImpactETHtoken();
        imEthAddress = address(imEth);
    }

    function createVault(
        address _beneficiary,
        string memory name,
        string memory description
    ) external {
        Vault newVault = new Vault(
            address(stETH),
            _beneficiary,
            address(imEth)
        );
        imEth.grantRole(imEth.MINTER_ROLE(), address(newVault));
        VaultInfo memory newVaultInfo = VaultInfo(
            name,
            description,
            _beneficiary,
            address(newVault)
        );
        vaults.push(newVaultInfo);
    }

    function vaultsNumber() external view returns (uint) {
        return vaults.length;
    }
}
