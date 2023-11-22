// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETHToken is ERC20 {
    
    constructor(uint _initialSupply) ERC20("Wrapped Ether", "WETH") {
        _mint(msg.sender, _initialSupply);
    }
    
}