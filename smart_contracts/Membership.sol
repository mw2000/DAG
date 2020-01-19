// Copyright 2020, DAG
// Description - Smart Contract containing the members, voting for rseolution and ranks, 
// and promoition and demotion of members to different ranks
// TODO - Need to add promotion and demotion

pragma solidity ^0.5.8;

import "./Resolution.sol";
import "./Rank.sol";

contract Membership {

    struct Member {
        Rank position;
        address addr;
        string name;
        string email;
        uint32 age;
        uint32 reputation;
    }

    // // Map member names to strings
    // mapping (string => address) public name_to_addr_db;
    // Core Map, get member data usingthe address
    mapping (address => Member) membership_db;

    // initialize the membership database
    constructor() public {
        // bootstrap, create founders
        membership_db[msg.sender] = Member(rank_db[0], msg.sender, "Admin", "", 18, 0);
    }

    function vote(address _voter, uint32 vote_mode, uint uuid, bool vote) public returns (bool) {
        if (vote_mode == 1) {
            // Voting for resolution
            if (vote) {
                resolution_db[uuid].votes_for++;
            } else {
                resolution_db[uuid].votes_against++;
            }
        } else if (vote_mode == 2) {
            // Voting for ranks
            if (vote) {
                rank_db[uuid].votes_for++;
            } else {
                rank_db[uuid].votes_against++;
            }
        } else if (vote_mode == 3) {
            if (vote) {
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
        membership_db[msg.sender] = Member(rank_db[1], msg.sender, name, email, age);
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
            if (msg.sender == rank_req_db[uuid].proposee_addr && current_date >= rank_req_db[uuid].decision_date
                    && rank_req_db[uuid].votes_for > rank_req_db[uuid].votes_against) {
                    rank_req_db[uuid].accepted = true;
                    membership_db[uuid].Rank = rank_db[rank_req_db[uuid].rank_uuid];
            }
        }
        return true;
    }

    function get_member_id(address member_addr) public returns (address, string, string, uint32, uint32){
        return (membership_db[member_addr].position.uuid, member_addr, membership_db[member_addr].name, membership_db[member_addr].email, 
            membership_db[member_addr].age, membership_db[member_addr].reputation);
    }
}