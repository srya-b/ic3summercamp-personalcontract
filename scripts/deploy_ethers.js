// Right click on the script name and hit "Run" to execute
(async () => {
    try {
        console.log('Running deployWithEthers script...')
    
        const contractName = 'PersonalContract' // Change this for other contract
        const constructorArgs = ["Surya"]    // Put constructor args (if any) here for your contract

        const proxyaddr = "0x8601eBB745ADA594E3361D30F605ECF5A0668141";
        const calldata = "0x9fc385ec0000000000000000000000000000000000000000000000000000000000000003";
        

        // Note that the script needs the ABI which is generated from the compilation artifact.
        // Make sure contract is compiled and artifacts are generated
        const artifactsPath = `browser/contracts/artifacts/${contractName}.json` // Change this for different path
    
        const metadata = JSON.parse(await remix.call('fileManager', 'getFile', artifactsPath))
        // 'web3Provider' is a remix global variable object
        let web3 = new ethers.providers.Web3Provider(web3Provider);
        //const signer = (new ethers.providers.Web3Provider(web3Provider)).getSigner()
        const signer = web3.getSigner();
    
    
        const tx = {
            "to": proxyaddr,
            "data": calldata,
            "value": 0,
        }

        signer.sendTransaction( tx );
        // let factory = new ethers.ContractFactory(metadata.abi, metadata.data.bytecode.object, signer);
    
        // let contract = await factory.deploy(...constructorArgs);
    
        // console.log('Contract Address: ', contract.address);
    
        // // The contract is NOT deployed yet; we must wait until it is mined
        // await contract.deployed()
        // console.log('Deployment successful.')
        
        web3.eth.sendTransaction(tx);
    } catch (e) {
        console.log(e.message)
    }
})()
