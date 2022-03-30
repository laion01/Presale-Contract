require("@nomiclabs/hardhat-waffle");
require('@nomiclabs/hardhat-ethers');
require("@nomiclabs/hardhat-etherscan");
const { mnemonic } = require('./secrets.json');

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545"
    },
    hardhat: {
    },
    bsctestnet: {
      url: "https://speedy-nodes-nyc.moralis.io/48589f1197db92bd84b05d0b/bsc/testnet",
      chainId: 97,
      // gasPrice: 20000000000,
      accounts: {mnemonic: mnemonic}
    },
    bscmainnet: {
      url: "https://bsc-dataseed.binance.org/",
      chainId: 56,
      gasPrice: 20000000000,
      accounts: {mnemonic: mnemonic}
    },
    ethmainnet: {
      url: "https://mainnet.infura.io/v3/aedc2f89691644c5ad87877903d280b8",
      accounts: {mnemonic: mnemonic},
    },
    polygonmainnet: {
      url: `https://rpc-mainnet.maticvigil.com/`,
      accounts: {mnemonic: mnemonic},
    },
    polygontestnet: {
      url: `https://rpc-mumbai.maticvigil.com/`,
      accounts: {mnemonic: mnemonic},
    },
    avalancheTestnet: {
      url: 'https://api.avax-test.network/ext/bc/C/rpc',
      gasPrice: 225000000000,
      //gas: 10000000,
      chainId: 43113,
      accounts: {mnemonic: mnemonic},
    },
    avalancheMainnet: {
      url: 'https://api.avax.network/ext/bc/C/rpc',
      gasPrice: 225000000000,
      chainId: 43114,
      accounts: {mnemonic: mnemonic},
    }
  },
  solidity: {
  version: "0.8.10",
  settings: {
    optimizer: {
      enabled: true
    }
   }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 20000
  },
  etherscan: {
    apiKey: "NFXES6PDMHSHKXWBBVIXB5BYICPT5UNB9D"
  }
};