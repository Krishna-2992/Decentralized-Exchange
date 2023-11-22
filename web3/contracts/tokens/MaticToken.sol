// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MaticToken is ERC20 {

    constructor(uint _initialSupply) ERC20("Polygon Matic", "MATIC") {
        _mint(msg.sender, _initialSupply);
    }
    
}