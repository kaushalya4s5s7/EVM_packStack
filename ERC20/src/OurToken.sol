//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20{
constructor(uint256 initial) ERC20("OurToken","KC"){
    _mint(msg.sender, initial);
}
}