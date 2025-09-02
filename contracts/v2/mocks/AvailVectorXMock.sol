// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.25;

import {IVectorx} from "../interfaces/IVectorx.sol";

contract AvailVectorXMock is IVectorx {
    mapping(bytes32 => bytes32) public dataRootCommitments;
    mapping(bytes32 => uint32) public rangeStartBlocks;

    function set(bytes32 rangeHash, bytes32 dataRoot) external {
        dataRootCommitments[rangeHash] = dataRoot;
    }

    function setStartBlock(bytes32 rangeHash, uint32 startBlock) external {
        rangeStartBlocks[rangeHash] = startBlock;
    }
}