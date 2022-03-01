import { expect } from "chai";
import { utils } from "ethers";
import { solidityKeccak256 } from "ethers/lib/utils";
import { ethers } from "hardhat";
import keccak256 from "keccak256";
import MerkleTree from "merkletreejs";

function encodeLeaf(addr: string, spots: number) {
  return ethers.utils.defaultAbiCoder.encode(
    ["address", "uint64"],
    [addr, spots]
  );
}

describe("Merkle Root Creating and Verification", function () {
  it("Merkle root is created and is used to verify correctly", async function () {
    const [owner, addr1, addr2, addr3, addr4, addr5] =
      await ethers.getSigners();

    const elements = [
      encodeLeaf(owner.address, 2),
      encodeLeaf(addr1.address, 2),
      encodeLeaf(addr2.address, 2),
      encodeLeaf(addr3.address, 2),
      encodeLeaf(addr4.address, 2),
      encodeLeaf(addr5.address, 2),
    ];

    const merkleTree = new MerkleTree(elements, keccak256, {
      hashLeaves: true,
      sortPairs: true,
    });

    const root = merkleTree.getHexRoot();

    const leaf = keccak256(elements[0]);

    const proof = merkleTree.getHexProof(leaf);

    console.log(proof);

    const RocketHeadz = await ethers.getContractFactory("RocketHeadz");
    const rocketHeadz = await RocketHeadz.deploy("", root);
    await rocketHeadz.deployed();

    let tx = await rocketHeadz.flipWhitelistSaleState();

    await tx.wait();
    tx = await rocketHeadz.whitelistMint(proof, 2, 2, "0x", {
      value: utils.parseEther("0.16"),
    });
    await tx.wait();
    expect(await rocketHeadz.numberMinted(owner.address)).to.equal(2);
  });
});
