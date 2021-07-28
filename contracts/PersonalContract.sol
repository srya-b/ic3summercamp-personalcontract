pragma solidity ^0.8.0;

import "contracts/libraries/ECDSA.sol";

contract PersonalContract {
	string public name;
	address public _owner = msg.sender;

    mapping (address => uint256) public balances;
    mapping (uint256 => Event) public events;
    mapping (uint256 => uint256) public whenFromNum;
    mapping (address => bool) public allowed;
    address delegate;

    uint256[] public seedSlots;
    uint256 public interval;
    uint256 public numEvents;
    
    uint256 constant ONEDAY = 86400;
    uint256 constant ONEWEEK = 604800;

	modifier onlyOwner() {
		require (msg.sender == _owner);
		_;
	}

    modifier onlyAllowed() {
        require(allowed[msg.sender] == true);
        _;
    }

    event NewEvent(uint256 indexed when, address indexed who);
    event Cancelled(uint256 indexed when, address indexed who, string reason);
    event Blocked(address indexed who, string reason);
    
    struct Event {
        bool enabled;
        uint256 when;
        address who;
        bool open;
        // TODO: maybe something for "where" either physical or virtual? (privacy)
    }


    // function events(uint256 key) external view returns (Event memory e) {
    //     e = _events[key];
    // }
    
    // function whenFromNum(uint256 key) external view returns (uint256 w) {
    //     w = _whenFromNum[key];
    // }
    
    // function allowed(address key) external view returns (bool b) {
    //     b = _allowed[key];
    // }
    
    // function numEvents() external view returns (uint256 n) {
    //     n = _numEvents;
    // }
    
    // function owner() external returns (address o) {
    //     o = _owner;
    // }

    /*
      _name: name of the user
      slots: an array representing the starting timestamp of the hourlong slots you have destroyPastEvents
      interval: how do these slots repeat? interval could be 1 week so the contract accesses the slot mapping contract 
                slot[i] and  slot[i] + interval and slot[i] + 2*interval, and so on for all slots
    */
	constructor (string memory _name, address _delegate) public {
	   // require(period == ONEDAY || period == ONEWEEK);
		name = _name;
		delegate = _delegate;

	}
	
	function updateDelegate(address d) onlyOwner external {
	    delegate = d;
	}
	
	
	fallback () external {
	    address d = delegate;
	    assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), d, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
	    }
        // assembly {
        //     let _target := sload(0)
        //     calldatacopy(0x0, 0x0, calldatasize()) 
        //     let retval := delegatecall(gas(), _target, 0x0, calldatasize(), 0x0, 0)
        //     let returnsize := returndatasize()
        //     returndatacopy(0x0, 0x0, returnsize)
        //     switch retval case 0 {revert(0, 0)} default {return (0, returnsize)}
        // }
	}
	
	
    // function redeemCard(bytes32 hash, uint8 v, bytes32 r, bytes32 s) external override returns (bool) {
    //     require( allowed[ECDSA.recover(hash, v, r, s)] == true );
    //     balances[msg.sender] += 1;
    //     return true;
    // }
    
    //function getEvent(uint256 num) public view returns (uint256 when, address who, bool cancelled, string memory reason) {
    // function getEvent(uint256 num) public override view returns (Event memory) {
    //     Event storage e = events[whenFromNum[num]];
    //     return e;
    //     // when = e.when;
    //     // who = e.who;
    //     // cancelled = e.cancelled;
    //     // reason = e.reason;
    // }
    
    // Redeems one hour slot for a specific timestamp
    // function scheduleSlot(uint256 slot, uint256 when) external override returns (bool) {
    //     require(balances[msg.sender] >= 1);
    //     require(block.timestamp <= when);
    //     require((when - seedSlots[slot]) % interval == 0 );
    //     require(events[when].who == address(0));
        
    //     balances[msg.sender] -= 1;
    //     numEvents += 1;
        
    //     events[when] = Event(when, msg.sender, false, "");
    //     whenFromNum[numEvents] = when;
        
    //     emit NewEvent(when, msg.sender);
    //     return true;
    // }
    
    
    // function scheduleSlot(uint256 num) onlyAllowed override external returns (bool) {
    //     require(balances[msg.sender] > 0);
    //     Event storage e = events[num];
    //     require(e.enabled == true);
    //     require(e.open == true);
        
    //     e.open = false;
    //     e.who = msg.sender;
    //     balances[msg.sender] -= 1;
        
    //     emit NewEvent(e.when, e.who);
    //     return true;
    // }
    
    /*  Conract owner actions */

    
    // function addEvent(uint256 when) onlyOwner override external returns (bool) {
    //     numEvents += 1;
    //     events[numEvents].enabled = true;
    //     events[numEvents].when = when;
    //     return true;
    // }
    
    // function decline(uint256 when, string memory reason) external override returns (bool) {
    //     Event storage e = events[when];
    //     require( events[when].who != address(0) );
    //     require( e.cancelled == false );
    //     require(block.timestamp >= e.when);
        
    //     e.cancelled = true;
    //     e.reason = reason;

    //     emit Cancelled(when, e.who, e.reason);
    //     return true;
    // }
    
    // block this address from creating future events (does this matter, user can use some other address and still redeem card)
    // function blockUser(address who, string memory reason) public override returns (bool) {
    //     // TODO implementation
    //     require(balances[who] > 0);
    //     balances[who] = 0;
        
    //     emit Blocked(who, reason);
    //     return true;
    // }
    
    
    // function blockAddress(address who) public override returns (bool) {
    //     require(balances[who] > 0);
    //     balances[who] = 0;
    //     return true;
    // }
    
    // TODO: set some website? or some bio information?
    
    /* Functions anyone can call */
    // function destroyPastEvents(uint256 eventHash) external override returns (bool) {
    //     // TODO implementation
    //     return true;
    // }

	
}
