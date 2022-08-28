from brownie import banking, accounts

def deploy_banking():
    admin = accounts[0]
    bank=banking.deploy({
        'from':admin
    })
    return bank

def main():
    deploy_banking() 