import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import { string } from "hardhat/internal/core/params/argumentTypes";
require('dotenv').config()

const POLYGON_MUMBAI_URL = process.env.POLYGON_MUMBAI_URL
const PRIVATE_KEY = process.env.PRIVATE_KEY
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY

const config: HardhatUserConfig = {
  solidity: "0.8.20",
  networks: {
    hardhat: {
      chainId: 31337
    }, 
    mumbai: {
      url: POLYGON_MUMBAI_URL ? POLYGON_MUMBAI_URL : "", 
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : []
    }
  }, 
  etherscan: {
    apiKey: {
      polygonMumbai: ETHERSCAN_API_KEY ? ETHERSCAN_API_KEY : ""
    }
  }
};

export default config;
