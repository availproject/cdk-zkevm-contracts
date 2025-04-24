// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.25;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {IAvailBridge} from "../../interfaces/IAvailBridge.sol";
import {IAvailVectorx} from "../../interfaces/IAvailVectorx.sol";
import {IDataAvailabilityProtocol} from "../../interfaces/IDataAvailabilityProtocol.sol";
import {AvailAttestationLib} from "../../lib/AvailAttestationLib.sol";

contract AvailAttestation is OwnableUpgradeable, IDataAvailabilityProtocol, AvailAttestationLib {

    // True/False based on if Avail bridge attestation verification is enabled
    bool public isEnabled;

    event AvailBridgeVerificationToggled(bool enabled);

    /**
     * @dev Thrown when the caller is not the admin
     */
    error OnlyAdmin();

    // Address that will be able to adjust contract parameters
    address public admin;

    modifier onlyAdmin() {
        if (admin != msg.sender) {
            revert OnlyAdmin();
        }
        _;
    }

    constructor() {
        _disableInitializers();
    }

    function initialize(IAvailBridge bridge, address _admin) external initializer {
        admin = _admin;
        isEnabled = false;
        __AvailAttestation_init(bridge);
        __Ownable_init_unchained();
    }

    function getProcotolName() external pure override returns (string memory) {
        return "AvailDA";
    }


    function verifyMessage(
        bytes32,
        bytes calldata dataAttestationProof
    ) external {
        if (isEnabled){
            _attest(dataAttestationProof);
        }
    }

    //////////////////
    // admin functions
    //////////////////

    /**
     * @notice Allow the admin to enable/disable the avail bridge attestation verification
     * @param _isEnabled Enabled the avail bridge attestation verification
     */
    function setAvailBridgeVerificationEnabled(
        bool _isEnabled
    ) external onlyAdmin {
        isEnabled = _isEnabled;
        emit AvailBridgeVerificationToggled(_isEnabled);
    }
}