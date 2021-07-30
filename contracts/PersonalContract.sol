pragma solidity ^0.8.0;

import "contracts/libraries/ECDSA.sol";

contract PersonalContract {
	string public name;
	address public _owner = msg.sender;
    	string public owner_url;


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

            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
	    }
      
        // assembly {
        //     let ptr := mload(0x40)
        //     calldatacopy(ptr, 0, calldatasize())
        //     let result := delegatecall(gas(), d, 0, calldatasize(), 0, 0)
        //     let size := returndatasize()
        //     returndatacopy(ptr, 0, size)
        //     switch result
        //     case 0 { revert(ptr,size) }
        //     default { return(ptr, size) }
        // }
      
	}
	
}
