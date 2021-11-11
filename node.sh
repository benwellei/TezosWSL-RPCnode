#!/bin/bash

cd ~
cd tezos
./tezos-node run --rpc-addr `hostname -I | xargs`":8732" --allow-all-rpc `hostname -I | xargs`":8732" --cors-header='content-type' --cors-origin='*'