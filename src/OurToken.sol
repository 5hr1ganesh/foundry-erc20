// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("OurToken", "OT") {
        _mint(msg.sender, initialSupply);
    }

    // Public mint function for testing purposes
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    // Public burn function for testing purposes
    function burn(address from, uint256 amount) public {
        _burn(from, amount);
    }
}

/*
In a standard ERC20 contract, 
the approve function allows a token owner 
to authorize a spender to transfer tokens 
from their account up to a specified limit. 
However, this can lead to a race condition 
if the spender tries to transfer tokens 
while the owner is simultaneously changing the approval amount. 
This could result in unexpected or unsafe token transfers.*/
//     using SafeERC20 for IERC20;

// IERC20 token = IERC20(addressOfToken);
// token.safeTransfer(recipient, amount);
// token.safeApprove(spender, amount);
// token.safeTransferFrom(sender, recipient, amount);
