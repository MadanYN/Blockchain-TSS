from web3 import Web3
ganache_url = 'http://127.0.0.1:7545'
web3 = Web3(Web3.HTTPProvider(ganache_url))
account_1 = '0x113a66C5e8e194d2bc617f7054A0044AE08F1137'
account_2 = '0xeE829d7554e7D630fFca02D223A987ED5782ed31'

private_key = '3e2e15e0d04946b7999b42fe0238951673512c6e70a4c0698dc9ffc215d1a26c'

nonce = web3.eth.getTransactionCount(account_1)

tx = {
    'nonce': nonce,
    'to': account_2,
    'value': web3.toWei(100,'finney'),
    'gas': 200000,
    'gasPrice': web3.toWei('50','gwei')
}
signed_tx = web3.eth.account.signTransaction(tx,private_key)
tx_hash = web3.eth.sendRawTransaction(signed_tx.rawTransaction)