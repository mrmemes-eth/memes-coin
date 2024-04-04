// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {SolidStateERC20} from "lib/solidstate-solidity/contracts/token/ERC20/SolidStateERC20.sol";
import {ERC20BaseInternal} from "lib/solidstate-solidity/contracts/token/ERC20/base/ERC20BaseInternal.sol";
import {
    ERC20Snapshot,
    ERC20SnapshotInternal
} from "lib/solidstate-solidity/contracts/token/ERC20/snapshot/ERC20Snapshot.sol";
import {Ownable} from "lib/solidstate-solidity/contracts/access/ownable/Ownable.sol";
import {MemesCoinStorage} from "./MemesCoinStorage.sol";

contract MemesCoin is SolidStateERC20, ERC20Snapshot, Ownable {
    uint256 public constant SUPPLY_CAP = 10_000_000_000 ether; // 10 billion
    uint256 public constant MAX_MINT_PERCENTAGE = 1;
    uint256 public constant MIN_TIME_BETWEEN_MINTS = 365 days;

    error SupplyCapExceeded();
    error MintingCapExceeded();
    error MintingDateNotReached();
    error MintToZeroAddressBlocked();

    // create diamond storage for mintingAllowedAfter date

    constructor() {
        _setName("MemesCoin");
        _setSymbol("$EMEM");
        _setDecimals(18);
        _setOwner(msg.sender);
        // don't allow minting again until after 1 year
        MemesCoinStorage.layout().mintingAllowedAfter = block.timestamp + MIN_TIME_BETWEEN_MINTS;
        _mint(msg.sender, (SUPPLY_CAP * MAX_MINT_PERCENTAGE) / 100);
    }

    function mintingAllowedAfter() public view returns (uint256) {
        return MemesCoinStorage.layout().mintingAllowedAfter;
    }

    function mint(address account, uint256 amount) external onlyOwner {
        if (block.timestamp < mintingAllowedAfter()) {
            revert MintingDateNotReached();
        }

        if (account == address(0)) {
            revert MintToZeroAddressBlocked();
        }

        // set the mintingAllowedAfter date
        MemesCoinStorage.layout().mintingAllowedAfter = block.timestamp + MIN_TIME_BETWEEN_MINTS;

        // check that the amount does not exceed the MAX_MINT_PERCENTAGE
        if (amount > (SUPPLY_CAP * MAX_MINT_PERCENTAGE) / 100) {
            revert MintingCapExceeded();
        }

        // check that the amount we will mint is less than or equal to the SUPPLY_CAP
        if (_totalSupply() + amount > SUPPLY_CAP) {
            revert SupplyCapExceeded();
        }

        _mint(account, amount);
    }

    function burn(address account, uint256 amount) external onlyOwner {
        _burn(account, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20SnapshotInternal, ERC20BaseInternal)
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}
