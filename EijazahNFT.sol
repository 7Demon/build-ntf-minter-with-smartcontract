// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract EijazahNFT is ERC721, ERC721URIStorage, ERC721Burnable, Ownable{
    uint256 private _tokenIdCounter;
    struct dataEijazah {
        address penerima;
        address penerbit;
        string nim;
    }
    mapping(uint256 => dataEijazah) public infoEsertif;
    event EijazahDiterbitkan(
        uint256 indexed tokenId,
        address kepada,
        string penerima,
        string nim,
        address indexed oleh,
        uint256 tanggalTerbit
    );

    constructor(address initialOwner) ERC721("Eijazah", "EIJZ") Ownable(initialOwner){}

    // mint nft atau menerbitkan esertif
    function mintCertificate(address _to, string calldata _penerima, string calldata nim, string calldata _uri)  external onlyOwner returns (uint256){
        require(_to != address(0), "Eijazah: Alamat penerima tidak valid");
        // increment id token
        _tokenIdCounter++;
        uint256 newTokenId  = _tokenIdCounter;
        // menyimpan informasi esertif ke on-chain
        infoEsertif[newTokenId]=dataEijazah({
            penerima: _to,
            penerbit: msg.sender,
            nim: nim
        });
        // mint esertif dan langsung mengirimkan ke penerima
        _safeMint(_to, newTokenId);

        // set URI untuk metadata
        _setTokenURI(newTokenId, _uri);
        emit EijazahDiterbitkan(newTokenId, _to, _penerima, nim, msg.sender, block.timestamp);
        return newTokenId;
    }
    
    // verifikasi kepemilikan esertif
    function verifyCertificate(address _pemilik, uint256 _tokenid) public view returns (bool){
        //validasi tokenid ada atau tidak
        require(infoEsertif[_tokenid].penerbit != address(0), "Eijazah: token id tidak valid");
        return ownerOf(_tokenid) == _pemilik;
    }
    // fungsi untuk melihat validitas token
    function getCertificateOwner(uint256 _tokenid) public view returns (bool){
        require(_ownerOf(_tokenid) != address(0),  "Token id tidak valid");
        return true;
    }
    // fungsi burn
    function burnCertificate(uint256 tokenId) external onlyOwner {
        delete infoEsertif[tokenId];
        _burn(tokenId);
    }

    function tokenURI(uint256 _tokenId) public view override(ERC721, ERC721URIStorage) returns(string memory) {
        return super.tokenURI(_tokenId);
    }
    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
    
}