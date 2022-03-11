//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Deposit{
    address public immutable admin; 
    constructor(){
    admin = msg.sender;
    }
    receive() external payable{
    }
    fallback() external payable{
    }
    function send_ether() public payable{
    }
    function get_balance() public view returns(uint){
        return address(this).balance;
    }
    function transfer_max(address payable recepient) public{
        require(msg.sender == admin, "transaction failed, you are not the admin!");
        recepient.transfer(get_balance());
    }
}