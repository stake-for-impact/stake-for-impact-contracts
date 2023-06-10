// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {IstETH} from '../src/interfaces/IstETH.sol';
import {ImpactETHtoken} from '../src/imETHtoken.sol';
import {Vault} from '../src/Vault.sol';

contract VaultTest is Test {
    Vault public vault;
    ImpactETHtoken public imETH;
    IstETH public stETH;

    address public beneficiaryAddress;

    function setUp() public {
        uint256 forkId = vm.createFork("mainnet");
        vm.selectFork(forkId);

        imETH = new ImpactETHtoken();
        beneficiaryAddress = address(0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5); //random address from etherscan mainnet for testing
        stETH = IstETH(0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84);
        vault = new Vault(address(stETH), beneficiaryAddress, address(imETH));
    }

    function testDeposit () public {
        vault.deposit{value: 100 ether}();
        console.log("stETH balance: %s", stETH.balanceOf(address(vault)));
        assertTrue(stETH.balanceOf(address(vault)) > stETH.getSharesByPooledEth(100 ether));
    }

    function testWithdraw () public {
        vault.deposit{value: 100 ether}();
        vault.withdraw(stETH.getSharesByPooledEth(50 ether));
        assertTrue(stETH.balanceOf(address(this)) == 100 ether);
    }

}