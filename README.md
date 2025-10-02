# Risk-free Selfish Mining in Hybrid Predictability Model. A Case Study on Polkadot's NPoS

## Overview

This repository contains the implementation for our paper "Risk-free Selfish Mining in Hybrid Predictability Model. A Case Study on Polkadot's NPoS" The repository includes:

- Implementation code for attack polka-sdk
- Modified code for normal polka-sdk v1.16.9
- Utils for fetch polka chain state
- Experimental datasets and results for our paper

## Ethical Considerations

Our research adheres to responsible disclosure principles:

- All experiments are conducted exclusively on isolated local testnets
- No testing occurs on the live Polka network
- The attacks we analyzed do not disclose any new vulnerability information or additional exploit techniques

## System Requirements

### Hardware Dependencies

The experiments do not require any specialized hardware. Our reference system configuration:

| Component | Specification       |
| --------- | ------------------- |
| CPU       | 32-core processor   |
| Memory    | 32 GB RAM           |
| Storage   | 200 GB              |
| Network   | 100 Mbps connection |

### Software Dependencies

Our experiments require:

- Ubuntu 24.04 or later
- Docker Engine version 24.0.6 or higher
- docker-compose plugin
- rust

Installation instructions are available in the [official Docker documentation](https://docs.docker.com/engine/install/)

Install rust with the following commands:

```shell
$ sudo apt install build-essential
$ sudo apt install --assume-yes git clang curl libssl-dev protobuf-compiler
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
$ source ~/.cargo/env
$ rustup default stable
$ rustup update
$ rustup update nightly
$ rustup target add wasm32-unknown-unknown --toolchain nightly
$ rustup target add wasm32-unknown-unknown --toolchain stable-x86_64-unknown-linux-gnu
$ rustup component add rust-src --toolchain stable-x86_64-unknown-linux-gnu
```

## Installation & Configuration

After installing Docker, follow these steps:

1. Git clone the repository:

```bash
git clone https://github.com/tsinghua-cel/polka-attack-experiment.git
```

2. Enter the repository directory:

```bash
cd polka-attack-experiment
```

3. Build the required Docker image in the repository root directory:

```bash
./build.sh
```

Then script will cost about 2 hours to build the docker images.

## Experiments

To run the experiments, use the following command:

```bash
cd  testcase/ && ./run.sh && cd -
```

This script will run all the experiments cost about 25 hours.
Then you can stop the experiments with:

```bash
cd testcase/ && ./stop.sh && cd -
```

After experiments, the results will be stored in the `collector` directory for each testcase.
