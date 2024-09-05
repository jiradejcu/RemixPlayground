// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract ClaimReward {
    address public owner;
    IERC20 public rewardToken;
    mapping(address => uint256) public rewards;

    event RewardClaimed(address indexed user, uint256 amount);
    event RewardAdded(address indexed user, uint256 amount);

    constructor(address _rewardToken) {
        owner = msg.sender;
        rewardToken = IERC20(_rewardToken);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // Function to add rewards to a specific user
    function addReward(address _user, uint256 _amount) external onlyOwner {
        rewards[_user] += _amount;
        emit RewardAdded(_user, _amount);
    }

    // Function for users to claim their rewards
    function claimReward() external {
        uint256 amount = rewards[msg.sender];
        require(amount > 0, "No rewards to claim");
        require(rewardToken.balanceOf(address(this)) >= amount, "Insufficient contract balance");

        rewards[msg.sender] = 0;
        rewardToken.transfer(msg.sender, amount);
        emit RewardClaimed(msg.sender, amount);
    }

    // Function to retrieve the current reward of the caller
    function getCurrentReward() external view returns (uint256) {
        return rewards[msg.sender];
    }

    // Function to retrieve the reward balance of any address
    function getRewardBalance(address _user) external view returns (uint256) {
        return rewards[_user];
    }

    // Function to retrieve the contract's ERC20 token balance
    function getContractTokenBalance() external view returns (uint256) {
        return rewardToken.balanceOf(address(this));
    }
}
