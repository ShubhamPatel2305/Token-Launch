// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC20 {
    function transfer() external returns(bool);
    function balanceOf() external view returns(uint256);
    function allowance() external view returns(uint256);
    function approve() external view returns(bool);
    function transferFrom() external view returns(bool);
    //symbol
    function symbol() external view returns(string memory);
    //total supply
    function totalSupply() external view returns(uint256);
    //name
    function name() external view returns(string memory);
    
}