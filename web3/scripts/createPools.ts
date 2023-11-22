import hre from 'hardhat'
import { PoolFactory, PoolFactory__factory } from '../typechain-types'
import {poolFactoryAddress} from '../constants/poolFactoryAddress'
import tokens from "../constants/tokenAddresses"

require('dotenv').config()

const main = async () => {

    const rpcUrl = process.env.POLYGON_MUMBAI_URL ? process.env.POLYGON_MUMBAI_URL : ""
    const privateKey: string = process.env.PRIVATE_KEY ? process.env.PRIVATE_KEY : ""

    const provider = new hre.ethers.JsonRpcProvider(rpcUrl)
    const wallet = new hre.ethers.Wallet(privateKey)
    const signer = wallet.connect(provider)

    const poolFactory: PoolFactory = PoolFactory__factory.connect(poolFactoryAddress, signer)

    const pools = [
        {firstToken: tokens.daiTokenAddress, secondToken: tokens.maticTokenAddress, fee: 100},
        {firstToken: tokens.daiTokenAddress, secondToken: tokens.shibaInuTokenAddress, fee: 100}
    ]

    for(let pool of pools) {
        const tx = await poolFactory.createPool(
            pool.firstToken, 
            pool.secondToken, 
            pool.fee
        )
        await tx.wait()
        console.log("✅Pool ", pool, "created")
    }
    console.log('Pools created!!')
}

main().catch((err) => {
    console.log(err)
    process.exit(1)
})