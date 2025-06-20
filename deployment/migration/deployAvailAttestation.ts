import { ethers, upgrades } from "hardhat";
import { PolygonValidiumEtrog } from "../../typechain-types";
const migrateDAProtocol = require("./migrate_da_protocol.json");

async function main() {
    const [deployer] = await ethers.getSigners();

    const {
        availBridgeAddress,
        adminZKEVMAddress,
        polygonValidiumEtrogAddress
    } = migrateDAProtocol

    console.log("Avail bridge address: ", availBridgeAddress)
    console.log("Admin ZKEVM address: ", adminZKEVMAddress)
    console.log("Polygon Validium Etrog address: ", polygonValidiumEtrogAddress)

    const AvailAttestationContract = await ethers.getContractFactory("AvailAttestation");

    let availAttestation;
    try {
        availAttestation = await upgrades.deployProxy(AvailAttestationContract, [availBridgeAddress, adminZKEVMAddress], {
            unsafeAllow: ["constructor"],
            initializer: "initialize"
        });
        await availAttestation?.waitForDeployment();
        console.log("AvailAttestation proxy deployed to:", await availAttestation.getAddress());
    } catch (error: any) {
        console.log("upgrades.deployProxy of availAttestation ", error.message);
    }

    // Load data commitee
    const PolygonconsensusFactory = await ethers.getContractFactory("PolygonValidiumEtrog")
    const PolygonValidiumContract = (await PolygonconsensusFactory.attach(polygonValidiumEtrogAddress)) as PolygonValidiumEtrog
    // add data commitee to the consensus contract
    await (await PolygonValidiumContract.setDataAvailabilityProtocol(availAttestation?.target as any)).wait();
    console.log("#######################\n");
    console.log("DataAvailabilityProtocol is set to:", await PolygonValidiumContract.dataAvailabilityProtocol());
    console.log("RollupManager:", await PolygonValidiumContract.rollupManager());

    await (await availAttestation?.transferOwnership(adminZKEVMAddress)).wait();
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});