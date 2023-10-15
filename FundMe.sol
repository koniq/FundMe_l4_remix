// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

// gas cost for deploying contract
// no improvements       599197 cost
// after using constant  579649
// after using immutable 556190

error NotOwner();

contract FundMe{
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;
    // reading non-const 23400
    // reading const     21600
    address[] funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;
    // mutable   23400 gas
    // immutable 20900 gas

    // called when contract is being created
    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable {

        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough"); //18 decimals
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        
        for(uint256 i; i < funders.length; i++){
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        } 
        
        funders = new address[](0);
        // sending :
        // transfer throws exception
        // msg.sender = address
        // payable(msg.sender) = payable address
        // sending is automatically reverted when fails
        payable(msg.sender).transfer(address(this).balance);

        // send returns boolean, transaction will has to be reverted manually by using require
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // // call - low level, does not revert automatically
        // (bool callSuccess, ) = payable(msg.sender).call{value:address(this).balance}("");
        // require(callSuccess, "Call failed");
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    modifier onlyOwner{
        //require(msg.sender == i_owner, "Sender is not owner");
        if(msg.sender != i_owner) { revert NotOwner();}
        _;
    }
}