pragma solidity >=0.5.0 <0.9.0;

//you can not push to a string
//you can not axes an index of a string
//you can not get the length of a string

contract Bytesandstrings{
    bytes public b1 = 'abc'; // this array will be in hexadecimal
    string public s1 = 'abc'; // this array will be in UTF-8


    function addelement() public {
        b1.push('x');
    }

    function getelement(uint i) public view returns(bytes1){
        return b1[i];
    }
    function getlength() public view returns(uint length){
        return b1.length;
    }
}