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
        membership_db[msg.sender] = Member(rank[1], msg.sender, name, email, age);
    }

    function get_member_id(address member_addr) public returns (address, string, string, uint32, uint32){
        return (membership_db[member_addr].position.uuid, member_addr, membership_db[member_addr].name, membership_db[member_addr].email, 
            membership_db[member_addr].age, membership_db[member_addr].reputation);
    }
}