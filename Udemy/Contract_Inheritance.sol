pragma solidity >=0.5.0 <0.9.0;

contract BaseContract{
    int public x;
    address public owner;

    constructor(){
        x = 5;
        owner = msg.sender;
    }

    function setX(int _x) public{
        x = _x;
    }
}
//if we deploy A, basecontract is not deployed. Only A.
contract A is BaseContract{ //this contract inherits every thing from the base contract like if we did a copy paste. We can add some extra stuff just by writing in it
    uint public y;
}