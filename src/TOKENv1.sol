// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract TOKENv1 is Initializable, ERC20Upgradeable, ERC20BurnableUpgradeable, ERC20PermitUpgradeable, OwnableUpgradeable, UUPSUpgradeable {
    error UpgradeRequestFailure();

    uint256 public nextUpgradeTime;
    address public nextImplementation;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) initializer public {
        __ERC20_init("Token", "TOKEN");
        __ERC20Burnable_init();
        __ERC20Permit_init("Token");
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();

        nextUpgradeTime = type(uint256).max;
    }

    function requestUpgrade(address _impl) external onlyOwner {
        nextUpgradeTime = block.timestamp + 8 days;
        nextImplementation = _impl;
    }

    function _authorizeUpgrade(address _impl) internal override onlyOwner {
        if (nextImplementation != _impl || nextUpgradeTime < block.timestamp) {
            revert UpgradeRequestFailure();
        }
        nextUpgradeTime = type(uint256).max;
    }

    uint256[50] private __gap;
}
