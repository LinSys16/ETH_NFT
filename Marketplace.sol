// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Marketplace {

    struct Listing {
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bool sold;
    }

    address private owner;
    bool private paused;
    Listing[] public listings;
    mapping(address => mapping(uint256 => bool)) public activeListings;

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }
    modifier whenNotPaused() {
        require(!paused, "The contract is paused");
        _;
    }

    event Paused();
    event Unpaused();
    event NFTListed(address indexed seller, address indexed nftContract, uint256 indexed tokenId, uint256 price);
    event NFTSold(address indexed buyer, address indexed nftContract, uint256 indexed tokenId, uint256 price);

    constructor() {
        owner = msg.sender;
        paused = false;
    }

    function pause() public onlyOwner {
        paused = true;
        emit Paused();
    }

    function unpause() public onlyOwner {
        paused = false;
        emit Unpaused();
    }

    function listNFT(address nftContract, uint256 tokenId, uint256 price) external whenNotPaused {
        require(price > 0, "Price must be greater than 0");

        require(IERC721(nftContract).supportsInterface(0x80ac58cd), "Contract is not ERC721");

        require(IERC721(nftContract).ownerOf(tokenId) == msg.sender, "You are not the owner");

        require(
            IERC721(nftContract).getApproved(tokenId) == address(this) || 
            IERC721(nftContract).isApprovedForAll(msg.sender, address(this)), 
            "Marketplace is not approved to transfer this NFT"
        );
        // Transferir el NFT al marketplace
        IERC721(nftContract).safeTransferFrom(msg.sender, address(this), tokenId);

        listings.push(Listing(msg.sender, nftContract, tokenId, price, false));
        activeListings[nftContract][tokenId] = true;

        emit NFTListed(msg.sender, nftContract, tokenId, price);
    }

    function buyNFT(uint256 listingId) external payable whenNotPaused {
        Listing storage listing = listings[listingId];
        require(msg.value == listing.price, "Incorrect price");
        require(!listing.sold, "NFT already sold");

        listing.sold = true;
        activeListings[listing.nftContract][listing.tokenId] = false;

        // Transferir el NFT al comprador
        IERC721(listing.nftContract).safeTransferFrom(address(this), msg.sender, listing.tokenId);

        // Transferir el pago al vendedor
        payable(listing.seller).transfer(msg.value);

        emit NFTSold(msg.sender, listing.nftContract, listing.tokenId, listing.price);
        }
}