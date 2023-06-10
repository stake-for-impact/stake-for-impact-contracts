// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {ImpactETHtoken} from '../src/imETHtoken.sol';
import {Vault} from '../src/Vault.sol';
import {VaultFactory} from '../src/VaultFactory.sol';
import {sfrxETH} from 'frxETH-public/sfrxETH.sol';
import {frxETHMinter} from 'frxETH-public/frxETHMinter.sol';

contract VaultTest is Test {
    Vault public vault;
    ImpactETHtoken public imETH;
    VaultFactory public factory;
    sfrxETH public sfrxETHcontract;
    frxETHMinter public frxEthMinter;


    address public beneficiaryAddress;

    function setUp() public {
        uint256 forkId = vm.createFork("mainnet");
        vm.selectFork(forkId);

        frxEthMinter = frxETHMinter(payable (0xbAFA44EFE7901E04E39Dad13167D089C559c1138));
        sfrxETHcontract = sfrxETH(0xac3E018457B222d93114458476f3E3416Abbe38F);
        factory = new VaultFactory(address(frxEthMinter), address(sfrxETHcontract));
        beneficiaryAddress = address(0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5); //random address from etherscan mainnet for testing
        factory.createVault(beneficiaryAddress);
        imETH = ImpactETHtoken(factory.imEthAddress());
        vault = Vault(payable (factory.vaults(0)));
    }

    function testDeposit () public {
        vault.deposit{value: 100 ether}();
        assertEq(imETH.balanceOf(address(this)), 100 ether);
        assertEq(imETH.totalSupply(), 100 ether);
        assertApproxEqAbs(sfrxETHcontract.balanceOf(address(vault)), 100 ether, 5000000000000000000);
    }

    function testWithdraw () public {
        vault.deposit{value: 100 ether}();
        uint256 sfrxETHcontractVaultDepositBeforeWithdraw = sfrxETHcontract.balanceOf(address(vault));
        vault.withdraw(50 ether);
        assertEq(imETH.totalSupply(), 50 ether);
        assertEq(imETH.balanceOf(address(this)), 50 ether);
        assertApproxEqAbs(sfrxETHcontract.balanceOf(address(vault)), sfrxETHcontractVaultDepositBeforeWithdraw - sfrxETHcontract.convertToShares(50 ether), 100000);
    }

    function testHarvest () public {
        vault.deposit{value: 100 ether}();
        console.log("sfrxETH balance of the vault:", sfrxETHcontract.balanceOf(address(vault)));
        console.log("sfrxETH balance of the beneficiary:", sfrxETHcontract.balanceOf(beneficiaryAddress));
        vault.harvestRewards();
        console.log("beneficiary balance:", sfrxETHcontract.balanceOf(beneficiaryAddress));
        //assertApproxEqAbs(sfrxETHcontract.getPooledEthByShares(sfrxETHcontract.balanceOf(address(vault))), vault.totalETHDeposited, 1000000000);
        //assertEq(vault.userBalance(address(this)), 100 ether);
    }
}