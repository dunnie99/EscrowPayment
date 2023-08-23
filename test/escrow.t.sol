// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Escrow.sol";

contract CounterTest is Test {
    Escrow public payment;

    function setUp() public {
        payment = new Escrow();
        
    }
}