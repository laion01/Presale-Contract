pragma solidity ^0.8.10;

abstract contract ReentrancyGuard {

    bool private _notEntered;

    constructor () {

        _notEntered = true;
    }

    modifier nonReentrant() {

        require(_notEntered, "ReentrancyGuard: reentrant call");

        _notEntered = false;
        _;
        _notEntered = true;
    }
}