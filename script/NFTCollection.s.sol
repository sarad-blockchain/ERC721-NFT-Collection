//SPDX-License-Identifier: UNLSICENSED

pragma solidity ^0.8.30;

import "../lib/forge-std/src/Script.sol";
import "../src/NFTCollection.sol";

contract NFTCollectionScript is Script {
    function run() external returns (NFTCollection) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        string memory name_ = "Echoes of Self";
        string memory symbol_ = "ECHO";
        uint256 totalSupply_ = 6; 
        string memory baseURI_ = "ipfs://bafybeieoksqth3o6jnyve2zizlenfomtqgf553m5fea5uj7s4fonwsigmy/";
       
        NFTCollection nftCollection = new NFTCollection(name_, symbol_, totalSupply_, baseURI_);
        
        vm.stopBroadcast();

        return nftCollection;
    }

}
