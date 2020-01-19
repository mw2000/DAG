// Copyright 2020, DAG
// Description - Smart Contract containing the resolutions introduced
// TODO - None for now

pragma solidity ^0.5.8;

import "./Membership.sol";

contract Resolution {

    struct Resolution {
        uint32 uuid; // Unique id of the resolution
        address proposee_addr;
        uint votes_for;
        uint votes_against;
        string url;
        string hash_tag;
        string description;
        string title;
        uint32 proposal_date;
        uint32 decision_date; // Can be 6 hours, 12 hours, 1 day, 1 week of introduction
        bool accepted; // Was the resolution accepted or not
    }

    // Database of all resolutions adopted
    mapping (uint32 => Resolution) resolution_db;

    uint32 total_resolutions;

    // initialize the membership database
    constructor() public {
        // bootstrap, create founders
        total_resolutions = 0;
        resolution_db[total_resolutions] = Resolution(total_resolutions, msg.sender, 1, 0, 
            "goo.gl/1A3dZ", "", "The resolution of adoption of the DAG as the new government", 
            "Adoption of DAG", 0, 0, true);
        total_resolutions++;
    }

    function add_resolution(address proposee_addr, string memory url, string memory hash_tag, uint32 description, 
        string memory title, uint32 proposal_date, uint32 decision_date) public returns (bool) {
        // Add the resolution to the database
        resolution_db[total_resolutions] = Resolution(total_resolutions, proposee_addr, 0, 0, 
            url, hash_tag, description, title, proposal_date, decision_date, false);
        total_resolutions++;
        // membership_db[proposee].reputation += 100;
        return true;
    }
}

