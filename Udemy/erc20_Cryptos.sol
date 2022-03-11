pragma solidity >=0.5.0 <0.9.0;

interface ERC20Interface {
    function totalSupply() external view returns (uint balance);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function transfer(address to, uint tokens) external returns (bool success);

    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function approve (address to, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract Cryptos is ERC20Interface{
    string public name = "cryptos";
    string public symbol = "CRPT";
    uint public decimals = 0; //18 is the max 
    uint public override totalSupply;

    address public founder; 
    mapping(address => uint) public balances; //how much tokens has each address
    mapping(address => mapping(address => uint)) allowed; //this mapping stores the allowed token funds an adress can give to an other one (Ex: User wallet to a contract)


    modifier egnouthFunds(uint tokens){
        require(balances[msg.sender] >= tokens, "your balance is too low!");
        _;
    }

    constructor(){
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns(uint balance){
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public virtual egnouthFunds(tokens) override returns(bool success){

        balances[msg.sender] -= tokens;
        balances[to] += tokens;

        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) view public override returns(uint){
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) public egnouthFunds(tokens) override returns(bool success){
        require(tokens > 0);
        
        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public virtual override returns (bool success){
        require(allowed[from][to] >= tokens, "you not allowed that much!");
        require(balances[from] >= tokens, "Insuficient funds");

        balances[from] -= tokens;
        allowed[from][to] -= tokens;
        balances[to] += tokens; 

        return true;
    }

}

contract CryptosICO is Cryptos{
    address public admin;
    address payable public deposit;
    uint tokenPrice = 0.0001 ether;
    uint public hardCap = 300 ether;
    uint public raisedAmount;
    uint public saleStart = block.timestamp;
    uint public saleEnd = block.timestamp + 604800;
    uint public tokenTradeStart = saleEnd + 604800;
    uint public maxInvestement = 5 ether;
    uint public minInvestement = 0.1 ether;

    enum State {beforeStart, running, afterEnd, halted}
    State public icoState;

    constructor(address payable _deposit){
        deposit = _deposit;
        admin = msg.sender;
        icoState = State.beforeStart;
    }

    receive() payable external{
        invest();
    }

    modifier onlyAdmin(){
        require(msg.sender == admin, "you are not the admin!");
        _;
    }

    function halt() public onlyAdmin{
        icoState = State.halted;
    }

    function resume() public onlyAdmin{
        icoState = State.running;
    }

    function changeDepositAdress(address payable newDeposit) public onlyAdmin{
        deposit = newDeposit;
    }

    function getCurrentState() public view returns(State){
        if(icoState == State.halted){
            return State.halted;
        }else if(block.timestamp < saleStart){
            return State.beforeStart;
        }else if(block.timestamp >= saleStart && block.timestamp <= saleEnd){
            return State.running;
        }else if(block.timestamp > saleEnd){
            return State.afterEnd;
        }
    }

    event Invest(address investor, uint value, uint tokens);
    
    function invest() payable public returns(bool){ //flawed function, we can still send funds when the hardcap has been reached
        icoState = getCurrentState();
        require(icoState == State.running, "the ICO is not running!");
        require(msg.value >= minInvestement && msg.value <= maxInvestement);
        raisedAmount += msg.value; //bizarre! que ce passe t'il quand on est dessou de la limite mais on la depasse avec notre investement
        require(raisedAmount <= hardCap);

        uint tokens = msg.value / tokenPrice;

        balances[msg.sender] += tokens;  //declared in the cryptos contract and inherited by the ICO contract
        balances[founder] -= tokens;
        deposit.transfer(msg.value);

        emit Invest(msg.sender, msg.value, tokens);
        return true;
    }

    function transfer(address to, uint tokens) public egnouthFunds(tokens) override returns(bool success){
        require(block.timestamp > tokenTradeStart, "trading of the token has not started yet!");
        Cryptos.transfer(to, tokens); //same as super.transfer(to, tokens);
        return true;
    }

    function transferFrom( address from, address to, uint tokens) public override returns (bool){
        require(block.timestamp > tokenTradeStart);
        Cryptos.transferFrom(from, to, tokens);
        return true;
    }

    function burn() public returns(bool){
        icoState = getCurrentState();
        require(icoState == State.afterEnd);
        balances[founder] = 0; //all the founder tokens have been burned
        return true;
    }

    function getTime() public view returns(uint time){
        return block.timestamp;
    }

    function getBalance() public view returns(uint balance){
        return address(this).balance;
    }
}