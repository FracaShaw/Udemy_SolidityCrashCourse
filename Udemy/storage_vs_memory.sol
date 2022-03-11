pragma solidity >=0.5.0 <0.9.0;

contract A{
    string[] public cities = ['prage', 'bucharest'];

    function f_memory() public{
        string[] memory s1 = cities; //this change is stays inside the function
        s1[0] = 'berlin';
    }

    function f_storage() public{
        string[] storage s1 = cities; //this change affects the global variable
        s1[0] = 'berlin';
    }

}