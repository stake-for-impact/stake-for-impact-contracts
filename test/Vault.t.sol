// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {IstETH} from '../src/interfaces/IstETH.sol';
import {ImpactETHtoken} from '../src/imETHtoken.sol';
import {Vault} from '../src/Vault.sol';

contract VaultTest is Test {
    Vault public vault;
    ImpactETHtoken public imETH;
    IstETH public stETH;
    ILido public lidoContract;

    function setUp() public {
        uint256 forkId = vm.createFork("mainnet");
        vm.selectFork(forkId);

        imETH = new ImpactETHtoken();
        stETH = IstETH(0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84);
        vault = new Vault(address(imETH), address(stETH));
    }
}