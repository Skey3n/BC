// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract VotingContract {
    address public admin;
    uint public votingStartTime;
    uint public votingEndTime;
    
    enum Option { OptionA, OptionB } // add options
    mapping(address => bool) public hasVoted;
    mapping(Option => uint) public voteCount;

    event Voted(address indexed voter, Option indexed option);

    constructor(uint _startTime, uint _endTime) {
        admin = msg.sender;
        votingStartTime = _startTime;
        votingEndTime = _endTime;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyDuringVotingPeriod() {
        require(block.timestamp >= votingStartTime && block.timestamp <= votingEndTime, "Voting is not currently allowed");
        _;
    }

    function vote(Option _option) public onlyDuringVotingPeriod {
        require(!hasVoted[msg.sender], "You have already voted");
        
        hasVoted[msg.sender] = true;
        voteCount[_option]++;
        emit Voted(msg.sender, _option);
    }

    function getVoteCount(Option _option) public view returns (uint) {
        return voteCount[_option];
    }
}