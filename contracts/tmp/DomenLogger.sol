// SPDX-License-Identifier: UNLICENSED
pragma solidity ^ 0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract DomenLogger{

    address public owner;
    string public domenURL;

    constructor(string memory _url){
        owner = msg.sender;
        domenURL = _url;
    }

    // save getted data?  
    // {
    //      address: [
    //         'url-1',
    //         ... ,
    //         'url-n',
    //.     ]
    //  }
    // check address & if was before - add to [arr] 


    // also add methods for 
    // 1 get all addressed
    // 2 get all urls
    // 3 get all data
    // 4 get all urls-data for current address
    // 5 get owner from current url
    // 6 save data added ??? // OR I can get this from contract???

}