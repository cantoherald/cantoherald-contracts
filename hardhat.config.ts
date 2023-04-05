import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';
import 'hardhat-deploy';

const config: HardhatUserConfig = {
  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
  networks: {
    ['canto-testnet']: {
      live: true,
      url: 'https://canto-testnet.plexnode.wtf',
      chainId: 7701,
      accounts: [`0x${process.env.CANTO_TESTNET_PRIVATE_KEY}`],
      tags: ['staging'],
    },
  },
  solidity: '0.8.18',
};

export default config;
