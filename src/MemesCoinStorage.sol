// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

library MemesCoinStorage {
    struct Layout {
        uint256 mintingAllowedAfter;
    }

    bytes32 internal constant STORAGE_SLOT = keccak256("memescoin.storage");

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
