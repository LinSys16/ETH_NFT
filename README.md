# ETH_NFT
Team:
Jonathan Gamboa
Liseth González - https://github.com/Mgonzalez06/marketplace_nft
Lindsay Badilla - https://github.com/LinSys16/ETH_NFT
This NFT marketplace project consists of two main contracts: MyNFT.sol for minting ERC721 tokens and MarketplaceNFT.sol for listing, buying, and canceling NFTs. The design incorporates several key patterns in Solidity:

1. Ownable
This pattern restricts critical administrative functions to the contract owner, ensuring that only a designated address can perform sensitive operations, which enhances security and control. This is vital for a marketplace, as it helps prevent unauthorized actions that could compromise user assets.

2. Emergency Stop
This allows the owner to pause the contract’s operations in case of emergencies, such as security vulnerabilities or required maintenance, preventing potential exploitation during critical times. This capability is crucial for protecting users' investments and maintaining trust in the platform.

3. Checks-Effects-Interactions
This pattern mitigates reentrancy attacks by ensuring that all internal checks and state changes are completed before making any calls to external contracts, thus reducing the risk of unintended side effects. In a marketplace, where financial transactions occur, preventing reentrancy attacks is essential to safeguard funds.

We also implement modifiers to manage access control by encapsulating common checks in reusable components, making the code cleaner and more maintainable. They help enforce specific conditions before executing functions, thereby improving security and readability.

These patterns collectively contribute to creating a secure, modular, and efficient NFT marketplace, ensuring that it operates safely and effectively while maintaining a clear structure.
