pragma solidity ^0.8.0;

interface IPersonalContract {
    
    // Redeem a signature given in the qr code of a paper wallet. A single hour long time slot is awarded to 
    // redeem at some future time;
    function redeemCard(bytes32 hash, uint8 v, bytes32 r, bytes32 s) external returns (bool);
    
    // Redeems one hour slot for a specific timestamp
    function scheduleHour(uint256 time_since_epoch) external returns (bool);
    
    
    /*  Conract owner actions */
    
    // decline the communication with a string reason why and return of spent "token" (? is token the right word)?
    function declineHour(uint256 eventHash, string memory reason) external;
    
    // decline and remove the user's allowed schedule slots
    function declineAndBlock(uint256 eventHash, string memory reason) external returns (bool);
    
    // block this address from creating future events (does this matter, user can use some other address and still redeem card)
    function blockUser(address to_block) external returns (bool);
    
    // TODO: set some website? or some bio information?
    
    /* Functions anyone can call */
    function destroyPastEvents(uint256 eventHash) external returns (bool);
    
    
    
}