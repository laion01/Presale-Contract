// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  const Crinet = await hre.ethers.getContractFactory("Crinet");
  const crinetContract = await Crinet.deploy();
  await crinetContract.deployed();
  console.log("Crinet Token : ", crinetContract.address);

  const CNTPresale = await hre.ethers.getContractFactory("CNTPresale");
  const contract = await CNTPresale.deploy(crinetContract.address, "0x78867bbeef44f2326bf8ddd1941a4439382ef2a7", "0xF62F51CE6191c17380A64d49C58D1206Cd091410");
  await contract.deployed();

  await contract.Initialize();
  await contract.startICO();
  
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
