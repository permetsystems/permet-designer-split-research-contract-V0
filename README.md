# Permet Systems Designer Split Contract V0

Permet builds on 0xSplits’ [Liquid Splits](https://docs.0xsplits.xyz/modules/liquid) which redistributes funds according to NFT owners.

# Split Contract Details

The contract is an ERC-721 (NFT) contract with total supply configured for total number of Design NFTs. 

NFTs (ticker: $FWBS5) are minted in the constructor on deployment to each recipient who participated in the project. 

The Design NFT images are stored on Arweave and each Design NFT designates a portion of the profit split: 

- 6 for [Eugene Angelo](https://angelo.ltd/)
- 2 for [Corey San Augustin](https://lastorchid.com/)
- 1 for [FWB](https://www.fwb.help/editorial/in-the-future-of-fashion-everyone-gets-paid)
- 1 for Permet

We created a liquid split by interfacing with 0xSplits’ liquid split contract. 

When profit is distributed, the split is updated based on which wallets hold the relevant Design NFTs.

The magic of this contract is in the constructor. To fork it for your own use, redeploy a forked version with your own parameters.

![alt text](https://ztwbsne6fwmpuy6kfpde3rdolnzb4ssvqano6syxxjwm6fqwarqq.arweave.net/zOwZNJ4tmPpjyivGTcRuW3IeSlWAGu9LF7pszxYWBGE)
