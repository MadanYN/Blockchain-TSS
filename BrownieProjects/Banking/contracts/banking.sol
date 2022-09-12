pragma solidity ^0.8.0;

contract banking{
    mapping(address => uint)private balances;
    mapping(address => uint)public balances_principle;
    mapping(address => uint)private times; //map to save time for intreset calculation

    uint private yearToSec = 31556926;
    uint private intresetRate = 7; //intrest rate is assumed to be 7% per year
    uint public totalBankBalance;
    
    modifier onlyAfter(address _address, uint _amount){
        balances[_address] += (((block.timestamp-times[_address])*balances_principle[_address]*intresetRate)/yearToSec)/100;
        require(balances[_address] >= _amount, "You don't have enough balance in your account");
        _;
    }
    modifier bankReservoir(uint _amount){
        require(address(this).balance >= _amount, "Oops!! not enough money in bank");
        _;
    }
    event showTotalBalance(address _address);
    event showBalance(address _address, uint balance);
    event addBalance(address _address, uint addedBalance);
    event transfer(address sender, address receiver, uint sentAmount);
    event withdraw(address account, uint withdrawnAmount);

    function ShowTotalBalance() public returns(uint){
        emit showTotalBalance(address(this));
        totalBankBalance=address(this).balance;
        return totalBankBalance;
    }
    function ShowBalance(address _address) public returns (uint) {
        balances[_address] += (((block.timestamp-times[_address])*balances_principle[_address]*intresetRate)/yearToSec)/100;
        times[_address]=block.timestamp;
        emit showBalance(_address, balances[_address]);
        return balances[_address];
    }
    function AddBalance() external payable{
        balances[msg.sender] += (((block.timestamp-times[msg.sender])*balances_principle[msg.sender]*intresetRate)/yearToSec)/100;
        balances_principle[msg.sender] += msg.value;
        balances[msg.sender] += msg.value;
        times[msg.sender] = block.timestamp;
        emit addBalance(msg.sender, msg.value);

    }
    function Withdraw(uint _amount) external payable bankReservoir(_amount) onlyAfter(msg.sender,_amount){
        balances[msg.sender] -= _amount;
        balances_principle[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        emit withdraw(msg.sender,_amount);
    }
    function Transfer(address payable _address, uint _amount) external payable bankReservoir(_amount) onlyAfter(msg.sender,_amount){
        balances[msg.sender] -= _amount;
        balances[_address] += _amount;
        balances_principle[msg.sender] -= _amount;
        balances_principle[_address] += _amount;
        _address.transfer(_amount);
        emit transfer(msg.sender,_address,_amount);
    }

}