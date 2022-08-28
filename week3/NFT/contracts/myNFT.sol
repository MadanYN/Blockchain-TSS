// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.2/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.7.2/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.2/utils/Counters.sol";

contract myNFT is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public mintRate = 0.001 ether;
    uint256 public maxSupply = 4;

    constructor() ERC721("myNFT", "MNFT") {}

    function mintNFT(address to) public payable {
        require(totalSupply() < maxSupply, "Out of supply");
        require(msg.value >= mintRate, "Not enough ether");
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
    }

    function safeMintMultuiple(address to, uint256 numbers) public payable {
        require(
            (totalSupply() + numbers) <= maxSupply,
            "Out of supply, check maxSupply and totalSupply"
        );
        require(msg.value >= (numbers * mintRate), "not enough ether");
        for (uint256 i = 0; i < numbers; i++) {
            _tokenIdCounter.increment();
            uint256 tokenId = _tokenIdCounter.current();
            _safeMint(to, tokenId);
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "No ethers to withdraw");
        payable(owner()).transfer(address(this).balance);
    }
   
}
