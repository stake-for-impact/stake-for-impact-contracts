// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {IstETH} from '../src/interfaces/IstETH.sol';
import {StakeForImpactNFT} from '../src/imNFT.sol';
import {NFTinfo} from '../src/imNFT.sol';
import {Vault} from '../src/Vault.sol';
import {VaultFactory} from '../src/VaultFactory.sol';
import {VaultInfo} from '../src/VaultFactory.sol';
import {IERC721Receiver} from 'openzeppelin-contracts/token/ERC721/IERC721Receiver.sol';

contract VaultTest is Test, IERC721Receiver {
    Vault public vault;
    StakeForImpactNFT public imNFT;
    NFTinfo public nftInfo;
    IstETH public stETH;
    VaultFactory public factory;
    VaultInfo public vaultInfo;
    address public vaultAddress;
    bytes32 public FACTORY_ROLE;

    address public beneficiaryAddress;

    function setUp() public {
        uint256 forkId = vm.createFork("mainnet");
        vm.selectFork(forkId);
        stETH = IstETH(0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84);
        imNFT = new StakeForImpactNFT();
        factory = new VaultFactory(address(stETH), address(imNFT));
        imNFT.grantRole(imNFT.FACTORY_ROLE(), address(factory));
        console.log("Facory address:", address(factory));
        beneficiaryAddress = address(0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5); //random address from etherscan mainnet for testing
        factory.createVault(beneficiaryAddress, "test", "test");
        (,,,vaultAddress) = factory.vaults(0);
        vault = Vault(payable(vaultAddress));
    }

    function testDeposit () public {
        vault.deposit{value: 100 ether}();
        assertEq(imNFT.balanceOf(address(this)), 1);
        assertTrue(stETH.balanceOf(address(vault)) > stETH.getSharesByPooledEth(100 ether));
    }

    function testWithdraw () public {
        uint256 tokenId = vault.deposit{value: 100 ether}();
        console.log("Token id", tokenId);
        uint256 stETHVaultDepositBeforeWithdraw = stETH.balanceOf(address(vault));
        imNFT.approve(address(vault), tokenId);
        vault.withdraw(tokenId);
        assertEq(imNFT.balanceOf(address(this)), 0);
        assertEq(stETH.balanceOf(address(vault)), 0);
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

    function testMultipleVaults () public {
        factory.createVault(0xe688b84b23f322a994A53dbF8E15FA82CDB71127, "TestVault1", "TestVault1");
        factory.createVault(0xe688b84b23f322a994A53dbF8E15FA82CDB71127, "TestVault2", "TestVault2");
        (,,,address vault1address) = factory.vaults(0);
        (,,,address vault2address) = factory.vaults(1);
        Vault vault1 = Vault(payable(vault1address));
        Vault vault2 = Vault(payable(vault2address));
        uint256 tokenId1 = vault1.deposit{value: 100 ether}();
        uint256 tokenId2 = vault2.deposit{value: 300 ether}();
        console.log("Vault1 address:", address(vault1));
        console.log("Vault2 address:", address(vault2));
        vm.expectRevert("This NFT is not associated with this vault");
        vault2.withdraw(tokenId1);
        imNFT.safeTransferFrom(address(this), 0xa24DbaEf7b10866d9F195ca829395676f8DA6c10, tokenId1);
        console.log("Owner of tokenId1:", imNFT.ownerOf(tokenId1));
        vm.startPrank(0xa24DbaEf7b10866d9F195ca829395676f8DA6c10);
        imNFT.approve(address(vault1), tokenId1);
        vault1.withdraw(tokenId1);
        vm.stopPrank();
        assertEq(stETH.balanceOf(0xa24DbaEf7b10866d9F195ca829395676f8DA6c10), 100 ether);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        return this.onERC721Received.selector;
    }
}