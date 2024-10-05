// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Tryhard - Compete, Achieve, and Earn Badges
/// @notice This smart contract allows users to compete in challenges, earn achievements, and mint badges as NFTs
contract Tryhard is ERC721, Ownable {
    uint256 public nextBadgeId;
    mapping(address => uint256) public achievements;
    mapping(uint256 => string) public badgeMetadata; // Metadata URI for each badge
    mapping(uint256 => string) public challenges;

    event NewChallenge(uint256 indexed challengeId, string challengeName);
    event BadgeMinted(address indexed user, uint256 badgeId, string metadataURI);
    event AchievementUnlocked(address indexed user, uint256 points);

    constructor() ERC721("TryhardBadge", "THB") {
        nextBadgeId = 1;
    }

    function createChallenge(uint256 challengeId, string memory challengeName) external onlyOwner {
        challenges[challengeId] = challengeName;
        emit NewChallenge(challengeId, challengeName);
    }

    function completeChallenge(address user, uint256 points, string memory badgeURI) external onlyOwner {
        achievements[user] += points;
        _mintBadge(user, badgeURI);
        emit AchievementUnlocked(user, points);
    }

    function _mintBadge(address user, string memory metadataURI) internal {
        uint256 badgeId = nextBadgeId;
        _safeMint(user, badgeId);
        badgeMetadata[badgeId] = metadataURI;
        emit BadgeMinted(user, badgeId, metadataURI);
        nextBadgeId++;
    }

    function getBadgeMetadata(uint256 badgeId) external view returns (string memory) {
        return badgeMetadata[badgeId];
    }

    function viewAchievements(address user) external view returns (uint256) {
        return achievements[user];
    }

    function getChallengeDetails(uint256 challengeId) external view returns (string memory) {
        return challenges[challengeId];
    }
}
