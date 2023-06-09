// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// Imports of Openzeppelin security contracts

import {Ownable} from 'openzeppelin-contracts/access/Ownable.sol'; // allows usage onlyOwner modifier
import {ERC20} from 'openzeppelin-contracts/token/ERC20/ERC20.sol';
import {ILido} from './interfaces/ILido.sol';
import {IstETH} from './interfaces/IstETH.sol';
import {HarvestManager} from './HarvestManager.sol';

contract Vault is Ownable, ERC20 {

    // Initiate Lido interface
    ILido public lidoContract;
    IstETH public stETH;
    HarvestManager public harvestManager;

    address public rewardAddress;
    address public vaultOwner;
    address public harvestManagerAddress;
    bool public emergencyMode;
    
    event OwnershipTransfered(address newOwner);

    event ManagerChanged(address newManager);

    constructor(address _lidoContractAddress, address _rewardAddress, address _harvestManagerAddress) ERC20("Impact ETH", "imETH") {

        rewardAddress = _rewardAddress;
        lidoContract = ILido(_lidoContractAddress);
        harvestManagerAddress = _harvestManagerAddress;
        emergencyMode = false;

    }


    ////////////////////////////////////
    /// USER FUNCTIONS
    /// https://solidity-by-example.org/defi/vault/
    /////////////////////////////////////

    function deposit() external payable {
        _mint(msg.sender, msg.value);
    }

    function withdraw(uint _amountToWithdraw) external {
        require((this.balanceOf(msg.sender)>= _amountToWithdraw), 'You cannot withdraw more than you deposited');
        _burn(msg.sender, _amountToWithdraw);
        
        /*
        To be done
        token.transfer(msg.sender, _amountToWithdraw);
        */
    }

    function stakeToLido() external payable {
        lidoContract.submit{value: msg.value}(rewardAddress);
    }

    /**
        @notice This function calculates and harvester rewards and harvests them if any
    */
    function harvestRewards() external {

        // Variable to store amount of unharvested rewards
        uint256 _stETHBalance = stETH.balanceOf(address(this));
        uint256 unharvestedRewards = stETH.getPooledEthByShares(_stETHBalance);
        require(unharvestedRewards > 0, 'No rewards to harvest');
        stETH.transfer(address(harvestManager), unharvestedRewards);
    
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
        harvestManagerAddress = _newManager;
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