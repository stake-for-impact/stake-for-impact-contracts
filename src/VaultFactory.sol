// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// Uncomment this line to use console.log
import "forge-std/console.sol";
import {Vault} from "./Vault.sol";
import {ImpactETHtoken} from "./imETHtoken.sol";
import {IstETH} from "./interfaces/IstETH.sol";
import {Ownable} from 'openzeppelin-contracts/access/Ownable.sol';
import {Pausable} from 'openzeppelin-contracts/security/Pausable.sol';

struct VaultInfo {
    string name;
    string description;
    address beneficiary;
    address vaultAddress;
}

contract VaultFactory is Ownable, Pausable {

    // @notice Instance of the ImpactETHtoken contract
    ImpactETHtoken public imEth;

    // @notice Instance of the stETH contract
    IstETH public stETH;

    // @notice Array of all the vaults created
    VaultInfo[] public vaults;

    // @notice imETH contract address
    address public imEthAddress;

    // @notice Boolean variable that indicates if the contract is active or not
    bool public isContractActive;

    constructor(address _stETH) {
        stETH = IstETH(_stETH);
        imEth = new ImpactETHtoken();
        imEthAddress = address(imEth);
        isContractActive = true;
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

    /**
        @notice Returns a number of vaults created
    */
    function vaultsNumber() external view returns (uint) {
        return vaults.length;
    }
}
