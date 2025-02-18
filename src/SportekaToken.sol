// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SportekaToken is ERC20 {
    constructor(uint initialSupply) ERC20("SportekaToken", "SPRTK") {
        _mint(msg.sender, initialSupply);
}
}