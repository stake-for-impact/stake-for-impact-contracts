// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "openzeppelin-contracts/access/AccessControl.sol";

/**
    * @title Impact ETH token
    * @notice ERC20 token representing user's stake in one of the Impact Vaults that are part of 
    Stake for Impact protocol. While the token can be transfered, only its owner can redeem it and only against the vault
    they have staked in. The token is minted when user stakes in a vault and burned when user redeems their stake. The vault factoy
 */

contract ImpactETHtoken is ERC20, ERC20Burnable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor() ERC20("Impact ETH", "imETH") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    /**
        * @notice Mints tokens to the specified address. Can be called by Vaults that are part of Stake 
        for Impact protocol.
        * @param to address to mint tokens to
        * @param amount amount of tokens to mint
     */
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    /**
        * @notice Burns tokens from the specified address. Can be called by Vaults that are part of Stake 
        for Impact protocol.
        * @param from address to burn tokens from
        * @param amount amount of tokens to burn
     */
    function burn(address from, uint256 amount) public onlyRole(MINTER_ROLE) {
        _burn(from, amount);
    }
}