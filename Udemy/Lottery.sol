pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address payable[] public players;
    address payable public admin;



    constructor() {
        admin = payable(msg.sender);
    }

    receive() external payable{
    }

    fallback() external payable{
    }

    function enter_lottery() public payable{
        require(msg.value == 0.1 ether, "you did not send 0.1 ether");
        require(msg.sender != admin, "you are the admin and can not participate");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender == admin, "you are not the admin of the contract");
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length))); //suceptible to miner attack vy picking the block that makes him win
    }
    function pickwinner() public returns(address){
        require(msg.sender == admin, "you are not the manager");
        require(players.length >= 3, "there is not egnouth players");
        address payable winner = players[random() % players.length];
        winner.transfer((getBalance() * 90) / 100);
        admin.transfer((getBalance() * 10) / 100);
        players = new address payable[](0); //resetting the Lottery
        return winner;
    }

}