// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// sample struct code 
/*
    helpers: 
    https://docs.soliditylang.org/en/v0.8.21/layout-of-source-files.html

    Contract structure: 
    * Добавьте директиву лицензии
    * укажите минимальную версию Solidity
    * определите класс контракта,
    * конструктор контракта, 
    * имя контракта и 
    * символ контракта.

    const contract = await ethers.deployContract("myContract");
    const address = await contract.getAddress();

    // IDEAs: 
    //  1 https://ethereum.stackexchange.com/questions/144/can-contracts-pay-the-gas-instead-of-the-message-sender


*/


// contract DataStorage is Ownable {
contract DomenRegistrator {

    address public ownerContract;
    uint256 public minimalGasTax;

    event TaxCollected(address indexed from, uint256 amount);

    // https://stackoverflow.com/questions/41894337/does-ethereum-solidity-support-associative-arrays
    // https://solidity-by-example.org/structs/
    // https://solidity-by-example.org/data-locations/
    // https://medium.com/coinmonks/solidity-storage-vs-memory-vs-calldata-8c7e8c38bce
    // my code
    struct OwnerStruct {
        address ownerAddress;
        string[] domainNames;
        uint256[] deposit;
        uint16[] updated;
    }

    OwnerStruct[] private ownerStruct;

    struct ReportStruct {
        string domainName;
        uint256 deposit;
    }

    ReportStruct private reportStruct;

    /**
        METHODS
    */
   
    // RIGHTs
    modifier onlyOwner() {
        require(msg.sender == ownerContract, "Only the owner can call this function");
        _;
    }

    // VIEW METHODs
    function getBalance( ) external view returns ( uint256 ) {
        return ownerContract.balance;
    }

    function getDeposit( address _ownerAddress ) external view returns ( uint256[] memory ) {
        uint256[] memory _deposit;
        for (uint i = 0; i < ownerStruct.length; i++) 
        {
            if(ownerStruct[i].ownerAddress == _ownerAddress){
                _deposit = ownerStruct[i].deposit;
                break;
            } 
        }
        return _deposit;
    }

    function getListUpdateDate( address _ownerAddress ) external view returns ( uint16[] memory ) {
        uint16[] memory _updated;
        for (uint i = 0; i < ownerStruct.length; i++) 
        {
            if(ownerStruct[i].ownerAddress == _ownerAddress){
                _updated = ownerStruct[i].updated;
                break;
            } 
        }
        return _updated;
    }

    function getAllData() external view returns ( OwnerStruct[] memory) {
        return ownerStruct;
    }

    // // Error: overflow [ See: https://links.ethers.org/v5-errors-NUMERIC_FAULT-overflow ] 
    // // (fault=\"overflow\", operation=\"toNumber\", 
    // function getAllOwners () public view returns(address[] memory)  {
        
    //     address[] memory allOwnerList;

    //     for (uint i = 0; i < ownerStruct.length; i++) 
    //     {
    //         allOwnerList[i] = ownerStruct[i].ownerAddress;
    //     }

    //     return allOwnerList;
    // }
    // // Error: overflow [ See: https://links.ethers.org/v5-errors-NUMERIC_FAULT-overflow ] 
    // // (fault=\"overflow\", operation=\"toNumber\", 
    // function getAllRegisteredDomains () public view returns(string[] memory)  {
        
    //     string[] memory allDomains;
    //     uint256 count = 0;

    //     for (uint i = 0; i < ownerStruct.length; i++) 
    //     {
    //         for (uint j = 0; j < ownerStruct[i].domainNames.length; j++) {
    //             allDomains[count] = ownerStruct[i].domainNames[j];
    //             count++;
    //         }
    //     }
    //     return allDomains;
    // }

    function getCurrentOwnerData ( address _ownerAddress ) external view returns( OwnerStruct memory)  {
        
        OwnerStruct memory ownerData;

        for (uint i = 0; i < ownerStruct.length; i++) 
        {
            if( ownerStruct[i].ownerAddress == _ownerAddress ) {
                ownerData =  ownerStruct[i];
            }
        }

        return ownerData;
    }

    function getAllDomainsFromCurrentOwner ( address _ownerAddress ) external view returns(string[] memory)  {
        
        string[] memory allOwnerDomains;

        for (uint i = 0; i < ownerStruct.length; i++) 
        {
            if( ownerStruct[i].ownerAddress == _ownerAddress ) {
                allOwnerDomains = ownerStruct[i].domainNames;
                break;
            }
        }
        return allOwnerDomains;
    }

    // WHO WORK BUT NOT ALL TIME ???? may bw bug with use adderess variable
    // STRANGE WORK 
    /*
    revert
	The transaction has been reverted to the initial state.
    Note: The called function should be payable if you send value and the value you send should be less than your current balance.
    Debug the transaction to get more information.
    */
    function getOwnerFromDomain ( string calldata _domainName ) external view returns(address)  {
        
        address _owner;

        for (uint i = 0; i < ownerStruct.length; i++) 
        {
            for (uint j = 0; i < ownerStruct[i].domainNames.length; i++) {
                
                if(keccak256(bytes(ownerStruct[i].domainNames[j])) == keccak256(bytes(_domainName))){
                    _owner = ownerStruct[i].ownerAddress;
                    // return ownerStruct[i].ownerAddress;
                }
            }
        }
        return _owner;
    }

    // ADD 
    function addNewDomain ( address _ownerAddress, string calldata _domainName ) public payable {

        require( msg.value >= minimalGasTax, 
            string.concat(uintToString(msg.value), 
            " : Tax amount is less than minimum")
        );    
        uint256 _deposit = msg.value;
    
        bool exist = false;
        uint256 indexExist = 0;
        // https://ethereum.stackexchange.com/questions/3034/how-to-get-current-time-by-solidity
        uint16[] memory dateNow = new uint16[](1);
        dateNow[0] = uint16(block.timestamp); 

        string[] memory initURL = new string[](1);
        initURL[0] = _domainName;

        uint256[] memory initDeposit = new uint256[](1);
        initDeposit[0] = _deposit;

        address ownerAddress = _ownerAddress;// msg.sender; // for test - user can input address

        for (uint i = 0; i < ownerStruct.length; i++) 
        {
            if( ownerStruct[i].ownerAddress == ownerAddress) {
                exist = true;
                indexExist = i;
                break;
            }
        }

        if(exist == true ){
            // string[]. bad work for init - more simple use string with pattern as sample " ; " for cutting
            // ownerStruct[indexExist].domainNames.push(_domainName); 
            // https://www.educative.io/answers/how-to-perform-string-concatenation-in-solidity

            // ownerStruct[indexExist].domainNames = string.concat(ownerStruct[indexExist].domainNames, " ; ", _domainName);
            bool isUsed = false;
            for (uint i = 0; i < ownerStruct.length; i++) {

                for (uint j = 0; j < ownerStruct[i].domainNames.length; j++) 
                {

                    if (keccak256(bytes(ownerStruct[i].domainNames[j])) == keccak256(bytes(_domainName))) {
                        isUsed = true;
                    }
                    require( !isUsed, 
                        string.concat(uintToString(msg.value), 
                        " : this domain name has registered. Please write non-used domain name")
                    );    
                }
            }

            ownerStruct[indexExist].domainNames.push(_domainName);
            ownerStruct[indexExist].deposit.push(_deposit);
            ownerStruct[indexExist].updated.push(uint16(block.timestamp));

        } else {

            ownerStruct.push(
                OwnerStruct({
                    ownerAddress : ownerAddress,
                    domainNames : initURL,
                    deposit : initDeposit,
                    updated : dateNow
                })
            );
        }

        emit TaxCollected(msg.sender, msg.value);
       
    }

    // REMOVE

    // PROBLEM SIMILAR as in getOwnerFromDomain()
    function removeDomainFromOwner ( string calldata _domainName, address payable _ownerAddress ) public payable { //returns ( ReportStruct memory)

        // TODO: 
        // If owner have domans.length == 0 => remove owner? 
        

        for (uint i = 0; i < ownerStruct.length; i++) 
        {
            if( ownerStruct[i].ownerAddress == _ownerAddress){

                for (uint j = 0; i < ownerStruct[i].domainNames.length; i++) {
                    
                    if(keccak256(bytes(ownerStruct[i].domainNames[j])) == keccak256(bytes(_domainName))){
                        // correct remove element from []
                        // https://blog.solidityscan.com/improper-array-deletion-82672eed8e8d

                        // revert deposit
                        reportStruct.deposit = ownerStruct[i].deposit[j];
                        _ownerAddress.transfer( ownerStruct[i].deposit[j] );

                        // clear domain array data
                        reportStruct.domainName = ownerStruct[i].domainNames[j];
                        ownerStruct[i].domainNames[j] = ownerStruct[i].domainNames[ownerStruct[i].domainNames.length -1];
                        ownerStruct[i].domainNames.pop();

                        // clear deposit array data
                        ownerStruct[i].deposit[j] = ownerStruct[i].deposit[ownerStruct[i].deposit.length -1];
                        ownerStruct[i].deposit.pop();

                        break;

                    }
                }
            }

        }
        // return reportStruct;
    }

    /*
        ROOT
    */
    function setMinimumTaxAmount(uint256 _newMinimalGasTax) public onlyOwner {
        minimalGasTax = _newMinimalGasTax;
    }



    constructor (uint _minimalGasTax) {
        minimalGasTax = _minimalGasTax;
        ownerContract = msg.sender;  // get address
    }


    /**
     *  UTILS
     */
    function uintToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        
        uint256 temp = value;
        uint256 digits;
        
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits--;
            buffer[digits] = bytes1(uint8(48 + value % 10));
            value /= 10;
        }
        
        return string(buffer);
    }

    /**
     *  TEST
     */
    // Реалізуйте юніт-тести для всього функціонала, і, власне, сам контракт.




}
