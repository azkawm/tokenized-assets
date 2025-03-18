// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PropertyToken is ERC1155, Ownable {
    uint256 public constant HOUSE = 1; // NFT (Unique Property)
    uint256 public constant TOKENIZED_SHARE = 2; // Fungible (Fractional Ownership)

    mapping(uint256 => string) private _uris;

    constructor() ERC1155("") {}

    // Mint new tokens
    function mint(address to, uint256 id, uint256 amount, string memory newuri) external onlyOwner {
        _mint(to, id, amount, "");
        _uris[id] = newuri; // Store metadata URI for the token
    }

    // Batch mint multiple token types at once
    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, string[] memory uris) external onlyOwner {
        require(ids.length == uris.length, "Mismatched array lengths");
        _mintBatch(to, ids, amounts, "");
        for (uint256 i = 0; i < ids.length; i++) {
            _uris[ids[i]] = uris[i];
        }
    }

    // Retrieve token metadata URI
    function uri(uint256 tokenId) public view override returns (string memory) {
        return _uris[tokenId];
    }

    // Burn (destroy) tokens
    function burn(address from, uint256 id, uint256 amount) external onlyOwner {
        _burn(from, id, amount);
    }
}
