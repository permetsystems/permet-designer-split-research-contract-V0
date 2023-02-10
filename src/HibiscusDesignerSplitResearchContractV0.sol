/** 
        *              *              *                                              
      &&&&&          &&&&&          &&&&&       
     &&&&&&&        &&&&&&&        &&&&&&&      
     &&&&&&&        &&&&&&&        &&&&&&&      
      &&&&&          &&&&&          &&&&&       
                                                  
        &              &              &                                              
     &&&&&&&        &&&&&&&        &&&&&&&     
   (&&&&&&&&&)    (&&&&&&&&&)    (&&&&&&&&&)     
  (&&&&&&&&&&&)  (&&&&&&&&&&&)  (&&&&&&&&&&&)    
   (&&&&&&&&&)    (&&&&&&&&&)    (&&&&&&&&&)     
     &&&&&&&        &&&&&&&        &&&&&&&     
        &              &              &                                                                                
                                                  
      &&&&&          &&&&&          &&&&&       
     &&&&&&&        &&&&&&&        &&&&&&&      
     &&&&&&&        &&&&&&&        &&&&&&&      
      &&&&&          &&&&&          &&&&&       
        *              *              *  
  HIBISCUS Technologies;
  
  SPDX-License-Identifier: MIT  
  Copyright (c) 2022 Hibiscus Technologies
  https://hibiscus.tech/
  @hibiscusdao
 **/

pragma solidity ^0.8.17;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {Owned} from "solmate/auth/Owned.sol";
import {LibString} from "solmate/utils/LibString.sol";
import {LiquidSplit} from "./LiquidSplit.sol";
import {IERC2981Royalties} from "./interfaces/IERC2981Royalties.sol";
import {DefaultOperatorFilterer} from "operator-filter-registry/DefaultOperatorFilterer.sol";

/// @title HibiscusDesignerSplitResearchContractV0
/// @author HibiscusDAO forked & modified implementation of 0xSplits splits-liquid-template
/// @dev This contract uses token = address(0) to refer to ETH.
contract HibiscusDesignerSplitResearchContractV0 is Owned, LiquidSplit, ERC721, DefaultOperatorFilterer, IERC2981Royalties {
    using LibString for uint256;

    error TokenDoesNotExist(uint256 tokenId);

    /// @notice Royalty percentage / 10000
    uint256 public royaltyPoints;

    /// @notice Total number of tokens minted on contract deployment
    uint256 public totalSupply = 10;

    /// @notice Base URI for minted tokens
    string public baseURI;

    /// @notice An array representation of the split allocation for each token. 
    /// @dev sum(splitByTokenId) = 1e6 === LiquidSplit PERCENTAGE_SCALE
    uint32[] public splitByTokenId = [
        333333, // token 0 - distribution token 1
        333333, // token 1 - distribution token 2
        7936,   // token 2 - bff t-shirt
        70902,  // token 3 - together hooded sweatshirt
        49736,  // token 4 - together long sleeve shirt
        47102,  // token 5 - basics t-shirt
        73350,  // token 6 - basics hooded sweatshirt
        36676,  // token 7 - basics flannel hat
        31754,  // token 8 - embroidery token 1
        15878   // token 9 - embroidery token 2
    ];

    /// @notice Sets URI and mints tokens to initial holders
    /// @param accounts Array of initial holder addresses
    /// @param _splitMain Address of the 
    /// @param _owner Address of the contract owner
    /// @param _baseURI Base URI for tokenURI
    /// @param _royaltyPoints Basis points of royalties paid to the split contract
    constructor(
        address[] memory accounts,
        address _splitMain,
        address _owner,
        string memory _baseURI,
        uint256 _royaltyPoints
    ) 
        ERC721("Hibiscus Designer Split Research Contract V0", "FWBS5") 
        Owned(_owner) 
        LiquidSplit(_splitMain, 0) 
    {
        /// set baseURI for contract
        baseURI = _baseURI;

        // set royalty points
        royaltyPoints = _royaltyPoints;

        /// mint NFTs to initial holders
        unchecked {
            for (uint256 i; i < totalSupply; ++i) {
                _safeMint(accounts[i], i);
            }
        }
    }

    /// @notice Returns a user's percentage split allocation where LiquidSplit PERCENTAGE_SCALE = 1e6
    /// @param account address to return allocation for
    /// @return percentBalance The allocation for this address
    function scaledPercentBalanceOf(address account) public view override returns (uint32 percentBalance) {
        for (uint256 i; i < totalSupply;) {
            if (ownerOf(i) == account) {
                percentBalance += splitByTokenId[i];
            }
            unchecked {
                /// overflow should be impossible in for-loop index
                ++i;
            }
        }
    }

    /// @notice Returns a token's URI if it has been minted
    /// @param tokenId The id of the token to get the URI for
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert TokenDoesNotExist(tokenId);
        }
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI,"token_",tokenId.toString(), ".json")) : "";
    }

    /// @notice Set royalty points
    /// @param _royaltyPoints Royalty percentage / 10000
    function setRoyaltyPoints(uint256 _royaltyPoints) external onlyOwner {
        royaltyPoints = _royaltyPoints;
    }

    /// @notice Called with the sale price to determine how much royalty
    //          is owed and to whom.
    /// @param _tokenId - the NFT asset queried for royalty information
    /// @param _value - the sale price of the NFT asset specified by _tokenId
    /// @return _receiver - address of who should be sent the royalty payment
    /// @return _royaltyAmount - the royalty payment amount for value sale price
    function royaltyInfo(uint256 _tokenId, uint256 _value)
        external
        view
        override(IERC2981Royalties)
        returns (address _receiver, uint256 _royaltyAmount)
    {
        return (address(this), (_value * royaltyPoints) / 10000);
    }


    /** 
        OpenSea Royalty Enforcement function overrides
    **/
    function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
        super.setApprovalForAll(operator, approved);
    }

    function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
        super.approve(operator, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data)
        public
        override
        onlyAllowedOperator(from)
    {
        super.safeTransferFrom(from, to, tokenId, data);
    }
}