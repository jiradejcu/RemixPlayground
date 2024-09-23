// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract EIP712Example {
    string public constant name = "EIP712Example";
    string public constant version = "1";

    bytes32 private constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    bytes32 private constant MESSAGE_TYPEHASH = keccak256("Message(address sender,uint256 amount)");

    struct Message {
        address sender;
        uint256 amount;
    }

    bytes32 public DOMAIN_SEPARATOR;

    constructor() {
        DOMAIN_SEPARATOR = keccak256(abi.encode(
            DOMAIN_TYPEHASH,
            keccak256(bytes(name)),
            keccak256(bytes(version)),
            block.chainid,
            address(this)
        ));
    }

    function hashMessage(Message memory message) internal pure returns (bytes32) {
        return keccak256(abi.encode(
            MESSAGE_TYPEHASH,
            message.sender,
            message.amount
        ));
    }

    function verify(Message memory message, bytes memory signature) public view returns (address) {
        bytes32 messageHash = hashMessage(message);
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, messageHash));
        
        return ECDSA.recover(digest, signature);
    }
}
