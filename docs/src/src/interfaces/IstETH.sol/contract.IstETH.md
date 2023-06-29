# IstETH
[Git Source](https://github.com/stake-for-impact/stake-for-impact-contracts/blob/695b7bcd51b692b533a2b354bd5483ff5163fb9b/src/interfaces/IstETH.sol)

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

