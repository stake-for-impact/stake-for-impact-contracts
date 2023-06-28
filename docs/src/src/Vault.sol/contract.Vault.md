# Vault
[Git Source](https://github.com/stake-for-impact/stake-for-impact-contracts/blob/695b7bcd51b692b533a2b354bd5483ff5163fb9b/src/Vault.sol)

**Inherits:**
Ownable, Pausable

Users can deposit ETH to this contract, that will be staked with Lido.
The staking rewards will be distributed to the beneficairy of the contract.


## State Variables
### stETH

```solidity
IstETH public stETH;
```


### imETH

```solidity
ImpactETHtoken public imETH;
```


### beneficiaryAddress

```solidity
address public beneficiaryAddress;
```


### totalDepositedEth

```solidity
uint256 public totalDepositedEth;
```


### userBalance

```solidity
mapping(address => uint256) public userBalance;
```


## Functions
### constructor


```solidity
constructor(address _stETHaddress, address _beneficiary, address _imETHaddress);
```

### deposit

This function allows users to deposit ETH to the contract. The amount of ETH deposited will be minted as imETH tokens


```solidity
function deposit() external payable whenNotPaused;
```

### withdraw

This function allows users to withdraw funds from the contract. The withdrawal amount should not exceed
user's initial deposit. Amount of the imETH tokens will be burned


```solidity
function withdraw(uint256 _amountToWithdraw) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_amountToWithdraw`|`uint256`|Amount of funds to withdraw|


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
function transferResidues() external onlyOwner;
```

### receive


```solidity
receive() external payable;
```

## Events
### Deposit

```solidity
event Deposit(address indexed user, uint256 amount);
```

### Withdraw

```solidity
event Withdraw(address indexed user, uint256 amount);
```

### StakeToLido

```solidity
event StakeToLido(uint256 amount);
```

### HarvestRewards

```solidity
event HarvestRewards(uint256 amount);
```

