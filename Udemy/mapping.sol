pragma solidity >=0.5.0 <0.9.0;

contract Auction{
    mapping(address => uint) public bids;

    function bid() payable public{
        bids[msg.sender] = msg.value; //msg.sender is the adress that calls the function in a transactton 
                                      //and msg.value is the value in wei sent when calling that function

    }
}