from ctypes import addressof
from scripts.deploy import deploy_banking
from brownie import accounts

#test_addbalance() is used for testing AddBalance() and ShowTotalBalance() functions
#brownie test -k test_addbalance
def test_addbalance():
    bank=deploy_banking()
    account=accounts[1]
    #Arrange
    temp=100

    #Act
    tx1=bank.AddBalance({'from':account,'value':temp})
    tx1.wait(1)
    tx2=bank.ShowTotalBalance({'from':account})
    tx2.wait(1)

    #Assert
    assert bank.balances_principle(account)==temp 
    assert bank.totalBankBalance()==temp

#test_withdrawl is used for testing Withdrawl() function
#brownie test -k test_withdrawl
def test_withdraw():
    bank=deploy_banking()
    account=accounts[1]
    temp=100

    tx1 = bank.AddBalance({'from':account,'value':temp})
    tx1.wait(1)
    tx2 = bank.Withdraw(temp,{'from':account})
    tx2.wait(1)

    assert bank.balances_principle(account)==0

#test_transfer is used to test Transfer() function
#brownie test -k test_transfer
def test_transfer():
    bank=deploy_banking()
    account_sender=accounts[1]
    account_reciever=accounts[2]
    deposit=100
    transfer=50

    tx1 = bank.AddBalance({'from':account_sender,'value':deposit})
    tx1.wait(1)
    tx2 = bank.Transfer(account_reciever,transfer,{'from':account_sender})
    tx2.wait(1)

    assert bank.balances_principle(account_sender)==deposit-transfer
    assert bank.balances_principle(account_reciever)==transfer
