// Copyright 2020, DAG
// Description - Smart Contract containing the ranks given to members, to elevate them to a committee
// TODO - Maybe give a powers array or something. (Too Vague)

pragma solidity ^0.5.8;

import "./Membership.sol";

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
    mapping (uint32 => Rank) rank_db;
    mapping (uint32 => Rank_Request) rank_req_db; 

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

    function add_rank(string memory title, string memory description, address proposee_addr,
        uint32 proposal_date, uint32 decision_date) public returns (bool) {
        // Add the rank to the database
        rank_db[total_ranks] = Rank(total_ranks, title, description, proposee_addr, 
            0, 0, proposal_date, decision_date, false);
        total_ranks++;
        // membership_db[proposee].reputation += 1000;
        return true;
    }

    // Add a rank request to the database
    function add_rank_request(uint32 rank_uuid, address rank_requester_addr, uint32 proposal_date, 
        uint32 decision_date) public returns (bool) {
        rank_req_db[total_rank_reqs] = Rank_Request (total_rank_reqs, rank_requester_addr, rank_uuid, 0, 0,
            proposal_date, decision_date, false);
        total_rank_reqs++;
        return true;
    }
    
    function get_rank_request(uint32 uuid) public view returns (uint32, address, uint32) {
        return (rank_req_db[uuid].uuid, rank_req_db[uuid].rank_requester_addr, rank_req_db[uuid].rank_uuid);
    }
    
    function get_rank_request_stats (uint32 uuid) public view returns (uint32, uint32, uint32, uint32, bool) {
        return (rank_req_db[uuid].votes_for, rank_req_db[uuid].votes_against, rank_req_db[uuid].proposal_date, 
            rank_req_db[uuid].decision_date, rank_req_db[uuid].accepted);
    }
    

    function get_rank(uint32 uuid) public view returns (uint32, string memory, string memory, address) {
        return (rank_db[uuid].uuid, rank_db[uuid].title, rank_db[uuid].description, rank_db[uuid].proposee_addr);
    }
    
    function get_rank_stats(uint32 uuid) public view returns (uint32, uint32, uint32, uint32, bool) {
        return (rank_db[uuid].votes_for, rank_db[uuid].votes_against, rank_db[uuid].proposal_date, 
            rank_db[uuid].decision_date, rank_db[uuid].accepted);
    }

}

