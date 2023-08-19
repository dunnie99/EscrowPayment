// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Escrow {
    address public buyer;
    address public seller;
    address public arbiter;
    uint256 public amount;
    bool public agreementFulfilled;
    bool public fundsDisbursed;
    bool public isCompleted;
    

    constructor() {
        arbiter = msg.sender;
    }

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only the buyer can call this function");
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller, "Only the seller can call this function");
        _;
    }

    modifier onlyArbiter() {
        require(msg.sender == seller, "Only the seller can call this function");
        _;
    }

    modifier onlyArbiterOrBuyer() {
        require(msg.sender == arbiter || msg.sender == buyer, "Only the arbiter or Buyer can call this function");
        _;
    }

    modifier escrowNotCompleted() {
        require(!isCompleted, "Escrow has already been completed");
        _;
    }

    modifier agreementCompleted() {
        require(agreementFulfilled, "Agreement has already been fulfilled");
        _;
    }

    modifier agreementNotCompleted() {
        require(!agreementFulfilled, "Agreement has already been fulfilled");
        _;
    }

    function init(address _seller, address _buyer) public onlyArbiter{
        buyer = _buyer;
        seller = _seller;
    }


    function fulfilled() onlyArbiterOrBuyer public {
        agreementFulfilled = true;
    }

    function releaseFunds() external agreementCompleted escrowNotCompleted {
        require(!fundsDisbursed, "Funds have already been disbursed");
        fundsDisbursed = true;
        isCompleted = true;
        payable(seller).transfer(amount);
    }

    function refundBuyer() external agreementNotCompleted escrowNotCompleted onlyArbiterOrBuyer {
        require(!fundsDisbursed, "Funds have already been disbursed");
        fundsDisbursed = true;
        payable(buyer).transfer(amount);
    }

    function arbitrateRefund() external onlyArbiter agreementNotCompleted escrowNotCompleted  {
        require(!fundsDisbursed, "Funds have already been disbursed");
        isCompleted = true;
        fundsDisbursed = true;
        payable(buyer).transfer(amount);
    }


    receive() external payable {
        require(msg.sender == buyer, "Only the buyer can send funds");
        require(msg.value > 0, "Funds must be greater than zero");
        amount += msg.value;
    }









}