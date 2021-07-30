pragma solidity ^0.8.0;

import "contracts/libraries/ECDSA.sol";

contract PersonalContractProxy {
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
    event TestEvent(address a);

    struct Event {
        bool enabled;
        uint256 when;
        address who;
        bool open;
        // TODO: maybe something for "where" either physical or virtual? (privacy)
    }
    
    function redeemCard(bytes32 hash, uint8 v, bytes32 r, bytes32 s) external returns (bool) {
        require( allowed[ECDSA.recover(hash, v, r, s)] == true );
        balances[msg.sender] += 1;
        return true;
    }
    
    //function getEvent(uint256 num) public view returns (uint256 when, address who, bool cancelled, string memory reason) {
    function getEvent(uint256 num) public view returns (Event memory) {
        Event storage e = events[whenFromNum[num]];
        return e;
    }
    
    function scheduleSlot(uint256 num) onlyAllowed external returns (bool) {
        require(balances[msg.sender] > 0);
        Event storage e = events[num];
        require(e.enabled == true);
        require(e.open == true);
        
        e.open = false;
        e.who = msg.sender;
        balances[msg.sender] -= 1;
        
        emit NewEvent(e.when, e.who);
        return true;
    }
    
    /*  Conract owner actions */

    
    function addEvent(uint256 when) onlyOwner external returns (bool) {
        numEvents += 1;
        
        events[when].enabled = true;
        events[when].open = true;
        events[when].when = when;
        
        whenFromNum[numEvents] = when;
        return true;
    }
    
    function blockAddress(address who) public returns (bool) {
        require(balances[who] > 0);
        balances[who] = 0;
        return true;
    }
    
    function approveAddress(address a) public returns (bool) {
        allowed[a] = true;
    }
    
    // TODO: set some website? or some bio information?
    
    /* Functions anyone can call */
    function destroyPastEvents(uint256 eventHash) external returns (bool) {
        // TODO implementation
        return true;
    }


}