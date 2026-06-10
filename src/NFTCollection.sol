//SPDX-License-Identifier: UNLSICENSED

pragma solidity ^0.8.30;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract NFTCollection is ERC721 {
    using Strings for uint256;

    uint256 public tokenIdCounter; // 0 default value
    uint256 public totalSupply;
    string public baseURI;

    event Minted(address indexed userAddress, uint256 indexed tokenId);
    constructor (string memory name_, string memory symbol_, uint256 totalSupply_, string memory baseURI_) ERC721 (name_, symbol_) {
        totalSupply = totalSupply_;
        baseURI = baseURI_;
    }

    function mint() external {
        // TotalSupply = 100 [0] -[99]
        require( tokenIdCounter < totalSupply, "Sold out");

        _safeMint(msg.sender, tokenIdCounter);
        uint256 id = tokenIdCounter;
        tokenIdCounter++;

         emit Minted(msg.sender, id); 
    }

    function _baseURI() internal override view virtual returns (string memory) {
        return baseURI;
    }

    function tokenURI(uint256 tokenId) public override view virtual returns (string memory) {
        _requireOwned(tokenId);

        string memory base = _baseURI();
        return bytes(base).length > 0 ? string.concat(base, tokenId.toString(), ".json") : "";
    }


}


