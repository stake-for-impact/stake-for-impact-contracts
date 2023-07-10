// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// Uncomment this line to use console.log
import "forge-std/console.sol";
import {Vault} from "./Vault.sol";
import {StakeForImpactNFT} from './imNFT.sol';
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
    StakeForImpactNFT public imNFT;

    // @notice Instance of the stETH contract
    IstETH public stETH;

    // @notice Array of all the vaults created
    VaultInfo[] public vaults;

    // @notice imETH contract address
    address public imNFTaddress;

    /**
        @notice Event that is emitted when a new vault is created
        @param vaultAddress Address of the new vault
        @param beneficiary Address of the beneficiary (Charity, fund, NGO, etc.)
        @param name Name of the vault
        @param description Description of the vault
        @param msgSender Address of the user who created the vault
     */
    event VaultCreated(
        address indexed vaultAddress,
        address indexed beneficiary,
        string name,
        string description,
        address indexed msgSender);

    constructor(address _stETHaddress, address _imNFTaddress) {
        stETH = IstETH(_stETHaddress); 
        imNFT = StakeForImpactNFT(_imNFTaddress);
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
            address(imNFT)
        );
        imNFT.grantMinterRole(address(newVault));
        VaultInfo memory newVaultInfo = VaultInfo(
            name,
            description,
            _beneficiary,
            address(newVault)
        );
        vaults.push(newVaultInfo);
        emit VaultCreated(
            address(newVault),
            _beneficiary,
            name,
            description,
            msg.sender
        );
    }

    /**
        @notice Returns a number of vaults created
    */
    function vaultsNumber() external view returns (uint) {
        return vaults.length;
    }
}
