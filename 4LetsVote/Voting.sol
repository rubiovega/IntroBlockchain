// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract DhontElectionRegion {
    mapping(uint => uint) private weights;
    uint regionId;
    uint[] results;

    constructor (uint id, uint parties){
        regionId = id;
        results = new uint[] (parties);
    }

    function savedRegionInfo() private{
        weights[28] = 1; // Madrid
        weights[8] = 1; // Barcelona
        weights[41] = 1; // Sevilla
        weights[44] = 5; // Teruel
        weights[42] = 5; // Soria
        weights[49] = 4; // Zamora
        weights[9] = 4; // Burgos
        weights[29] = 2; // Malaga
    }

    function  registerVote(uint party) internal returns (bool) {
        if (party <= results.length){
            results[party] += weights[regionId];
            return true;
        }
        else return false; 
    }


}

abstract contract PollingStation {
    bool public votingFinished;
    bool private votingOpen;
    address president;

    constructor(address p) {
        president = p;
    }

    modifier onlyPresident() {
        require(msg.sender == president, "ERROR: Not the president");
        _;
    }

    modifier votingIsOpen() {
        require(votingOpen, "The voting is not opened");
        _;
    }

    function openVoting() external onlyPresident {
        if(!votingOpen) votingOpen = true;
    }

    function closeVoting() external onlyPresident {
        votingFinished = true;
    }

    function castVote(uint idParty) external virtual;
    function getResults() external virtual returns (uint[] memory);
}



   contract DhondtPollingStation is DhontElectionRegion, PollingStation {
        
        constructor (address a, uint id, uint parties) DhontElectionRegion (id, parties) PollingStation (a) {}

        function castVote(uint idParty) override external votingIsOpen {
            registerVote(idParty);
        }

        function getResults() override external returns (uint[] memory){
            require (votingFinished, "ERROR: Voting has not finished");
            return results;
        }

    } 