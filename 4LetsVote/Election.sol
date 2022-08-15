// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 < 0.8.0;

import "lab4/PollingStation.sol";

contract Election {
    mapping (uint => PollingStation) PollingStations;

    address authority;
    

    modifier onlyAuthority() {
        require(msg.sender == authority, "ERROR: Wrong authority");
        _;
    }

    modifier freshId(uint regionId) {
        require(PollingStations[regionId] == 0, "ERROR: ");
        _;
    }
}