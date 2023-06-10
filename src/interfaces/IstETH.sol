// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC20} from 'openzeppelin-contracts/token/ERC20/IERC20.sol';

interface IstETH is IERC20 {
    function getPooledEthByShares(uint256 _sharesAmount) external view returns (uint256);
    function getSharesByPooledEth(uint256 _ethAmount) external view returns (uint256);
    function submit(address _rewardAddress) external payable;
    function sharesOf(address _account) external view returns (uint256);
}