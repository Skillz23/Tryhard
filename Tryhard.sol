
      // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Tryhard - Compete, Achieve, and Earn Badges
/// @notice This smart contract allows users to compete in challenges, earn achievements, and mint badges as NFTs
contract Tryhard is ERC721, Ownable {
    uint256 public nextBadgeId;
    mapping(address => uint256) public achievements;
    mapping(uint256 => string) private _badgeMetadata; // Metadata URI for each badge
    mapping(uint256 => string) private _challenges;

    event NewChallenge(uint256 indexed challengeId, string challengeName);
    event BadgeMinted(address indexed user, uint256 badgeId, string metadataURI);
    event AchievementUnlocked(address indexed user, uint256 points);

    constructor() ERC721("TryhardBadge", "THB") {
        nextBadgeId = 1;
    }

    /// @notice Creates a new challenge
    /// @param challengeId The ID of the challenge
    /// @param challengeName The name of the challenge
    function createChallenge(uint256 challengeId, string memory challengeName) external onlyOwner {
        require(bytes(_challenges[challengeId]).length == 0, "Challenge already exists");
        _challenges[challengeId] = challengeName;
        emit NewChallenge(challengeId, challengeName);
    }

    /// @notice Marks a challenge as completed and mints a badge for the user
    /// @param user The address of the user
    /// @param points The number of achievement points awarded
    /// @param badgeURI The metadata URI for the badge
    function completeChallenge(address user, uint256 points, string memory badgeURI) external onlyOwner {
        achievements[user] += points;
        _mintBadge(user, badgeURI);
        emit AchievementUnlocked(user, points);
    }

    /// @notice Mints a badge and assigns it to the user
    /// @param user The address of the user
    /// @param metadataURI The metadata URI of the badge
    function _mintBadge(address user, string memory metadataURI) internal {
        uint256 badgeId = nextBadgeId;
        _safeMint(user, badgeId);
        _badgeMetadata[badgeId] = metadataURI;
        emit BadgeMinted(user, badgeId, metadataURI);
        nextBadgeId++;
    }

    /// @notice Returns the metadata of a badge
    /// @param badgeId The ID of the badge
    /// @return The metadata URI associated with the badge
    function getBadgeMetadata(uint256 badgeId) external view returns (string memory) {
        require(_exists(badgeId), "Badge does not exist");
        return _badgeMetadata[badgeId];
    }

    /// @notice Returns the achievements of a user
    /// @param user The address of the user
    /// @return The total achievement points of the user
    function viewAchievements(address user) external view returns (uint256) {
        return achievements[user];
    }

    /// @notice Returns the details of a challenge
    /// @param challengeId The ID of the challenge
    /// @return The name of the challenge
    function getChallengeDetails(uint256 challengeId) external view returns (string memory) {
        require(bytes(_challenges[challengeId]).length != 0, "Challenge does not exist");
        return _challenges[challengeId];
    }
}
