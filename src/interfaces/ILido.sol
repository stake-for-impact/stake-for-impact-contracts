// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ILido {
    function submit(address _rewardAddress) external payable;
}