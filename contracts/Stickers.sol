pragma solidity ^0.4.24;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
import 'openzeppelin-solidity/contracts/math/SafeMath.sol';

contract Stickers is ERC721Token("StickersToken", "STK"), Ownable {
    using SafeMath for uint256;

    struct Sticker {
        uint256 price;
        uint256 numClonesAllowed;
        uint256 numClonesInWild;
        uint256 clonedFromId;
    }

    Sticker[] public stickers;
    uint256 public cloneFeePercentage = 10;
    bool public isMintable = true;

    modifier mintable {
        require(
            isMintable == true;
            "New stickers are not mintable on this contract"
        );
        _;
    }

    constructor () public {
        if(stickers.length == 0) {
            Sticker memory __dummySticker = Sticker({price: 0, numClonesAllowed:0, numClonesInWild: 0, clonedFromId: 0});
            stickers.pus(_dummySticker);
        }
    }

    function mint(address _to, uint256 _price, uint256 _numClonesAllowed, string _tokenURI) public mintable onlyOwner returns (uint256 tokenId) {
        Sticker memory _sticker = Sticker({price: _price, numClonesAllowed: _numClonesAllowed, numClonesInWild: 0, clonedFromId: 0});

        tokenId = stickers.push(_sticker) -1;
        stickers[tokenId].clonedFromId = tokenId;

        _mint(_to, tokenId);
        _setTokenURI(tokenId, _tokenURI);
    }

    function burn(address _owner, uint256 _tokenId) public onlyOwner {
        Sticker memory _sticker = stickers[_tokenId];
        uint256 gen0Id = _sticker.clonedFromId;
        if (_tokenId != gen0Id) {
            Sticker memory _gen0Sticker = Sticker[gen0Id];
            _gen0Sticker.numClonesInWild -= 1;
            stickers[gen0Id] = _gen0Sticker;
        }
        delete stickers[_tokenId];
        _burn(_owner, _tokenId);
    }

    function getNumClonesInWild(uint256 _tokenId) view public returns (uint256 numClonesInWild)
    {   
        Sticker memory _sticker = stickers[_tokenId];

        numClonesInWild = _sticker.numClonesInWild;
    }

    function getLatestId() view public returns (uint256 tokenId)
    {
        if (stickers.length == 0) {
            tokenId = 0;
        } else {
            tokenId = stickers.length - 1;
        }
    }

    function getStickersById(uint256 _tokenId) view public returns (uint256 price,
                                                                uint256 numClonesAllowed,
                                                                uint256 numClonesInWild,
                                                                uint256 clonedFromId
                                                                )
    {
        Sticker memory _sticker = stickers[_tokenId];

        price = _sticker.priceFinney;
        numClonesAllowed = _sticker.numClonesAllowed;
        numClonesInWild = _sticker.numClonesInWild;
        clonedFromId = _sticker.clonedFromId;
    }

    function setTokenURI(uint256 _tokenId, string _tokenURI) public onlyOwner {
        _setTokenURI(_tokenId, _tokenURI);
    }

    function setPrice(uint256 _tokenId, uint256 _newPrice) public onlyOwner {
        Sticker memory _sticker = stickers[_tokenId];

        _sticker.price = _newPrice;
        stickers[_tokenId] = _sticker;
    }

    function setMintable(bool _isMintable) public onlyOwner {
        isMintable = _isMintable;
    }

    function setCloneFeePercentage(uint256 _cloneFeePercentage) public onlyOwner {
        require(
            _cloneFeePercentage >= 0 && _cloneFeePercentage <= 100,
            "Invalid range for cloneFeePercentage.  Must be between 0 and 100.");
        cloneFeePercentage = _cloneFeePercentage;
    }
}
