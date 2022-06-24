// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {Vm} from "forge-std/Vm.sol";
import {NOOBPOINTSToken} from "../NoobPointsToken.sol";
import "../NoobCtfChallengesWeek1.sol";
import "../Chagecontract_Week1.sol";

contract ContractTest is Test {
    Utilities internal utilities;
    NOOBPOINTSToken  internal noobpotiontoken;
    NoobCtfChallengesWeek1 internal noobctfchallengesweek1;
    ChageContractWeek1 internal chagecontractweek1;
    address payable[] internal users;
    bytes32 internal chagecontract_hash;
    address internal constant ContractOwners = 0x0000000000000000000000000000000000000007; 
    address internal Ctf_Challenger;
    address internal TroubleMaker;
    function setUp() public {
        vm.prank(ContractOwners);
        chagecontractweek1 = new ChageContractWeek1();
        chagecontract_hash = keccak256(abi.encodePacked(address(chagecontractweek1)));

        vm.prank(ContractOwners);
        noobpotiontoken = new NOOBPOINTSToken();
        
        noobctfchallengesweek1 = new NoobCtfChallengesWeek1(address(noobpotiontoken),chagecontract_hash);
        
        utilities = new Utilities();
        
        users = utilities.createUsers(2);
        Ctf_Challenger = users[0];
        vm.label(Ctf_Challenger,"Ctf_Challenger");
        TroubleMaker = users[1];
        vm.label(TroubleMaker,"TroubleMaker");
        vm.deal(ContractOwners, 100 ether);
        }

    function testContractOwners() public {
        assertTrue(noobpotiontoken.owner() == ContractOwners);
    }

    function testFailProhibitedTransfer() public {
        noobpotiontoken.transfer(Ctf_Challenger, 10000);
        noobpotiontoken.transferFrom(ContractOwners ,Ctf_Challenger, 1000); 
    }

    function testFailTroubleMakersendpotion() public {
        vm.startPrank(TroubleMaker);
        noobpotiontoken.sendpotion(TroubleMaker,10000);
    }

    function testCtfContractseadPoint() public {
        vm.prank(ContractOwners);
        noobpotiontoken.setPointcontract(address(noobctfchallengesweek1),true);
        vm.prank(address(noobctfchallengesweek1));
        noobpotiontoken.sendpotion(Ctf_Challenger,10000);
    }

    function testFailTroubleMakerset() public{
        noobpotiontoken.setPointcontract(address(0), true);
    }
    function testFailTroubleset() public {
        noobctfchallengesweek1.change("test", 123456);
    }

    function testCompletethechallenge() public{
        vm.prank(ContractOwners);
        noobpotiontoken.setPointcontract(address(noobctfchallengesweek1), true);
        vm.prank(address(chagecontractweek1));
        noobctfchallengesweek1.change("link", 123456);
        bytes32 _password = vm.load(address(noobctfchallengesweek1), bytes32(uint256(2)));
        emit log_bytes32(_password);
        utilities.mineBlocks(31231223123123123132131321);
        vm.startPrank(Ctf_Challenger);
        noobctfchallengesweek1.checkPassword(123456);
        noobpotiontoken.balanceOf(msg.sender) == 10000000000000000000;
        bytes32 _chagepassword = vm.load(address(noobctfchallengesweek1), bytes32(uint256(2)));
        emit log_uint(uint256(_chagepassword));
        console.log(block.number);
    }

    function testFailSameAddressComplet() public {
        vm.prank(ContractOwners);
        noobpotiontoken.setPointcontract(address(noobctfchallengesweek1), true);
        vm.prank(address(chagecontractweek1));
        noobctfchallengesweek1.change("link", 123456);
        vm.startPrank(Ctf_Challenger);
        noobctfchallengesweek1.checkPassword(123456);
        bytes32 _newpassword = vm.load(address(noobctfchallengesweek1), bytes32(uint256(2)));
        emit log_uint(uint256(_newpassword));
        noobctfchallengesweek1.checkPassword(uint256(_newpassword));
    }
}



