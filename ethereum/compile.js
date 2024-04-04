const path = require('path');
const fs = require('fs');
const solc = require('solc');

// Read the Solidity source file
const contractPath = path.resolve(__dirname, 'Main.sol');
const source = fs.readFileSync(contractPath, 'utf8');

const input = {
    language: 'Solidity',
    sources: {
        'Main.sol': {
            content: source,
        },
    },
    settings: {
        outputSelection: {
            '*': {
                '*': ['*'],
            },
        },
    },
};

const output = JSON.parse(solc.compile(JSON.stringify(input)));

// Output errors, if any
if (output.errors) {
    output.errors.forEach(err => {
        console.error(err.formattedMessage);
    });
    process.exit(1);
}

// Write compiled contracts to the 'build' directory
const buildPath = path.resolve(__dirname, 'build');
fs.mkdirSync(buildPath, { recursive: true }); // Create directory recursively

for (let contractName in output.contracts['Main.sol']) {
    const contractData = output.contracts['Main.sol'][contractName];
    fs.writeFileSync(
        path.resolve(buildPath, contractName + '.json'),
        JSON.stringify(contractData, null, 4)
    );
    console.log(`Contract ${contractName} compiled and saved!`);
}
