# VaultFactory
[Git Source](https://github.com/stake-for-impact/stake-for-impact-contracts/blob/34f949c11ae27916b9e458099dad829ed45a3068/src/VaultFactory.sol)

**Inherits:**
Ownable


## State Variables
### imEth

```solidity
ImpactETHtoken public imEth;
```


### stETH

```solidity
IstETH public stETH;
```


### vaults

```solidity
VaultInfo[] public vaults;
```


### imEthAddress

```solidity
address public imEthAddress;
```


### isContractActive

```solidity
bool public isContractActive;
```


## Functions
### constructor


```solidity
constructor(address _stETH);
```

### createVault

This function allows to create a new vault


```solidity
function createVault(address _beneficiary, string memory name, string memory description) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_beneficiary`|`address`|Address of the beneficiary (Charity, fund, NGO, etc.)|
|`name`|`string`|Name of the vault|
|`description`|`string`|Description of the vault|


### vaultsNumber


```solidity
function vaultsNumber() external view returns (uint256);
```

### pauseContract

This function allows to pause the contract, when enabled, only withdrawals are possible, no deposits


```solidity
function pauseContract() external onlyOwner;
```

### unpauseContract

This function allows to unpause the contract, when enabled, deposits are possible


```solidity
function unpauseContract() external onlyOwner;
```

