# VaultFactory
[Git Source](https://github.com/stake-for-impact/stake-for-impact-contracts/blob/41d39fa73e1fd805ac874252d72e779f9bd6f027/src/VaultFactory.sol)

**Inherits:**
Pausable


## State Variables
### imNFT

```solidity
StakeForImpactNFT public imNFT;
```


### stETH

```solidity
IstETH public stETH;
```


### vaults

```solidity
VaultInfo[] public vaults;
```


### imNFTaddress

```solidity
address public imNFTaddress;
```


## Functions
### constructor


```solidity
constructor(address _stETHaddress, address _imNFTaddress);
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

## Events
### VaultCreated
Event that is emitted when a new vault is created


```solidity
event VaultCreated(
    address indexed vaultAddress,
    address indexed beneficiary,
    string name,
    string description,
    address indexed msgSender
);
```

