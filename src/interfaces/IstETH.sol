// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC20} from 'openzeppelin-contracts/token/ERC20/IERC20.sol';

interface IstETH is IERC20 {
    function getPooledEthByShares(uint256 _sharesAmount) external view returns (uint256);
}