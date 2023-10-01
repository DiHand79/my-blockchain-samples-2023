/**
 * https://youtu.be/oHU3eme6l40?si=HFXdmN1mU5mwjnZ5
 * https://hardhat.org/tutorial/testing-contracts#writing-tests
 * https://hardhat.org/hardhat-runner/docs/guides/test-contracts
 * https://hardhat.org/hardhat-runner/docs/getting-started#testing-your-contracts
 * https://hardhat.org/hardhat-runner/docs/guides/test-contracts#measuring-code-coverage
 *
 */

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
    domainNames.push(`my.home-${i}.xyz`);
    domainNames.push(`next.country-${i}.io`);
  }
  let users = [];
  let minimalGasTax;
  let domainRegistrator;
  let randomUser;
  let testAddress;
  let randomDomain;
  let usedDomains = [];

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

  it('Get all owner. Should be clear address[] from init: ', async function () {
    // const { domainRegistrator } = await loadFixture(deployRegistrationContract);
    console.log(await domainRegistrator.getAllOwners());
  });

  it('Get all registered domains. Shuld be clear string[] from init: ', async function () {
    // const { domainRegistrator } = await loadFixture(deployRegistrationContract);
    console.log(await domainRegistrator.getAllRegisteredDomains());
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
      randomUser = Math.floor(Math.random() * users.length);
      randomDomain = Math.floor(Math.random() * domainNames.length);
      // can comment for test duobled domainName daa exception
      if (!usedDomains.includes(domainNames[randomDomain])) {
        await domainRegistrator.addNewDomain(
          users[randomUser],
          domainNames[randomDomain],
          {
            value: minimalGasTax + BigInt(Math.round(Math.random() * 100)),
          }
        );
        usedDomains.push(domainNames[randomDomain]);
      } else {
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

  it('Get owner from current domain. Should be NON-ZERO ADDRESS type ', async function () {
    randomIndex = Math.floor(Math.random() * usedDomains.length);
    randomUsedDomain = await usedDomains[randomIndex];
    console.log('Find Owner for Domain: ', randomUsedDomain);
    console.log(await domainRegistrator.getOwnerFromDomain(randomUsedDomain));
  });

  it('Change minTax (ownerContractONLY how test?). uint256', async function () {
    randomIndex = BigInt(Math.floor(Math.random() * 100));
    console.log(await domainRegistrator.setMinimumTaxAmount(randomIndex));
    console.log(await domainRegistrator.getMinimumTaxt());
  });

  //HARDHAT BUG  ERR  Method 'HardhatEthersProvider.resolveName' is not implemented
  // SOLUTION ??? https://vsupalov.com/ethers-call-payable-solidity-function/
  it('Remove domain by domainName & owner. Should update domains & deposits array data', async function () {
    // select random used domain
    randomDomain = Math.floor(Math.random() * usedDomains.length);
    // get owner domain
    const address = await domainRegistrator.getOwnerFromDomain(
      usedDomains[randomDomain]
    );

    // console.log(await domainRegistrator.connect(address).getAllData());

    console.log('REMOVE DOMAIN: ', usedDomains[randomDomain]);
    console.log('REMOVE QWNER: ', address);
    console.log(
      'TEst valid address & connect: ',
      await domainRegistrator.connect(address)
    ); // test valid address
    // remove domain from owner & revert deposit
    console.log(
      // await domainRegistrator.removeDomainFromOwner(
      await domainRegistrator
        .connect(address)
        .removeDomainFromOwner(address, usedDomains[randomDomain])
    );

    let updateUsedDomains = usedDomains.filter(
      (url) => url !== usedDomains[randomDomain]
    );
    usedDomains = updateUsedDomains;
  });

  // // TODO
  // // ERR  Array accessed at an out-of-bounds or negative index
  // it('Get all owner. Should be NON-clear address[] after work: ', async function () {
  //   // const { domainRegistrator } = await loadFixture(deployRegistrationContract);
  //   console.log(await domainRegistrator.getAllOwners());
  // });

  // // ERR   Array accessed at an out-of-bounds or negative index
  // it('Get all registered domains. Shuld be NON-clear string[] after work: ', async function () {
  //   // const { domainRegistrator } = await loadFixture(deployRegistrationContract);
  //   console.log(await domainRegistrator.getAllRegisteredDomains());
  // });
});
