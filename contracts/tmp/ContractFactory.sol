// SPDX-License-Identifier: UNLICENSED
pragma solidity ^ 0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

// Address Hardhat for test  0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266

import './DomenLogger.sol';

contract ContractFactory{

    function CreateContract( string calldata url )
    public

    returns ( DomenLogger tokenAddress ){
        return new DomenLogger(url);
    }

}