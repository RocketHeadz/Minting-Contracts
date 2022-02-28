pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// ______           _        _   _   _                _
// | ___ \         | |      | | | | | |              | |
// | |_/ /___   ___| | _____| |_| |_| | ___  __ _  __| |____
// |    // _ \ / __| |/ / _ \ __|  _  |/ _ \/ _` |/ _` |_  /
// | |\ \ (_) | (__|   <  __/ |_| | | |  __/ (_| | (_| |/ /
// \_| \_\___/ \___|_|\_\___|\__\_| |_/\___|\__,_|\__,_/___|

contract RocketHeadz is ERC721A, Ownable {
    using Strings for uint256;

    string public baseURI;

    /**** CONSTANTS ****/
    uint256 public constant MINT_PRICE = 0.08 ether;
    uint128 public constant MAX_MINTS_PER_TX = 10;
    uint128 public constant MAX_ROCKETHEADZ = 11111;

    constructor(string memory _baseURI) ERC721A("RocketHeadz", "RH") {
        baseURI = _baseURI;
    }

    /**
     * Returns the number of tokens minted by the owner
     */
    function numberMinted(address owner) public view returns (uint256) {
        return _numberMinted(owner);
    }

    /**
     * @dev
     * This implementation returns the tokenURI
     * based on the tokenId
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
        return
            bytes(baseURI).length != 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
                : "";
    }

    /**
     * @dev Mints `quantity` tokens and transfers them to `to`.
     */
    function mint(
        address to,
        uint256 quantity,
        bytes memory _data,
        bool safe
    ) public payable {
        require(quantity <= MAX_MINTS_PER_TX, "MAX_MINT_PER_TX_EXCEDDED");
        uint256 supply = totalSupply();
        require(supply + quantity <= MAX_ROCKETHEADZ, "MAX_SUPPLY_EXCEEDED");
        require(
            msg.value >= MINT_PRICE * quantity,
            "INSUFFICIENT_ETH_FOR_MINT"
        );
        _mint(to, quantity, _data, safe);
    }
}
