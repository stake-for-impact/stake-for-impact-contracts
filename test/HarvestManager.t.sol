// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import 'forge-std/console.sol';
import {Ownable} from 'openzeppelin-contracts/access/Ownable.sol';
import {IERC20} from 'openzeppelin-contracts/token/ERC20/IERC20.sol';
import {Vault} from '../src/Vault.sol';
import {Test} from 'forge-std/Test.sol';
import {HarvestManager} from '../src/HarvestManager.sol';

contract HarvestManagerTest is Test {
    HarvestManager public harvestManager;
    Vault public vault;
    IERC20 public stETH;

    function setUp() public {
        uint256 forkId = vm.createFork("mainnet");
        vm.selectFork(forkId);
        
    }
}