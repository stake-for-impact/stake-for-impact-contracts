# IstETH
[Git Source](https://github.com/stake-for-impact/stake-for-impact-contracts/blob/41d39fa73e1fd805ac874252d72e779f9bd6f027/src/interfaces/IstETH.sol)

**Inherits:**
IERC20


## Functions
### getPooledEthByShares


```solidity
function getPooledEthByShares(uint256 _sharesAmount) external view returns (uint256);
```

### getSharesByPooledEth


```solidity
function getSharesByPooledEth(uint256 _ethAmount) external view returns (uint256);
```

### submit


```solidity
function submit(address _rewardAddress) external payable;
```

### sharesOf


```solidity
function sharesOf(address _account) external view returns (uint256);
```

### transferShares


```solidity
function transferShares(address _recipient, uint256 _sharesAmount) external returns (uint256);
```

