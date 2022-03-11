pragma solidity >=0.5.0 <0.9.0;

abstract contract BaseContract{ //an abstract contract can not be deployed. A contract with one or many virtual functions must be abstract
    int public x;
    address public owner;

    constructor(){
        x = 5;
        owner = msg.sender;
    }

    function setX(int _x) public virtual;

}

abstract contract A is BaseContract{ //if a contract inherits from a abstract contract and does not implement virtual functions it neeeds to be abstrat as well
    uint public y;
}

contract B is BaseContract{ //or implement the function
    uint public y;

    function setX(int _x) public override{ //when overriding a virtual function in a derived contract we need to use override
        x = _x;
    }
}