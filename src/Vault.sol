// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// Imports of Openzeppelin security contracts

import "@openzeppelin/contracts/access/Ownable.sol"; // allows usage onlyOwner modifier

/*
@notice initiating Lido interface in order use Lido staking
**/

interface ILido {
    function submit(address _rewardAddress) external payable;
}

contract Vault is Ownable {

    // Initiate Lido interface
    ILido public lidoContract;

    address public rewardAddress;

    IERC20 public immutable impactETH;

    // total supply of minted impactETH
    uint public totalSupply;

    // maps minted impactETH to users addresses
    mapping(address => uint) public balanceOf;


    address public vaultOwner;
    address public harvestManager;
    bool public emergencyMode;
    
    event OwnershipTransfered(address newOwner);

    event ManagerChanged(address newManager);

    constructor(address _token, address _lidoContractAddress, address _rewardAddress) {

        rewardAddress = _rewardAddress
        lidoContract = ILido(_lidoContractAddress);

        impactETH = IERC20(_token);

        _transferOwnership(_msgSender());

        harvestManager = msg.sender;
        emergencyMode = false;

    }


    ////////////////////////////////////
    /// USER FUNCTIONS
    /// https://solidity-by-example.org/defi/vault/
    /////////////////////////////////////


    function _mint(address _to, uint _mintedAmount) private {
        totalSupply += _mintedAmount;
        balanceOf[_to] += _mintedAmount;
    }


    function deposit(uint _amountToDeposit) external payable {
        _mint(msg.sender, _amount);
        token.transferFrom(msg.sender, address(this), _amount);
    }


    function _burn(address _from, uint _burnAmount) private {
        totalSupply -= _burnAmount;
        balanceOf[_from] -= _burnAmount;
    }



    function withdraw(uint _amountToWithdraw) external {
        require((token.balanceOf(address(this))>= _amountToWithdraw), 'You cannot withdraw more than you deposited');
        _burn(msg.sender, _amountToWithdraw);
        
        /*
        To be done
        token.transfer(msg.sender, _amountToWithdraw);
        */
    }

    function stakeToLido() external payable {
        lidoContract.submit{value: msg.value}(rewardAddress);
    }

    function harvestRewards()


    ////////////////////////////////////
    /// OWNER FUNCTIONS
    /////////////////////////////////////
 
 
    /** 
        @notice changes the controling contract - Harvest manager
        @param _newManager
    */

    function changeHarvestManager(address _newManager) public onlyOwner {
        require(_newManager != address(0), 'Address cannot be zero address');
        harvestManager = _newManager;
        emit ownershipTransfered(_newOwner);
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

    function sweep() onlyOwner {

    }

    // * receive function
    receive() external payable {
        
    }

    // * fallback function
    fallback() external payable {

    }



    interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
    }
}