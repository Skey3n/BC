// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.18;

contract TokenContract {
    address public owner;
    uint256 public tokenPrice = 5 ether; // Precio por token: 5 Ether
    mapping(address => uint256) public balances;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
        balances[owner] = 100;
    }

    function buyTokens(uint256 _numTokens) public payable {
        uint256 totalCost = _numTokens * tokenPrice;
        require(msg.value >= totalCost, "Insufficient Ether provided");
        require(balances[owner] >= _numTokens, "Owner does not have enough tokens");

        balances[msg.sender] += _numTokens;
        balances[owner] -= _numTokens;

        // Reembolsar el exceso de Ether enviado
        if (msg.value > totalCost) {
            payable(msg.sender).transfer(msg.value - totalCost);
        }
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}