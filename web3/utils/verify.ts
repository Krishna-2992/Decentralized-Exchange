import {run} from 'hardhat'

export const verify = async (contractAddress: string, args: any) => {
    try {
        await run("verify:verify", {
            address: contractAddress, 
            constructorArguments: args
        })
    } catch(e: any) {
        if(e.message.toLowerCase().includes("already verified"))
            console.log("Smart contract already verified!!")
        else
            console.log('💥💥 => ', e)
    }
}
