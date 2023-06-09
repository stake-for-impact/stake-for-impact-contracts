// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {IstETH} from '../src/interfaces/IstETH.sol';
import {ImpactETHtoken} from '../src/imETHtoken.sol';
import {Vault} from '../src/Vault.sol';
import {VaultFactory} from '../src/VaultFactory.sol';
import {VaultInfo} from '../src/VaultFactory.sol';

contract VaultTest is Test {
    Vault public vault;
    ImpactETHtoken public imETH;
    IstETH public stETH;
    VaultFactory public factory;
    VaultInfo public vaultInfo;
    address public vaultAddress;

    address public beneficiaryAddress;

    function setUp() public {
        uint256 forkId = vm.createFork("mainnet");
        vm.selectFork(forkId);

        stETH = IstETH(0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84);
        factory = new VaultFactory(address(stETH));
        beneficiaryAddress = address(0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5); //random address from etherscan mainnet for testing
        factory.createVault(beneficiaryAddress, "test", "test");
        imETH = ImpactETHtoken(factory.imEthAddress());
        (,,,vaultAddress) = factory.vaults(0);
        vault = Vault(payable(vaultAddress));
    }

    function testDeposit () public {
        vault.deposit{value: 100 ether}();
        assertEq(imETH.balanceOf(address(this)), 100 ether);
        assertEq(imETH.totalSupply(), 100 ether);
        assertTrue(stETH.balanceOf(address(vault)) > stETH.getSharesByPooledEth(100 ether));
    }

    function testWithdraw () public {
        vault.deposit{value: 100 ether}();
        uint256 stETHVaultDepositBeforeWithdraw = stETH.balanceOf(address(vault));
        vault.withdraw(50 ether);
        assertEq(imETH.totalSupply(), 50 ether);
        assertEq(imETH.balanceOf(address(this)), 50 ether);
        assertApproxEqAbs(stETH.balanceOf(address(vault)), stETHVaultDepositBeforeWithdraw - stETH.getSharesByPooledEth(50 ether), 100000);
    }

    function testHarvest () public {
        vault.deposit{value: 100 ether}();
        console.log("stETH balance of the vault:", stETH.balanceOf(address(vault)));
        console.log("stETH balance of the beneficiary:", stETH.balanceOf(beneficiaryAddress));
        vault.harvestRewards();
        console.log(stETH.balanceOf(beneficiaryAddress));
        //assertApproxEqAbs(stETH.getPooledEthByShares(stETH.balanceOf(address(vault))), imETH.totalSupply(), 1000000000);
        //assertEq(vault.userBalance(address(this)), 100 ether);
        //assertEq(stETH.balanceOf(beneficiaryAddress), stETH.balanceOf(address(vault)) - stETH.getSharesByPooledEth(imETH.totalSupply()));
    }
}