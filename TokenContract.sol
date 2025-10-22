// SPDX-License-Identifier: Unlicenced
pragma solidity 0.8.30;
contract TokenContract {
    address public owner;
    uint256 public constant TOKEN_PRICE = 5 ether;
    struct Receivers {
        string name;
        uint256 tokens;
    }
    mapping(address => Receivers) public users;
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    constructor(){
        owner = msg.sender;
        users[owner].tokens = 100;
    }
    function double(uint _value) public pure returns (uint){
        return _value*2;
    }
    function register(string memory _name) public{
        users[msg.sender].name = _name;
    }
    function giveToken(address _receiver, uint256 _amount) onlyOwner public{
        require(users[owner].tokens >= _amount);
        users[owner].tokens -= _amount;
        users[_receiver].tokens += _amount;
    }
    // Nueva función para comprar tokens
    function buyTokens(uint256 _amount) public payable {
        uint256 totalCost = _amount * TOKEN_PRICE;

        require(msg.value == totalCost, "Debes enviar exactamente 5 ether por token");
        require(msg.value >= totalCost, "Ether insuficiente para la compra");
        require(users[owner].tokens >= _amount, "El propietario no tiene suficientes tokens");

        // Transferir tokens
        users[owner].tokens -= _amount;
        users[msg.sender].tokens += _amount;
    }

    // Ver balance de Ether del contrato
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getOwnerTokens() public view returns (uint256) {
        return users[owner].tokens;
    }

    function getMyTokens() public view returns (uint256) {
        return users[msg.sender].tokens;
    }
}