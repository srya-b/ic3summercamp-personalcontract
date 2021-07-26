pragma solidity ^0.8.0;

import "contracts/IPersonalContract.sol";
import "contracts/libraries/ECDSA.sol";

contract PersonalContract is IPersonalContract {
	string public name;
	address owner = msg.sender;

    struct Event {
        uint256 eventHash;
        address who;
        uint256 epoch_timestamp;
        // TODO: maybe something for "where" either physical or virtual? (privacy)
    }

    mapping (uint256 => Event) events;

	modifier onlyOwner() {
		require (msg.sender == owner);
		_;
	}

	constructor (string memory _name) public {
		name = _name;
	}
	
	
    function redeemCard(bytes32 hash, uint8 v, bytes32 r, bytes32 s) external override returns (bool) {
        // TODO implementation
        return true;
    }
    
    // Redeems one hour slot for a specific timestamp
    function scheduleHour(uint256 time_since_epoch) external override returns (bool) {
        // TODO implementation
        return true;
    }
    
    
    /*  Conract owner actions */
    
    // decline the communication with a string reason why and return of spent "token" (? is token the right word)?
    function declineHour(uint256 eventHash, string memory reason) external override {
        // TODO implementation
    }
    
    // decline and remove the user's allowed schedule slots
    function declineAndRescindHour(uint256 eventHash, string memory reason) external override returns (bool) {
        // TODO implementation
        return true;
    }
    
    // block this address from creating future events (does this matter, user can use some other address and still redeem card)
    function blockUser(address to_block) external override returns (bool) {
        // TODO implementation
        return true;
    }
    
    // TODO: set some website? or some bio information?
    
    /* Functions anyone can call */
    function destroyPastEvents(uint256 eventHash) external override returns (bool) {
        // TODO implementation
        return true;
    }

	
}
