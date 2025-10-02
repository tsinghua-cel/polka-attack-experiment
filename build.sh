#!/bin/bash
cd code/attack_polkadot_sdk && ./build.sh && cd -
cd code/normal_polkadot_sdk && ./build.sh && cd -
cd code/polka-utils && ./build.sh && cd -