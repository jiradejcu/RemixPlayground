const { ethers } = require("ethers");

const provider = new ethers.providers.JsonRpcProvider("https://data-seed-prebsc-1-s1.binance.org:8545");

const privateKey = "bf45a5d7d16f4da2c0638581f8ec8a162f3d4714564c5fab33b21e214e2261ad";
const wallet = new ethers.Wallet(privateKey, provider);

async function signMessage() {
    const domain = {
        name: "EIP712Example",
        version: "1",
        chainId: 97,
        verifyingContract: "0x2D2F3FE9C3b480916EB4Bf57247a4fBCFeC75994",
    };

    const types = {
        Message: [
            { name: "sender", type: "address" },
            { name: "amount", type: "uint256" },
        ],
    };

    const value = {
        sender: wallet.address,
        amount: 1000,
    };

    const signature = await wallet._signTypedData(domain, types, value);
    console.log("Signature:", signature);
}

signMessage()
