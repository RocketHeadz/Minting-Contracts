// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@maticnetwork/fx-portal/contracts/tunnel/FxBaseChildTunnel.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "erc721a/contracts/ERC721A.sol";

contract RocketHeadzPolygon is ERC721A, FxBaseChildTunnel, Pausable, Ownable {
    constructor(address _fxChild)
        ERC721A("RocketHeadz Polygon", "RKHTHDZ-POLY")
        FxBaseChildTunnel(_fxChild)
    {}

    function _processMessageFromRoot(
        uint256,
        address sender,
        bytes memory message
    ) internal override validateSender(sender) {
        // decode incoming data
        (, address to, , uint256 quantity) = abi.decode(
            message,
            (address, address, uint256, uint256)
        );
        _mint(to, quantity, "0x", true);
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address,
        address,
        uint256
    ) public pure override {
        revert("DISABLED");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address,
        address,
        uint256
    ) public pure override {
        revert("DISABLED");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address,
        address,
        uint256,
        bytes memory
    ) public pure override {
        revert("DISABLED");
    }
}
