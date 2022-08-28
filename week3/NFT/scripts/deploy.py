from brownie import myNFT
import time
import yaml

def deploy_mynft():
    admin = accounts[0]
    mynft = myNFT.deploy({
        'from': admin
    })
    time.sleep(1)
    return mynft

def main():
    deploy_mynft()