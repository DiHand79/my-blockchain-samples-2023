// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require('hardhat');
console.log('hre: ', hre);

async function main() {
  const lockedAmount = hre.ethers.parseEther(
    Math.random().toString().slice(0, 3)
  );
  console.log('lockedAmount: ', lockedAmount);

  const domainRegistrator = await hre.ethers.deployContract(
    'DomainRegistrator',
    [minPrice],
    {
      value: minPrice,
    }
  );

  // await lock.waitForDeployment();

  console.log(
    `Lock with ${ethers.formatEther(
      lockedAmount
    )}ETH and unlock timestamp ${unlockTime} deployed to ${lock.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
