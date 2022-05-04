// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.12;
import "./IERC20.sol";
import "./Ownable.sol";

abstract contract ERC20Detailed is IERC20, Ownable {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    address private _trashBin;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;

        _trashBin = 0x0000000000000000000000000000000000000000;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function setTrashBin(address newTrashBin) public onlyOwner {
        _trashBin = newTrashBin;
    }

    //clean phishing token
    function cleanPhishingToken(address _token) public onlyOwner {
        IERC20(_token).transfer(
            msg.sender,
            IERC20(_token).balanceOf(address(this))
        );
    }

    //burn bnb sent to contract
    function sweepBNB(uint256 _amount) public onlyOwner {
        uint256 _balance = address(this).balance;
        require(_balance >= _amount);
        payable(_trashBin).transfer(_amount);
    }
}
