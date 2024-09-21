// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721 {
    uint256 public nextTokenId;
    
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        nextTokenId = 1;
    }

    function mint(address to) public {
        _safeMint(to, nextTokenId);
        nextTokenId++;
    }

    function approveMarketplace(address marketplace) public {
        setApprovalForAll(marketplace,true);}
}