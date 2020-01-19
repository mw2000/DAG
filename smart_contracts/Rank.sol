// Copyright 2020, DAG
// Description - Smart Contract containing the ranks given to members, to elevate them to a committee
// TODO - Maybe give a powers array or something. (Too Vague)

pragma solidity ^0.5.8;

import "./Membership.sol";

contract Rank {

    struct Rank {
        uint32 uuid; // Unique id of the resolution
        string title; // Title of Rank
        string description; // Description of Rank
        address proposee_addr;
        address[] rank_holders;
        uint32 votes_for;
        uint32 votes_against;
        uint32 proposal_date;
        uint32 decision_date; // Can be 6 hours, 12 hours, 1 day, 1 week of introduction
        bool accepted; // Was the resolution accepted or not?
        // uint32 preference; // Might use it later or not
    }

    // Database of all resolutions adopted
    mapping (uint32 => Rank) rank_db;

    uint32 total_ranks;

    // initialize the membership database
    constructor() public {
        // bootstrap, create founders
        total_ranks = 0;
        rank_db[0] = Rank(0, "Admin", "Rank given to the initiator of the DAG", msg.sender, [msg.sender],
            1, 0, 0, 0, true); 
        rank_db[1] = Rank(1, "Member", "Rank given to the member of the DAG", msg.sender, [], 1, 0, 0, 0, true); 
        total_ranks++;
        total_ranks++;
    }

    function add_rank(uint32 uuid, string memory title, string memory description, address proposee_addr,
        uint32 proposal_date, uint32 decision_date) public returns (bool) {
        // Add the resolution to the database
        rank_db[total_ranks] = Rank(total_ranks, title, description, proposee_addr, [], 
            0, 0, proposal_date, decision_date, false);
        total_ranks++;
        // membership_db[proposee].reputation += 1000;
        return true;
    }

    function get_rank(uint32 uuid) public returns (uint32, string, string, address, uint32, 
        uint32, uint32, uint32) {
        return (rank_db[uuid].uuid, rank_db[uuid].title, rank_db[uuid].description, rank_db[uuid].proposee_addr, 
            rank_db[uuid].votes_for, rank_db[uuid].votes_against, rank_db[uuid].proposal_date, 
            rank_db[uuid].decision_date, rank_db[uuid].accepted);
    }

    function get_rank_holders(uint32 uuid) public returns (address[] memory) {
        return rank_db[uuid].rank_holders;
    }
}

