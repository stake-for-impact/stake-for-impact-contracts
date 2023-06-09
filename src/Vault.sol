// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// Imports of Openzeppelin security contracts

import {Ownable} from 'openzeppelin-contracts/access/Ownable.sol'; // allows usage onlyOwner modifier
import {ERC20} from 'openzeppelin-contracts/token/ERC20/ERC20.sol';
import {ILido} from './interfaces/ILido.sol';

/**
    * @title HarvestManager
    * @dev HarvestManager contract
    * @notice HarvestManager is a contract that recieves earned staking rewards from the Vault contract 
    and distributes them to the beneficaires
*/

contract Vault is Ownable, ERC20 {

    /// @notice Initiate Lido interface
    ILido public lidoContract;

    /// @notice  
    address public vaultOwner;

    /// @notice    
    address public harvestManager;
    
    /// @notice 
    bool public emergencyMode;
    
    /// @notice Event fired when owner of the contract is changed
    event OwnershipTransfered(address newOwner);

    /// @notice Event fired when contract of Harvest manager is changed
    event ManagerChanged(address newManager);

    constructor(address _token, address _lidoContractAddress) ERC20("Impact ETH", "imETH") {
        lidoContract = ILido(_lidoContractAddress);
        transferOwnership(_msgSender());
        harvestManager = msg.sender;
        emergencyMode = false;
    }

    /**
        * @notice 
    */
    function calculateRewards() public view returns (uint) {
        uint _undistributedRewards;
        _undistributedRewards = uint(stETH.balanceOf(address(this))) - uint(address(this).balance);
        return _undistributedRewards;
    }

    ////////////////////////////////////
    /// USER FUNCTIONS
    /////////////////////////////////////

    /**
        * @notice Function that sends ETH to Lido to obtain stETH
    */
    function stakeToLido() internal payable {
        lidoContract.submit{value: msg.value};
    }

    /**
        * @notice Function that enables to the user to deposit ETH in order to donate related rewards from staking
    */
    function deposit() external payable {
        _mint(msg.sender, msg.value);
        stakeToLido();
    }

    /**
        * @notice Function that enables to the user to withdraw their funds  
        * @param _amountToWithdraw amount that a user wants to withdraw
    */
    function withdraw(uint _amountToWithdraw) external {
        require((this.balanceOf(msg.sender)>= _amountToWithdraw), 'You cannot withdraw more than you deposited');
        _burn(msg.sender, _amountToWithdraw);
    }

    function harvestRewards() external {
        // to be done
    }


    ////////////////////////////////////
    /// OWNER FUNCTIONS
    /////////////////////////////////////
 
 
    /** 
        @notice changes the controling contract - Harvest manager
        @param _newManager Address of the new Harvest Manager
    */
    function changeHarvestManager(address _newManager) public onlyOwner {
        require(_newManager != address(0), 'Address cannot be zero address');
        harvestManager = _newManager;
        emit OwnershipTransfered(_newManager);
    }

    /** 
        @notice Enables to put contract into 'Emergency mode' thus it is not possible to deposit any funds
    */
    function activateEmergency() public onlyOwner{
        emergencyMode = true;
    }

    /** 
        @notice Enables to send rest of funds that are not possible to withdraw to the Harvest Manager contract
    */
    function sweep() external onlyOwner {

    }

    // * receive function
    receive() external payable {
        
    }

    // * fallback function
    fallback() external payable {

    }
}