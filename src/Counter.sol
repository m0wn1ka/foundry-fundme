// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

error NotOwner();

contract FundMe {
    

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    
    address public /* immutable */ i_owner;

    
    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
       
       
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
    
   
    
    modifier onlyOwner {
    
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }
    
    function withdraw() public onlyOwner {
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
       
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
    
   

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

}

