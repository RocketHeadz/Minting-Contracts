import { ethers } from "hardhat";
import list from "../constants/whitelist.json";
import keccak256 from "keccak256";
import MerkleTree from "merkletreejs";

async function main() {
  let whitelistList = list.map((value) => {
    encodeLeaf(value.address, value.numWhitelist);
  });
  const merkleTree = new MerkleTree(whitelistList, keccak256, {
    hashLeaves: true,
    sortPairs: true,
  });

  const root = merkleTree.getHexRoot();
  console.log("Merkle root:", root);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

function encodeLeaf(addr: string, spots: number) {
  return ethers.utils.defaultAbiCoder.encode(
    ["address", "uint64"],
    [addr, spots]
  );
}
