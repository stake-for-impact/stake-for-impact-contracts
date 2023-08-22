// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import {IstETH} from './interfaces/IstETH.sol';
import {StakeForImpactNFT} from './imNFT.sol';
import {Pausable} from 'openzeppelin-contracts/security/Pausable.sol';
import {NFTinfo} from './imNFT.sol';

/**
    @title Impact Vault contract
    @notice Users can deposit ETH to this contract, that will be staked with Lido. 
    The staking rewards will be distributed to the beneficairy of the contract.
 */

contract Vault is Pausable {

    IstETH public stETH;
    StakeForImpactNFT public imNFT;
    
    // @notice Wallet address of the beneficiary (Charity, fund, NGO, etc.)
    address public beneficiaryAddress;

    // @notice Total amount of ETH deposited to this contract
    uint256 public totalDepositedEth;


    // @notice Event that is emitted when a new user deposits ETH to the contract
    event Deposit(address indexed user, uint256 amount, uint256 tokenId);

    // @notice Event that is emitted when a user withdraws ETH from the contract
    event Withdraw(address indexed user, uint256 amount, uint256 tokenId);

    // @notice Event that is emitted when sktakeToLido function is called
    event StakeToLido(uint256 amount);

    // @notice Event that is emitted when rewardsa re harvested
    event HarvestRewards(uint256 amount);

    constructor(address _stETHaddress, address _beneficiary, address _imNFTaddress) {
        stETH = IstETH(_stETHaddress);
        beneficiaryAddress = _beneficiary;
        imNFT = StakeForImpactNFT(_imNFTaddress);
    }

    /**
        @notice This function allows users to deposit ETH to the contract. The amount of ETH deposited will be minted as imETH tokens
     */
    function deposit() external payable whenNotPaused returns(uint256) {
        uint256 tokenId = imNFT.safeMint(msg.sender, address(this), msg.value);
        this.stakeToLido();
        totalDepositedEth += msg.value;
        emit Deposit(msg.sender, msg.value, tokenId);
        return tokenId;
    }

    /**
        @notice This function allows users to withdraw funds from the contract. Fractional withdrawals are not supported. User can withdraw the full 
        amount deposited and imNFT associated with the deposit will be burned
        @param tokenId Token ID of the imNFT token user wants to withdraw
     */
    function withdraw(uint256 tokenId) external {
        require(imNFT.ownerOf(tokenId) == msg.sender, 'You are not the owner of this NFT');
        NFTinfo memory nftInfo = imNFT.getTokenDetails(tokenId);
        require(nftInfo.vaultAddress == address(this), 'This NFT is not associated with this vault');
        uint256 _ETHtoWithdraw = nftInfo.depositAmount;
        totalDepositedEth -= nftInfo.depositAmount;
        imNFT.burn(tokenId);
        stETH.transferShares(msg.sender, stETH.getSharesByPooledEth(_ETHtoWithdraw));
        emit Withdraw(msg.sender, _ETHtoWithdraw, tokenId);
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
        bool success = stETH.transfer(beneficiaryAddress, stETH.getPooledEthByShares(unharvestedRewards));
        require(success, "Transfer failed");
        emit HarvestRewards(unharvestedRewards);
    }

    /**
        @notice This function allows to transfer residues of stETH to the beneficiary, when all depositors 
        have withdrawn their stakes.
    */
    function transferResidues() external {
        require(this.totalDepositedEth() == 0, 'There are still depositors');
        bool success = stETH.transfer(beneficiaryAddress, stETH.sharesOf(address(this)));
        require(success, "Transfer failed");
        emit HarvestRewards(stETH.sharesOf(address(this)));
    }

    /**
        @notice This function can be called to check amount of unharvested staking rewards 
    */
    function checkUnharvestedRewards() external view returns(uint256) {
        uint256 _totalLidoShares = stETH.sharesOf(address(this));
        uint256 unharvestedRewards = _totalLidoShares - stETH.getSharesByPooledEth(totalDepositedEth);
        return unharvestedRewards;
    }

    // * receive function
    receive() external payable {
            imNFT.safeMint(msg.sender, address(this), msg.value);(msg.sender, msg.value);
            this.stakeToLido();
    }
}