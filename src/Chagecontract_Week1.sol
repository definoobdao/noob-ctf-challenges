// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "@openzeppelin/contracts/access/Ownable.sol";
    interface Inoobctfchallengesweek1 {
        function change(string calldata newlink, uint256 newpassword) external;
    }
contract ChageContractWeek1 is Ownable{
    Inoobctfchallengesweek1 public NoobctfchallengesweekContract;
    function set (address _NoobctfchallengesweekContract) public onlyOwner{
        NoobctfchallengesweekContract = Inoobctfchallengesweek1(_NoobctfchallengesweekContract);
    }
    
    function change(string calldata newlink, uint256 newpassword) public onlyOwner{
        NoobctfchallengesweekContract.change(newlink, newpassword);
    }
}