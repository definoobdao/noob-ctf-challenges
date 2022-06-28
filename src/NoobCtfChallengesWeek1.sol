// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface Inoobpoint {
    function sendpotion(address recipient, uint256 amount) external;
    function getnickname(address challenger) external returns(string memory);
}

contract NoobCtfChallengesWeek1{
    mapping (address => bool) isComplete;
    bytes32 private chagecontract_hash;
    uint256 private password;  //█████
    string[] private discrod_link = ["REDACTED"]; //https://discord.gg/█████████
    Inoobpoint public pointcontract;
    
    event CompleteCtflog(address indexed challenger, string nickname, string message);
    
    constructor(address _pointcontract, bytes32 _chagecontract_hash){
        pointcontract =  Inoobpoint(_pointcontract);
        chagecontract_hash = _chagecontract_hash;
    }

    function checkPassword(uint256 _password) public {
        require(_password == password && !isComplete[msg.sender],"ngmi");
        isComplete[msg.sender] = true;
        unchecked {password = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)));}
        pointcontract.sendpotion(msg.sender, 10);
        emit CompleteCtflog(msg.sender, pointcontract.getnickname(msg.sender) , "Complete the first week of challenges");
    }

    function change(string calldata newlink, uint256 newpassword) public {
        require(keccak256(abi.encodePacked(msg.sender)) == chagecontract_hash,"u can't change anything");
        discrod_link[0] = newlink;
        password = newpassword;
    }
}