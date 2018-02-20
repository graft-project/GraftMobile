# Features of Mobile Clients

Currently, Mobile Clients are read-only and cannot process transactions.
This document contains the list of available features of Mobile Clients.

## Select Network

Graft Mobile Clients support three types of network:
*  Mainnet - Actual GRAFT blockchain, production network. This is the 
blockchain that carry real GRF transactions;
*  Public Testnet - Exact functional copy of mainnet for public testing of 
mining, supernodes, wallet apps, and other features of GRAFT ecosystem;
*  Public RTA Testnet - Blockchain and test network running on the code branch 
that contains Real Time Authorization and other future features that are not 
yet available on mainnet. For more details about Real-Time Authorization see 
[Graft Network Whitepaper](https://www.graft.network/wp-content/uploads/2017/09/Graft-1.1.pdf).

The mobile client works only with one network at same time. When you install 
Graft Mobile Client at the first time the application will propose to select 
the network and create or restore your Graft wallet.

### Reset Account

To change the network, go to the Settings and press "Reset Wallet" button, 
enter your password. Then the application will clear your account data and 
propose to select another network.

## Create/Restore Wallet

When you select the network, the application will propose to create or restore 
wallet. 

### Create Wallet

To create a wallet, you need to enter the password and press "Create 
New Wallet" button. 

If the application creates wallet successfully, it'll show a mnemonic phrase. 
The mnemonic phrase is the universal human-readable representation of your 
Graft wallet, which can be used to restore your wallet or copy it to another 
client. 

**Note**: Please, copy or remember the mnemonic phrase, if you a lost it, 
you cannot restore your Graft wallet.

**Note**: The password is needed only for security reason, if you don't worry about 
the privacy of your data, you can leave the password field empty.

### Restore Wallet

Alternatively to the wallet creation, you can restore your wallet from the 
mnemonic phrase. For this press "Restore Wallet" button, enter the mnemonic 
phrase and password. Then press "Restore" button, if everything is OK, the 
application restores account and open the main screen.

**Note**: The password is needed only for security reason, if you don't worry about 
the privacy of your data, you can leave the password field empty.

### View Mnemonic Phrase

Such as the mnemonic phrase is very important to restore your Graft wallet, the 
application provides the way to view the mnemonic phrase even if you had already
created an account, but for some reason, you forgot or didn't copy the mnemonic 
phrase.

To view the mnemonic phrase go to the Settings and press "Show Mnemonic 
Password" button. The application will ask you to enter your password if the 
password is correct, you will see the mnemonic phrase.

## View Account Balance

Such as Mobile Clients are read-only now, you can only view account balance. 
The balance is updating automatically and you can check it on the Wallet page. 

## Interaction with Graft Command Line Interface (CLI)

Since Mobile Clients are read-only currently, if you want to process 
transactions or make other actions, you need to use Graft Command Line 
Interface on your PC. You can install Graft CLI from binary packages or sources 
for all main platforms: Linux, Windows, MacOS.

To restore your wallet via Graft CLI, you need to get the mnemonic phrase of 
your Graft wallet and run Graft CLI with the following options:

```sh
--restore-deterministic-wallet      \\allow to create wallet from mnemonic phrase
--electrum-seed "<mnemonic phrase>" \\mnemonic phrase of your Graft wallet
```

For example:

**Linux/MacOS**:

```bash
./<path to GraftNetwork install directory>/graft-wallet-cli --restore-deterministic-wallet --electrum-seed "<mnemonic phrase>"

```

**Windows**:

```cmd
<path to GraftNetwork install directory>\graft-wallet-cli.exe --restore-deterministic-wallet --electrum-seed "<mnemonic phrase>"

```

Then Graft CLI will ask to enter a file name for your wallet and password to 
secure your wallet.

**Note**: This password hasn't a relation to the password in the Mobile Client, 
so you can enter any which you want.

To get more information about options of Graft CLI you can run it with `--help` 
option:

```bash
./<path to GraftNetwork install directory>/graft-wallet-cli --help

```

To get information about actions which are available for your wallet in the 
Graft CLI, enter `help` command when opening your Graft wallet in the Graft CLI.
