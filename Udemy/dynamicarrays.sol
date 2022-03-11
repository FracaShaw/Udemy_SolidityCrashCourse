pragma solidity ^0.8.7;

contract dynamicarrays {
    uint[] public numbers;
    
    function getlength() public view returns(uint){
        return numbers.length;
    }

    function addelement(uint new_element) public{
        numbers.push(new_element);
    }

    function getelement(uint index) public view returns(uint){
        if (index < numbers.length)
            return numbers[index];
        return 0;
    }

    function removeelement() public {
        numbers.pop();
    }

    function f() public {
        uint[] memory y = new uint[](3);
        y[0] = 10;
        y[1] = 20;
        y[2] = 30;
        numbers = y;
    }
}