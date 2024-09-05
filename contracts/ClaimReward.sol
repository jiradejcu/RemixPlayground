// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ClaimReward {
    address public owner;
    mapping(address => uint256) public rewards;

    event RewardClaimed(address indexed user, uint256 amount);
    event RewardAdded(address indexed user, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    function addReward(address _user, uint256 _amount) external onlyOwner {
        rewards[_user] += _amount;
        emit RewardAdded(_user, _amount);
    }

    function claimReward() external {
        uint256 amount = rewards[msg.sender];
        require(amount > 0, "No rewards to claim");
        rewards[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
        emit RewardClaimed(msg.sender, amount);
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
