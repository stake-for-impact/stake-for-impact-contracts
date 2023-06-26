# ImpactETHtoken
[Git Source](https://github.com/stake-for-impact/stake-for-impact-contracts/blob/34f949c11ae27916b9e458099dad829ed45a3068/src/imETHtoken.sol)

**Inherits:**
ERC20, ERC20Burnable, AccessControl

ERC20 token representing user's stake in one of the Impact Vaults that are part of
Stake for Impact protocol. While the token can be transfered, only its owner can redeem it and only against the vault
they have staked in. The token is minted when user stakes in a vault and burned when user redeems their stake. The vault factoy


## State Variables
### MINTER_ROLE

```solidity
bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
```


## Functions
### constructor


```solidity
constructor() ERC20("Impact ETH", "imETH");
```

### mint

Mints tokens to the specified address. Can be called by Vaults that are part of Stake
for Impact protocol.


```solidity
function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`to`|`address`|address to mint tokens to|
|`amount`|`uint256`|amount of tokens to mint|


### burn

Burns tokens from the specified address. Can be called by Vaults that are part of Stake
for Impact protocol.


```solidity
function burn(address from, uint256 amount) public onlyRole(MINTER_ROLE);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`from`|`address`|address to burn tokens from|
|`amount`|`uint256`|amount of tokens to burn|


