pragma solidity >=0.5.0 <0.9.0;

contract A{
    
    function strjoin(string memory a, string memory b) public pure returns (string memory) {
        return string(abi.encodePacked(a, b));
    }
}