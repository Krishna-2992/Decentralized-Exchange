const hre = require('hardhat')
const {verify} = require('../utils/verify.ts')
const {PoolFactory} = require('../typechain-types')

const main = async () => {
    const poolFactory: typeof PoolFactory = await hre.ethers.deployContract(
        'PoolFactory'
    )
    await poolFactory.waitForDeployment();
    console.log(
        `✅ PoolFactory contract deployed at address ${poolFactory.target}`
    )
    // verifying...
    // if(hre.network.name != 'hardhat'){
    //     console.log(
    //         `Hold on tight...Verifying the PoolFactory contract`
    //     )
    //     await verify(poolFactory.target, [])
    // }
}

main().catch((err) => {
    console.log(err)
    process.exit(1)
})