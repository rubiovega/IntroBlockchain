// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 < 0.8.0;

contract PiggyArray {

    struct Client {
        string name;
        address addr;
        uint balance;
    }

    Client[] infoClients;

    function clientExists(address addr) internal view returns(bool) {
        uint i = 0;
        bool found = false;

        while(!found && i < infoClients.length) {
            if(infoClients[i].addr == addr)
                found = true;
            i++;
        }

        return found;
    }

    function addClient(string memory name) external payable {
        require(bytes(name).length != 0, "ERROR: The name field is empty");
        require(!clientExists(msg.sender), "ERROR: Client already exists");

        Client memory c = Client(name, msg.sender, msg.value);
        infoClients.push(c);
    }
    
    function getBalance() external view returns(uint) {  
        require(clientExists(msg.sender), "ERROR: Client doesn't exist");  
            
        uint i = 0;
        uint b = 0;
        bool found = false;

        while(!found && i < infoClients.length) {
            if(infoClients[i].addr == msg.sender) {
                found = true;
                b = infoClients[i].balance;
            }
            i++;
        }
        return b;
    }

    function deposit() external payable {
        require(clientExists(msg.sender), "ERROR: Client doesn't exist");

        uint i = 0;
        bool found = false;

        while(!found && i < infoClients.length) {
            if(infoClients[i].addr == msg.sender) {                
                infoClients[i].balance += msg.value;
                found = true;
            }
            i++;
        }
    }

    function withdraw(uint amountInWei) external {
        require(clientExists(msg.sender), "ERROR: Client doesn't exist");        
        
        uint i = 0;
        bool found = false;

        while(!found && i < infoClients.length) {
            if(infoClients[i].addr == msg.sender) {                
                require(infoClients[i].balance >= amountInWei, "ERROR: Not enough balance");
                infoClients[i].balance -= amountInWei;
                found = true;
            }
            i++;
        }

        payable(msg.sender).transfer(amountInWei);
    }
}

contract PiggyMapping {

    struct Client {
        uint balance;
        string name;
    }

    mapping (address => Client) clients;

    function addClient(string memory name) external payable { 
        require (bytes(name).length != 0, "ERROR: The name field is empty");
        require (bytes(clients[msg.sender].name).length == 0, "ERROR: Client already exists");
        clients[msg.sender] = Client(msg.value, name);
    }

    function getBalance()external view returns (uint) {
        require (bytes(clients[msg.sender].name).length > 0, "ERROR: Client doesn't exist");
        return clients[msg.sender].balance;
    }

    function withdraw(uint amountInWei) external{
        require (bytes(clients[msg.sender].name).length > 0, "ERROR: Client doesn't exist");
        require (clients[msg.sender].balance >= amountInWei, "ERROR: Not enough balance");          
        clients[msg.sender].balance = clients[msg.sender].balance - amountInWei;     
        payable(msg.sender).transfer(amountInWei);  
    }

    function deposit() external payable {
        require (bytes(clients[msg.sender].name).length > 0, "ERROR: Client doesn't exist");
        clients[msg.sender].balance = clients[msg.sender].balance + msg.value;
    }
}

contract PiggyMapping2 {

    struct Client {
        uint balance;
        address a;
        string name;
    }

    mapping (address => Client) clients;
    address[] clientsKey;


    function addClient(string memory name) external payable { 
        require (bytes(name).length != 0, "ERROR: The name field is empty");
        require (bytes(clients[msg.sender].name).length == 0, "ERROR: Client already exists");
        clients[msg.sender] = Client(msg.value, msg.sender, name);
        clientsKey.push(msg.sender);
    }

    function getBalance()external view returns (uint) {
        require (bytes(clients[msg.sender].name).length > 0, "ERROR: Client doesn't exist");
        return clients[msg.sender].balance;
    }

    function withdraw(uint amountInWei) external{
        require (bytes(clients[msg.sender].name).length > 0, "ERROR: Client doesn't exist");
        require (clients[msg.sender].balance >= amountInWei, "ERROR: Not enough balance");          
        clients[msg.sender].balance = clients[msg.sender].balance - amountInWei;     
        payable(msg.sender).transfer(amountInWei);  
    }

    function deposit() external payable {
        require (bytes(clients[msg.sender].name).length > 0, "ERROR: Client doesn't exist");
        clients[msg.sender].balance = clients[msg.sender].balance + msg.value;
    }

    function checkBalances() external view returns (bool) {
        uint sumBalance = 0;

        for(uint i = 0; i < clientsKey.length; i++) {
            address addr = clientsKey[i];
            sumBalance += clients[addr].balance;
        }        
        return sumBalance == address(this).balance;
    }
}