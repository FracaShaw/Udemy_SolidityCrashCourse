pragma solidity >=0.6.0 <0.9.0;

contract CrowdFunding{
    mapping(address => uint) public contributors;
    address public admin;
    uint public nbrOfContributors;
    uint public minimumContribution;
    uint public deadline;
    uint public goal;
    uint public raisedAmount;
    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed; //default value of a bool is false in solidity
        uint nbrOfVoters;
        mapping(address => bool) voters;
    }

    mapping(uint => Request) public requests;
    uint public numRequests;

    constructor(uint _goal, uint _deadline){
        goal = _goal;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        admin = msg.sender;
    }

    event ContributeEvent(address _sender, uint _value);
    event CreateRequestEvent(string _description, address _recipient, uint _value); //this creates a special structure on the blockchain that while be updated when this events happen and a javascript application can listen to it (usefull for updating the front end whith what is happening on chain)
    event MakePaymentEvent(address _recipient, uint _value);

    modifier beforeDeadline(){
        require(block.timestamp < deadline, "deadline has passed!");
        _;
    }
    modifier bigger_than_minimum_contribution(){
        require(msg.value >= minimumContribution, "minimum contribution not met!");
        _;
    }
    modifier passedDeadline(){
        require(block.timestamp >= deadline, "deadline has not been reached yet!");
        _;
    }
    modifier goalNotReached(){
        require(raisedAmount < goal, "goal has been reached!");
        _;
    }
    modifier goalReached(){
                require(raisedAmount >= goal, "goal has not been reached!");
        _;
    }
    modifier onlyAdmin(){
        require(msg.sender == admin, "only admin can call this funtion!");
        _;
    }
    modifier isContributor(){
        require(contributors[msg.sender] > 0, "your not a contributor!");
        _;
    }
    //modifier requestsExist(_requestNbr){
      //  require(requests[_requestNbr].value > 0); //how to do it???
        //_;
    //}

    function contribute() public payable beforeDeadline bigger_than_minimum_contribution{
        if(contributors[msg.sender] == 0){
            nbrOfContributors++;
        }
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;

        emit ContributeEvent(msg.sender, msg.value);
    }

    receive() payable external{
        contribute();
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function getRefund() public passedDeadline goalNotReached isContributor{
        uint refundValue;
        address payable recipient;

        recipient = payable(msg.sender);
        refundValue = contributors[recipient];
        contributors[recipient] = 0; //we do this before sending the funds to be protected from a reentrancy attack
        recipient.transfer(refundValue);
    }

    function createRequest(string memory _description, address payable _recipient, uint _value) public onlyAdmin{
        Request storage newRequest = requests[numRequests];
        numRequests++;

        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.nbrOfVoters = 0;

        emit CreateRequestEvent(_description, _recipient, _value);
    }

    function voteRequest(uint _requestNbr) public isContributor{ // voting means voting yes and not voting means voting no
        Request storage thisRequest = requests[_requestNbr];
        
        require(thisRequest.voters[msg.sender] == false, "you already voted!");
        thisRequest.voters[msg.sender] = true;
        thisRequest.nbrOfVoters++;
    }

    function makePayment(uint _requestNo) public onlyAdmin goalReached{
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false, "this request has already been completed!");
        require(thisRequest.nbrOfVoters > nbrOfContributors / 2, "this proposal did not pass!"); //50% of contributos voted this proposal
        require(getBalance() >= thisRequest.value, "no egnouth funds available");
        thisRequest.completed = true;
        thisRequest.recipient.transfer(thisRequest.value);

        emit MakePaymentEvent(thisRequest.recipient, thisRequest.value);
    }

}