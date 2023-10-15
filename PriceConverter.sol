// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter{
    
    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
                (,int price,,,) = priceFeed.latestRoundData();
                // RTH in terms of USD
                // 3000.00000000
        return uint256(price * 1e10); // converting to 18 decimals like we have msg.value
    }

    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 price = getPrice();
        uint256 ethAmountInUsd = (price * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}