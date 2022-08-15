// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface ERC721simplified {
  // EVENTS
  event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

  // APPROVAL FUNCTIONS
  function approve(address _approved, uint256 _tokenId) external payable;

  // TRANSFER FUNCTION
  function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

  // VIEW FUNCTIONS (GETTERS)
  function balanceOf(address _owner) external view returns (uint256);
  function ownerOf(uint256 _tokenId) external view returns (address);
  function getApproved(uint256 _tokenId) external view returns (address);
}

library ArrayUtils {

    function contains(string[] storage arr, string memory val) external view returns (bool) {
        uint i = 0;

        while(i < arr.length) {
            if(bytes(arr[i]).length == bytes(val).length) 
                if(keccak256(bytes(arr[i])) == keccak256(bytes(val)))                
                    return true;
            
            i++;
        }
        return false;
    }


    function increment(uint[] storage arr, uint8 percentage) external {
        for(uint i = 0; i < arr.length; i++) {
            arr[i] += arr[i] * percentage;
        }
    }

    function sum(uint[] storage arr) external view returns (uint) {
        uint s = 0;

        for(uint i = 0; i < arr.length; i++) {
            s += arr[i];
        }

        return s;
    }
}

contract MonsterTokens is ERC721simplified {

    struct Weapons {
        string[] names; // name of the weapon
        uint[] firePowers; // capacity of the weapon
    }
    
    struct Character {
        string name; // character name
        Weapons weapons; // weapons assigned to this character
        address tokenOwner;
        address approvedAddress;
    }

    address immutable owner;
    uint profit;
    uint tokenId;

    mapping(uint => Character) monsters;

    constructor(address o) {
        owner = o;
        tokenId = 10001;
        profit = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "ERROR: Wrong owner");
        _;
    }

    modifier onlyTokenOwner(uint256 tId) {
        require(msg.sender == monsters[tId].tokenOwner, "ERROR: Wrong token owner");
        _;
    }

    modifier approvedAddress(uint256 tId) {
        require(msg.sender == monsters[tId].tokenOwner ||
                msg.sender == monsters[tId].approvedAddress, "ERROR: Invalid address");
        _;
    }

    modifier validTransfer(uint256 tId) {
        require(msg.value >= ArrayUtils.sum(monsters[tId].weapons.firePowers), "ERROR: Not valid amount of Wei");
        _;
    }

    function createMonsterToken(string memory name, address tOwner) external onlyOwner returns (uint) {
        uint tId = tokenId;

        monsters[tId].name = name;
        monsters[tId].tokenOwner = tOwner;
        monsters[tId].weapons.names = new string[](0);
        monsters[tId].weapons.firePowers = new uint[](0);

        tokenId++;
        return tId;
    }

    function addWeapon(uint tId, string memory weaponName, uint firePower) external approvedAddress(tId) {
        require(!ArrayUtils.contains(monsters[tId].weapons.names,weaponName), "Weapon already added");       
        
        monsters[tId].weapons.names.push(weaponName);
        monsters[tId].weapons.firePowers.push(firePower);
    }

    function incrementFirePower(uint tId, uint8 percentage) external {
        ArrayUtils.increment(monsters[tId].weapons.firePowers, percentage);
    }

    function collectProfits() external onlyOwner {
        payable(owner).transfer(profit);
    }

    // APPROVAL FUNCTIONS
    function approve(address _approved, uint256 _tokenId) override external payable onlyTokenOwner(_tokenId) validTransfer(_tokenId) {
        require(_approved != address(0), "ERROR: Empty address");
        monsters[_tokenId].approvedAddress = _approved;
        
        emit Approval(msg.sender, _approved, _tokenId);
        profit += msg.value;
    }

    // TRANSFER FUNCTION
    function transferFrom(address _from, address _to, uint256 _tokenId) override external payable approvedAddress(_tokenId) validTransfer(_tokenId) {
        emit Transfer(_from, _to, _tokenId);
        profit += msg.value;
    }

    // VIEW FUNCTIONS (GETTERS)
    function balanceOf(address _owner) override external view returns (uint) {
        uint n = 0;

        for(uint i = 1001; i < tokenId; i++) {
            if(monsters[i].tokenOwner == _owner)
                n++;
        }

        return n;
    }

    function ownerOf(uint256 _tokenId) override external view returns (address){
        address o = monsters[_tokenId].tokenOwner;

        if(o == address(0))
            revert("Token does not have owner");
        else
            return o;
    }

    function getApproved(uint256 _tokenId) override external view returns (address) {        
        require(_tokenId >= 10001 && _tokenId <= tokenId, "Invalid token");
        return monsters[_tokenId].approvedAddress;
    }
}