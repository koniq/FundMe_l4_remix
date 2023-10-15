// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract FallbackExmaple {

    uint256 public result;

    // executed when creating transaction to the contract with no calldata
    receive() external payable {
        result = 1;
    }

    // executed when creating transaction on contract with calldata
    fallback() external payable {
        result = 2;
    }

    // Ether is send to contract
    //      is msg.data empty?
    //          /   \
    // receive()?    fallback()
    //   /      \ 
    // yes      no
    //  /         \ 
    //receive()    fallback()
    
}