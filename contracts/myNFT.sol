//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/*
Create an ERC721 Token with the following requirements
    1. user can only buy tokens when the sale is started
    2. the sale should be ended within 30 days
    3. the owner can set base URI
    4. the owner can set the price of NFT
    5. NFT minting hard limit is 100
Note:
you can use this link as a base URI = "https://floydnft.com/token/;"
the contract should be deployed on any ethereum test network by using a hardhat or truffle
*/

///dev Nauman Tayyab

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";


contract myNFT is Ownable, ERC721 {


    uint public startSaleTime;
    uint public endSaleTime;
    string public baseURI;
    uint8 public totalSupply;
    uint8 public lastTokenId;

    mapping(uint => string) URIlist;
    mapping(uint => uint) internal priceList;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;

/*
   constructor (
        string memory _tokenName,
        string memory _tokenSymbol) payable ERC721(_tokenName,_tokenSymbol){
            _tokenName = MyNFT;
            _tokenSymbol = MNT;
    }
*/

   constructor() payable ERC721("MyNFT", "MNT") {}


    function startTokenSale() public onlyOwner returns(string memory){
        startSaleTime = block.timestamp;
        endSaleTime = startSaleTime + 30 days;
        return("Token sale has started now.");
    }

   /// 3. the owner can set base URI
    function setBaseURI(string memory _baseURI) public onlyOwner returns(string memory){
        baseURI = _baseURI;
        return("Base URI is set now.");
    }

    //ttokenURI: https://bafkreigkygjq6pywis7d22miplcbvdllfvjec3bekomspyoiwpbttopztq.ipfs.dweb.link/

    //mapping(uint => string) URIlist;

    function mintNFT(address to, string memory tokenURI) public onlyOwner returns(uint8, string memory) {
        require(lastTokenId <= 100, "You have already minted 100 tokens.");
        lastTokenId++;
        totalSupply++;
        uint8 _tokenId = lastTokenId;

        //add to mappings
        URIlist[_tokenId] = tokenURI;
        _owners[_tokenId] = msg.sender;
        _balances[msg.sender]++;

        return(_tokenId, "Minted");
    }

    function setNFTPrice(uint8 tokenId, uint tokenPrice) public onlyOwner returns(uint8, string memory, uint){
        require(tokenId != 0 && tokenId <= lastTokenId, "Token does not exist.");
        priceList[tokenId] = tokenPrice;
        return(tokenId, "Token price set to ", tokenPrice);
    }

    //  mapping(uint256 => address) internal _owners;
    //  mapping(address => uint256) internal _balances;
    //  mapping(uint256 => address) private _tokenApprovals;


    function buyNFT(uint8 tokenId) public payable returns(string memory){
        require(startSaleTime != 0 && startSaleTime < block.timestamp, "Token sale has not started yet.");
        require(msg.value >= priceList[tokenId],"Your payment is short.");

        address seller = _owners[tokenId];
        _owners[tokenId] = msg.sender;
        _balances[msg.sender]++;
        _balances[seller]--;

        return("Token sold");
    }

    function vewTokenPrice(uint8 tokenId) public view returns(uint){
        return(priceList[tokenId]);
    }
}