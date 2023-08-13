# Contracts

Protocol consists of three core contracts:

[VaultFactory.sol](../../../src/contract.VaultFactory.md) - Factory that can be used by anyone to deploy new vault (creat new campaign).

[imNFT.sol](../../../src/contract.StakeForImpactNFT.md) - ERC-721 standard NFT token contract. It mints/burns an NFT when someone deposits/withdraws stake from some vault. All new vaults are granted minting role for this contract.

[Vault.sol](../../../src/contract.Vault.md) - core contract of the protocol that keeps user's deposits, own liquid staking tokens and distributes rewards to the beneficiaries.
