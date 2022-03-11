pragma solidity >=0.5.0 <0.9.0;

interface BaseContract{ 
    //int public x;
    //address public owner;     //an Interface can not have global variables

    //constructor(){            //an Interface can not have a constructor
    //    x = 5;
    //    owner = msg.sender;
    //}

    function setX(int _x) external;  //function in an Interface are implicitly virtual and have to be external
}

abstract contract A is BaseContract{ 
}

contract B is BaseContract{ 
    int public x;
    uint public y;

    function setX(int _x) public override{ //we can override the function from internal to public
        x = _x;
    }
}