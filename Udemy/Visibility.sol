pragma solidity >=0.5.0 <0.9.0;

contract A{
    int public x = 10;
    int y = 20;

    function get_y() public view returns(int){
        return y;
    }
    function f1() private view returns(int){ //this function can not be accessed outside the contract but f2 that is plublic can call it
        return x;
    }
    function f2() public view returns(int){
        return f1();
    }

    function f3() internal view returns(int){ //this function is accessible from derived contract
        return x;
    }

    function f4() external view returns(int){ //can only be called from outside the contract, is more efficient in gas than public
        return x;
    }

}

contract B is A{
    int public xx = f3();
}

contract c{
    A public contract_a = new A();
    int public xx = contract_a.f4();
}