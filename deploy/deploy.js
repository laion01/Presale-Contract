// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');
  const [owner ] = await ethers.getSigners()
  const Crinet = await hre.ethers.getContractFactory("Crinet");
  const crinetContract = await Crinet.deploy();
  await crinetContract.deployed();
  console.log("Crinet Token : ", crinetContract.address);

  const CNTPresale = await hre.ethers.getContractFactory("CNTPresale");
  const contract = await CNTPresale.deploy("0x17d0b69a947Db94c825c07216905103dca2Dc732", "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56", "0x0521b960Ee5fc3C40C5Af18fDE4A79752dEd5142");
  await contract.deployed();

  console.log(await owner.getTransactionCount());
  await contract.Initialize();
  await contract.startICO();
  console.log(await owner.getTransactionCount());
  console.log("Crinet Presale : ", contract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
