const { ethers } = require("ethers");

const provider = new ethers.JsonRpcProvider("https://data-seed-prebsc-1-s1.binance.org:8545");

const privateKey = "bf45a5d7d16f4da2c0638581f8ec8a162f3d4714564c5fab33b21e214e2261ad";
const wallet = new ethers.Wallet(privateKey, provider);

async function signMessage() {
    const domain = {
        name: "EIP712Example",
        version: "1",
        chainId: 97,
        verifyingContract: "0xC093D11828c25678b73015907b9ae844c3bA1d24",
    };

    const types = {
        Message: [
            { name: "sender", type: "address" },
            { name: "amount", type: "uint256" },
        ],
    };

    const value = {
        sender: wallet.address,
        amount: 100,
    };

    const signature = await wallet.signTypedData(domain, types, value);
    console.log("Tuple:", `["${value.sender}",${value.amount}]`);
    console.log("Signature:", signature);
}

signMessage()
