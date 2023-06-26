# IstETH
[Git Source](https://github.com/stake-for-impact/stake-for-impact-contracts/blob/34f949c11ae27916b9e458099dad829ed45a3068/src/interfaces/IstETH.sol)

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

