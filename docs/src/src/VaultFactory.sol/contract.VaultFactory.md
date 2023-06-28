# VaultFactory
[Git Source](https://github.com/stake-for-impact/stake-for-impact-contracts/blob/695b7bcd51b692b533a2b354bd5483ff5163fb9b/src/VaultFactory.sol)

**Inherits:**
Ownable, Pausable


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
function createVault(address _beneficiary, string memory name, string memory description) external whenNotPaused;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_beneficiary`|`address`|Address of the beneficiary (Charity, fund, NGO, etc.)|
|`name`|`string`|Name of the vault|
|`description`|`string`|Description of the vault|


### vaultsNumber

Returns a number of vaults created


```solidity
function vaultsNumber() external view returns (uint256);
```

