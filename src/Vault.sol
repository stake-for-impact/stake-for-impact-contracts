// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import {IstETH} from './interfaces/IstETH.sol';
import {ImpactETHtoken} from './imETHtoken.sol';

/**
    @title Impact Vault contract
    @notice Users can deposit ETH to this contract, that will be staked with Lido. 
    The staking rewards will be distributed to the beneficairy of the contract.
 */

contract Vault {

    IstETH public stETH;
    ImpactETHtoken public imETH;
    
    // @notice Wallet address of the beneficiary (Charity, fund, NGO, etc.)
    address public beneficiaryAddress;

    // @notice Mapping of user's addresses and amount of ETH they have deposited to this contract (represented as imETH)
    mapping(address => uint256) public userBalance;

    constructor(address _stETHaddress, address _beneficiary, address _imETHaddress) {
        stETH = IstETH(_stETHaddress);
        beneficiaryAddress = _beneficiary;
        imETH = ImpactETHtoken(_imETHaddress);
    }

    /**
        @notice This function allows users to deposit ETH to the contract. The amount of ETH deposited will be minted as imETH tokens
     */
    function deposit() external payable {
        imETH.mint(msg.sender, msg.value);
        this.stakeToLido();
    }

    /**
        @notice This function allows users to withdraw funds from the contract. The withdrawal amount should not exceed 
        user's initial deposit. Amount of the imETH tokens will be burned
        @param _amountToWithdraw Amount of funds to withdraw
     */
    function withdraw(uint _amountToWithdraw) external {
        //require statement checks that _amountToWithdraw is not greater than in mapping userBalance
        require(userBalance[msg.sender] >= _amountToWithdraw, 'You cannot withdraw more than you deposited');
        imETH.burn(msg.sender, _amountToWithdraw);
        stETH.transfer(msg.sender, stETH.getPooledEthByShares(_amountToWithdraw));
    }

    /**
        @notice This function allows users to stake available ETH in the contract with Lido
     */
    function stakeToLido() external payable {
        stETH.submit{value: address(this).balance}(address(this));
    }

    /**
        @notice This function calculates unharvested rewards and distributes them to the beneficiary
    */
    function harvestRewards() external {
        uint256 _stETHBalance = stETH.balanceOf(address(this));
        uint256 unharvestedRewards = stETH.getPooledEthByShares(_stETHBalance);
        require(unharvestedRewards > 0, 'No rewards to harvest');
        stETH.transfer(beneficiaryAddress, unharvestedRewards);
    
    }

    /** 
        @notice Enables to send rest of funds that are not possible to withdraw to the Harvest Manager contract
    */
    function sweep() external {

    }

    // * receive function
    receive() external payable {
        imETH.mint(msg.sender, msg.value);
        this.stakeToLido();
    }
}