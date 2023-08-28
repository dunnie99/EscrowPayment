// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Escrow {
    address public buyer;
    address public seller;
    address public arbiter;
    uint256 public payment;
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
        require(msg.sender == arbiter, "Only the arbiter can call this function");
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

    function init(address _seller, address _buyer, uint256 _payment) public onlyArbiter{
        buyer = _buyer;
        seller = _seller;
        payment = _payment;
        
    }

    function contractFund() payable external {
        require(msg.value >= payment, "Invalid amount");

    }


    function fulfilled() onlyBuyer public {
        agreementFulfilled = true;
    }

    function releaseFunds() external agreementCompleted escrowNotCompleted {
        require(!fundsDisbursed, "Funds have already been disbursed");
        fundsDisbursed = true;
        isCompleted = true;
        payable(seller).transfer(payment);
    }

    function refundBuyer() external agreementNotCompleted escrowNotCompleted onlyArbiterOrBuyer {
        require(!fundsDisbursed, "Funds have already been disbursed");
        fundsDisbursed = true;
        payable(buyer).transfer(payment);
    }

    function arbitrateRefund() external onlyArbiter agreementNotCompleted escrowNotCompleted  {
        require(!fundsDisbursed, "Funds have already been disbursed");
        isCompleted = true;
        fundsDisbursed = true;
        payable(buyer).transfer(payment);
    }

    function withdrawal() public onlyArbiter {
        uint256 bal = amount - payment;
        payable(arbiter).transfer(bal);
    }


    receive() external payable {
        amount += msg.value;
    }






}