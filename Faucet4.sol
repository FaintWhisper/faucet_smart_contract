// SPDX-License-Identifier: CC-BY-SA-4.0

// Version of Solidity compiler this program was written for
pragma solidity ^0.6.4;

// Our first contract is a faucet!
contract Faucet {
    address payable owner;
    mapping (address => bool) private wallets;

    // Contract constructor: set owner
    constructor() public {
        owner = msg.sender;
    }

    // Access control modifier
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    // Accept any incoming amount
    receive() external payable {}

    // Contract destructor
    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
    
    function addWallet(address wallet_address) private {
        wallets[wallet_address] = true;
    }

    function alreadyRequested(address wallet_address) public view returns (bool){
        return wallets[wallet_address];
    }

    // Give out ether to anyone who asks
    function withdraw(uint withdraw_amount) public payable {
        if (!alreadyRequested(msg.sender)) {
            // Limit withdrawal amount
            require(withdraw_amount <= 5 ether);
    
            // Send the amount to the address that requested it
            msg.sender.transfer(withdraw_amount);
            
            // Add claimant address to local array
            addWallet(msg.sender);
        }
    }
}