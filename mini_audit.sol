pragma solidity 0.6.4;

import "./Interfaces/ERC721.sol";

contract ERC721BidSale {

    address payable _seller;
    ERC721 _tokenContract;
    uint256 _tokenId;
    uint256 _delay;
    uint256 _timeLimit;
    uint256 _lastBid;
    address payable _lastBidder;

    constructor() public {
        _seller = msg.sender;
    }

    function setup(ERC721 tokenContract, uint256 tokenId, uint256 delay) external {
        require(msg.sender == _seller, "NOT_AUTHROIZED");
        _delay = delay;
        _tokenContract = tokenContract;
        _tokenId = tokenId;
        _tokenContract.transferFrom(msg.sender, address(this), tokenId);
        _timeLimit = now + delay;
    }

    function bid() external payable {
        require(msg.value > _lastBid, "BID_TOO_LOW");
        require(now < _timeLimit, "BID_OVER");
        _lastBidder.transfer(_lastBid); // This makes reentrance attack possible, lastbidder can be a contract that rejects transfer
        _timeLimit = now + _delay;
        _lastBid = msg.value;
        _lastBidder = msg.sender;
    }
    
    function widthrawPrice() external {
        require(now >= _timeLimit, "BID_NOT_OVER"); // miners have control over the time. block number is more approp.
        if (_lastBidder != address(0)) {
            require(_lastBidder == msg.sender, "NOT_LAST_BIDDER");
        } else {
        require(_seller == msg.sender, "NOT_SELLER"); }
        _tokenContract.safeTransferFrom(address(this), msg.sender, _tokenId);
    }

    function withdrawSale() external { // seller can steal the last bid at any time. No buyer protection
        _seller.transfer(_lastBid);
        _lastBid = 0;
    }
}
