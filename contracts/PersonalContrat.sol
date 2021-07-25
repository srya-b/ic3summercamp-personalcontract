pragma solidity ^0.8.0;

contract PersonalContract {
	string public name;
	address owner = msg.sender;

	modifier onlyOwner() {
		require (msg.sender == owner);
		_;
	}

	constructor (string memory _name) public {
		name = _name;
	}
}
