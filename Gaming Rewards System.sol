// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title GameRewards
 * @dev A smart contract for managing gaming rewards and achievements on Core Chain
 */
contract GameRewards {
    address public owner;
    
    // Player data structure
    struct Player {
        uint256 rewardsBalance;
        uint256 achievementCount;
        bool isRegistered;
    }
    
    // Mapping to store player data
    mapping(address => Player) public players;
    
    // Events
    event PlayerRegistered(address indexed playerAddress);
    event RewardsEarned(address indexed playerAddress, uint256 amount);
    event RewardsRedeemed(address indexed playerAddress, uint256 amount);
    
    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
    
    modifier playerExists(address playerAddress) {
        require(players[playerAddress].isRegistered, "Player is not registered");
        _;
    }
    
    /**
     * @dev Constructor sets the contract deployer as the owner
     */
    constructor() {
        owner = msg.sender;
    }
    
    /**
     * @dev Register a new player in the system
     * @return success Boolean indicating successful registration
     */
    function registerPlayer() public returns (bool success) {
        require(!players[msg.sender].isRegistered, "Player already registered");
        
        players[msg.sender] = Player({
            rewardsBalance: 0,
            achievementCount: 0,
            isRegistered: true
        });
        
        emit PlayerRegistered(msg.sender);
        return true;
    }
    
    /**
     * @dev Award rewards to a player for achievements or gameplay
     * @param playerAddress Address of the player to award rewards to
     * @param amount Amount of rewards to award
     * @return newBalance Updated rewards balance of the player
     */
    function awardRewards(address playerAddress, uint256 amount) public onlyOwner playerExists(playerAddress) returns (uint256 newBalance) {
        players[playerAddress].rewardsBalance += amount;
        players[playerAddress].achievementCount += 1;
        
        emit RewardsEarned(playerAddress, amount);
        return players[playerAddress].rewardsBalance;
    }
    
    /**
     * @dev Allow a player to redeem their rewards
     * @param amount Amount of rewards to redeem
     * @return remaining Remaining rewards balance after redemption
     */
    function redeemRewards(uint256 amount) public playerExists(msg.sender) returns (uint256 remaining) {
        require(players[msg.sender].rewardsBalance >= amount, "Insufficient rewards balance");
        
        players[msg.sender].rewardsBalance -= amount;
        
        // In a real implementation, this would trigger an external action
        // such as transferring tokens or triggering an off-chain process
        
        emit RewardsRedeemed(msg.sender, amount);
        return players[msg.sender].rewardsBalance;
    }
}
