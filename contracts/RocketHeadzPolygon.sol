// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@maticnetwork/fx-portal/contracts/tunnel/FxBaseChildTunnel.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./ERC721A.sol";

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
        (
            address fromAddress,
            address to,
            uint256 startTokenId,
            uint256 quantity
        ) = abi.decode(message, (address, address, uint256, uint256));
        if (fromAddress == address(0)) {
            _mint(to, quantity, "0x", true);
        } else {
            _transfer(fromAddress, to, startTokenId);
        }
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
