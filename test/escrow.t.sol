// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Escrow.sol";

contract CounterTest is Test {
    Escrow public crow;

    function setUp() public {
        vm.prank(Bob);
        crow = new Escrow();
        
    }

    address Bob = vm.addr(0x1);
    address Alice = vm.addr(0x2);
    address Tj = vm.addr(0x3);


    function testInit() public {
        vm.prank(Bob);
        crow.init(Alice, Tj, 20);
    }

    function testETHTransfer () public {
        vm.deal(Tj, 100 ether);
        vm.startPrank(Tj);
        crow.contractFund();



    }
}