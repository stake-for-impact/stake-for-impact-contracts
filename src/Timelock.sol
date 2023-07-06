// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {TimelockController} from "openzeppelin-contracts/governance/TimelockController.sol";
import {Ownable} from "openzeppelin-contracts/access/Ownable.sol";

contract Timelock is Ownable, TimelockController {
    constructor(
        uint256 minDelay, address[] memory proposers, address[] memory executors, address admin
    ) TimelockController( minDelay, proposers, executors, admin)  {

    }
}