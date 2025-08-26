// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.25;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {IAvailVectorx} from "../interfaces/IAvailVectorx.sol";
import {IAvailBridge} from "../interfaces/IAvailBridge.sol";

/**
 * @author  @QEDK-rishabhagrawalzra(Avail)
 * @title   AvailAttestation
 * @notice  An abstract data attestation implementation for validiums, optimiums and generic rollup stacks
 * @custom:security security@availproject.org
 */
abstract contract AvailAttestationLib is Initializable {
    struct AttestationData {
        uint32 blockNumber;
        uint128 leafIndex;
    }

    IAvailBridge public bridge;
    IAvailVectorx public vectorx;

    mapping(bytes32 => AttestationData) public attestations;

    error InvalidAttestationProof();

    // slither-disable-next-line naming-convention,dead-code
    function __AvailAttestation_init(IAvailBridge _bridge) internal virtual onlyInitializing {
        bridge = _bridge;
        vectorx = bridge.vectorx();
    }

    function _attest(bytes memory data) internal virtual {
        IAvailBridge.MerkleProofInput memory input = abi.decode(data, (IAvailBridge.MerkleProofInput));
        if (!bridge.verifyBlobLeaf(input)) revert InvalidAttestationProof();
        attestations[input.leaf] = AttestationData(
            vectorx.rangeStartBlocks(input.rangeHash) + uint32(input.dataRootIndex) + 1, uint128(input.leafIndex)
        );
    }

    // slither-disable-next-line naming-convention
    uint256[50] private __gap;
}