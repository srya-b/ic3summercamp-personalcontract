pragma solidity ^0.8.0;

interface IPersonalContract {
    struct Event {
        bool enabled;
        uint256 when;
        address who;
        bool open;
        // TODO: maybe something for "where" either physical or virtual? (privacy)
    }

    // Redeem a signature given in the qr code of a paper wallet. A single hour long time slot is awarded to 
    // redeem at some future time;
    function redeemCard(bytes32 hash, uint8 v, bytes32 r, bytes32 s) external returns (bool);
    
    // Redeems one hour slot for a specific timestamp
    //function scheduleSlot(uint256 when, uint256 slot) external returns (bool);
    function scheduleSlot(uint256 num) external returns (bool);

    
    function getEvent(uint256 num) external view returns (Event memory);
    
    /*  Conract owner actions */
    
    function addEvent(uint256 when) external returns (bool);

    
    // decline the communication with a string reason why and return of spent "token" (? is token the right word)?
    //function decline(uint256 when, string memory reason) external returns (bool);
    
    // block this address from creating future events (does this matter, user can use some other address and still redeem card)
//    function blockUser(address who, string memory reason) external returns (bool);
    function blockAddress(address who) external returns (bool);

    // TODO: set some website? or some bio information?
    
    /* Functions anyone can call */
    function destroyPastEvents(uint256 eventHash) external returns (bool);
    
    
    
}