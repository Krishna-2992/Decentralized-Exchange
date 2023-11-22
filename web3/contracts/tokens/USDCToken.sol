// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract USDCToken is ERC20 {

    constructor(uint _initialSupply) ERC20("USDC", "USDC") {
        _mint(msg.sender, _initialSupply);
    }
    
}