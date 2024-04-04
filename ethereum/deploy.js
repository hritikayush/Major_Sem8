const Website3 = require('web3');
const fs = require('fs');
const HDWalletProvider = require('@truffle/hdwallet-provider');

// Load the compiled contracts
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
const provider=new HDWalletProvider(
    'goddess outdoor country benefit voyage property hurry lawn october tongue fog dwarf',
    'https://sepolia.infura.io/v3/1c5c58d53c4344efa05c7d36b469bb82'
);
const web3=new Website3(provider);

const deployContracts = async () => {
    // Get the accounts
    const accounts = await web3.eth.getAccounts();

    // Deploy ProviderContract
    const providerContract = new web3.eth.Contract(providerContractJSON.abi);
    const providerDeployedContract = await providerContract.deploy({
        data: providerContractJSON.bytecode,
        arguments: ['Provider Name'] // Update with desired constructor arguments
    }).send({
        from: accounts[0],
        gas: '5000000'
    });
    console.log('ProviderContract deployed at:', providerDeployedContract.options.address);

    // Deploy other contracts similarly...

    // Stop the provider
    web3.currentProvider.engine.stop();
};

deployContracts();
