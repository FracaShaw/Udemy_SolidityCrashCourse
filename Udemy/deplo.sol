pragma solidity >=0.5.0 <0.9.0;

contract A{
    address public ownerA;
    constructor(address eoa) { //external owned account so that the contract A created is owned by the person calling the creator function and not the creator function it self
        ownerA = eoa;
    }
}

contract Creator{
    address public ownerCreator;
    A[] public deployedA;

    constructor(){
        ownerCreator = msg.sender;
    }

    function deployA() public{
        A new_A_address = new A(msg.sender);
        deployedA.push(new_A_address);
    }
}