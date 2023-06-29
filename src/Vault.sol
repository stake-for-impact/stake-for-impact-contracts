// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import {IstETH} from './interfaces/IstETH.sol';
import {ImpactETHtoken} from './imETHtoken.sol';
import {Ownable} from 'openzeppelin-contracts/access/Ownable.sol';
import {Pausable} from 'openzeppelin-contracts/security/Pausable.sol';

/**
    @title Impact Vault contract
    @notice Users can deposit ETH to this contract, that will be staked with Lido. 
    The staking rewards will be distributed to the beneficairy of the contract.
 */

contract Vault is Ownable, Pausable {

    IstETH public stETH;
    ImpactETHtoken public imETH;
    
    // @notice Wallet address of the beneficiary (Charity, fund, NGO, etc.)
    address public beneficiaryAddress;

    // @notice Total amount of ETH deposited to this contract
    uint256 public totalDepositedEth;

    // @notice Mapping of user's addresses and amount of ETH they have deposited to this contract (represented as imETH)
    mapping(address => uint256) public userBalance;

    // @notice Event that is emitted when a new user deposits ETH to the contract
    event Deposit(address indexed user, uint256 amount);

    // @notice Event that is emitted when a user withdraws ETH from the contract
    event Withdraw(address indexed user, uint256 amount);

    // @notice Event that is emitted when sktakeToLido function is called
    event StakeToLido(uint256 amount);

    // @notice Event that is emitted when rewardsa re harvested
    event HarvestRewards(uint256 amount);

    constructor(address _stETHaddress, address _beneficiary, address _imETHaddress) {
        stETH = IstETH(_stETHaddress);
        beneficiaryAddress = _beneficiary;
        imETH = ImpactETHtoken(_imETHaddress);
    }

    /**
        @notice This function allows users to deposit ETH to the contract. The amount of ETH deposited will be minted as imETH tokens
     */
    function deposit() external payable whenNotPaused {
        imETH.mint(msg.sender, msg.value);
        this.stakeToLido();
        userBalance[msg.sender] += msg.value;
        totalDepositedEth += msg.value;
        emit Deposit(msg.sender, msg.value);
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
        userBalance[msg.sender] -= _amountToWithdraw;
        totalDepositedEth -= _amountToWithdraw;
        stETH.transfer(msg.sender, stETH.getSharesByPooledEth(_amountToWithdraw));
        emit Withdraw(msg.sender, _amountToWithdraw);
    }

    /**
        @notice This function allows users to stake available ETH in the contract with Lido
     */
    function stakeToLido() external payable whenNotPaused {
        emit StakeToLido(address(this).balance);
        stETH.submit{value: address(this).balance}(address(this));
    }

    /**
        @notice This function calculates unharvested rewards and distributes them to the beneficiary
    */
    function harvestRewards() external whenNotPaused {
        uint256 _totalLidoShares = stETH.sharesOf(address(this));
        uint256 unharvestedRewards = _totalLidoShares - stETH.getSharesByPooledEth(totalDepositedEth);
        require(unharvestedRewards > 0, 'No rewards to harvest');
        stETH.transfer(beneficiaryAddress, stETH.getPooledEthByShares(unharvestedRewards));
        emit HarvestRewards(unharvestedRewards);
    }

    /**
        @notice This function allows to transfer residues of stETH to the beneficiary, when all depositors 
        have withdrawn their stakes.
    */
    function transferResidues() external onlyOwner {
        require(this.totalDepositedEth() == 0, 'There are still depositors');
        stETH.transfer(beneficiaryAddress, stETH.sharesOf(address(this)));
    }

    // * receive function
    receive() external payable {
        imETH.mint(msg.sender, msg.value);
        this.stakeToLido();
    }
}