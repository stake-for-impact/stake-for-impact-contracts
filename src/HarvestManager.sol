// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import 'forge-std/console.sol';
import {Ownable} from 'openzeppelin-contracts/access/Ownable.sol';
import {IERC20} from 'openzeppelin-contracts/token/ERC20/IERC20.sol';
import {Vault} from './Vault.sol';

/**
    * @title HarvestManager
    * @dev HarvestManager contract
    * @notice HarvestManager is a contract that recieves earned staking rewards from the Vault contract 
    and distributes them to the beneficaires
*/

contract HarvestManager is Ownable {

    /// @notice Nested mapping that keeps track of all the existing beneficiaries, addresses of users of the Vault contract and how much shares each user has allocated to each beneficiary
    mapping(address => mapping(address => uint256)) public beneficiary;

    /// @notice Mapping that keeps track of all the existing beneficiaries and their total amount of shares
    mapping(address => uint256) public totalShares;

    /// @notice Variable that keeps track of the total amount of shares allocated to all the beneficiaries
    uint256 public totalSharesAcrossAll;

    /// @notice Array that keeps track of all existing beneficiaries
    address[] public beneficiariesList;

    /// @notice create instace of the Vault contract
    Vault public vault;
    IERC20 public stETH;

    /// @notice Event fired when new beneficiary is added
    event BeneficiaryAdded(address beneficiary, address user);

    /// @notice Event fired when shares are allocated to beneficiaries;
    event SharesAllocated(address[] _beneficiaries, uint256[] _shares);

    /// @notice Event fired when shares are renounced from beneficiaries;
    event SharesRenounced(address[] _beneficiaries, uint256[] _shares);

    constructor(address payable _vaultAddress, address _stETHAddress) {
        vault = Vault(_vaultAddress);
        stETH = IERC20(_stETHAddress);
    }

    /**
        * @notice Function that allows anyone to add a new beneficiary and sets its balance to 0 shares from 0 users
        * @param _beneficiary Address of the new beneficiary
    */
    function addBeneficiary(address _beneficiary) public {
        emit BeneficiaryAdded(_beneficiary, msg.sender);
        beneficiary[_beneficiary][msg.sender] = 0;
        beneficiariesList.push(_beneficiary);
    }

    /**
        @notice Function that allows to allocate part of their shares to one or more beneficiaries. The amount of shares user can allocate should not exceed balance of this user in vault contract
        @param _beneficiary[] Array of addresses of beneficiaries;
        @param _shares[] Array of shares to allocate to each beneficiary;
    */
    function allocateShares(address[] memory _beneficiary, uint256[] memory _shares) external {
        require(_beneficiary.length == _shares.length, "HarvestManager: length of _beneficiary and _shares arrays should be equal");
        require(_beneficiary.length > 0, "HarvestManager: length of _beneficiary array should be greater than 0");

        emit SharesAllocated(_beneficiary, _shares);

        // this for loop sums up all the shares that user has allocated to all the beneficiaries
        uint256 _totalShares = 0;
        for (uint256 i = 0; i < _beneficiary.length; i++) {
            _totalShares += _shares[i];
        }
        // require that total amount of shares allocated to beneficiaries does not exceed balance of this user in vault contract
        require(_totalShares <= vault.balanceOf(msg.sender), "HarvestManager: total amount of shares allocated to beneficiaries exceeds balance of this user in vault contract");
        
        for (uint256 i = 0; i < _beneficiary.length; i++) {
            beneficiary[_beneficiary[i]][msg.sender] += _shares[i];
        }

        /// for loop that updates totalShares mapping
        for (uint256 i = 0; i < _beneficiary.length; i++) {
            totalShares[_beneficiary[i]] += _shares[i];
            totalSharesAcrossAll += _shares[i];
        }
    }

    /**
        @notice Function that allows user to renounce shares allocated to one or more beneficiaries
        @param _beneficiary[] Array of addresses of beneficiaries;
        @param _shares[] Array of shares to renounce;
    */
    function renounceShares(address[] memory _beneficiary, uint256[] memory _shares) external {
        require(_beneficiary.length == _shares.length, "HarvestManager: length of _beneficiary and _shares arrays should be equal");
        require(_beneficiary.length > 0, "HarvestManager: length of _beneficiary array should be greater than 0");

        emit SharesRenounced(_beneficiary, _shares);

        // this for loop sums up all the shares that user has allocated to all the beneficiaries
        uint256 _totalShares = 0;
        for (uint256 i = 0; i < _beneficiary.length; i++) {
            _totalShares += _shares[i];
        }
        // require that total amount of shares allocated to beneficiaries does not exceed balance of this user in vault contract
        require(_totalShares <= vault.balanceOf(msg.sender), "HarvestManager: total amount of shares renounced from the beneficiaries exceeds balance of this user in vault contract");    

        for (uint256 i = 0; i < _beneficiary.length; i++) {
            beneficiary[_beneficiary[i]][msg.sender] -= _shares[i];
        }

        /// for loop that updates totalShares mapping
        for (uint256 i = 0; i < _beneficiary.length; i++) {
            totalShares[_beneficiary[i]] -= _shares[i];
            totalSharesAcrossAll -= _shares[i];
        }
    }

    /**
        @notice External function that can be called to distribute available stETH in this contract to all the beneficiaries, taking into account their total shares
    */
    function distributeHarvest() external {
        require(stETH.balanceOf(address(this)) > 0, "HarvestManager: there is no stETH to distribute");
        
        /// total outstandig supply of the Vault
        uint256 _totalOutstandigSupply = vault.totalSupply();

        require(totalSharesAcrossAll < _totalOutstandigSupply, "HarvestManager: total shares across all beneficiaries exceeds Vault outstanding supply");
        
        /// For loop that distributes stETH to all the beneficiaries according to their total shares
        for (uint256 i = 0; i < beneficiariesList.length; i++) {
            uint256 _amountToTransfer = stETH.balanceOf(address(this)) * totalShares[beneficiariesList[i]] / totalSharesAcrossAll;
            stETH.transfer(beneficiariesList[i], _amountToTransfer);
        }
    }
}