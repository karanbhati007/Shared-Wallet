//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "./Allowance.sol";

contract MySharedWallet is Allowance{
    //address private owner;
    event MoneySent(address indexed _to,uint amount);
    event MoneyRecieved(address indexed _from, uint amount);


    function reciveMoney() payable public{
        emit MoneyRecieved(msg.sender, msg.value);
    }    

    // Deposit by Anyone from outside !!
    receive() external payable{
        reciveMoney();
    }

    function renounceOwnership() public view override onlyOwner {
        revert("can't renounceOwnership here");
    }

    function withdrawMoney(address payable _to,uint _amount) public ownerOrAny(_amount){
        require(address(this).balance >= _amount, "Contract has Insufficient Balance !!");
        if(!isOwner()){
            reduceAllowance(msg.sender,_amount);
        }
        emit MoneySent(_to,_amount);
        _to.transfer(_amount);
    }


    function getCurrSmartConBalance() public view returns(uint){
        return address(this).balance;
    }

}