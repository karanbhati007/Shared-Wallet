//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Ownable{
    event AllowanceChanged(address indexed _forWho,address indexed _byWhom,uint oldAmt,uint newAmt);
    mapping(address => uint) public allowance;
    
    function isOwner() internal view returns(bool){
        return owner() == msg.sender;
    }

    modifier ownerOrAny(uint _amount){
        require(isOwner() || allowance[msg.sender] >= _amount , "Not Allowed, You Don't have enough Allowance !!");
        _;
    }

    function changeAllowance(address _who,uint _amount) public onlyOwner {
        emit AllowanceChanged(_who,msg.sender,allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    function reduceAllowance(address _who, uint _amount) internal ownerOrAny(_amount){
        emit AllowanceChanged(_who,msg.sender,allowance[_who],allowance[_who] - _amount);
        allowance[_who] -= _amount;
    }


}

