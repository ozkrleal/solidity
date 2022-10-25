// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

// constant, immutable

// 859817 gas
// 840,281

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 20 * 1e18; 
    // 21,415 - CONSTAnt
    // 23,515 - non constant

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;
    // 21,508 - immutalbe
    // 23,644 gas - non-immutable

    constructor(){
        // owner is whoever deployed this contract
        i_owner = msg.sender;
    }

    function fund() public payable { // in order to send smth with a function you need payable
        
        // Want to be able to set a mminimum fund amount in USD 
        // 1. How do we send ETH to this contract?
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough!"); // 1e18 = 1 * 10^18
        
        // 18 decimals cus WEI
        // What is reverting?
        // undo any action before and send remaining gas
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }


     function withdraw() public onlyOwner {

         for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
             address funder = funders[funderIndex];
             addressToAmountFunded[funder] = 0;
         }
        // reset the array
        funders = new address[](0);
        // actually withdraw the funds

        //transfer
            // msg.sender = address
            // payable(msg.sender) = payable address
        //payable(msg.sender).transfer(address(this).balance);
        
        //send
        //bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //require(sendSuccess, "Send failed");

        //call === IS THE BEST . this IS HOW WE SEND CRYPTO
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
        revert();
     }

     modifier onlyOwner {
        // require(msg.sender == i_owner, "Sender is not owner. Wopz");
        
        // more efficient (After 0.8.4)
        if(msg.sender != i_owner){
            revert NotOwner();
        }
        _; // doing the rest of the code
     }

}