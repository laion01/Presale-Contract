const { expect } = require("chai");
const { ethers } = require("hardhat");
const hre = require("hardhat");
const util = require('util')

const timer = util.promisify(setTimeout);

var owner_addr = "";
var addr_1 = "";
var addr_2 = "";
var token_addr1 = "";
var token_addr2 = "";
var token_addr3 = "";
var token_addr4 = "";
var vesting_addr = "";

var xSeed = null, dragon = null, bFootball = null, ski = null;
var tokenVesting = null;

var xseed_account;
describe("Deploy Token and Contract", function () {
  it("Token Deploy : Owner's balance should be zero.", async function () {
    // const [owner, addr1, addr2] = await ethers.getSigners();
    // owner_addr = owner.address;
    // xseed_account = addr1;
    // addr_1 = addr1.address;
    // addr_2 = addr2.address;

    // const XSeedToken = await hre.ethers.getContractFactory("MetaXSeed_ERC20");
    // xSeed = await XSeedToken.deploy("MetaXSeed", "$XSEED", "200000000000000000000000000", addr_1);
    // await xSeed.deployed();
    // token_addr1 = xSeed.address;

    
    // expect(await xSeed.balanceOf(owner_addr)).to.equal("0");
    
  });
});
