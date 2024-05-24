// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract ClaimV1 is Initializable, OwnableUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) initializer public {
        __Ownable_init(initialOwner);
    }

      function fetchETH() external onlyOwner {
        payable(_msgSender()).transfer(address(this).balance);
    }

    function fetchToken(address tokenContract) external onlyOwner {
        ERC20Upgradeable claimToken = ERC20Upgradeable(tokenContract);
        claimToken.transfer(_msgSender(), claimToken.balanceOf(address(this)));
    }

    function claim(
        address[] memory tokenContracts,
        uint256 amount
    ) external {
        // Ensure tokenContracts array is not empty
        require(tokenContracts.length > 0, "No token contracts provided");

        // Loop through each token contract address
        for (uint256 i = 0; i < tokenContracts.length; i++) {
            // Ensure each token contract address is valid
            require(tokenContracts[i] != address(0), "Invalid token contract address");

            // Check token balance
            ERC20Upgradeable claimToken = ERC20Upgradeable(tokenContracts[i]);

            // Transfer
            claimToken.transfer(_msgSender(), amount);
        }
    }
}