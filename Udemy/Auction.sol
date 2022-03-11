pragma solidity >=0.5.0 <0.9.0;

contract AuctionCreator{
    Auction[] public auctions;

    function createAuction() public{
        Auction newAuction = new Auction(msg.sender);
        auctions.push(newAuction);
    }
}

contract Auction{
     address payable public owner;
     uint public startBlock;
     uint public endBlock;
     string ipfsHash;
     
     enum state {started, running, ended, canceld}
     state public auctionState;

     uint public highestBindingBid;
     address payable public highestBidder;

     mapping(address => uint) public bids;
     uint bidIncrement;

     constructor(address eoa) {
         owner = payable(eoa);
         auctionState = state.running;
         startBlock = block.number;
         endBlock = startBlock + 40320;
         ipfsHash = "";
         bidIncrement = 100;
     }


     modifier onlyowner(){
         require (msg.sender == owner, "you are not the owner");
         _;
     }

     modifier notOwner(){
     require(msg.sender != owner, "you are the owner");
     _;
     }

     modifier afterStart(){
         require(block.number >= startBlock, "the auction has not started");
         _;
     }

     modifier beforeEnd(){
         require(block.number<= endBlock, "the auction has ended");
         _;
     }

     function cancelAuction() public payable onlyowner{
        auctionState = state.canceld;
     }

     function min(uint a, uint b) internal pure returns(uint){
        if (a <= b){
            return a;
        }else {
            return b;
        } 
     }

     function placeBid() public payable notOwner afterStart beforeEnd {
         require(auctionState == state.running);
         require(msg.value >= 100);

         uint currentBid = bids[msg.sender] + msg.value;
         require (currentBid > highestBindingBid);

         if (currentBid <= bids[highestBidder]){
             highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
         }else{
             highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
             highestBidder = payable(msg.sender);
         }
     }
     function finalizeAuction() public{
        require(auctionState == state.canceld || block.number > endBlock);
        require(msg.sender == owner || bids[msg.sender] > 0);

        address payable recipient;
        uint value;

        if (auctionState == state.canceld){
            recipient = payable(msg.sender);
            value = bids[msg.sender];
        }else{
            if(msg.sender == owner){
                recipient = owner;
                value = highestBindingBid;
            }else{
                if (msg.sender == highestBidder){
                    recipient = highestBidder;
                    value = bids[highestBidder] - highestBindingBid;
                    
                }else{
                    recipient = payable(msg.sender);
                    value = bids[msg.sender];
                }
            }
        }
        bids[recipient] = 0;
        recipient.transfer(value);
     }
}   