// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DAIToken is ERC20 {

    constructor(uint _initialSupply) ERC20("Makers DAI Token", "DAI") {
        _mint(msg.sender, _initialSupply);
    }
    
}