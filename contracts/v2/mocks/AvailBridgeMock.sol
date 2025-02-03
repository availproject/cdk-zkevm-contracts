// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.25;

import { IAvailBridge } from "../interfaces/IAvailBridge.sol";
import { IAvailVectorx } from "../interfaces/IAvailVectorx.sol";

contract AvailBridgeMock is IAvailBridge {
    IAvailVectorx private _vectorx;
    bool private _paused;
    address public feeRecipient;
    uint256 public feePerByte;

    constructor() {
        _paused = false;
        feeRecipient = msg.sender;
        feePerByte = 100; // Example fee
    }

    function vectorx() external view override returns (IAvailVectorx) {
        return _vectorx;
    }

    function setPaused(bool status) external override {
        _paused = status;
    }

    function updateVectorx(IAvailVectorx newVectorx) external override {
        _vectorx = newVectorx;
    }

    function updateTokens(bytes32[] calldata assetIds, address[] calldata tokenAddresses) external override {}

    function updateFeePerByte(uint256 newFeePerByte) external override {
        feePerByte = newFeePerByte;
    }

    function updateFeeRecipient(address newFeeRecipient) external override {
        feeRecipient = newFeeRecipient;
    }

    function withdrawFees() external override {}

    function receiveMessage(Message calldata message, MerkleProofInput calldata input) external override {
        emit MessageReceived(message.from, msg.sender, message.messageId);
    }

    function receiveAVAIL(Message calldata message, MerkleProofInput calldata input) external override {}

    function receiveETH(Message calldata message, MerkleProofInput calldata input) external override {}

    function receiveERC20(Message calldata message, MerkleProofInput calldata input) external override {}

    function sendMessage(bytes32 recipient, bytes calldata data) external payable override {
        emit MessageSent(msg.sender, recipient, 1); // Mock message ID
    }

    function sendAVAIL(bytes32 recipient, uint256 amount) external override {}

    function sendETH(bytes32 recipient) external payable override {}

    function sendERC20(bytes32 assetId, bytes32 recipient, uint256 amount) external override {}

    function verifyBlobLeaf(MerkleProofInput calldata input) external pure override returns (bool) {
        return input.blobRoot != bytes32(0); // Simulating a simple verification
    }

    function verifyBridgeLeaf(MerkleProofInput calldata input) external pure override returns (bool) {
        return input.bridgeRoot != bytes32(0); // Simulating a simple verification
    }
}