pragma solidity ^0.8.7;

contract fixedsizearray {
    uint[3] public numbers = [1, 2, 3];

    bytes1 public b1;
    bytes2 public b2;
    bytes3 public b3;
    //.. up to bytes32
    function setelement(uint index, uint value) public{
        numbers[index] = value;
    }
    
    function getlength() public view returns(uint){
        return numbers.length;
    }

    function seybytesarray() public{
        b1 = 'a';
        b2 = 'ab';
        b3 = 'abc';
    }

    //function setbytesarray()
}