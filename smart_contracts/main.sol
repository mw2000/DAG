// Copyright 2020, DAG
// Description - Smart Contract containing the members, voting for rseolution and ranks, 
// and promoition and demotion of members to different ranks
// TODO - Need to add promotion and demotion

pragma solidity ^0.4.24;

import "./MembershipDB.sol";
import "./ResolutionDB.sol";
import "./RankDB.sol";

contract main is MembershipDB, ResolutionDB, RankDB {

    function vote(address _voter, uint32 vote_mode, uint32 uuid, bool vote_) public returns (bool) {
        if (vote_mode == 1) {
            // Voting for resolution
            if (vote_) {
                resolution_db[uuid].votes_for++;
            } else {
                resolution_db[uuid].votes_against++;
            }
        } else if (vote_mode == 2) {
            // Voting for ranks
            if (vote_) {
                rank_db[uuid].votes_for++;
            } else {
                rank_db[uuid].votes_against++;
            }
        } else if (vote_mode == 3) {
            if (vote_) {
                rank_req_db[uuid].votes_for++;
            } else {
                rank_req_db[uuid].votes_against++;
            }
        }
        membership_db[_voter].reputation++;
        return true;
    }

    function add_member(address _member_addr, string memory name, string memory email, uint32 age) 
        public returns (bool) {
        // Need to pass resolution to add member
        //  ** Scrap this for now, make it open model
        // execute_vote();
        // Restrict to email
        membership_db[msg.sender] = Member(1, _member_addr, name, email, age, 10000);
    }

    function accept(uint32 uuid, uint32 accept_mode, uint32 current_date) public returns (bool){
        if (accept_mode == 1) {
            if (msg.sender == resolution_db[uuid].proposee_addr && current_date >= resolution_db[uuid].decision_date
                && resolution_db[uuid].votes_for > resolution_db[uuid].votes_against) {
                    resolution_db[uuid].accepted = true;
            }
        } else if (accept_mode == 2) {
            if (msg.sender == rank_db[uuid].proposee_addr && current_date >= rank_db[uuid].decision_date
                && rank_db[uuid].votes_for > rank_db[uuid].votes_against) {
                    rank_db[uuid].accepted = true;
            }
        } else if (accept_mode == 3) {
            if (msg.sender == rank_req_db[uuid].rank_requester_addr && current_date >= rank_req_db[uuid].decision_date
                    && rank_req_db[uuid].votes_for > rank_req_db[uuid].votes_against) {
                    rank_req_db[uuid].accepted = true;
                    membership_db[rank_req_db[uuid].rank_requester_addr].rank = rank_req_db[uuid].rank_uuid;
            }
        }
        return true;
    }

    function get_member_id(address member_addr) public view returns (uint32, address, string memory, string memory, uint32, uint32){
        return (membership_db[member_addr].rank, member_addr, membership_db[member_addr].name, membership_db[member_addr].email, 
            membership_db[member_addr].age, membership_db[member_addr].reputation);
    }

    function add_resolution(address proposee_addr, string memory url, string memory hash_tag, string memory description, 
        string memory title, uint32 proposal_date, uint32 decision_date) public returns (bool) {
        // Add the resolution to the database
        resolution_db[total_resolutions] = Resolution(total_resolutions, proposee_addr, 0, 0, 
            url, hash_tag, description, title, proposal_date, decision_date, false);
        total_resolutions++;
        // membership_db[proposee].reputation += 100;
        return true;
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
