// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// sample code 
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
*/


// contract DataStorage is Ownable {
contract DomenRegistrator {

    address public ownerContract;
    uint256 public minimalGasTax;
    // uint public deposit = 0;
    // string public domain;
    // address[] owners;
    // string[] domains;

    event TaxCollected(address indexed from, uint256 amount);


    // my code
    // https://stackoverflow.com/questions/41894337/does-ethereum-solidity-support-associative-arrays
    // https://solidity-by-example.org/structs/
    // https://solidity-by-example.org/data-locations/
    // https://medium.com/coinmonks/solidity-storage-vs-memory-vs-calldata-8c7e8c38bce
    struct QwnerStruct {
        address ownerAddress;
        string[] domainNames; // not work
        // string domainNames; // work
        uint256[] deposit;
        uint16[] updated;
    }

    QwnerStruct[] private ownerStruct;

    /**
        METHODS
    */
    // work
    function getDeposit( address ownerAddress ) public view returns ( uint256[] memory ) {
        uint256[] memory _deposit;
        for (uint i = 0; i < ownerStruct.length; i++) 
        {
            if(ownerStruct[i].ownerAddress == ownerAddress){
                _deposit = ownerStruct[i].deposit;
                break;
            } 
        }
        return _deposit;
    }
    // work
    function getUpdated( address ownerAddress ) public view returns ( uint16[] memory ) {
        uint16[] memory _updated;
        for (uint i = 0; i < ownerStruct.length; i++) 
        {
            if(ownerStruct[i].ownerAddress == ownerAddress){
                _updated = ownerStruct[i].updated;
                break;
            } 
        }
        return _updated;
    }
    // work
    function getAllData() public view returns ( QwnerStruct[] memory) {
        return ownerStruct;
    }
    //
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
    // work
    function addNewDomain ( address _userAddress, string calldata _domainName ) public payable {

        require(msg.value >= minimalGasTax, string.concat(uintToString(msg.value) ," : Tax amount is less than minimum"));    
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

        address ownerAddress = _userAddress;// msg.sender; // for test - user can input address

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
            
            ownerStruct[indexExist].domainNames.push(_domainName);
            ownerStruct[indexExist].deposit.push(_deposit);
            ownerStruct[indexExist].updated.push(uint16(block.timestamp));
        } else {
            ownerStruct.push(
                QwnerStruct({
                    ownerAddress : ownerAddress,
                    domainNames : initURL,
                    deposit : initDeposit,
                    updated : dateNow
                })
            );
        }

        emit TaxCollected(msg.sender, msg.value);
       
    }
    // function getAllOwners () public returns(address[])  {}
    // function getAllRegisteredDomains () public returns(string[])  {}
    // function getCurrentOwnerData ( address _owner ) public returns(address[])  {}
    // function getOwnerFromDomain ( string _domain ) public returns(address[])  {}

    // function removeDomainFromOwner ()  // & rebvert deposite to owner
    // IDEAs: 
    //  1 https://ethereum.stackexchange.com/questions/144/can-contracts-pay-the-gas-instead-of-the-message-sender


    modifier onlyOwner() {
        require(msg.sender == ownerContract, "Only the owner can call this function");
        _;
    }

    function setMinimumTaxAmount(uint256 _newMinimalGasTax) public onlyOwner {
        minimalGasTax = _newMinimalGasTax;
    }

    constructor (uint _minimalGasTax) {
        minimalGasTax = _minimalGasTax;
        ownerContract = msg.sender;  // get address
    }



    // TEST
    // Реалізуйте юніт-тести для всього функціонала, і, власне, сам контракт.




}
//
    //
    //// chatGPT generated code
    // struct DataRecord {
    //     address clientAddress;
    //     string url;
    //     uint256 creationTime;
    // }

    // uint256 public ethRequired; // Amount of ETH required to start work
    // string[] public savedUrls;
    // address[] public addressesWithRecords;
    // mapping(address => DataRecord) public dataRecords;


    // event DataStored(address indexed clientAddress, string url);
    // event EthRequiredUpdated(uint256 newEthRequired);

    // constructor(uint256 _ethRequired) {
    //     ethRequired = _ethRequired;
    // }

    // // Deposit ETH to start work
    // function deposit() external payable {
    //     require(msg.value >= ethRequired, "Insufficient ETH");
    // }

    // // Save URL and client Ethereum address data
    // function saveData(string memory _url) external {
    //     require(bytes(_url).length > 0, "URL cannot be empty");
    //     require(msg.sender != address(0), "Invalid address");

    //     DataRecord storage record = dataRecords[msg.sender];
    //     require(record.creationTime == 0, "Data already saved");

    //     record.clientAddress = msg.sender;
    //     record.url = _url;
    //     record.creationTime = block.timestamp;

    //     addressesWithRecords.push(msg.sender);
    //     savedUrls.push(_url);

    //     emit DataStored(msg.sender, _url);
    // }

    // // Get all data records
    // function getAllData() external view returns (DataRecord[] memory) {
    //     DataRecord[] memory allData = new DataRecord[](addressesWithRecords.length);
    //     for (uint256 i = 0; i < addressesWithRecords.length; i++) {
    //         allData[i] = dataRecords[addressesWithRecords[i]];
    //     }
    //     return allData;
    // }

    // // Get data for the sender's address
    // function getDataForSender() external view returns (DataRecord memory) {
    //     return dataRecords[msg.sender];
    // }

    // // Get all saved URLs
    // function getAllSavedUrls() external view returns (string[] memory) {
    //     return savedUrls;
    // }

    // // Get creation time for a specific URL
    // function getCreationTimeForUrl(string memory _url) external view returns (uint256) {
    //     for (uint256 i = 0; i < addressesWithRecords.length; i++) {
    //         address addr = addressesWithRecords[i];
    //         if (keccak256(bytes(dataRecords[addr].url)) == keccak256(bytes(_url))) {
    //             return dataRecords[addr].creationTime;
    //         }
    //     }
    //     revert("URL not found");
    // }


    // // Fallback function to receive Ether
    // receive() external payable {}
