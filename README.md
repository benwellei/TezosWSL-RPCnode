# Tezos RPC Node on WSL
Steps to run a local RPC Node using Windows Subsystem for Linux on Windows 10

## TODO
[ ] Setup WSL to have a static IP

## Installing WSL2 and Ubuntu

### 1) Turn on Windows Subsystem for Linux and Virtual Machine Platform

* Go to Control Panel > Programs and Features > Turn Windows features on or off
* Check the boxes next to `Windows Subsystem for Linux` and `Virtual Machine Platform`
* Don't restart yet. Wait until the next step


### 2) Turn Off Fast Startup

There are sometimes networking issues that are caused by the fast startup feature.

* Go to Control Panel > Power Options > Choose what the power buttons do
* Uncheck `Turn on fast startup (recommended)`
* Restart Computer

### 3) Enable WSL2 and Install Ubuntu

* Open Windows PowerShell
* Make sure that WSL2 is defaulted: `wsl --set-default-version 2`
* Get [Ubuntu for WSL](https://ubuntu.com/wsl) and install it
* Run Ubuntu from the Start Menu. It will need to finish installation and you will need to make a user/password
* Ensure that WSL2 is being used buy opening Windows PowerShell and using `wsl -l -v`
* Update Ubuntu: `sudo apt update` > `sudo apt upgrade`

## Setting up a Tezos Node

* Start Ubuntu and navigate to the home dir `cd $HOME`

### 1) Install the libraries that Tezos is dependent on
`sudo apt update && sudo apt install -y rsync git m4 build-essential patch unzip bubblewrap wget pkg-config libgmp-dev libev-dev libhidapi-dev`

### 2) Install Rust
`cd $HOME`

`wget https://sh.rustup.rs/rustup-init.sh`

`chmod +x rustup-init.sh`

`./rustup-init.sh --profile minimal --default-toolchain 1.44.0 -y`

`source $HOME/.cargo/env`

### 3) Install Zcash Parameters

`wget https://raw.githubusercontent.com/zcash/zcash/master/zcutil/fetch-params.sh`

`chmod +x fetch-params.sh`

`./fetch-params.sh`

### 4) Install OPAM

`wget https://github.com/ocaml/opam/releases/download/2.0.3/opam-2.0.3-x86_64-linux`

`sudo cp opam-2.0.3-x86_64-linux /usr/local/bin/opam`

`sudo chmod a+x /usr/local/bin/opam`

### 5) Get Sources

`git clone https://gitlab.com/tezos/tezos.git`

`cd tezos`

`git checkout latest-release`

### 6) Install Tezos Dependencies

`opam init --bare`

`make build-deps`

Answer the prompts with `N` then `y`

A switch error may appear, but you can ignore it.

### 7) Compile Sources

`eval $(opam env)`

`make`

You can verify the client version using `./tezos-client --version`


### 8) Generate Identity

`./tezos-node identity generate`

This might take a minute

### 9) Download and Import a Snapshot

* Download the most recent Mainnet Rolling snapshot from [Giganode](https://snapshots-tezos.giganode.io/)
* Rename the file to something shorter (optional) and move it to the tezos folder.
>You can open the current directory in WSL by using the command `explorer.exe .`

* Import the snapshot: `./tezos-node snapshot import <snapshotname.rolling>`

The import will take a good bit of time.


## Starting the Node and Pointing the RPC

Once the snapshot has been imported, you can start the node. It will still take a little while to catch up to the current block.

### 1) Find the IP for WSL

* Open another Ubuntu session
* Run `ip add`

The IP will be towards the bottom of the printout.

### 2) Start the Node

Run the following command using the WSL IP address.

`./tezos-node run --rpc-addr XXX.XX.XX.XX:8732 --allow-all-rpc XXX.XX.XX.XX:8732 --cors-header='content-type' --cors-origin='*'`

### 3) Wait for the Node to Sync

* It will take a bit for the node to catch up to the current block. Once it's synced you the log will slow down. 
* Check that the node is synced buy running `./tezos-client bootstrapped`
* When you see the message `Node is Bootstrapped`, your node is ready.

## Setup Temple Wallet to use your local Node

### 1) Add a Custom RPC

* In Temple, go to Settings > Networks
* Scroll to the bottom to add a new network
* Add a name
* In the RPC base URL add `http://your_WSL_IP:8732`using the WSL IP that you found above
* Leave the Lambda View contract blank
* Click `Add Network`


## Credits

[OpenTezos](https://opentezos.com/deploy-a-node)

[Baking Benjamins](https://docs.bakingbenjamins.com/baking/setup-tezos-node-with-rpc)

[Tezos Dev Resources](https://tezos.gitlab.io/user/node-configuration.html#rpc-parameters)
