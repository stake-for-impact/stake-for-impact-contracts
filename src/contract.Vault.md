# Vault
[Git Source](https://github.com/stake-for-impact/stake-for-impact-contracts/blob/41d39fa73e1fd805ac874252d72e779f9bd6f027/src/Vault.sol)

**Inherits:**
Pausable

Users can deposit ETH to this contract, that will be staked with Lido.
The staking rewards will be distributed to the beneficairy of the contract.


## State Variables
### stETH

```solidity
IstETH public stETH;
```


### imNFT

```solidity
StakeForImpactNFT public imNFT;
```


### beneficiaryAddress

```solidity
address public beneficiaryAddress;
```


### totalDepositedEth

```solidity
uint256 public totalDepositedEth;
```


## Functions
### constructor


```solidity
constructor(address _stETHaddress, address _beneficiary, address _imNFTaddress);
```

### deposit

This function allows users to deposit ETH to the contract. The amount of ETH deposited will be minted as imETH tokens


```solidity
function deposit() external payable whenNotPaused returns (uint256);
```

### withdraw

This function allows users to withdraw funds from the contract. Fractional withdrawals are not supported. User can withdraw the full
amount deposited and imNFT associated with the deposit will be burned


```solidity
function withdraw(uint256 tokenId) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|Token ID of the imNFT token user wants to withdraw|


### stakeToLido

This function allows users to stake available ETH in the contract with Lido


```solidity
function stakeToLido() external payable whenNotPaused;
```

### harvestRewards

This function calculates unharvested rewards and distributes them to the beneficiary


```solidity
function harvestRewards() external whenNotPaused;
```

### transferResidues

This function allows to transfer residues of stETH to the beneficiary, when all depositors
have withdrawn their stakes.


```solidity
function transferResidues() external;
```

### receive


```solidity
receive() external payable;
```

## Events
### Deposit

```solidity
event Deposit(address indexed user, uint256 amount, uint256 tokenId);
```

### Withdraw

```solidity
event Withdraw(address indexed user, uint256 amount, uint256 tokenId);
```

### StakeToLido

```solidity
event StakeToLido(uint256 amount);
```

### HarvestRewards

```solidity
event HarvestRewards(uint256 amount);
```

