pragma solidity >=0.5.0 <0.9.0;

struct Instructor{
    uint age;
    string name;
    address addr; //type eth address
}

enum State {open, closed, unknown} // a enum is a variable that has human redable values like this 3 states

contract Academy{
    Instructor public AcademyInstructor;

    State public AcademyState = State.open;

    constructor(uint _age, string memory _name){
        AcademyInstructor.age = _age;
        AcademyInstructor.name = _name;
        AcademyInstructor.addr = msg.sender; //msg.sender == the adress that deploys the contract
    }

    function changeInstructor(uint _age, string memory _name, address _addr) public{
        if (AcademyState == State.open){
            Instructor memory myInstructor = Instructor({
                age: _age,
                name: _name,
                addr: _addr
            }
                );
            AcademyInstructor = myInstructor;
        }
    }
}

contract School{
    Instructor public schoolInstructor;
}