#!/bin/bash

# check an file is exist at the path
if [ -f "/data/chains/rococo_local_testnet/network/secret_ed25519" ]; then
    echo "Secret key already exists, skipping generation."
else
    polkadot key generate-node-key --base-path /data --chain /app/rococo-local.json
fi

polkadot --log babe=debug,slots=debug,grandpa=debug --base-path=/data --chain=/app/rococo-local.json --state-pruning=archive --blocks-pruning=archive --validator --rpc-external --rpc-cors=all --name=$NODEROLE --$NODEROLE --rpc-methods=unsafe > /data/node.log 2>&1
#polkadot --base-path=/data --chain=/app/rococo-local.json --validator --rpc-external --rpc-cors=all --name=$NODEROLE --$NODEROLE --rpc-methods=unsafe --force-authoring
