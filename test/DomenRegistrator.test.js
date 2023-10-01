/**
 * https://youtu.be/oHU3eme6l40?si=HFXdmN1mU5mwjnZ5
 * https://hardhat.org/tutorial/testing-contracts#writing-tests
 * https://hardhat.org/hardhat-runner/docs/guides/test-contracts
 * https://hardhat.org/hardhat-runner/docs/getting-started#testing-your-contracts
 * https://hardhat.org/hardhat-runner/docs/guides/test-contracts#measuring-code-coverage
 *
 */

// import { expect } from 'chai';
// import hre from 'hardhat';
// const { ethers } = hre;

const { expect } = require('chai');
const { ethers } = require('hardhat');
const {
  loadFixture,
  time,
} = require('@nomicfoundation/hardhat-toolbox/network-helpers');

describe('Deploy:', function () {
  const domainNames = [];
  for (let i = 0; i < 5; i++) {
    domainNames.push(`example-${i}.com`);
    domainNames.push(`sample-${i}.gov`);
    domainNames.push(`home-${i}.org`);
    domainNames.push(`my.home-${i}.cc`);
  }
  let users = [];
  let minimalGasTax;
  let domainRegistrator;
  let randomUser;
  let testAddress;
  const usedDomains = [];

  this.beforeAll('init deploy', async function () {
    const [owner, user1, user2, user3] = await ethers.getSigners(); // 20 entities
    users = [user1, user2, user3];
    // '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266'
    // '0x70997970C51812dc3A010C7d01b50e0d17dc79C8'
    // '0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC'
    // '0x90F79bf6EB2c4f870365E785982E1f101E93b906'

    minimalGasTax = BigInt(Math.round(Math.random() * 100));
    console.log('minimalGasTax: ', minimalGasTax);

    const DomainRegistrator = await ethers.getContractFactory(
      'DomainRegistrator',
      owner
    );
    domainRegistrator = await DomainRegistrator.deploy(minimalGasTax);
  });

  // async function deployRegistrationContract() {
  //   const [owner, user1, user2, user3] = await ethers.getSigners(); // 20 entities
  //   const users = [user1, user2, user3];
  //   // '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266'
  //   // '0x70997970C51812dc3A010C7d01b50e0d17dc79C8'
  //   // '0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC'
  //   // '0x90F79bf6EB2c4f870365E785982E1f101E93b906'

  //   let minimalGasTax = BigInt(Math.round(Math.random() * 100));
  //   console.log('minimalGasTax: ', minimalGasTax);

  //   const DomainRegistrator = await ethers.getContractFactory(
  //     'DomainRegistrator',
  //     owner
  //   );
  //   const domainRegistrator = await DomainRegistrator.deploy(minimalGasTax);
  //   // work 0x5FbDB2315678afecb367f032d93F642f64180aa3
  //   // console.log('ADDRESS: ', await domainRegistrator.getAddress());
  //   return { owner, users, domainRegistrator, minimalGasTax };
  // }

  it('Deployed & verification: ', async function () {
    // const { domainRegistrator } = await loadFixture(deployRegistrationContract);
    // verification contract address
    expect(await domainRegistrator.getAddress()).to.be.properAddress;
  });

  it('Init balance hould have very BigNumber ETH: ', async function () {
    // const { domainRegistrator } = await loadFixture(deployRegistrationContract);
    console.log(await domainRegistrator.getBalance());
  });

  it('Init all data hould have array clear data []: ', async function () {
    // const { domainRegistrator } = await loadFixture(deployRegistrationContract);
    console.log(await domainRegistrator.getAllData());
  });

  it('Get minimum tax gas - should more than 0 : ', async function () {
    // const { domainRegistrator } = await loadFixture(deployRegistrationContract);
    console.log(await domainRegistrator.getMinimumTaxt());
  });

  it('Add several users & domainNames: ', async function () {
    // const { users, domainRegistrator, minimalGasTax } = await loadFixture(
    //   deployRegistrationContract
    // );

    for (let i = 0; i < Math.round(Math.random() * 30) + 2; i++) {
      const randomUser = Math.floor(Math.random() * users.length);
      let randomDomain = Math.floor(Math.random() * domainNames.length);
      // can comment for test duobled domainName daa exception
      if (!usedDomains.includes(domainNames[randomDomain])) {
        // console.log(domainNames[randomDomain], ' :vs: ', usedDomains);
        await domainRegistrator.addNewDomain(
          users[randomUser],
          domainNames[randomDomain],
          {
            value: minimalGasTax + BigInt(Math.round(Math.random() * 100)),
          }
        );
        usedDomains.push(domainNames[randomDomain]);
      } else {
        // console.log(
        //   domainNames[randomDomain] + ' >>> usedDomains: ',
        //   usedDomains
        // );
        randomDomain = Math.floor(Math.random() * domainNames.length);
        if (usedDomains.length == domainNames.length) {
          console.log(
            'domain name is ended, need use more big input array names data'
          );
          break;
        }
      }
    }

    console.log(await domainRegistrator.getAllData());
  });

  it('Get deposit - should non-clear(deposite for each domain) array with int data more than minimalGasTax: ', async function () {
    randomUser = Math.floor(Math.random() * users.length);
    testAddress = users[randomUser].address;
    console.log(await domainRegistrator.getDeposit(testAddress));
  });

  it('Get all updates data. Each addNewDomain - uint16(block.timestamp): ', async function () {
    console.log(await domainRegistrator.getListUpdateDate(testAddress));
  });

  it(`Get all qwner data. Should be 
  {        
    address ownerAddress;
    string[] domainNames;
    uint256[] deposit;
    uint16[] updated;
  }): `, async function () {
    console.log(await domainRegistrator.getCurrentOwnerData(testAddress));
  });

  it('Get all domains current owner. Should be non-clear string[] ', async function () {
    randomUser = Math.floor(Math.random() * users.length);
    testAddress = users[randomUser].address;
    console.log(
      await domainRegistrator.getAllDomainsFromCurrentOwner(testAddress)
    );
  });

  it('Get owner from current domain. Should be ADDRESS type ', async function () {
    randomIndex = Math.floor(Math.random() * usedDomains.length);
    randomUsedDomain = usedDomains[randomUser];
    console.log(await domainRegistrator.getOwnerFromDomain(randomUsedDomain));
  });

  it('Change minTax (ownerContractONLY how test?). uint256', async function () {
    randomIndex = BigInt(Math.floor(Math.random() * 100));
    console.log(await domainRegistrator.setMinimumTaxAmount(randomIndex));
    console.log(await domainRegistrator.getMinimumTaxt());
  });

  // // with inpud two fields data
  // domainRegistrator.addNewDomain( address, domain )
  // domainRegistrator.removeDomainFromOwner( address, domain )
});

// describe('DomainRegistrator', function () {
//   // We define a fixture to reuse the same setup in every test.
//   // We use loadFixture to run this setup once, snapshot that state,
//   // and reset Hardhat Network to that snapshot in every test.
//   async function deployOneYearLockFixture() {
//     const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
//     const ONE_GWEI = 1_000_000_000;

//     const lockedAmount = ONE_GWEI;
//     const unlockTime = (await time.latest()) + ONE_YEAR_IN_SECS;

//     // Contracts are deployed using the first signer/account by default
//     const [owner, otherAccount] = await ethers.getSigners();

//     const DomainRegistrator = await ethers.getContractFactory(
//       'DomainRegistrator'
//     );
//     const domainRegistrator = await DomainRegistrator.deploy(unlockTime, {
//       value: lockedAmount,
//     });

//     return { domainRegistrator, unlockTime, lockedAmount, owner, otherAccount };
//   }

//   describe('Deployment', function () {
//     it('Should set the right unlockTime', async function () {
//       const { domainRegistrator, unlockTime } = await loadFixture(
//         deployOneYearLockFixture
//       );

//       expect(await domainRegistrator.unlockTime()).to.equal(unlockTime);
//     });

//     it('Should set the right owner', async function () {
//       const { domainRegistrator, owner } = await loadFixture(
//         deployOneYearLockFixture
//       );

//       expect(await domainRegistrator.owner()).to.equal(owner.address);
//     });

//     it('Should receive and store the funds to domainRegistrator', async function () {
//       const { domainRegistrator, lockedAmount } = await loadFixture(
//         deployOneYearLockFixture
//       );

//       expect(
//         await ethers.provider.getBalance(domainRegistrator.target)
//       ).to.equal(lockedAmount);
//     });

//     it('Should fail if the unlockTime is not in the future', async function () {
//       // We don't use the fixture here because we want a different deployment
//       const latestTime = await time.latest();
//       const DomainRegistrator = await ethers.getContractFactory(
//         'DomainRegistrator'
//       );
//       await expect(
//         DomainRegistrator.deploy(latestTime, { value: 1 })
//       ).to.be.revertedWith('Unlock time should be in the future');
//     });
//   });

//   describe('Withdrawals', function () {
//     describe('Validations', function () {
//       it('Should revert with the right error if called too soon', async function () {
//         const { domainRegistrator } = await loadFixture(
//           deployOneYearLockFixture
//         );

//         await expect(domainRegistrator.withdraw()).to.be.revertedWith(
//           "You can't withdraw yet"
//         );
//       });

//       it('Should revert with the right error if called from another account', async function () {
//         const { domainRegistrator, unlockTime, otherAccount } =
//           await loadFixture(deployOneYearLockFixture);

//         // We can increase the time in Hardhat Network
//         await time.increaseTo(unlockTime);

//         // We use domainRegistrator.connect() to send a transaction from another account
//         await expect(
//           domainRegistrator.connect(otherAccount).withdraw()
//         ).to.be.revertedWith("You aren't the owner");
//       });

//       it("Shouldn't fail if the unlockTime has arrived and the owner calls it", async function () {
//         const { domainRegistrator, unlockTime } = await loadFixture(
//           deployOneYearLockFixture
//         );

//         // Transactions are sent using the first signer by default
//         await time.increaseTo(unlockTime);

//         await expect(domainRegistrator.withdraw()).not.to.be.reverted;
//       });
//     });

//     describe('Events', function () {
//       it('Should emit an event on withdrawals', async function () {
//         const { domainRegistrator, unlockTime, lockedAmount } =
//           await loadFixture(deployOneYearLockFixture);

//         await time.increaseTo(unlockTime);

//         await expect(domainRegistrator.withdraw())
//           .to.emit(domainRegistrator, 'Withdrawal')
//           .withArgs(lockedAmount, anyValue); // We accept any value as `when` arg
//       });
//     });

//     describe('Transfers', function () {
//       it('Should transfer the funds to the owner', async function () {
//         const { domainRegistrator, unlockTime, lockedAmount, owner } =
//           await loadFixture(deployOneYearLockFixture);

//         await time.increaseTo(unlockTime);

//         await expect(domainRegistrator.withdraw()).to.changeEtherBalances(
//           [owner, domainRegistrator],
//           [lockedAmount, -lockedAmount]
//         );
//       });
//     });
//   });
// });
