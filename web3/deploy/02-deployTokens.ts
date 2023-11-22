import { DAIToken, MaticToken, ShibaInuToken, USDCToken, WETHToken } from "../typechain-types"
// import fs from 'fs'

const hre = require('hardhat')
const {verify} = require('../utils/verify')


const main = async () => {

    const initialMintValue: BigInt = hre.ethers.parseUnits('10000000', 18)
    console.log(initialMintValue)

    const daiToken: DAIToken = await hre.ethers.deployContract('DAIToken', [initialMintValue])
    const maticToken: MaticToken = await hre.ethers.deployContract('MaticToken', [initialMintValue])
    const shibaInuToken: ShibaInuToken = await hre.ethers.deployContract('ShibaInuToken', [initialMintValue])
    const usdcToken: USDCToken = await hre.ethers.deployContract('USDCToken', [initialMintValue])
    const wethToken: WETHToken = await hre.ethers.deployContract('WETHToken', [initialMintValue])
    
    await daiToken.waitForDeployment();
    await maticToken.waitForDeployment();
    await shibaInuToken.waitForDeployment();
    await usdcToken.waitForDeployment();
    await wethToken.waitForDeployment();

    console.log(`✅ DaiToken contract deployed at address ${daiToken.target}`)
    console.log(`✅ MaticToken contract deployed at address ${maticToken.target}`)
    console.log(`✅ ShibaInuToken contract deployed at address ${shibaInuToken.target}`)
    console.log(`✅ USDCToken contract deployed at address ${usdcToken.target}`)
    console.log(`✅ WETHToken contract deployed at address ${wethToken.target}`)

    // verifying...
    // if(hre.network.name != 'hardhat'){
    //     console.log(
    //         `Hold on tight...Verifying the contracts`
    //     )
        // await verify(daiToken.target, [])
        // await verify(maticToken.target, [])
        // await verify(shibaInuToken.target, [])
        // await verify(usdcToken.target, [])
        // await verify(wethToken.target, [])

    //     console.log(`✅ Token contracts verified!!`)
    // }

    // creating and writing the addresses in a .json file
    {
        
        // const tokenAddresses = {
        //     daiToken: daiToken, 
        //     maticToken: maticToken, 
        //     shibaInuToken: shibaInuToken, 
        //     usdcToken: usdcToken, 
        //     wethToken: wethToken
        // }
    
        // const tokenAddressString = JSON.stringify(tokenAddresses)
    
        // fs.writeFile('constants.json', tokenAddressString, (err) => {
        //     if (err) {
        //       console.error('Error writing file:', err);
        //       return;
        //     }
          
        //     console.log('File created and written successfully!');
        //   });
    }
}

main().catch((err) => {
    console.log(err)
    process.exit(1)
})