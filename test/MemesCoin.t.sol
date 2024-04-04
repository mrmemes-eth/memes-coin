// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {MemesCoin} from "../src/MemesCoin.sol";
import {IOwnableInternal} from "lib/solidstate-solidity/contracts/access/ownable/IOwnableInternal.sol";

contract MemesCoinTest is Test {
    MemesCoin public memesCoin;

    function setUp() public {
        vm.startPrank(address(1));
        memesCoin = new MemesCoin();
        vm.stopPrank();
    }

    function test_InitalState() public view {
        assertEq(memesCoin.name(), "MemesCoin");
        assertEq(memesCoin.symbol(), "$EMEM");
        assertEq(memesCoin.owner(), address(1));
        assertEq(memesCoin.mintingAllowedAfter(), block.timestamp + 365 days);
        assertEq(memesCoin.totalSupply(), 100_000_000 ether);
    }

    function test_NonOwnerCannotMint() public {
        vm.expectRevert(IOwnableInternal.Ownable__NotOwner.selector);
        memesCoin.mint(address(this), 100 ether);
    }

    function test_SubsequentMintFails() public {
        vm.prank(address(1));
        vm.expectRevert(MemesCoin.MintingDateNotReached.selector);
        memesCoin.mint(address(this), 100 ether);
    }

    function test_MintAfterYear() public {
        vm.warp(block.timestamp + 365 days);
        vm.prank(address(1));
        memesCoin.mint(address(1), 100 ether);
        assertEq(memesCoin.totalSupply(), 100_000_100 ether);
        assertEq(memesCoin.balanceOf(address(1)), 100_000_100 ether);
        assertEq(memesCoin.mintingAllowedAfter(), block.timestamp + 365 days);
    }

    function test_OverMintingCapFails() public {
        vm.warp(block.timestamp + 365 days);
        vm.prank(address(1));
        vm.expectRevert(MemesCoin.MintingCapExceeded.selector);
        memesCoin.mint(address(1), 100_000_001 ether);
    }

    function test_SupplyCapExceededFails() public {
        // first year's minting is already done
        assertEq(memesCoin.totalSupply(), 100_000_000 ether);

        // mint the full supply over the next 99 years
        for (uint256 i = 0; i < 99; i++) {
            vm.warp(block.timestamp + 365 days);
            vm.prank(address(1));
            memesCoin.mint(address(1), 100_000_000 ether);
        }

        // 10 billion total supply minted
        assertEq(memesCoin.totalSupply(), 10_000_000_000 ether);

        // attempt to mint one wei more after a year
        vm.warp(block.timestamp + 365 days);
        vm.prank(address(1));
        vm.expectRevert(MemesCoin.SupplyCapExceeded.selector);
        memesCoin.mint(address(1), 1);
    }

    function test_Burn() public {
        vm.prank(address(1));
        memesCoin.burn(address(1), 1 ether);
        assertEq(memesCoin.totalSupply(), 99_999_999 ether);
        assertEq(memesCoin.balanceOf(address(1)), 99_999_999 ether);
    }

    function test_OnlyOwnerCanBurn() public {
        vm.expectRevert(IOwnableInternal.Ownable__NotOwner.selector);
        memesCoin.burn(address(1), 1 ether);
    }
}
