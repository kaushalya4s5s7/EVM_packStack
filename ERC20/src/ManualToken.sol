//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract ManualToken{
    mapping (address=> uint256) public s_balances;

    error BalanceMismatch(address account, uint256 expected, uint256 actual);

    function name() public pure returns(string memory){
        return "ManualToken";
    }
    function totalSupply() public pure returns(uint256 supply){
        return 100 ether;
    }
    function decimals() public pure returns(uint8 decimal){
        return 18;
    }
    function balanceOf(address _owner) public view returns(uint256 balance){
        return s_balances[_owner];
    }
    function transfer(address _to, uint256 _amount) public {
        uint256 previousBalances = balanceOf(msg.sender) + balanceOf(_to);
        s_balances[msg.sender] -= _amount;
        s_balances[_to] += _amount;
        revert BalanceMismatch({
            account: msg.sender,
            expected: previousBalances,
            actual: balanceOf(msg.sender) + balanceOf(_to)
        });
     }
}