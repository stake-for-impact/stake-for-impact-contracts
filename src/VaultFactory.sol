// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// Uncomment this line to use console.log
import "forge-std/console.sol";
import {Vault} from "./Vault.sol";
import {ImpactETHtoken} from "./imETHtoken.sol";
import {IstETH} from "./interfaces/IstETH.sol";
import {Pausable} from 'openzeppelin-contracts/security/Pausable.sol';

struct VaultInfo {
    string name;
    string description;
    address beneficiary;
    address vaultAddress;
}

contract VaultFactory is Pausable {

    // @notice Instance of the ImpactETHtoken contract
    ImpactETHtoken public imETH;

    // @notice Instance of the stETH contract
    IstETH public stETH;

    // @notice Array of all the vaults created
    VaultInfo[] public vaults;

    // @notice imETH contract address
    address public imEthAddress;

    // @notice Boolean variable that indicates if the contract is active or not
    bool public isContractActive;

    constructor(address _stETH, address _imETH) {
        stETH = IstETH(_stETH);
        imEthAddress = address(_imETH);
        imETH = ImpactETHtoken(_imETH);
    }

    /**
        @notice This function allows to create a new vault
        @param _beneficiary Address of the beneficiary (Charity, fund, NGO, etc.)
        @param name Name of the vault
        @param description Description of the vault
    */
    function createVault(
        address _beneficiary,
        string memory name,
        string memory description
    ) external whenNotPaused {
        Vault newVault = new Vault(
            address(stETH),
            _beneficiary,
            address(imETH)
        );
        imETH.grantMinterRole(address(newVault));
        VaultInfo memory newVaultInfo = VaultInfo(
            name,
            description,
            _beneficiary,
            address(newVault)
        );
        vaults.push(newVaultInfo);
    }

    /**
        @notice Returns a number of vaults created
    */
    function vaultsNumber() external view returns (uint) {
        return vaults.length;
    }
}
