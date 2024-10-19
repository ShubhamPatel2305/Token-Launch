// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import openzepelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenIco is ERC20{
    constructor() ERC20("TokenIco","@PAPA"){
        _mint(msg.sender,1000000000000000000); //1 eth total supply
    }
}

