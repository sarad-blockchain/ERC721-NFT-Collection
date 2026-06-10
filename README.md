# Echoes of Self — NFT Collection

A Solidity smart contract for minting a limited NFT collection, built with Foundry and OpenZeppelin.

## Overview

**Echoes of Self** (`ECHO`) is an ERC-721 collection of 6 unique pieces stored on IPFS. Each token represents a different chapter of self-discovery and personal transformation. The contract handles sequential minting with a hard supply cap and fully on-chain token URI resolution pointing to IPFS metadata.

## How it works

When the contract is deployed it receives four constructor parameters: collection name, symbol, total supply cap, and a base URI pointing to the IPFS metadata folder. From that point on the flow is simple:

1. A user calls `mint()` — no arguments needed.
2. The contract checks that `tokenIdCounter < totalSupply`. If the collection is sold out, the transaction reverts with `"Sold out"`.
3. On success, `_safeMint` assigns the current counter value as the new token ID to `msg.sender`, the counter increments, and a `Minted` event is emitted.
4. Token IDs are sequential starting from 0. Calling `tokenURI(id)` returns `baseURI + id + ".json"`, which resolves to the token's JSON metadata on IPFS — containing name, description, image, and attributes.

There is no allowlist, no payment, and no admin mint. Any address can mint until the supply is exhausted.

## Contract

`src/NFTCollection.sol`

| Feature | Detail |
|---|---|
| Standard | ERC-721 (OpenZeppelin v5) |
| Name | Echoes of Self |
| Symbol | ECHO |
| Total Supply | 6 |
| Mint | Public, sequential, one call per mint |
| Token URI | `baseURI + tokenId + ".json"` |
| Base URI | `ipfs://bafybeieoksqth3o6jnyve2zizlenfomtqgf553m5fea5uj7s4fonwsigmy/` |

### Key functions

```solidity
// Mint the next available token to msg.sender
function mint() external

// Returns the full IPFS URI for a given token
function tokenURI(uint256 tokenId) public view returns (string memory)
```

### Events

```solidity
event Minted(address indexed userAddress, uint256 indexed tokenId);
```

## Project Structure

```
NFT/
├── src/
│   └── NFTCollection.sol       # Main contract
├── script/
│   └── NFTCollection.s.sol     # Foundry deploy script
├── test/
│   └── NFTCollectiontest.t.sol # Test suite
├── uris/
│   ├── 0.json                  # Metadata: Reborn
│   ├── 1.json
│   ├── 2.json
│   ├── 3.json
│   ├── 4.json
│   └── 5.json
├── lib/
│   ├── forge-std/
│   └── openzeppelin-contracts/
└── foundry.toml
```

## Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)

### Install dependencies

```bash
forge install
```

### Build

```bash
forge build
```

### Run tests

```bash
forge test
```

Run with verbosity to see logs:

```bash
forge test -vvv
```

## Deployment

The deploy script is configured for Sepolia. Copy `.env.example` to `.env` and fill in your values:

```
PRIVATE_KEY=your_private_key_here
RPC_URL=your_rpc_url_here        # e.g. Alchemy Sepolia endpoint
```

Then deploy:

```bash
forge script script/NFTCollection.s.sol:NFTCollectionScript \
  --rpc-url $RPC_URL \
  --broadcast \
  --verify
```

## Tests

The test suite (`test/NFTCollectiontest.t.sol`) covers:

| Test | Description |
|---|---|
| `test_ConstructorSetsName` | Name is set correctly |
| `test_ConstructorSetsSymbol` | Symbol is set correctly |
| `test_ConstructorSetsTotalSupply` | Total supply is set correctly |
| `test_ConstructorSetsBaseURI` | Base URI is set correctly |
| `test_ConstructorSetsCounterAtZero` | Token counter starts at 0 |
| `test_MintSucceeds_WhenUnderSupply` | Mint works within supply |
| `test_MintReverts_WhenOverSupply` | Reverts with "Sold out" after supply is exhausted |
| `test_MintSetsCorrectOwner` | Minted token is owned by caller |
| `test_MintMultipleUsers` | Multiple users can each mint |
| `test_MintUpdatesBalance` | Balance updates correctly |
| `test_TokenURIReturnsCorrectURI` | URI resolves to `baseURI + tokenId + ".json"` |
| `test_TokenIdsAreSequential` | IDs are assigned in order |
| `test_MintEmitsEvent` | `Minted` event is emitted with correct args |
| `testFuzz_MintNeverExceedsSupply` | Fuzz: counter never exceeds total supply |
| `test_DeployStateIsValid` | All constructor params are stored correctly |

## Metadata

Each token's metadata lives on IPFS and follows the OpenSea metadata standard:

```json
{
  "name": "...",
  "description": "...",
  "image": "ipfs://...",
  "attributes": [
    { "trait_type": "Type", "value": "Art" },
    { "trait_type": "Theme", "value": "..." },
    ...
  ]
}
```

## Dependencies

- [OpenZeppelin Contracts v5](https://github.com/OpenZeppelin/openzeppelin-contracts) — ERC-721 base implementation
- [forge-std](https://github.com/foundry-rs/forge-std) — Foundry testing utilities

## License

UNLICENSED
