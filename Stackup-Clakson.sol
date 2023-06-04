// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract StackUp {
  // enums
  enum playerQuestStatus {
    NOT_JOINED,
    JOINED,
    SUBMITTED
  }
  
  enum questReward {
    APPROVED,
    REWARDED,
    REJECTED
  }

  // struct
  struct Quest {
    uint256 questId;
    uint256 numberOfPlayers;
    string title;
    uint8 reward;
    uint256 numberOfRewards;
    uint256 startTime;
    uint256 endTime;
  }
  
  // state variables
  address public admin;
  uint256 public nextQuestId;
  mapping(uint256 => Quest) public quests;
  mapping(address => mapping(uint256 => playerQuestStatus)) public playerQuestStatuses;
  mapping(address => mapping(uint256 => questReward)) public questRewards;

  // constructor
  constructor() {
    admin = msg.sender;
  }

  // external
  function createQuest(
    string calldata title_,
    uint8 reward_,
    uint256 numberOfRewards_,
    uint256 startTime_,
    uint256 endTime_
  ) external {
    require(msg.sender == admin, "Only the admin can create quests");
    quests[nextQuestId].questId = nextQuestId;
    quests[nextQuestId].title = title_;
    quests[nextQuestId].reward = reward_;
    quests[nextQuestId].numberOfRewards = numberOfRewards_;
    quests[nextQuestId].startTime = startTime_;
    quests[nextQuestId].endTime = endTime_;
    nextQuestId++;
  }

  function joinQuest(uint256 questId) external questExists(questId) {
    require(
      playerQuestStatuses[msg.sender][questId] ==
      playerQuestStatus.NOT_JOINED,
      "Player has already joined/submitted this quest"
    );
    require(
      quests[questId].startTime > block.timestamp,
      "It's too early to join this quest"
    );
    require(
      quests[questId].endTime <= block.timestamp,
      "This quest has ended"
    );

    playerQuestStatuses[msg.sender][questId] = playerQuestStatus.JOINED;

    Quest storage thisQuest = quests[questId];
    thisQuest.numberOfPlayers++;
  }

  function submitQuest(uint256 questId) external questExists(questId) {
    require(
      playerQuestStatuses[msg.sender][questId] ==
      playerQuestStatus.JOINED,
      "Player must first join the quest"
    );
    require(
      quests[questId].endTime <= block.timestamp,
      "This quest has ended"
    );
    playerQuestStatuses[msg.sender][questId] = playerQuestStatus.SUBMITTED;
  }

  function reviewSubmission(
    uint256 questId, 
    uint256 questReward_, 
    address playerAddress) external questExists(questId) {
    require(msg.sender == admin, "Only the admin can review quests");
    require(
      playerQuestStatuses[playerAddress][questId] ==
      playerQuestStatus.SUBMITTED,
      "Player must first submit the quest"
    );
    require(questReward_ >= 1 && questReward_ < 3,
    "Invalid option, please select 1 for approved, 2 for rewarded and 3 for rejected");

    if (questReward_ == 1) {
      questRewards[playerAddress][questId] = questReward.APPROVED;
    } else if (questReward_ == 2) {
      questRewards[playerAddress][questId] = questReward.REWARDED;
    } else if (questReward_ == 3)  {
      questRewards[playerAddress][questId] = questReward.REJECTED;
    }
  }

  // public
  function returnBlockTimestamp() public view returns(uint256) {
    return block.timestamp;
  }

  // modifier
  modifier questExists(uint256 questId) {
    require(quests[questId].reward != 0, "Quest does not exist");
    _;
  }

}