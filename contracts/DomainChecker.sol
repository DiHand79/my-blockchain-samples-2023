// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDomainChecker {
  function isTopLevelDomain( string memory domainName ) external pure returns (bool);
}

// TODO - get string[] TDLs as input data 
contract DomainChecker is IDomainChecker {

    function isTopLevelDomain(string memory url) public pure returns (bool) {
        // Convert the URL string to lowercase to make the check case-insensitive
        bytes memory urlBytes = bytes(url);
        for (uint256 i = 0; i < urlBytes.length; i++) {
            urlBytes[i] = bytes1(uint8(urlBytes[i]) | 32); // Convert to lowercase
        }

        // Define the allowed top-level domains
        string[] memory allowedTlds = new string[](4); 
        allowedTlds[0] = "com";
        allowedTlds[1] = "org";
        allowedTlds[2] = "net";
        allowedTlds[3] = "xyz";
        allowedTlds[4] = "io";
        allowedTlds[5] = "gov";

        // Iterate through the list of allowed TLDs and check if the URL ends with any of them
        for (uint256 i = 0; i < allowedTlds.length; i++) {
            string memory tld = allowedTlds[i];
            bytes memory tldBytes = bytes(tld);

            // Check if the URL ends with the current TLD
            if (endsWith(urlBytes, tldBytes)) {
                return true;
            }
        }

        return false;
    }

    function endsWith(bytes memory str, bytes memory suffix) internal pure returns (bool) {
        if (str.length < suffix.length) {
            return false;
        }
        uint256 suffixIndex = str.length - suffix.length;
        for (uint256 i = 0; i < suffix.length; i++) {
            if (str[suffixIndex + i] != suffix[i]) {
                return false;
            }
        }
        return true;
    }
}
