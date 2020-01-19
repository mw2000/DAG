// Copyright 2020, DAG
// Description - Smart Contract containing the members, voting for rseolution and ranks, 
// and promoition and demotion of members to different ranks
// TODO - Need to add promotion and demotion

pragma solidity ^0.5.8;

contract MembershipDB {

    struct Member {
        uint32 rank;
        address addr;
        string name;
        string email;
        uint32 age;
    }

    // Core Map, get member data usingthe address
    mapping (address => Member) public membership_db;

    // initialize the membership database
    constructor() public {
        // bootstrap, create founders
        membership_db[msg.sender] = Member(0, msg.sender, "Admin", "", 18);
    }

}