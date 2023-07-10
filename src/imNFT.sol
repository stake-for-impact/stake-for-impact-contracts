// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "openzeppelin-contracts/access/AccessControl.sol";
import "openzeppelin-contracts/utils/Counters.sol";

struct NFTinfo {
        address vault;
        uint256 depositAmount;
}


contract StakeForImpactNFT is ERC721, ERC721Burnable, AccessControl {
    using Counters for Counters.Counter;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant FACTORY_ROLE = keccak256("FACTORY_ROLE");
    Counters.Counter private _tokenIdCounter;

    mapping (uint256 => NFTinfo) private _tokenDetails;

    /**
        @notice Event fired when NFT is minted
        @param to address of the user who will receive the NFT
        @param vault address of the Vault user is depositing to
        @param depositAmount amount of ETH user is depositing to the Vault
    */
    event NFTMinted(address to, address vault, uint256 depositAmount);

    constructor() ERC721("Stake for Impact NFT", "imNFT") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
        @notice This function will be called by vaults to issue an NFT when user deposits to vault. Parameters are written into struct
        @param to address of the user who will receive the NFT
        @param vault address of the Vault user is depositing to
        @param depositAmount amount of ETH user is depositing to the Vault
    */
    function safeMint(address to, address vault, uint256 depositAmount) public onlyRole(MINTER_ROLE) returns (uint256) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _tokenDetails[tokenId] = NFTinfo({
                vault: vault,
                depositAmount: depositAmount
        });
        emit NFTMinted(to, vault, depositAmount);
        return tokenId;
    }

    /**
        @notice This function will be called to retrieve additional information about the NFT
        @param tokenId id of the NFT
    */
    function getTokenDetails(uint256 tokenId) public view returns (NFTinfo memory) {
        return _tokenDetails[tokenId];
    }

    /**
        @notice This function will be called by FACTORY_ROLE to grant MINTER_ROLE to a newly deployed vault
        @param vault address of the vault
     */
    function grantMinterRole(address vault) public onlyRole(FACTORY_ROLE) {
        _grantRole(MINTER_ROLE, vault);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}