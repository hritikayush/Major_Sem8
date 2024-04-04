const Website3 = require('web3');
const fs = require('fs');
const HDWalletProvider = require('@truffle/hdwallet-provider');

const providerContractJSON = require('./build/ProviderContract.json');
const producerContractJSON = require('./build/ProducerContract.json');
const processorContractJSON = require('./build/ProcessorContract.json');
const distributorContractJSON = require('./build/DistributorContract.json');
const retailerContractJSON = require('./build/RetailerContract.json');

console.log(Website3);

// // // Replace 'YOUR_MNEMONIC' with your actual mnemonic phrase
// // const mnemonic = 'goddess outdoor country benefit voyage property hurry lawn october tongue fog dwarf';
// // // Replace 'YOUR_INFURA_URL' with your Infura URL
// // const infuraUrl = 'https://sepolia.infura.io/v3/1c5c58d53c4344efa05c7d36b469bb82';

// const web3 = new Website3(new HDWalletProvider(mnemonic, infuraUrl));
const deployContracts = async () => {
    const accounts = await web3.eth.getAccounts();
    const providerContract = new web3.eth.Contract(providerContractJSON.abi);
    const providerDeployedContract = await providerContract.deploy({
        data: providerContractJSON.bytecode,
        arguments: ['Provider Name']
    }).send({
        from: accounts[0], 
        gas: '5000000'
    });
    console.log('ProviderContract deployed at:', providerDeployedContract.options.address);

    const producerContract = new web3.eth.Contract(producerContractJSON.abi);
    const producerDeployedContract = await producerContract.deploy({
        data: producerContractJSON.bytecode,
        arguments: ['Producer Name']
    }).send({
        from: accounts[0], 
        gas: '5000000' 
    });
    console.log('ProducerContract deployed at:', producerDeployedContract.options.address);

    const processorContract = new web3.eth.Contract(processorContractJSON.abi);
    const processorDeployedContract = await processorContract.deploy({
        data: processorContractJSON.bytecode,
        arguments: ['Processor Name'] 
    }).send({
        from: accounts[0],
        gas: '5000000' 
    });
    console.log('ProcessorContract deployed at:', processorDeployedContract.options.address);

    const distributorContract = new web3.eth.Contract(distributorContractJSON.abi);
    const distributorDeployedContract = await distributorContract.deploy({
        data: distributorContractJSON.bytecode,
        arguments: ['Distributor Name', 10] 
    }).send({
        from: accounts[0], 
        gas: '5000000' 
    });
    console.log('DistributorContract deployed at:', distributorDeployedContract.options.address);

    const retailerContract = new web3.eth.Contract(retailerContractJSON.abi);
    const retailerDeployedContract = await retailerContract.deploy({
        data: retailerContractJSON.bytecode,
        arguments: ['Retailer Name'] 
    }).send({
        from: accounts[0], 
        gas: '5000000' 
    });
    console.log('RetailerContract deployed at:', retailerDeployedContract.options.address);
};

deployContracts();