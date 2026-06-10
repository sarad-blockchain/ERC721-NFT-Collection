//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.30;

import "../lib/forge-std/src/Test.sol";
import "../src/NFTCollection.sol";
import "../script/NFTCollection.s.sol";

contract NFTCollectionTest is Test {

    NFTCollection nftCollection;
    NFTCollectionScript script;

    string name_ = "Echoes of Self";
    string symbol_ = "ECHO";
    uint256 totalSupply_ = 6;
    string baseURI_ = "ipfs://bafybeieoksqth3o6jnyve2zizlenfomtqgf553m5fea5uj7s4fonwsigmy/";

    address user1 = vm.addr(1);
    address user2 = vm.addr(2);
    address user3 = vm.addr(3);

    function setUp() public {
       nftCollection = new NFTCollection(name_, symbol_, totalSupply_, baseURI_);
    }

    function test_ConstructorSetsName() public view{
        assertEq(nftCollection.name(), name_);
    }

    function test_ConstructorSetsSymbol() public view{
        assertEq(nftCollection.symbol(), symbol_);
    }

    function test_ConstructorSetsTotalSupply() public view{
        assertEq(nftCollection.totalSupply(), totalSupply_);
    }

    function test_ConstructorSetsBaseURI() public view {
        assertEq(nftCollection.baseURI(), baseURI_);
    }

    function test_ConstructorSetsCounterAtZero() public view {
        assertEq(nftCollection.tokenIdCounter(), 0);
    }

    function test_MintSucceeds_WhenUnderSupply() public {

        vm.startPrank(user1);

        uint256 tokenId = nftCollection.tokenIdCounter();
        uint256 expectedTokenId = 0;
        assertEq(tokenId, expectedTokenId);

        nftCollection.mint();

        uint256 newTokenId = nftCollection.tokenIdCounter();
        assertEq(newTokenId, expectedTokenId + 1);

        assertEq(nftCollection.balanceOf(user1), 1);

        vm.stopPrank();
    }

    function test_MintReverts_WhenOverSupply() public {

        vm.startPrank(user1);

        for (uint256 id = 0; id < totalSupply_; id++) {
            nftCollection.mint();
        }

        vm.expectRevert("Sold out");
        nftCollection.mint();

        vm.stopPrank();
    }

    function test_MintSetsCorrectOwner() public {
        vm.startPrank(user1);

        nftCollection.mint();

        assertEq(nftCollection.ownerOf(0), user1);

        vm.stopPrank();
    }

    function test_MintMultipleUsers() public {
        vm.startPrank(user1);
    
        nftCollection.mint();
        vm.stopPrank();

        vm.startPrank(user2);
        nftCollection.mint();
        vm.stopPrank();

        vm.startPrank(user3);
        nftCollection.mint();
        vm.stopPrank();

        assertEq(nftCollection.ownerOf(0), user1);
        assertEq(nftCollection.ownerOf(1), user2);
        assertEq(nftCollection.ownerOf(2), user3);
    }

    function test_MintUpdatesBalance() public {
        vm.startPrank(user1);

        nftCollection.mint();
        nftCollection.mint();

        assertEq(nftCollection.balanceOf(user1), 2);

        vm.stopPrank();
    }

    function test_TokenURIReturnsCorrectURI() public {
        vm.startPrank(user1);

        nftCollection.mint();

        string memory expectedURI = string.concat(baseURI_, "0.json");
        assertEq(nftCollection.tokenURI(0), expectedURI);

        vm.stopPrank();
    }

    function test_TokenIdsAreSequential() public {
        vm.startPrank(user1);

        nftCollection.mint();
        nftCollection.mint();

        assertEq(nftCollection.ownerOf(0), user1);
        assertEq(nftCollection.ownerOf(1), user1);

        vm.stopPrank();
    }
     function test_MintEmitsEvent() public {
        vm.startPrank(user1);

        vm.expectEmit(true, true, false, false);
        emit NFTCollection.Minted(user1, 0);

        nftCollection.mint();

        vm.stopPrank();
    }

    function test_BaseURI_ReturnsCorrectValue() public view {
       assertEq(nftCollection.baseURI(), baseURI_);
   }
    function testFuzz_MintNeverExceedsSupply(uint256 mintCount) public {
        vm.assume(mintCount <= totalSupply_);

        vm.startPrank(user1);

        for (uint256 i = 0; i < mintCount; i++) {
            nftCollection.mint();
        }

        assertEq(nftCollection.tokenIdCounter(), mintCount);
        assertEq(nftCollection.balanceOf(user1), mintCount);

        vm.stopPrank();
    }

    function test_DeployStateIsMinted() public {
        NFTCollection nft = new NFTCollection(name_, symbol_, totalSupply_, baseURI_);

        vm.startPrank(user1);
        nft.mint();

        assertEq(nft.ownerOf(0), user1);
        assertEq(nft.tokenIdCounter(), 1);
    }

    function test_DeployStateIsValid() public{
        NFTCollection nft = new NFTCollection(name_, symbol_, totalSupply_, baseURI_);

        assertEq(nft.name(), name_);
        assertEq(nft.symbol(), symbol_);
        assertEq(nft.totalSupply(), totalSupply_);
        assertEq(nft.baseURI(), baseURI_);
        assertEq(nft.tokenIdCounter(), 0);
    }

}
