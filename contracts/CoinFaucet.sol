// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinFaucet {
    address public owner;             // The owner of the faucet
    uint256 public dripAmount;        // Amount of coins to dispense per request (in wei)
    uint256 public cooldownTime;      // Cooldown time between requests per address (in seconds)

    mapping(address => uint256) public lastRequestTime; // Tracks the last request time of each address

    event CoinsDispensed(address indexed user, uint256 amount);

    constructor(uint256 _dripAmount, uint256 _cooldownTime) {
        owner = msg.sender;
        dripAmount = _dripAmount;
        cooldownTime = _cooldownTime;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // Function to request coins from the faucet
    function requestCoins() external {
        require(block.timestamp >= lastRequestTime[msg.sender] + cooldownTime, "Please wait before requesting again");
        require(address(this).balance >= dripAmount, "Faucet is empty");

        lastRequestTime[msg.sender] = block.timestamp;
        payable(msg.sender).transfer(dripAmount);

        emit CoinsDispensed(msg.sender, dripAmount);
    }

    // Function to update the drip amount
    function setDripAmount(uint256 _newAmount) external onlyOwner {
        dripAmount = _newAmount;
    }

    // Function to update the cooldown time
    function setCooldownTime(uint256 _newCooldown) external onlyOwner {
        cooldownTime = _newCooldown;
    }

    // Function for the owner to withdraw coins from the faucet
    function withdrawCoins(uint256 _amount) external onlyOwner {
        require(address(this).balance >= _amount, "Insufficient balance");
        payable(owner).transfer(_amount);
    }

    // Function to deposit coins into the faucet
    receive() external payable {}

    // Function to check the faucet's coin balance
    function getFaucetBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
