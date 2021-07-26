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
        bool cancelled;
        string reason;
        // TODO: maybe something for "where" either physical or virtual? (privacy)
    }


    mapping (address => uint256) balances;
    mapping (uint256 => Event) events;

	modifier onlyOwner() {
		require (msg.sender == owner);
		_;
	}

    event NewEvent(uint256 indexed eventHash, address indexed fro, uint256 timestamp);
    event Cancelled(uint256 indexed eventHash, address indexed fro, string reason);
    event Blocked(address indexed who, string reason);

	constructor (string memory _name) public {
		name = _name;
	}
	
	
    function redeemCard(bytes32 hash, uint8 v, bytes32 r, bytes32 s) external override returns (bool) {
        require( ECDSA.recover(hash, v, r, s) == owner );
        balances[msg.sender] += 1;
        return true;
    }
    
    // Redeems one hour slot for a specific timestamp
    function scheduleHour(uint256 time_since_epoch) external override returns (bool) {
        require(balances[msg.sender] >= 1);
        require(block.timestamp <= time_since_epoch);
        balances[msg.sender] -= 1;
        
        uint256 key = uint256(uint160(address(msg.sender)))  ^ time_since_epoch;
        events[key] = Event(key, msg.sender, time_since_epoch, false, "");
        
        emit NewEvent(key, msg.sender, time_since_epoch);
        return true;
    }
    
    
    /*  Conract owner actions */
    
    // decline the communication with a string reason why and return of spent "token" (? is token the right word)?
    function declineHour(uint256 eventHash, string memory reason) external override {
        Event storage e = events[eventHash];
        require( events[eventHash].who != address(0) );
        require( e.cancelled == false);
        require(block.timestamp >= e.epoch_timestamp);
        
        e.cancelled = true;
        e.reason = reason;
        // TODO: maybe we should have some kind of contract callback when cancelling instead of scheduler watching for some event?
        
        emit Cancelled(e.eventHash, e.who, e.reason);
    }
    
    // decline and remove the user's allowed schedule slots
    function declineAndBlock(uint256 eventHash, string memory reason) external override returns (bool) {
        Event storage e = events[eventHash];
        require( events[eventHash].who != address(0) );
        require( e.cancelled == false);
        require(block.timestamp >= e.epoch_timestamp);
        
        e.cancelled = true;
        e.reason = true;
        
        balances[e.who] = 0;
        
        emit Blocked(e.who, reason);
        
        return true;
    }
    
    // block this address from creating future events (does this matter, user can use some other address and still redeem card)
    function blockUser(address to_block) public override returns (bool) {
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
