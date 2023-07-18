# StakeForImpactNFT
[Git Source](https://github.com/stake-for-impact/stake-for-impact-contracts/blob/41d39fa73e1fd805ac874252d72e779f9bd6f027/src/imNFT.sol)

**Inherits:**
ERC721, ERC721Burnable, AccessControl


## State Variables
### MINTER_ROLE

```solidity
bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
```


### FACTORY_ROLE

```solidity
bytes32 public constant FACTORY_ROLE = keccak256("FACTORY_ROLE");
```


### _tokenIdCounter

```solidity
Counters.Counter private _tokenIdCounter;
```


### _tokenDetails

```solidity
mapping(uint256 => NFTinfo) private _tokenDetails;
```


## Functions
### constructor


```solidity
constructor() ERC721("Stake for Impact NFT", "imNFT");
```

### safeMint

This function will be called by vaults to issue an NFT when user deposits to vault. Parameters are written into struct


```solidity
function safeMint(address to, address vaultAddress, uint256 depositAmount)
    public
    onlyRole(MINTER_ROLE)
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`to`|`address`|address of the user who will receive the NFT|
|`vaultAddress`|`address`|address of the Vault user is depositing to|
|`depositAmount`|`uint256`|amount of ETH user is depositing to the Vault|


### getTokenDetails

This function will be called to retrieve additional information about the NFT


```solidity
function getTokenDetails(uint256 tokenId) public view returns (NFTinfo memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`uint256`|id of the NFT|


### grantMinterRole

This function will be called by FACTORY_ROLE to grant MINTER_ROLE to a newly deployed vault


```solidity
function grantMinterRole(address vault) public onlyRole(FACTORY_ROLE);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`vault`|`address`|address of the vault|


### supportsInterface


```solidity
function supportsInterface(bytes4 interfaceId) public view override(ERC721, AccessControl) returns (bool);
```

## Events
### NFTMinted
Event fired when NFT is minted


```solidity
event NFTMinted(address to, address vault, uint256 depositAmount);
```

