import { Signer } from "@ethersproject/abstract-signer";
import { task } from "hardhat/config";
import { TaskArguments } from "hardhat/types";

import { FluxPriceFeed } from "../../src/types/FluxPriceFeed";
import { AccessControlledFluxPriceFeed } from "../../src/types/AccessControlledFluxPriceFeed";
import { FluxPriceFeed__factory } from "../../src/types/factories/FluxPriceFeed__factory";
import { AccessControlledFluxPriceFeed__factory } from "../../src/types/factories/AccessControlledFluxPriceFeed__factory";

task("deploy:FluxPriceFeed")
  .addParam("decimals", "The number of decimals in the value posted")
  .addParam("description", "The description of the contract")
  .addOptionalParam("validator", "The validator allowed to post data to the contract")
  .addOptionalParam("isAccessControlled", "Whether or access control should be enabled for reading from the contract")
  .setAction(async function (taskArgs: TaskArguments, { ethers }) {
    const accounts: Signer[] = await ethers.getSigners();

    // get validator address
    let validator;
    if (taskArgs.validator) {
      validator = taskArgs.validator;
    } else {
      validator = await accounts[0].getAddress();
    }

    // deploy either FluxPriceFeed or AccessControlledFluxPriceFeed
    if (taskArgs.isAccessControlled === "true") {
      const accesspricefeedFactory: AccessControlledFluxPriceFeed__factory = <AccessControlledFluxPriceFeed__factory>(
        await ethers.getContractFactory("AccessControlledFluxPriceFeed")
      );
      const pricefeed: AccessControlledFluxPriceFeed = <AccessControlledFluxPriceFeed>(
        await accesspricefeedFactory.deploy(validator, taskArgs.decimals, taskArgs.description)
      );
      await pricefeed.deployed();
      console.log("AccessControlledFluxPriceFeed deployed to: ", pricefeed.address);
    } else {
      const pricefeedFactory: FluxPriceFeed__factory = <FluxPriceFeed__factory>(
        await ethers.getContractFactory("FluxPriceFeed")
      );
      const pricefeed: FluxPriceFeed = <FluxPriceFeed>(
        await pricefeedFactory.deploy(validator, taskArgs.decimals, taskArgs.description)
      );
      await pricefeed.deployed();
      console.log("FluxPriceFeed deployed to: ", pricefeed.address);
    }
  });
