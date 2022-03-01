pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

// ______           _        _   _   _                _
// | ___ \         | |      | | | | | |              | |
// | |_/ /___   ___| | _____| |_| |_| | ___  __ _  __| |____
// |    // _ \ / __| |/ / _ \ __|  _  |/ _ \/ _` |/ _` |_  /
// | |\ \ (_) | (__|   <  __/ |_| | | |  __/ (_| | (_| |/ /
// \_| \_\___/ \___|_|\_\___|\__\_| |_/\___|\__,_|\__,_/___|

contract RocketHeadz is ERC721A, Ownable, Pausable {
    using Strings for uint256;

    /**** CONSTANTS ****/
    uint256 public constant MINT_PRICE = 0.08 ether;
    uint128 public constant MAX_MINTS_PER_TX = 10;
    uint128 public constant MAX_ROCKETHEADZ = 11111;
    address public constant TREASURY_WALLET =
        0x01573Df433484fCBe6325a0c6E051Dc62Ab107D1;
    address public constant T1 = 0x01573Df433484fCBe6325a0c6E051Dc62Ab107D1;
    address public constant T2 = 0x01573Df433484fCBe6325a0c6E051Dc62Ab107D1;
    address public constant T3 = 0x01573Df433484fCBe6325a0c6E051Dc62Ab107D1;
    address public constant T4 = 0x01573Df433484fCBe6325a0c6E051Dc62Ab107D1;
    address public constant T5 = 0x01573Df433484fCBe6325a0c6E051Dc62Ab107D1;
    address public constant T6 = 0x01573Df433484fCBe6325a0c6E051Dc62Ab107D1;

    string public baseURI;
    uint256 public reserved = 10;

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
    ) public payable whenNotPaused {
        require(quantity <= MAX_MINTS_PER_TX, "MAX_MINT_PER_TX_EXCEDDED");
        require(
            msg.value >= MINT_PRICE * quantity,
            "INSUFFICIENT_ETH_FOR_MINT"
        );
        uint256 supply = totalSupply();
        require(
            supply + quantity < MAX_ROCKETHEADZ - reserved,
            "MAX_SUPPLY_EXCEEDED"
        );
        _mint(to, quantity, _data, safe);
    }

    /**
     *  giveAway is used by the team to give away some NFT's to our community
     */
    function giveAway(
        address to,
        uint256 quantity,
        bytes memory _data,
        bool safe
    ) public onlyOwner {
        require(quantity <= reserved, "MAX_LIMIT_RESERVED_EXCEDDED");
        _mint(to, quantity, _data, safe);
        reserved -= quantity;
    }

    /**
     *  withdrawAll is used to whitdraw ether to appropriate addresses
     */
    function withdrawAll() public onlyOwner {
        uint256 halfBalance = address(this).balance / 2;
        (bool sent, ) = TREASURY_WALLET.call{value: halfBalance}("");
        require(sent, "Failed_ETHER_TRANSFER_TREASURY");
        uint256 balanceT1 = (halfBalance * 5) / 100;
        (sent, ) = TREASURY_WALLET.call{value: balanceT1}("");
        require(sent, "FAILED_ETH_TRANSFER_T1");
        uint256 balanceT2 = (halfBalance * 10) / 100;
        (sent, ) = TREASURY_WALLET.call{value: balanceT2}("");
        require(sent, "FAILED_ETH_TRANSFER_T2");
        uint256 balanceT3 = (halfBalance * 15) / 100;
        (sent, ) = TREASURY_WALLET.call{value: balanceT3}("");
        require(sent, "Failed_ETHER_TRANSFER_TREASURY");
        uint256 balanceT4 = (halfBalance * 5) / 100;
        (sent, ) = TREASURY_WALLET.call{value: balanceT4}("");
        require(sent, "Failed_ETHER_TRANSFER_TREASURY");
        uint256 balanceT5 = (halfBalance * 5) / 100;
        (sent, ) = TREASURY_WALLET.call{value: balanceT5}("");
        require(sent, "Failed_ETHER_TRANSFER_TREASURY");
        uint256 balanceT6 = (halfBalance * 5) / 100;
        (sent, ) = TREASURY_WALLET.call{value: balanceT6}("");
        require(sent, "Failed_ETHER_TRANSFER_TREASURY");
    }

    fallback() external payable {}

    receive() external payable {}
}
