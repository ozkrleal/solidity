// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract FundMe {

    uint256 public minimumUsd = 50;

    function fund() public payable { // in order to send smth with a function you need payable
        // Want to be able to set a mminimum fund amount in USD 
        // 1. How do we send ETH to this contract?
        require(msg.value >= minimumUsd, "Didn't send enough!"); // 1e18 = 1 * 10^18

        // What is reverting?
        // undo any action before and send remaining gas
    
    }

    // function withdraw(){}

}