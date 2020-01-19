// Copyright 2020, DAG
// Description - Smart Contract containing the ranks given to members, to elevate them to a committee
// TODO - Maybe give a powers array or something. (Too Vague)

pragma solidity ^0.4.24;

contract RankDB {

    struct Rank {
        uint32 uuid; // Unique id of the resolution
        string title; // Title of Rank
        string description; // Description of Rank
        address proposee_addr;
        uint32 votes_for;
        uint32 votes_against;
        uint32 proposal_date;
        uint32 decision_date; // Can be 6 hours, 12 hours, 1 day, 1 week of introduction
        bool accepted; // Was the resolution accepted or not?
        // uint32 preference; // Might use it later or not
    }

    struct Rank_Request {
        uint32 uuid;
        address rank_requester_addr;
        uint32 rank_uuid;
        uint32 votes_for;
        uint32 votes_against;
        uint32 proposal_date;
        uint32 decision_date; // Can be 6 hours, 12 hours, 1 day, 1 week of introduction
        bool accepted; // Was the resolution accepted or not?
    }

    // Database of all resolutions adopted
    mapping (uint32 => Rank) public rank_db;
    mapping (uint32 => Rank_Request) public rank_req_db; 

    uint32 total_ranks;
    uint32 total_rank_reqs;

    // initialize the membership database
    constructor() public {
        // bootstrap, create founders
        total_ranks = 0;
        total_rank_reqs = 0;
        rank_db[0] = Rank(0, "Admin", "Rank given to the initiator of the DAG", msg.sender, 1, 0, 0, 0, true); 
        rank_db[1] = Rank(1, "Member", "Rank given to the member of the DAG", msg.sender, 1, 0, 0, 0, true);
        total_ranks++;
        total_ranks++;
    }

}

