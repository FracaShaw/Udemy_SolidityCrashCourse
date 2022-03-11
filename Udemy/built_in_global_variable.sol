pragma solidity >=0.5.0 <0.9.0;

contract GlobalVariables{
    
    address public owner;
    uint public sentValue;
    uint public this_moment = block.timestamp; // in unix time
    uint public block_number = block.number;
    uint public difficulty = block.difficulty;
    uint public gaslimit = block.gaslimit;
    
    constructor() public{
        owner = msg.sender;
    }

    function changeOwner() public{
        owner = msg.sender;
    }
    
    function sendEther() public payable{
        sentValue = msg.value;
    }

    function getBalance() public view returns(uint){
        return address(this).balance; //this is the current contract, in this case type casted to address
    }

    function howmuchgas() public view returns(uint){
        uint start = gasleft();
        uint j = 1;
        while(j < 20){
            j++;
        }
        uint balance = getBalance();
        uint end = gasleft();
        return (start - end);
    }

}