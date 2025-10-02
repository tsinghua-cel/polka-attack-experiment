#!/bin/bash
# build binary
cargo build --release
# build and publish docker image
./docker/scripts/build-injected.sh && docker tag parity/polkadot:latest tscel/polkadot:exp-1.16.9 
