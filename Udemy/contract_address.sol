pragma solidity >=0.5.0 <0.9.0;

contract Deposit{
    address public owner;

    constructor(){
        owner = msg.sender;
    }
    receive() external payable {
    }
    
    fallback() external payable {
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function sendEther() public payable{
    }

    function transferEther(address payable recepient, uint amount) public returns(bool){
        require(owner == msg.sender, "transfer failed, you are not the owner of this contract");
        if (amount <= getBalance()){
            recepient.transfer(amount);
            return (true);
        }
        return (false);
    }
}
