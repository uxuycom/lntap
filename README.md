# LnTap
LnTap is Lightning & Taproot Asset All-in-One Docker, and here is the cli guide for initial version,
We are going to provide webui to common users.

Step 1:
```
docker build -t lntap .
```
After Docker Build Successfully, you can run the docker image.

Step2:
```
docker run --privileged -it --rm -v ~/lntap:/root lntap:latest /bin/sh
```
or 
```
./lntap-run.sh
```

Step 3:
Start LND Node
```
./start-lnd.sh start
```
If you are running the lntap image before, you can use the following command to start lnd.
and enter your password to unlock your wallet otherwise your can not use lncli command.
unless you unlock the lnd can be work, and you can use tapd connect to it.
```
./start-lnd.sh restart
lncli unlock
```
You can tail the log by
```
tail -f /var/log/lnd-service.log
```

## lncli create
you can create a new wallet or import your seeds to restore your wallet.
Step 4:

if you do not have address
```
lncli create
```
Just folow the guide to create your wallet.
And backup your LNS Cipher Seed Mnemonic.

```
~ # lncli newaddress p2tr
[lncli] could not load global options: unable to read macaroon path (check the network setting!): open /root/.lnd/data/chain/bitcoin/mainnet/admin.macaroon: no such file or directory
~ # lncli create
Input wallet password: 
Confirm password: 

Do you have an existing cipher seed mnemonic or extended master root key you want to use?
Enter 'y' to use an existing cipher seed mnemonic, 'x' to use an extended master root key 
or 'n' to create a new seed (Enter y/x/n): n

Your cipher seed can optionally be encrypted.
Input your passphrase if you wish to encrypt it (or press enter to proceed without a cipher seed passphrase): 
Confirm password: 

Generating fresh cipher seed...

!!!YOU MUST WRITE DOWN THIS SEED TO BE ABLE TO RESTORE THE WALLET!!!

---------------BEGIN LND CIPHER SEED---------------
 1. abandon   2. water     3. hello     4. motor 
 5. jealous   6. age       7. analyst   8. audit 
 9. vintage  10. wall     11. sauce    12. cook  
13. crouch   14. velvet   15. analyst  16. option
17. stadium  18. correct  19. seminar  20. blast 
21. such     22. nice     23. charge   24. often 
---------------END LND CIPHER SEED-----------------

!!!YOU MUST WRITE DOWN THIS SEED TO BE ABLE TO RESTORE THE WALLET!!!

lnd successfully initialized!
```
Step 5:
Now create your TAPROOT address
```
lncli newaddress p2tr
```
You will get your TAPROOT address, save it and transfer some BTC to it.
```
~ # lncli newaddress p2tr
{
    "address": "bc1pydtk4dws04k5506h9j6slck97d22rflfx4puag99m5ec228pt4kste9z63"
}
~ # 
```
Save this address, and transfer some BTC to it.


 You can use the following command to check your wallet addresses.
```
lncli wallet addresses list
```

## Ensure the balance and going to tap daemon

## Running TAPRoot Asset Daemon Now
You can't start Tapd before LND Wallet created.
Step 6:
```
./start-tapd.sh start
```
Use the following command to view logs
```
 tail -f /var/log/tapd-service.log 
```
when you see the following log, it means tapd is running successfully.
```
2023-10-24 09:55:40.510 [INF] RPCS: Starting RPC Server
2023-10-24 09:55:40.511 [INF] RPCS: RPC server listening on 127.0.0.1:10029
2023-10-24 09:55:40.540 [INF] CONF: Starting HTTPS REST proxy listener at 127.0.0.1:8089
2023-10-24 09:55:40.542 [INF] RPCS: gRPC proxy started at 127.0.0.1:8089
2023-10-24 09:55:40.542 [INF] SRVR: Taproot Asset Daemon fully active!
```
Now You can start to use tapcli to create your assets.
Before you start to mint assets, your should check the balance of your wallet.
which is in step 5. You should at least have 0.0002 BTC in your wallet.
Use this command to check your balance.
```
lncli wallet addresses list
```
If you see the balance is not zero, you can start to mint your assets.

## Mint Token
```
tapcli --network=mainnet --tapddir=/root/.taproot-assets assets mint \
 --type normal --name beefbux --supply 100 \
 --meta_bytes "this is your memo" \
  --enable_emission
```
If you want to mint collectible assets, you can use the other command. 
You can find it in the taproot asset website or in the community.

## Finalize Mint
```
tapcli --network=mainnet --tapddir=~/.taproot-assets assets mint finalize
```

## Check the Assets List
```
tapcli --network=mainnet --tapddir=~/.taproot-assets tapcli assets list
```

## Sync Data to Universe
```
tapcli --network=mainnet --tapddir=~/.taproot-assets universe federation add --universe_host universe.lightning.finance
tapcli --network=mainnet --tapddir=~/.taproot-assets u sync --unverse_host universe.lightning.finance
```
## Receive Assets

### Generate the receive address
```
tapcli --network=mainnet --tapddir=~/.taproot-assets addrs new --asset_id ed43c09dd425ec25051c0e467ca1852d624974c503625f38fbb679bbdf89d790 --amt 7
```
### Send 
```
tapcli --network=mainnet --tapddir=~/.taproot-assets assets send --addr tapbc1qqqsqqspqqzzpm2rczwagf0vy5z3crjx0jsc2ttzf96v2qmztuu0hdneh00cn4usq5ss89mey0962l2gjldu8z25gfexxg0dfax5qx9efgntn3spswdhelyeqcss9wam6p2ngmv7rc9j50gt7e2rdsjfeh5wj0rjzx9xhlgglntny6trpqss8vg4vmyczxctwjx6hydyh5sj9jcyuankp444az39vr4kjw8tewwepgqswrpww4hxjan9wfek2unsvvaz7tm4de5hvetjwdjjumrfva58gmnfdenjuenfdeskucm98gcnqvpj8yevw3gx
```

### Remember to back up your data 
The data saved in `~/lntap:/root`, or if you want to modify it, 
please note update 
 * lntap-run.sh 
 * lntap-run.cmd 
 * Dockerfile